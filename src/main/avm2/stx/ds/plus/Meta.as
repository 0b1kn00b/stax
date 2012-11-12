package stx.plus {
	import stx.Tuple3;
	import stx.Tuples;
	import stx.plus.ArrayOrder;
	import haxe.rtti.Meta;
	import stx.Strings;
	public class Meta {
		static public var __meta__ : * = { statics : { _hasMetaDataClass : { deprecate : ["0b1kn00b","thx"]}, _fieldsWithMeta : { deprecate : ["0b1kn00b","thx"]}}}
		static public function _hasMetaDataClass(c : Class) : Boolean {
			var m : * = haxe.rtti.Meta.getType(c);
			return null != m && Reflect.hasField(m,"DataClass");
		}
		
		static public function _getMetaDataField(c : Class,f : String) : * {
			var m : * = haxe.rtti.Meta.getFields(c);
			if(null == m || !Reflect.hasField(m,f)) return null;
			var fm : * = Reflect.field(m,f);
			if(!Reflect.hasField(fm,"DataField")) return null;
			return (function() : Array {
				var $r : Array;
				var $t : * = Reflect.field(fm,"DataField");
				if(Std._is($t,Array)) (($t) as Array);
				else throw "Class cast error";
				$r = $t;
				return $r;
			}()).copy().pop();
		}
		
		static public function _fieldsWithMeta(c : Class,name : String) : Array {
			var i : int = 0;
			return Prelude.SArrays.map(stx.plus.ArrayOrder.sortWith(Prelude.SArrays.filter(Prelude.SArrays.map(Type.getInstanceFields(c),function(v : String) : stx.Tuple3 {
				var fieldMeta : * = stx.plus.Meta._getMetaDataField(c,v);
				var inc : Boolean = fieldMeta == null || !Reflect.hasField(fieldMeta,name) || Reflect.field(fieldMeta,name);
				return stx.Tuples.t3(v,inc,((fieldMeta != null && Reflect.hasField(fieldMeta,"index"))?Reflect.field(fieldMeta,"index"):i++));
			}),function(v1 : stx.Tuple3) : Boolean {
				return v1._2;
			}),function(a : stx.Tuple3,b : stx.Tuple3) : int {
				var c1 : int = a._3 - b._3;
				if(c1 != 0) return c1;
				return stx.Strings.compare(a._1,b._1);
			}),function(v2 : stx.Tuple3) : String {
				return v2._1;
			});
		}
		
	}
}
