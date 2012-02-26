package stax.rtti;

/**
 * ...
 * @author 0b1kn00b
 */
import haxe.rtti.Infos;
import haxe.rtti.CType;
using Stax;

class RTypes {
	public static function typetree(type:Class<Infos>) {
		var rtti : String = untyped Reflect.field(type, "__rtti");
		var x = Xml.parse(rtti).firstElement();
		return new haxe.rtti.XmlParser().processElement(x);
	}
	public static function fields(type:Class<Infos>):Iterable<ClassField>{
		return 
				switch (typetree(type)) {
					//case TPackage( name , full , subs ) : subs.flatMap( RTypes.fields );
					case TClassdecl( c  ) 							: c.fields;
					default															: null;
				}
	}
}