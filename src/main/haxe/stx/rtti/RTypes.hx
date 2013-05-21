package stx.rtti;

import Type;

import haxe.rtti.CType;
import stx.Enums;

using stx.Prelude;

class RTypes {
	public static function typetree(type:Class<Dynamic>) {
		var rtti : String = untyped Reflect.field(type, "__rtti");
		var tn = (Type.getClassName(type));
		if(rtti == null){ throw 'No rtti found on $tn'; }
		var x = Xml.parse(rtti).firstElement();
		return new haxe.rtti.XmlParser().processElement(x);
	}
	public static function fields(type:Class<Dynamic>):Iterable<ClassField>{
		return switch (RTypes.typetree(type)) {
				//case TPackage( name , full , subs ) : subs.flatMap( RTypes.fields );
				case TClassdecl( c  ) 							: c.fields;
				default															: null;
			}
	}
	public static function ancestors(v:Classdef, ?a:Array<Classdef>) {
		var arr = (a == null) ? [] : a;
				arr.push( v );
		var scp = v.superClass;
		if (scp == null) return arr;
		var superclass = Type.resolveClass(scp.path);
		if ( superclass != null ) {
			return ancestors( 
				Enums.params( typetree( cast superclass ) )[0] , arr 
			);
		}
		return arr;
	}
}