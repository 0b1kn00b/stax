package stx.plus {
	import stx.plus.IntShow;
	import stx.plus.Meta;
	import stx.Strings;
	import stx.plus.ArrayShow;
	import stx.plus.BoolShow;
	import stx.plus.IterableShow;
	import stx.plus.FloatShow;
	public class Show {
		static protected function _createShowImpl(impl : Function) : Function {
			return function(v : *) : String {
				return ((null == v)?"null":impl(v));
			}
		}
		
		static public function getShowFor(t : *) : Function {
			return stx.plus.Show.getShowForType(Type._typeof(t));
		}
		
		static public function getShowForType(v : ValueType) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					$r = stx.plus.Show._createShowImpl(stx.plus.BoolShow.toString);
					break;
					case 1:
					$r = stx.plus.Show._createShowImpl(stx.plus.IntShow.toString);
					break;
					case 2:
					$r = stx.plus.Show._createShowImpl(stx.plus.FloatShow.toString);
					break;
					case 8:
					$r = stx.plus.Show._createShowImpl(function(v1 : *) : String {
						return "<unknown>";
					});
					break;
					case 4:
					$r = stx.plus.Show._createShowImpl(function(v2 : *) : String {
						var buf : Array = [];
						{
							var _g : int = 0, _g1 : Array = Reflect.fields(v2);
							while(_g < _g1.length) {
								var k : String = _g1[_g];
								++_g;
								var i : * = Reflect.field(v2,k);
								buf.push(k + ":" + (stx.plus.Show.getShowFor(i))(i));
							}
						}
						return "{" + buf.join(",") + "}";
					});
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						switch(Type.getClassName(c)) {
						case "String":
						$r3 = stx.plus.Show._createShowImpl(stx.Strings.toString);
						break;
						case "Array":
						$r3 = stx.plus.Show._createShowImpl(stx.plus.ArrayShow.toString);
						break;
						default:
						$r3 = ((stx.plus.Meta._hasMetaDataClass(c))?function() : Function {
							var $r4 : Function;
							var fields : Array = stx.plus.Meta._fieldsWithMeta(c,"show");
							$r4 = stx.plus.Show._createShowImpl(function(v3 : *) : String {
								var values : Array = Prelude.SArrays.map(Prelude.SArrays.filter(Prelude.SArrays.map(fields,function(f : String) : * {
									return Reflect.field(v3,f);
								}),function(v4 : *) : Boolean {
									return !Reflect.isFunction(v4);
								}),function(v5 : *) : String {
									return (stx.plus.Show.getShowFor(v5))(v5);
								});
								return stx.plus.IterableShow.mkString(values,null,Type.getClassName(c) + "(",")",", ");
							});
							return $r4;
						}():((Type.getInstanceFields(c).remove("toString"))?stx.plus.Show._createShowImpl(function(v6 : *) : String {
							return Reflect.callMethod(v6,Reflect.field(v6,"toString"),[]);
						}):stx.plus.Show._createShowImpl(function(v7 : *) : String {
							return Type.getClassName(Type.getClass(v7));
						})));
						break;
						}
						return $r3;
					}();
					break;
					case 7:
					var e : Class = $e2.params[0];
					$r = stx.plus.Show._createShowImpl(function(v8 : enum) : String {
						var buf1 : String = Type.enumConstructor(v8);
						var params : Array = Type.enumParameters(v8);
						if(params.length == 0) return buf1;
						else {
							buf1 += "(";
							{
								var _g2 : int = 0;
								while(_g2 < params.length) {
									var p : * = params[_g2];
									++_g2;
									buf1 += (stx.plus.Show.getShowFor(p))(p);
								}
							}
							return buf1 + ")";
						}
						return null;
					});
					break;
					case 0:
					$r = function(v9 : *) : String {
						return "null";
					}
					break;
					case 5:
					$r = stx.plus.Show._createShowImpl(function(v10 : *) : String {
						return "<function>";
					});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
