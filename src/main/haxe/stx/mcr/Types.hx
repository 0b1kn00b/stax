package stx.mcr;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

import stx.Accessors;
import stx.State;

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
  @doc('Produces the instance type of a class.')
  static public function toTInst(t:Type):Type{
    return switch (t) {
      case TType(t,params) :
        if(new EReg('#','g').match(t.toString())){
          var pth = t.toString().replace(new EReg('#','g'),'');
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
        trace(decl_params);
        trace(field_params);
        trace(value_params);

        var field_types   = arr;
        trace(field_types.map(function(x){
          return x.type;
        }));
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