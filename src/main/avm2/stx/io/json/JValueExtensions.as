package stx.io.json {
	import stx.Option;
	import stx.Tuples;
	import stx.io.json.JValue;
	import stx.Tuple2;
	public class JValueExtensions {
		static public function decompose(v : stx.io.json.JValue) : stx.io.json.JValue {
			return v;
		}
		
		static public function extract(c : Class,v : stx.io.json.JValue) : stx.io.json.JValue {
			return v;
		}
		
		static public function fold(v : stx.io.json.JValue,initial : *,f : Function) : * {
			var cur : * = initial;
			stx.io.json.JValueExtensions.map(v,function(j : stx.io.json.JValue) : stx.io.json.JValue {
				cur = f(cur,j);
				return j;
			});
			return cur;
		}
		
		static public function path(v : stx.io.json.JValue,s : String) : stx.io.json.JValue {
			var ss : Array = s.split("/"), c : stx.io.json.JValue = v;
			{ var $it : * = ss.iterator();
			while( $it.hasNext() ) { var x : String = $it.next();
			if(x.length > 0) c = stx.io.json.JValueExtensions.get(c,x);
			}}
			return c;
		}
		
		static public function map(v : stx.io.json.JValue,f : Function) : stx.io.json.JValue {
			{
				var $e : enum = (v);
				switch( $e.index ) {
				case 4:
				var xs : Array = $e.params[0];
				return f(stx.io.json.JValue.JArray(Prelude.SArrays.map(xs,function(x : stx.io.json.JValue) : stx.io.json.JValue {
					return stx.io.json.JValueExtensions.map(x,f);
				})));
				break;
				case 6:
				var v1 : stx.io.json.JValue = $e.params[1], k : String = $e.params[0];
				return f(stx.io.json.JValue.JField(k,stx.io.json.JValueExtensions.map(v1,f)));
				break;
				case 5:
				var fs : Array = $e.params[0];
				return f(stx.io.json.JValue.JObject(Prelude.SArrays.map(fs,function(field : stx.io.json.JValue) : stx.io.json.JValue {
					return stx.io.json.JValueExtensions.map(field,f);
				})));
				break;
				default:
				return f(v);
				break;
				}
			}
			return null;
		}
		
		static public function getOption(v : stx.io.json.JValue,k : String) : stx.Option {
			{
				var $e : enum = (v);
				switch( $e.index ) {
				case 5:
				var xs : Array = $e.params[0];
				{
					var hash : Hash = stx.io.json.JValueExtensions.extractHash(v);
					return ((hash.exists(k))?stx.Option.Some(hash.get(k)):stx.Option.None);
				}
				break;
				default:
				return stx.Option.None;
				break;
				}
			}
			return null;
		}
		
		static public function get(v : stx.io.json.JValue,k : String) : stx.io.json.JValue {
			return function() : stx.io.json.JValue {
				var $r : stx.io.json.JValue;
				{
					var $e2 : enum = (stx.io.json.JValueExtensions.getOption(v,k));
					switch( $e2.index ) {
					case 1:
					var v1 : stx.io.json.JValue = $e2.params[0];
					$r = v1;
					break;
					case 0:
					$r = Prelude.error("Expected to find field " + k + " in " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 80, className : "stx.io.json.JValueExtensions", methodName : "get"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function getOrElse(v : stx.io.json.JValue,k : String,def : Function) : stx.io.json.JValue {
			return function() : stx.io.json.JValue {
				var $r : stx.io.json.JValue;
				{
					var $e2 : enum = (stx.io.json.JValueExtensions.getOption(v,k));
					switch( $e2.index ) {
					case 1:
					var v1 : stx.io.json.JValue = $e2.params[0];
					$r = v1;
					break;
					case 0:
					$r = def();
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractString(v : stx.io.json.JValue) : String {
			return function() : String {
				var $r : String;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					var s : String = $e2.params[0];
					$r = s;
					break;
					default:
					$r = Prelude.error("Expected JString but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 93, className : "stx.io.json.JValueExtensions", methodName : "extractString"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractNumber(v : stx.io.json.JValue) : Number {
			return function() : Number {
				var $r : Number;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 2:
					var n : Number = $e2.params[0];
					$r = n;
					break;
					default:
					$r = Prelude.error("Expected JNumber but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 100, className : "stx.io.json.JValueExtensions", methodName : "extractNumber"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractBool(v : stx.io.json.JValue) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 1:
					var b : Boolean = $e2.params[0];
					$r = b;
					break;
					default:
					$r = Prelude.error("Expected JBool but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 107, className : "stx.io.json.JValueExtensions", methodName : "extractBool"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractKey(v : stx.io.json.JValue) : String {
			return stx.io.json.JValueExtensions.extractField(v)._1;
		}
		
		static public function extractValue(v : stx.io.json.JValue) : stx.io.json.JValue {
			return stx.io.json.JValueExtensions.extractField(v)._2;
		}
		
		static public function extractField(v : stx.io.json.JValue) : stx.Tuple2 {
			return function() : stx.Tuple2 {
				var $r : stx.Tuple2;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 6:
					var v1 : stx.io.json.JValue = $e2.params[1], k : String = $e2.params[0];
					$r = stx.Tuples.t2(k,v1);
					break;
					default:
					$r = Prelude.error("Expected JField but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 119, className : "stx.io.json.JValueExtensions", methodName : "extractField"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractHash(v : stx.io.json.JValue) : Hash {
			return function() : Hash {
				var $r : Hash;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 5:
					var xs : Array = $e2.params[0];
					$r = function() : Hash {
						var $r3 : Hash;
						var hash : Hash = new Hash();
						{
							var _g : int = 0;
							while(_g < xs.length) {
								var x : stx.io.json.JValue = xs[_g];
								++_g;
								var field : stx.Tuple2 = stx.io.json.JValueExtensions.extractField(x);
								hash.set(field._1,field._2);
							}
						}
						$r3 = hash;
						return $r3;
					}();
					break;
					default:
					$r = Prelude.error("Expected JObject but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 135, className : "stx.io.json.JValueExtensions", methodName : "extractHash"});
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractFields(v : stx.io.json.JValue) : Array {
			return Prelude.SArrays.flatMap(stx.io.json.JValueExtensions.extractArray(v),function(j : stx.io.json.JValue) : Array {
				return function() : Array {
					var $r : Array;
					{
						var $e2 : enum = (j);
						switch( $e2.index ) {
						case 6:
						var v1 : stx.io.json.JValue = $e2.params[1], k : String = $e2.params[0];
						$r = [stx.Tuples.t2(k,v1)];
						break;
						default:
						$r = [];
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function extractArray(v : stx.io.json.JValue) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 4:
					var xs : Array = $e2.params[0];
					$r = xs;
					break;
					case 5:
					var xs1 : Array = $e2.params[0];
					$r = xs1;
					break;
					default:
					$r = Prelude.error("Expected JArray or JObject but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 153, className : "stx.io.json.JValueExtensions", methodName : "extractArray"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
