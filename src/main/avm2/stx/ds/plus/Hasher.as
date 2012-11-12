package stx.plus {
	import stx.plus.ProductHasher;
	import stx.plus.DateHasher;
	import stx.plus.IntHasher;
	import stx.plus.StringHasher;
	import stx.plus.FloatHasher;
	import stx.plus.Meta;
	import stx.plus.ArrayHasher;
	import stx.plus.BoolHasher;
	import stx.plus.Show;
	public class Hasher {
		static protected function _createHashImpl(impl : Function) : Function {
			return function(v : *) : int {
				if(null == v) return 0;
				else return impl(v);
				return 0;
			}
		}
		
		static public function getHashFor(t : *) : Function {
			return stx.plus.Hasher.getHashForType(Type._typeof(t));
		}
		
		static public function getHashForType(v : ValueType) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					$r = stx.plus.Hasher._createHashImpl(stx.plus.BoolHasher.hashCode);
					break;
					case 1:
					$r = stx.plus.Hasher._createHashImpl(stx.plus.IntHasher.hashCode);
					break;
					case 2:
					$r = stx.plus.Hasher._createHashImpl(stx.plus.FloatHasher.hashCode);
					break;
					case 8:
					$r = stx.plus.Hasher._createHashImpl(function(v1 : *) : int {
						return Prelude.error("can't retrieve hascode for TUnknown: " + Std.string(v1),{ fileName : "Hasher.hx", lineNumber : 36, className : "stx.plus.Hasher", methodName : "getHashForType"});
					});
					break;
					case 4:
					$r = stx.plus.Hasher._createHashImpl(function(v2 : *) : int {
						var s : String = (stx.plus.Show.getShowFor(v2))(v2);
						return (stx.plus.Hasher.getHashFor(s))(s);
					});
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						switch(Type.getClassName(c)) {
						case "String":
						$r3 = stx.plus.Hasher._createHashImpl(stx.plus.StringHasher.hashCode);
						break;
						case "Date":
						$r3 = stx.plus.Hasher._createHashImpl(stx.plus.DateHasher.hashCode);
						break;
						case "Array":
						$r3 = stx.plus.Hasher._createHashImpl(stx.plus.ArrayHasher.hashCode);
						break;
						case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
						$r3 = stx.plus.Hasher._createHashImpl(stx.plus.ProductHasher.hashCode);
						break;
						default:
						$r3 = function() : Function {
							var $r4 : Function;
							var fields : Array = Type.getInstanceFields(c);
							$r4 = ((stx.plus.Meta._hasMetaDataClass(c))?function() : Function {
								var $r5 : Function;
								var fields1 : Array = stx.plus.Meta._fieldsWithMeta(c,"equalHash");
								$r5 = stx.plus.Hasher._createHashImpl(function(v3 : *) : int {
									var className : String = Type.getClassName(c);
									var values : Array = Prelude.SArrays.filter(Prelude.SArrays.map(fields1,function(f : String) : * {
										return Reflect.field(v3,f);
									}),function(v4 : *) : Boolean {
										return !Reflect.isFunction(v4);
									});
									return Prelude.SArrays.foldl(values,9901 * stx.plus.StringHasher.hashCode(className),function(v5 : int,e : *) : int {
										return v5 + 333667 * ((stx.plus.Hasher.getHashFor(e))(e) + 197192);
									});
								});
								return $r5;
							}():((Type.getInstanceFields(c).remove("hashCode"))?stx.plus.Hasher._createHashImpl(function(v6 : *) : int {
								return Reflect.callMethod(v6,Reflect.field(v6,"hashCode"),[]);
							}):Prelude.error("class does not have a hashCode method",{ fileName : "Hasher.hx", lineNumber : 64, className : "stx.plus.Hasher", methodName : "getHashForType"})));
							return $r4;
						}();
						break;
						}
						return $r3;
					}();
					break;
					case 7:
					var e1 : Class = $e2.params[0];
					$r = stx.plus.Hasher._createHashImpl(function(v7 : *) : int {
						var hash : int = stx.plus.StringHasher.hashCode(Type.enumConstructor(v7)) * 6151;
						{
							var _g : int = 0, _g1 : Array = Type.enumParameters(v7);
							while(_g < _g1.length) {
								var i : * = _g1[_g];
								++_g;
								hash += (stx.plus.Hasher.getHashFor(i))(i) * 6151;
							}
						}
						return hash;
					});
					break;
					case 5:
					$r = stx.plus.Hasher._createHashImpl(function(v8 : *) : int {
						return Prelude.error("function can't provide a hash code",{ fileName : "Hasher.hx", lineNumber : 75, className : "stx.plus.Hasher", methodName : "getHashForType"});
					});
					break;
					case 0:
					$r = function(v9 : *) : int {
						return 0;
					}
					break;
					default:
					$r = function(v10 : *) : int {
						return -1;
					}
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
