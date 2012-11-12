package stx.plus {
	import stx.Bools;
	import stx.Tuple2;
	import stx.plus.Meta;
	import stx.Dates;
	import stx.plus.ProductEqual;
	import stx.Strings;
	import stx.Tuples;
	import stx.Floats;
	import stx.Ints;
	import stx.plus.ArrayEqual;
	public class Equal {
		static public function getEqualFor(t : *) : Function {
			return stx.plus.Equal.getEqualForType(Type._typeof(t));
		}
		
		static public function getEqualForType(v : ValueType) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					$r = stx.plus.Equal._createEqualImpl(stx.Bools.equals);
					break;
					case 1:
					$r = stx.plus.Equal._createEqualImpl(stx.Ints.equals);
					break;
					case 2:
					$r = stx.plus.Equal._createEqualImpl(stx.Floats.equals);
					break;
					case 8:
					$r = function(a : *,b : *) : Boolean {
						return a == b;
					}
					break;
					case 4:
					$r = stx.plus.Equal._createEqualImpl(function(a1 : *,b1 : *) : Boolean {
						{
							var _g : int = 0, _g1 : Array = Reflect.fields(a1);
							while(_g < _g1.length) {
								var key : String = _g1[_g];
								++_g;
								var va : * = Reflect.field(a1,key);
								if(!(stx.plus.Equal.getEqualFor(va))(va,Reflect.field(b1,key))) return false;
							}
						}
						return true;
					});
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						switch(Type.getClassName(c)) {
						case "String":
						$r3 = stx.plus.Equal._createEqualImpl(stx.Strings.equals);
						break;
						case "Date":
						$r3 = stx.plus.Equal._createEqualImpl(stx.Dates.equals);
						break;
						case "Array":
						$r3 = stx.plus.Equal._createEqualImpl(stx.plus.ArrayEqual.equals);
						break;
						case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
						$r3 = stx.plus.Equal._createEqualImpl(stx.plus.ProductEqual.equals);
						break;
						default:
						$r3 = ((stx.plus.Meta._hasMetaDataClass(c))?function() : Function {
							var $r4 : Function;
							var fields : Array = stx.plus.Meta._fieldsWithMeta(c,"equalHash");
							$r4 = stx.plus.Equal._createEqualImpl(function(a2 : *,b2 : *) : Boolean {
								var values : Array = Prelude.SArrays.map(fields,function(v1 : String) : stx.Tuple2 {
									return stx.Tuples.t2(Reflect.field(a2,v1),Reflect.field(b2,v1));
								});
								{
									var _g2 : int = 0;
									while(_g2 < values.length) {
										var value : stx.Tuple2 = values[_g2];
										++_g2;
										if(Reflect.isFunction(value._1)) continue;
										if(!(stx.plus.Equal.getEqualFor(value._1))(value._1,value._2)) return false;
									}
								}
								return true;
							});
							return $r4;
						}():((Type.getInstanceFields(c).remove("equals"))?stx.plus.Equal._createEqualImpl(function(a3 : *,b3 : *) : Boolean {
							return a3.equals(b3);
						}):Prelude.error("class " + Type.getClassName(c) + " has no equals method",{ fileName : "Equal.hx", lineNumber : 73, className : "stx.plus.Equal", methodName : "getEqualForType"})));
						break;
						}
						return $r3;
					}();
					break;
					case 7:
					var e : Class = $e2.params[0];
					$r = stx.plus.Equal._createEqualImpl(function(a4 : enum,b4 : enum) : Boolean {
						if(0 != Type.enumIndex(a4) - Type.enumIndex(b4)) return false;
						var pa : Array = Type.enumParameters(a4);
						var pb : Array = Type.enumParameters(b4);
						{
							var _g11 : int = 0, _g3 : int = pa.length;
							while(_g11 < _g3) {
								var i : int = _g11++;
								if(!(stx.plus.Equal.getEqualFor(pa[i]))(pa[i],pb[i])) return false;
							}
						}
						return true;
					});
					break;
					case 0:
					$r = stx.plus.Equal._createEqualImpl(function(a5 : *,b5 : *) : Boolean {
						return Prelude.error("at least one of the arguments should be null",{ fileName : "Equal.hx", lineNumber : 89, className : "stx.plus.Equal", methodName : "getEqualForType"});
					});
					break;
					case 5:
					$r = stx.plus.Equal._createEqualImpl(Reflect.compareMethods);
					break;
					}
				}
				return $r;
			}();
		}
		
		static protected function _createEqualImpl(impl : Function) : Function {
			return function(a : *,b : *) : Boolean {
				return ((a == b || a == null && b == null)?true:((a == null || b == null)?false:impl(a,b)));
			}
		}
		
	}
}
