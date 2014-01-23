package stx.mcr;

import Prelude;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

import stx.Accessors;
import stx.State;

using stx.Arrays;
using stx.Strings;

class Types{
  #if macro
  static public function getParamsOfTypeDeclaration(type:Type):Array<Type>{
    return switch (type) {
      default                   :  [];
      case TEnum(_,params)      :  params;  
      case TInst(_,params)      :  params;
      case TType(_, params)     :  params;    
      case TAbstract(_, params) :  params;
    }
  }
  /*static public function getParamsOfType(type:Null<Type>):Array<TypeParameter>{
    return switch (type) {
      case TMono( t )            : getParamsOfType(t);
      case TEnum(t, params)      : 
      case TInst(t, params )     :
      case TType(t, params)      :
      case TFun(args, ret)       :
      case TAnonymous(a)         :
      case TDynamic(t)           :
      case TLazy(f)              :
      case TAbstract(t, params)  :
      case _                     : [];
    } 
  }*/
  static public function isClass(t:Type):Bool{
    return switch (t) {
      case TType(t,params) : return new EReg('#','g').match(t.toString());
      default : false;
    }
  }
  static public function hasTypeHoles(t:Null<Type>):Bool{
    return switch (t) {
      case TMono( t )            : hasTypeHoles(t.get());
      case TEnum(t, params)      : t.get().params.length > 0;
      case TInst(t, params )     : t.get().params.length > 0;
      case TType(t, params)      : t.get().params.length > 0;
      case TFun(args, ret)       : args.map(function(x) return x.t).add(t).any(hasTypeHoles);
      case TAnonymous(a)         : false;//not sure about contextual type annotations.
      case TDynamic(t)           : hasTypeHoles(t);
      case TLazy(f)              : hasTypeHoles(f());
      case TAbstract(t, params)  : t.get().params.length > 0;
      case _                     : false;
    }
  }
  static public function getHolesAndPegs(t:Type):Array<Tuple2<TypeParameter,Type>>{
    return switch (t) {
      case TType(t,p)   :
        var holes = t.get().params;
        var pegs  = p;
        holes.zip(pegs.pad(holes.length));
      case TInst(t, p)  :
        var holes = t.get().params;
        var pegs  = p;
        holes.zip(pegs.pad(holes.length));
      case TEnum(t, p)  :
        var holes = t.get().params;
        var pegs  = p;
        holes.zip(pegs.pad(holes.length));
      default           : [];
    }
  }
  @doc('Produces the instance type of a class.')
  static public function toTInst(t:Type):Type{
    return switch (t) {
      case TType(t,params) :
        if(new EReg('#','g').match(t.toString())){
          var pth = t.toString().replaceReg(new EReg('#','g'),'');
          var ins = Context.getType(pth);
          ins;
        }else{
          TType(t,params);
        }
      default : t;
    }
  }
  static public function fields(type:Type){
    return switch (type) {
      case TMono( t )            : [];
      case TEnum(t, params)      : [];
      case TInst(t, params )     : t.get().fields.get();
      case TType(t, params)      : fields(t.get().type);
      case TFun(args, ret)       : [];
      case TAnonymous(a)         : a.get().fields;
      case TDynamic(t)           : fields(t);
      case TLazy(f)              : fields(f());
      case TAbstract(t, params)  : t.get().array;
    };
  }
  static public function lookup(state:State<Type,Array<ClassField>>){
    return state.access(
      function(arr,state){
        var decl_params   = getParamsOfTypeDeclaration(state);
        var field_params  = arr.map(function(x){
          return x.params;
        });
        var value_params  = arr.map(function(x){
          return getParamsOfTypeDeclaration(x.type);
        });
/*        trace(decl_params);
        trace(field_params);
        trace(value_params);*/

        var field_types   = arr;
        /*trace(field_types.map(function(x){
          return x.type;
        }));*/
        return arr;
      }
    );
  }
  #end
  macro static public function test(e:Expr):Expr{
    var type    = Context.typeof(e);
    var st      = State.unit()
      .getSt()
      .map(fields)
      .map(Arrays.filter.bind(_,function(x:ClassField) return x.name!='new'));
    var o       = lookup(st);
        o.exec(type);
    return e;  
  }
}