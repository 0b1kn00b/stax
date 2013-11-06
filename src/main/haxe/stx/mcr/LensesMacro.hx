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
    var str = '';//var str = pack.length > 0 ? pack.join('.') + '.' : '';
    return if (params.length > 0)
      str + name + "<" + params.join(",") + ">";
    else
      str + name;
  }
    
  static public function nameForClassField(cf : ClassField) : String {
    //trace(cf);
    return cf.name + " : " + nameForType(cf.type);
  }
      
  static public function nameForType(x : Type) : String {
    if(x == null) return 'Dynamic';
    return switch (x) {
      case TType(t, params) : nameForType(t.get().type);
      case TInst(t, params) : typeName(t.get().pack,t.get().name, params.map(nameForType));
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
    //trace(c.name);
    var typeName  = nameForType(extensionType);      
    if (typeName  == null) throw ("not supported" + Std.string(extensionType));
    var cname     = c.name;
    var cTypeName = nameForType(c.type);

    if (cTypeName == null){
      return null;  
    }
    
    var params    = '';
    switch (extensionType.toTInst()) {
      case TInst(t,params0)  :
       var params1 = t.get().params;
       trace(params0);
       trace(params1);
      default               :
    }
    switch (c.type.toTInst()) {
      case TInst(t,params0)  :
       var params1 = t.get().params;
       trace(params0);
       trace(params1);
      default               :
    }
    var exprString = '
      { 
        get : function (value : $typeName):$cTypeName{ 
          return value==null ? null : value.$cname; 
        },
        set : function ($cname : $cTypeName, value : $typeName) {
          var clone         = stx.plus.Clone.getCloneFor(value)(value);
              clone.$cname  = $cname;
          return clone;
        }
      }
    ';
    //trace(exprString);
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

class LensesMacro<T> {

  static var extensionClassName = "LensesFor";
  static function isExtension(el) return
    el.t.get().name == extensionClassName;

  static public function build(): Array<Field> {
    var tp                = Context.getLocalClass();
    var cls : ClassType   = tp.get();
    var extensionType     = cls.interfaces.filter(isExtension).array()[0].params[0];
    var pos               = Context.currentPos();
    var classFields       = LenseMacroHelper.classFieldsFor(extensionType);
    //trace(classFields); 
    classFields = classFields.filter(
      function(x){
        return switch (x.type){
          case TFun( _, _ ) : false;
          default           : true;
        }
      }
    );
    var lenses = 
      classFields
      .map(LenseMacroHelper.lenseForClassField.bind(extensionType, _, pos))
      .filter(ntnl())
      .array();

    return lenses;
  }
}
#end
class Lenser{
  macro static public function lense(e:Expr):Expr{
    var type                    = Context.typeof(e);
    var flds                    = LenseMacroHelper.classFieldsFor(type.toTInst());
    var pack   : Array<String>  = ['stx','mcr','lense'];
    var name   : String         = "LensesFor" + option(Types.getID(type)).getOrElseC(Strings.uuid('xxxxxx'));
    var pos    : Position       = Context.currentPos();
    var params : Array<TypeParamDecl> = [];//
    var kind   : TypeDefKind    = TDClass();
    var fields : Array<Field>   = 
      flds.map(
        function (cf){
          return LenseMacroHelper.lenseForClassField(type, cf, Context.currentPos());
        }
      ).filter(function (x) return x!=null).array();

    Context.defineType({
      pack   : pack,
      name   : name,
      pos    : pos,
      kind   : kind,
      fields : fields
    });
    trace(Context.getType(pack.join('.') + '.$name'));
    var str = '${pack.join(".")}.$name';
    //trace(str);
    var o = Context.parse(str,Context.currentPos());

    return o;
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
