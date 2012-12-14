package stx.macro;

/**
 * ...
 * @author sledorze
 */

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using Lambda;

#if macro

class Helper {
  
  static function classFieldsForClassType(c : ClassType) return
    c.fields.get()
  
  inline static function typeName(name : String, params : List<String>) : String return
    if (params.length > 0)
      name + "<" + params.join(",") + ">";
    else
      name
    
  public static function nameForClassField(cf : ClassField) : String return
    cf.name + " : " + nameForType(cf.type)
      
  public static function nameForType(x : Type) : String return
    switch (x) {
      case TType(t, params) : typeName(t.get().name, params.map(nameForType));
      case TInst(t, params) : typeName(t.get().name, params.map(nameForType));
      case TAnonymous(a)    : "{" + a.get().fields.map(nameForClassField).join(",") + "}";
      case TFun(args, ret)  : args.map(function (x) return x.t).concat([ret]).map(nameForType).join(" -> ");
      case TEnum(t, params) : typeName(t.get().name, params.map(nameForType));
      case TAbstract(a,b)   : throw "not allowed " + Std.string(x);
      default               : throw "not allowed " + Std.string(x);
    }
  public static function classFieldsForSnd(t : Type) : Array<ClassField> {
    return null;
  }    
  public static function classFieldsFor(t : Type) : Array<ClassField> return
    switch (t) {
      case TMono( t )            : classFieldsFor(t.get());
	    case TEnum( t,  params )   : throw "lenses for enum not supported yet"; // could support common fields.. (would be quite nice!)
	    case TInst( t,  params )   : classFieldsForClassType(t.get());
	    case TType( t , params )   : classFieldsFor(t.get().type);
      case TFun( args , ret )    : throw "lenses for function do not makes sense";
	    case TAnonymous( a )       : a.get().fields;
	    case TDynamic( t )         : throw "lenses for Dynamic do not make sense"; // or a dynamic way to support it
	    case TLazy( f )            : throw "lenses for lazy not supported";
      case TAbstract(a,b)        : throw "lenses for abstract not supported " + Std.string(t);
    }

  public static function lenseForClassField(extensionType : Type, c : ClassField, pos : Position) : Field {
      
    var typeName = nameForType(extensionType);      
    if (typeName == null) throw ("not supported" + Std.string(extensionType));
    
    var cname = c.name;
    var cTypeName = nameForType(c.type);
    if (cTypeName == null)
      return null;
    
    var exprString = '
      { 
        get : function (___obj : $typeName) return ___obj.$cname,
        set : function ($cname : $cTypeName, ___obj : $typeName) {
          var ___cp = Reflect.copy(___obj);
          ___cp.$cname = $cname;
          return ___cp;
        }
      }
    ';
    
    var expr = Context.parse(exprString, pos);

    return {
      name : cname + '_',
      doc : null,
      access : [APublic, AStatic],
      kind : FVar( null, expr ),
      pos : pos,
      meta : []
    };
  }
    
}

class LensesMacro<T> {

  static var extensionClassName = "LensesFor";
  static function isExtension(el) return
    el.t.get().name == extensionClassName

  public static function build(): Array<Field> {
    var extensionType = {
      var clazz : ClassType = Context.getLocalClass().get();
      clazz.interfaces.filter(isExtension).array()[0].params[0];
    }
    
    var pos = Context.currentPos();
    var classFields = Helper.classFieldsFor(extensionType);
    var lenses = classFields.map(function (cf) return Helper.lenseForClassField(extensionType, cf, pos)).filter(function (x) return x!=null).array();
    return lenses;
  }
}
#end

@:autoBuild(stx.macro.LensesMacro.build()) interface LensesFor<T> { } 
