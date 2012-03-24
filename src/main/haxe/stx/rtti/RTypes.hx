package stx.rtti;

/**
 * ...
 * @author 0b1kn00b
 */
import Type;

import haxe.rtti.Infos;
import haxe.rtti.CType;
import stx.Enums;
														using Stax;

class RTypes {
	public static function typetree(type:Class<Infos>) {
		var rtti : String = untyped Reflect.field(type, "__rtti");
		var x = Xml.parse(rtti).firstElement();
		return new haxe.rtti.XmlParser().processElement(x);
	}
	public static function fields(type:Class<Infos>):Iterable<ClassField>{
		return 
				switch (RTypes.typetree(type)) {
					//case TPackage( name , full , subs ) : subs.flatMap( RTypes.fields );
					case TClassdecl( c  ) 							: c.fields;
					default															: null;
				}
	}
	public static function ancestors(v:Classdef, ?a:Array<Classdef>) {
		var enums = new Enums();
		var arr = (a == null) ? [] : a;
				arr.push( v );
		var scp = v.superClass;
		if (scp == null) return arr;
		var superclass = Type.resolveClass(scp.path);
		if ( superclass != null ) {
			return ancestors( 
				enums.params( typetree( cast superclass ) )[0] , arr 
			);
		}
		return arr;
	}
}