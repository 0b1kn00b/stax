package stx.rtti;

import Type;

import haxe.rtti.CType;
import stx.Enums;
import stx.Reflects;

using stx.Strings;
using stx.Tuples;
using stx.Options;
using stx.Prelude;
using stx.Arrays;
using stx.Iterables;

class RTypes {
	static public function typetree(type:Class<Dynamic>):Option<TypeTree> {
		var rtti : String 	= untyped Reflect.field(type, "__rtti");
		var tn 							= (Type.getClassName(type));
		if(rtti == null){ return None; }
		var x 							= Xml.parse(rtti).firstElement();
		return Some(new haxe.rtti.XmlParser().processElement(x));
	}
}
class TypeTrees{
	static public inline function classdef(t:TypeTree):Option<Classdef>{
	  return switch (t) {
	  	case TClassdecl(c) 	: Some(c);
	  	default 						: None;
	  }
	}
}
class Classdefs{
	static public function ancestors(v:Classdef):Option<Array<Classdef>>{
		var _ancestors : Classdef -> Array<Classdef> -> Option<Array<Classdef>>= null;
				_ancestors = function(v:Classdef,a:Array<Classdef>):Option<Array<Classdef>>{
					a.push(v);
					if(v.superClass == null) return Some(a);
					return Options.create(v.superClass)
						.map(function(x) return x.path)
						.flatMap(Types.resolveClassOption)
						.flatMap(RTypes.typetree)
						.flatMap(TypeTrees.classdef)
						.flatMap(_ancestors.bind(_,a));
				} 
		return _ancestors(v,[]);
	}
}
class CTypes{
	static public function toValueType(ct:CType):ValueType{
    return switch (ct) {
      case CUnknown               : TUnknown;
      case CEnum(name, _)         : TEnum(Enums.resolve(name));
      case CClass(name ,_ )       : TClass(Types.resolve(name));
      case CTypedef(_)            : TObject;
      case CFunction(_, _)        : TFunction;
      case CAnonymous(_)          : TObject;
      case CDynamic(_)            : TUnknown;
      case CAbstract('Int',_)     : TInt;
      case CAbstract('Float',_)   : TFloat;
      case CAbstract('Bool',_)    : TFloat;
      case CAbstract(_,_)         : TUnknown;
    }
  }
}