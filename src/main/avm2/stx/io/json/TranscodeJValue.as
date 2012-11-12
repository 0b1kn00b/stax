package stx.io.json {
	import stx.io.json.BoolJValue;
	import stx.io.json.FloatJValue;
	import stx.io.json.DateJValue;
	import stx.ds.Set;
	import stx.io.json.JValueExtensions;
	import stx.Option;
	import stx.ds.Map;
	import stx.io.json.OptionJValue;
	import stx.io.json.MapJValue;
	import stx.io.json.JValue;
	import stx.Tuple2;
	import stx.Tuple3;
	import stx.io.json.Tuple2JValue;
	import stx.Tuple4;
	import stx.ds.List;
	import stx.io.json.ArrayJValue;
	import stx.io.json.Tuple3JValue;
	import stx.Arrays;
	import stx.Tuple5;
	import stx.io.json.Tuple4JValue;
	import stx.io.json.StringJValue;
	import stx.io.json.Tuple5JValue;
	import stx.io.json.IntJValue;
	import stx.io.json.SetJValue;
	import stx.io.json.ListJValue;
	import stx.io.json.ObjectJValue;
	public class TranscodeJValue {
		static public var __meta__ : * = { statics : { getDecomposerFor : { note : ["#0bk1kn00b: I don´t understand why TObject can´t be decomposed"]}}}
		static protected function _createDecomposeImpl(impl : Function) : Function {
			return function(v : *) : stx.io.json.JValue {
				return ((null == v)?stx.io.json.JValue.JNull:impl(v));
			}
		}
		
		static public function getDecomposerFor(v : ValueType) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (v);
					switch( $e2.index ) {
					case 3:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.BoolJValue.decompose);
					break;
					case 1:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.IntJValue.decompose);
					break;
					case 2:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.FloatJValue.decompose);
					break;
					case 8:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v1 : String) : stx.io.json.JValue {
						return Prelude.error("Can't decompose TUnknown: " + v1,{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 111, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
					});
					break;
					case 4:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ObjectJValue.decompose);
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						switch(Type.getClassName(c)) {
						case "String":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.StringJValue.decompose);
						break;
						case "Date":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.DateJValue.decompose);
						break;
						case "Array":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ArrayJValue.decompose);
						break;
						case "stx.ds.List":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ListJValue.decompose);
						break;
						case "stx.ds.Map":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.MapJValue.decompose);
						break;
						case "stx.ds.Set":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.SetJValue.decompose);
						break;
						case "stx.Tuple2":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple2JValue.decompose);
						break;
						case "stx.Tuple3":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple3JValue.decompose);
						break;
						case "stx.Tuple4":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple4JValue.decompose);
						break;
						case "stx.Tuple5":
						$r3 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple5JValue.decompose);
						break;
						default:
						$r3 = Prelude.error("Decompose function cannot be created. " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 138, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
						break;
						}
						return $r3;
					}();
					break;
					case 7:
					var e : Class = $e2.params[0];
					$r = function() : Function {
						var $r4 : Function;
						switch(Type.getEnumName(e)) {
						case "Option":
						$r4 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.OptionJValue.decompose);
						break;
						case "stx.io.json.JValue":
						$r4 = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.JValueExtensions.decompose);
						break;
						default:
						$r4 = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v2 : enum) : stx.io.json.JValue {
							var name : stx.io.json.JValue = stx.io.json.StringJValue.decompose(Type.getEnumName(e));
							var constructor : stx.io.json.JValue = stx.io.json.StringJValue.decompose(Type.enumConstructor(v2));
							var parameters : stx.io.json.JValue = stx.io.json.JValue.JArray(Prelude.SArrays.map(Type.enumParameters(v2),function(v3 : *) : stx.io.json.JValue {
								return (stx.io.json.TranscodeJValue.getDecomposerFor(Type._typeof(v3)))(v3);
							}));
							return stx.io.json.JValue.JArray([name,constructor,parameters]);
						});
						break;
						}
						return $r4;
					}();
					break;
					case 5:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v4 : *) : stx.io.json.JValue {
						Prelude.error("Can't decompose function.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 153, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
						return stx.io.json.JValue.JNull;
					});
					break;
					case 0:
					$r = function(v5 : *) : stx.io.json.JValue {
						return stx.io.json.JValue.JNull;
					}
					break;
					default:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v6 : *) : stx.io.json.JValue {
						Prelude.error("Can't decompose unknown type.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 157, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
						return stx.io.json.JValue.JNull;
					});
					break;
					}
				}
				return $r;
			}();
		}
		
		static protected function _createExtractorImpl(impl : Function) : Function {
			return function(v : stx.io.json.JValue) : * {
				if(null == v) return null;
				else return impl(v);
				return null;
			}
		}
		
		static public function getExtractorFor(valueType : ValueType,args : Array = null) : Function {
			return function() : Function {
				var $r : Function;
				{
					var $e2 : enum = (valueType);
					switch( $e2.index ) {
					case 3:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v : stx.io.json.JValue) : Boolean {
						return stx.io.json.BoolJValue.extract(Boolean,v);
					});
					break;
					case 1:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v1 : stx.io.json.JValue) : int {
						return stx.io.json.IntJValue.extract(int,v1);
					});
					break;
					case 2:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v2 : stx.io.json.JValue) : Number {
						return stx.io.json.FloatJValue.extract(Number,v2);
					});
					break;
					case 8:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v3 : stx.io.json.JValue) : * {
						return Prelude.error("Can't extract TUnknown: " + Std.string(v3),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 172, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
					});
					break;
					case 4:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v4 : stx.io.json.JValue) : * {
						return stx.io.json.ObjectJValue.extract(v4);
					});
					break;
					case 6:
					var c : Class = $e2.params[0];
					$r = function() : Function {
						var $r3 : Function;
						var t : Class = c;
						var cname : String = Type.getClassName(c);
						$r3 = function() : Function {
							var $r4 : Function;
							switch(cname) {
							case "String":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v5 : stx.io.json.JValue) : String {
								return stx.io.json.StringJValue.extract(String,v5);
							});
							break;
							case "Date":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v6 : stx.io.json.JValue) : Date {
								return stx.io.json.DateJValue.extract(Date,v6);
							});
							break;
							case "Array":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v7 : stx.io.json.JValue) : Array {
								return stx.io.json.ArrayJValue.extract(Array,v7,args[0]);
							});
							break;
							case "stx.ds.List":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v8 : stx.io.json.JValue) : stx.ds.List {
								return stx.io.json.ListJValue.extract(v8,args[0],args[1]);
							});
							break;
							case "stx.ds.Map":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v9 : stx.io.json.JValue) : stx.ds.Map {
								return stx.io.json.MapJValue.extract(v9,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
							});
							break;
							case "stx.ds.Set":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v10 : stx.io.json.JValue) : stx.ds.Set {
								return stx.io.json.SetJValue.extract(v10,args[0],args[1]);
							});
							break;
							case "stx.Tuple2":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v11 : stx.io.json.JValue) : stx.Tuple2 {
								return stx.io.json.Tuple2JValue.extract(v11,args[0],args[1]);
							});
							break;
							case "stx.Tuple3":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v12 : stx.io.json.JValue) : stx.Tuple3 {
								return stx.io.json.Tuple3JValue.extract(v12,args[0],args[1],args[2]);
							});
							break;
							case "stx.Tuple4":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v13 : stx.io.json.JValue) : stx.Tuple4 {
								return stx.io.json.Tuple4JValue.extract(v13,args[0],args[1],args[2],args[3]);
							});
							break;
							case "stx.Tuple5":
							$r4 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v14 : stx.io.json.JValue) : stx.Tuple5 {
								return stx.io.json.Tuple5JValue.extract(v14,args[0],args[1],args[2],args[3],args[4]);
							});
							break;
							default:
							$r4 = Prelude.error("Extract function cannot be created. 'extract' method is missing. Type: " + Std.string(valueType),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 200, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
							break;
							}
							return $r4;
						}();
						return $r3;
					}();
					break;
					case 7:
					var e : Class = $e2.params[0];
					$r = function() : Function {
						var $r5 : Function;
						switch(Type.getEnumName(e)) {
						case "Option":
						$r5 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v15 : stx.io.json.JValue) : stx.Option {
							return stx.io.json.OptionJValue.extract(stx.Option,v15,args[0]);
						});
						break;
						case "stx.io.json.JValue":
						$r5 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v16 : stx.io.json.JValue) : stx.io.json.JValue {
							return stx.io.json.JValueExtensions.extract(stx.io.json.JValue,v16);
						});
						break;
						default:
						$r5 = stx.io.json.TranscodeJValue._createExtractorImpl(function(v17 : stx.io.json.JValue) : * {
							{
								var $e6 : enum = (v17);
								switch( $e6.index ) {
								case 4:
								var arr : Array = $e6.params[0];
								{
									var name : String = stx.io.json.StringJValue.extract(String,arr[0]);
									var constructor : String = stx.io.json.StringJValue.extract(String,arr[1]);
									var parameters : Array = function() : Array {
										var $r7 : Array;
										{
											var $e8 : enum = (arr[2]);
											switch( $e8.index ) {
											case 4:
											var a : Array = $e8.params[0];
											$r7 = function() : Array {
												var $r9 : Array;
												if(args == null) args = [];
												$r9 = Prelude.SArrays.map(stx.Arrays.zip(a,args),function(t1 : stx.Tuple2) : * {
													return (t1._2)(t1._1);
												});
												return $r9;
											}();
											break;
											default:
											$r7 = Prelude.error("Expected JArray but was: " + Std.string(v17),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 216, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
											break;
											}
										}
										return $r7;
									}();
									return Type.createEnum(Type.resolveEnum(name),constructor,parameters);
								}
								break;
								default:
								{
									Prelude.error("Expected JArray but was: " + Std.string(v17),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 220, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
									return null;
								}
								break;
								}
							}
							return null;
						});
						break;
						}
						return $r5;
					}();
					break;
					case 5:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v18 : stx.io.json.JValue) : stx.io.json.JValue {
						Prelude.error("Can't extract function.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 225, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
						return stx.io.json.JValue.JNull;
					});
					break;
					case 0:
					$r = function(v19 : stx.io.json.JValue) : * {
						return null;
					}
					break;
					default:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v20 : stx.io.json.JValue) : stx.io.json.JValue {
						Prelude.error("Can't extract unknown type.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 229, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
						return stx.io.json.JValue.JNull;
					});
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
