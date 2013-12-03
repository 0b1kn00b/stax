package stx.mcr;

/**
 * ...
 * @author sledorze
 */

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import stx.Compare.*;
import Stax.*;

using stx.Compose;
using stx.Enums;
using stx.Arrays;
using stx.Option;
using stx.Strings;
using stx.mcr.Types;

import stx.Objects.Object;

using Lambda;

#if macro

import tink.macro.tools.MacroTools;

class LenseMacroHelper {
  static function classFieldsForClassType(c : ClassType) return
    c.fields.get();
  
  inline static function typeName(pack:Array<String>,name : String, params : Array<String>) : String{
    var str = pack.length > 0 ? pack.join('.') + '.' : '';
    var o = 
     if (params.length > 0)
      str + name + "<" + params.join(",") + ">";
    else
      str + name;

    trace(o);
    return o;
  }
    
  static public function nameForClassField(cf : ClassField) : String {
    //trace(cf);
    return cf.name + " : " + nameForType(cf.type);
  }
      
  static public function nameForType(x : Type) : String {
    trace(x);
    if(x == null) return 'Dynamic';
    return switch (x) {
      case TType(t, params) : nameForType(t.get().type);
      case TInst(t, params) : 
      trace(t.get().params);
      typeName(t.get().pack,t.get().name, 
        params.map(nameForType)
        .map(Strings.split.bind(_,'.').then(Arrays.last))
      );
      case TAnonymous(a)    : "{" + a.get().fields.map(nameForClassField).join(",") + "}";
      case TFun(args, ret)  : args.map(function (x) return x.t).concat([ret]).map(nameForType).join(" -> ");
      case TEnum(t, params) : typeName(t.get().pack,t.get().name, params.map(nameForType));
      case TAbstract(t,ps)  : typeName(t.get().pack,t.get().name, ps.map(nameForType));
      case TDynamic(t)      : (t == null) ? "Dynamic" : nameForType(t);
      case TMono(t)         : nameForType(t.get());
      default               : throw "not allowed " + Std.string(x);
    }
  }
  @:note('#0b1kn00b: atm, Classes are Objects with no fields and a "#" appended to the classname, do a lookup in TTYpe if that is the case. 3-11-2013')
  static public function classFieldsFor(t : Type) : Array<ClassField> {
    return switch (t) {
      case TMono( t )            : classFieldsFor(t.get());
	    case TEnum( _,  _ )        : throw "lenses for enum not supported yet"; // could support common fields.. (would be quite nice!)
	    case TInst( t,  _ )        : classFieldsForClassType(t.get());
	    case TType( t , _ )        : classFieldsFor(t.get().type);
      case TFun( _ , _ )         : throw "lenses for functions do not makes sense";
	    case TAnonymous( a )       : a.get().fields;
	    case TDynamic(t)           : classFieldsFor(t);
	    case TLazy( fn )           : classFieldsFor(fn());
      case TAbstract(t,_)        : t.get().array;
    }
  }
  static public function lenseForClassField(extensionType : Type, c : ClassField, pos : Position) : Field {
    trace(extensionType);
    var typeName  = nameForType(extensionType);      
    if (typeName  == null) throw ("not supported" + Std.string(extensionType));
    var cname     = c.name;
    var cTypeName = nameForType(c.type);

    if (cTypeName == null){
      return null;  
    }
    var exprString = '
      { 
        get : function (value : $typeName):$cTypeName{ 
          return value==null ? null : value.$cname; 
        },
        set : function ($cname : $cTypeName, value : $typeName): $typeName {
          var clone         = stx.plus.Clone.getCloneFor(value)(value,[]);
              clone.$cname  = $cname;
          return clone;
        }
      }
    ';
    trace(exprString);
    var expr = Context.parse(exprString, pos);

    return {
      name   : cname + '',
      doc    : null,
      access : [APublic, AStatic],
      kind   : FVar( null, expr ),
      pos    : pos,
      meta   : []
    };
  }
    
}
#end
class Lenser{
  #if macro
  static function getTypeHoles(type:Null<Type>):Array<TypeParameter>{
    return switch (type) {
      case TMono( t )            : [];
      case TEnum(t, params)      : t.get().params;
      case TInst(t, params )     : t.get().params;
      case TType(t, params)      : getTypeHoles(stx.mcr.Types.toTInst(type));
      case TFun(args, ret)       : args.map(function(x) return x.t).flatMap(getTypeHoles).append(getTypeHoles(ret));
      case TAnonymous(a)         : [];
      case TDynamic(t)           : getTypeHoles(type);
      case TLazy(f)              : getTypeHoles(f());
      case TAbstract(t, params)  : t.get().params;
    }
  }
  #end
  @:noUsing macro static public function lenses(e:Expr):Expr{
    trace('lenses $e');
    switch (e.expr) {
      case EConst(CIdent(v)) : 
        var type      = Context.typeof(e);
        var flds      = LenseMacroHelper.classFieldsFor(type);
        var isClass   = type.isClass();
        var type      = type.toTInst();
        var hasHoles  = type.hasTypeHoles();
        if(hasHoles && isClass){
          var holesAndPegs = type.getHolesAndPegs();
        }
      default : 
    }
  /*    
    trace(e);
    var type                          = Context.typeof(e).toTInst();
    var holes                         = getTypeHoles(type);
    var flds                          = LenseMacroHelper.classFieldsFor(type);
    var pack   : Array<String>        = ['stx','mcr','lense'];
    var name   : String               = option(Types.getID(type))
    .map(Strings.replace.bind(_,'.','_'))
    .map('LensesFor_'.append)
    .getOrElseC(Strings.uuid('xxxxxx'));
    trace(name);
    var pos    : Position             = Context.currentPos();

    var params : Array<TypeParamDecl> = 
        holes.map(
          function(x):TypeParamDecl{
            return {"name":x.name};
          }
        );
    var kind   : TypeDefKind    = TDClass();
    var fields : Array<Field>   = 
      flds.map(
        function (cf){
          return LenseMacroHelper.lenseForClassField(type, cf, Context.currentPos());
        }
      ).filter(function (x) return x!=null).array();

    //trace(tink.macro.tools.Printer.printFields('',fields));
    Context.defineType({
      pack   : pack,
      name   : name,
      pos    : pos,
      kind   : kind,
      fields : fields,
      params : params
    });
    var str = '${pack.join(".")}.$name';
    var o   = Context.parse(str,Context.currentPos());
    trace(o);*/
    return e;
  }
  macro static public function print(e:Expr):Expr{
    var type                  = Context.typeof(e);
    switch (type) {
      case TEnum(t,params) : trace(t.get().names);
      default : 
    }
    return e;
  }
}

@:autoBuild(stx.mcr.LensesMacro.build()) interface LensesFor<T> { } 
