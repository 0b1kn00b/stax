package stx.rtti {
	import haxe.rtti.XmlParser;
	import stx.Enums;
	import haxe.rtti.TypeTree;
	public class RTypes {
		static public function typetree(type : Class) : haxe.rtti.TypeTree {
			var rtti : String = Reflect.field(type,"__rtti");
			var x : Xml = Xml.parse(rtti).firstElement();
			return new haxe.rtti.XmlParser().processElement(x);
		}
		
		static public function fields(type : Class) : * {
			return function() : List {
				var $r : List;
				{
					var $e2 : enum = (stx.rtti.RTypes.typetree(type));
					switch( $e2.index ) {
					case 1:
					var c : * = $e2.params[0];
					$r = c.fields;
					break;
					default:
					$r = null;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function ancestors(v : *,a : Array = null) : Array {
			var arr : Array = ((a == null)?[]:a);
			arr.push(v);
			var scp : * = v.superClass;
			if(scp == null) return arr;
			var superclass : Class = Type.resolveClass(scp.path);
			if(superclass != null) return stx.rtti.RTypes.ancestors(stx.Enums.params(stx.rtti.RTypes.typetree(superclass))[0],arr);
			return arr;
		}
		
	}
}
