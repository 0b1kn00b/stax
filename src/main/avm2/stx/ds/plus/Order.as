package stx.plus {
	import stx.Bools;
	import stx.plus.ProductOrder;
	import stx.plus.Meta;
	import stx.Dates;
	import stx.Tuple3;
	import stx.Strings;
	import stx.plus.ArrayOrder;
	import stx.Tuples;
	import stx.Floats;
	import stx.Ints;
	public class Order {
		static protected function _createOrderImpl(impl : Function) : Function {
			return function(a : *,b : *) : int {
				return ((a == b || a == null && b == null)?0:((a == null)?-1:((b == null)?1:impl(a,b))));
			}
		}
		
		static public function getOrderFor(t : *) : Function {
			return stx.plus.Order.getOrderForType(Type._typeof(t));
		}
		
		static public function getOrderForType(v : ValueType) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					$r = stx.plus.Order._createOrderImpl(stx.Bools.compare);
					break;
					case 1:
					$r = stx.plus.Order._createOrderImpl(stx.Ints.compare);
					break;
					case 2:
					$r = stx.plus.Order._createOrderImpl(stx.Floats.compare);
					break;
					case 8:
					$r = function(a : *,b : *) : int {
						return ((a == b)?0:((a > b)?1:-1));
					}
					break;
					case 4:
					$r = stx.plus.Order._createOrderImpl(function(a1 : *,b1 : *) : int {
						{
							var _g : int = 0, _g1 : Array = Reflect.fields(a1);
							while(_g < _g1.length) {
								var key : String = _g1[_g];
								++_g;
								var va : * = Reflect.field(a1,key);
								var vb : * = Reflect.field(b1,key);
								var v1 : int = (stx.plus.Order.getOrderFor(va))(va,vb);
								if(0 != v1) return v1;
							}
						}
						return 0;
					});
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						switch(Type.getClassName(c)) {
						case "String":
						$r3 = stx.plus.Order._createOrderImpl(stx.Strings.compare);
						break;
						case "Date":
						$r3 = stx.plus.Order._createOrderImpl(stx.Dates.compare);
						break;
						case "Array":
						$r3 = stx.plus.Order._createOrderImpl(stx.plus.ArrayOrder.compare);
						break;
						case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
						$r3 = stx.plus.Order._createOrderImpl(stx.plus.ProductOrder.compare);
						break;
						default:
						$r3 = ((stx.plus.Meta._hasMetaDataClass(c))?function() : Function {
							var $r4 : Function;
							var i : int = 0;
							var fields : Array = stx.plus.ArrayOrder.sortWith(Prelude.SArrays.filter(Prelude.SArrays.map(Type.getInstanceFields(c),function(v2 : String) : stx.Tuple3 {
								var fieldMeta : * = stx.plus.Meta._getMetaDataField(c,v2);
								var weight : int = ((fieldMeta != null && Reflect.hasField(fieldMeta,"order"))?Reflect.field(fieldMeta,"order"):1);
								return stx.Tuples.t3(v2,weight,((fieldMeta != null && Reflect.hasField(fieldMeta,"index"))?Reflect.field(fieldMeta,"index"):i++));
							}),function(v3 : stx.Tuple3) : Boolean {
								return v3._2 != 0;
							}),function(a2 : stx.Tuple3,b2 : stx.Tuple3) : int {
								var c1 : int = a2._3 - b2._3;
								if(c1 != 0) return c1;
								return stx.Strings.compare(a2._1,b2._1);
							});
							$r4 = stx.plus.Order._createOrderImpl(function(a3 : *,b3 : *) : int {
								var values : Array = Prelude.SArrays.map(Prelude.SArrays.filter(fields,function(v4 : stx.Tuple3) : Boolean {
									return !Reflect.isFunction(Reflect.field(a3,v4._1));
								}),function(v5 : stx.Tuple3) : stx.Tuple3 {
									return stx.Tuples.t3(Reflect.field(a3,v5._1),Reflect.field(b3,v5._1),v5._2);
								});
								{
									var _g2 : int = 0;
									while(_g2 < values.length) {
										var value : stx.Tuple3 = values[_g2];
										++_g2;
										var c2 : int = (stx.plus.Order.getOrderFor(value._1))(value._1,value._2) * value._3;
										if(c2 != 0) return c2;
									}
								}
								return 0;
							});
							return $r4;
						}():((Type.getInstanceFields(c).remove("compare"))?stx.plus.Order._createOrderImpl(function(a4 : *,b4 : *) : int {
							return a4.compare(b4);
						}):Prelude.error("class " + Type.getClassName(c) + " is not comparable",{ fileName : "Order.hx", lineNumber : 91, className : "stx.plus.Order", methodName : "getOrderForType"})));
						break;
						}
						return $r3;
					}();
					break;
					case 7:
					var e : Class = $e2.params[0];
					$r = stx.plus.Order._createOrderImpl(function(a5 : enum,b5 : enum) : int {
						var v6 : int = Type.enumIndex(a5) - Type.enumIndex(b5);
						if(0 != v6) return v6;
						var pa : Array = Type.enumParameters(a5);
						var pb : Array = Type.enumParameters(b5);
						{
							var _g11 : int = 0, _g3 : int = pa.length;
							while(_g11 < _g3) {
								var i1 : int = _g11++;
								var v7 : int = (stx.plus.Order.getOrderFor(pa[i1]))(pa[i1],pb[i1]);
								if(v7 != 0) return v7;
							}
						}
						return 0;
					});
					break;
					case 0:
					$r = stx.plus.Order._createOrderImpl(function(a6 : *,b6 : *) : int {
						return Prelude.error("at least one of the arguments should be null",{ fileName : "Order.hx", lineNumber : 109, className : "stx.plus.Order", methodName : "getOrderForType"});
					});
					break;
					case 5:
					$r = Prelude.error("unable to compare on a function",{ fileName : "Order.hx", lineNumber : 111, className : "stx.plus.Order", methodName : "getOrderForType"});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
