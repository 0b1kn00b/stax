package stx {
	import stx.Option;
	import stx.Tuples;
	import stx.Arrays;
	import stx.Tuple2;
	public class Objects {
		static public var __meta__ : * = { obj : { note : ["0b1kn00b","Does this handle reference loops, should it, could it?"]}}
		static public function copyDeep(d : *) : * {
			return stx.Objects.copy(d,false);
		}
		
		static public function copy(d : *,shallow : Boolean = true) : * {
			var res : * = { }
			stx.Objects.copyTo(d,res,shallow);
			return res;
		}
		
		static public function copyTypedDeep(d : *) : * {
			return stx.Objects.copy(d,false);
		}
		
		static public function copyTyped(d : *,shallow : Boolean = true) : * {
			return stx.Objects.copy(d,shallow);
		}
		
		static public function copyTo(src : *,dest : *,shallow : Boolean = true) : * {
			var safecopy : Function = function(d : *) : * {
				return function() : * {
					var $r : *;
					{
						var $e2 : enum = (Type._typeof(d));
						switch( $e2.index ) {
						case 4:
						$r = stx.Objects.copy(d,shallow);
						break;
						default:
						$r = d;
						break;
						}
					}
					return $r;
				}();
			}
			{
				var _g : int = 0, _g1 : Array = Reflect.fields(src);
				while(_g < _g1.length) {
					var field : String = _g1[_g];
					++_g;
					var value : * = Reflect.field(src,field);
					Reflect.setField(dest,field,((shallow)?value:safecopy(value)));
				}
			}
			return src;
		}
		
		static public function extendWith(dest : *,src : *,shallow : Boolean = true) : * {
			stx.Objects.copyTo(src,dest,shallow);
			return dest;
		}
		
		static public function copyExtendedWith(a : *,b : *,shallow : Boolean = true) : * {
			var res : * = stx.Objects.copy(a,shallow);
			stx.Objects.copyTo(b,res,shallow);
			return res;
		}
		
		static public function extendWithDeep(dest : *,src : *) : * {
			stx.Objects.copyTo(src,dest,false);
			return dest;
		}
		
		static public function copyExtendedWithDeep(a : *,b : *) : * {
			var res : * = stx.Objects.copy(a,false);
			stx.Objects.copyTo(b,res,false);
			return res;
		}
		
		static public function fields(d : *) : Array {
			return Reflect.fields(d);
		}
		
		static public function mapValues(d : *,f : Function) : * {
			return stx.Objects.setAll({ },Prelude.SArrays.map(Reflect.fields(d),function(name : String) : stx.Tuple2 {
				return stx.Tuples.t2(name,f(Reflect.field(d,name)));
			}));
		}
		
		static public function set(d : *,k : String,v : *) : * {
			Reflect.setField(d,k,v);
			return d;
		}
		
		static public function setAny(d : *,k : String,v : *) : * {
			Reflect.setField(d,k,v);
			return d;
		}
		
		static public function setAll(d : *,fields : *) : * {
			{ var $it : * = fields.iterator();
			while( $it.hasNext() ) { var field : stx.Tuple2 = $it.next();
			Reflect.setField(d,field._1,field._2);
			}}
			return d;
		}
		
		static public function replaceAll(d1 : *,d2 : *,def : *) : * {
			var names : Array = Reflect.fields(d2);
			var oldValues : Array = stx.Objects.extractValues(d1,names,def);
			stx.Objects.extendWith(d1,d2);
			return Prelude.SArrays.foldl(stx.Arrays.zip(names,oldValues),{ },function(o : *,t : stx.Tuple2) : * {
				Reflect.setField(o,t._1,t._2);
				return o;
			});
		}
		
		static public function setAllAny(d : *,fields : *) : * {
			{ var $it : * = fields.iterator();
			while( $it.hasNext() ) { var field : stx.Tuple2 = $it.next();
			Reflect.setField(d,field._1,field._2);
			}}
			return d;
		}
		
		static public function replaceAllAny(d1 : *,d2 : *,def : *) : * {
			var names : Array = Reflect.fields(d2);
			var oldValues : Array = stx.Objects.extractValues(d1,names,def);
			stx.Objects.extendWith(d1,d2);
			return Prelude.SArrays.foldl(stx.Arrays.zip(names,oldValues),{ },function(o : *,t : stx.Tuple2) : * {
				Reflect.setField(o,t._1,t._2);
				return o;
			});
		}
		
		static public function get(d : *,k : String) : stx.Option {
			return ((Reflect.hasField(d,k))?stx.Option.Some(Reflect.field(d,k)):stx.Option.None);
		}
		
		static public function getAny(d : *,k : String) : stx.Option {
			return ((Reflect.hasField(d,k))?stx.Option.Some(Reflect.field(d,k)):stx.Option.None);
		}
		
		static public function extractFieldValues(obj : *,field : String) : Array {
			return Prelude.SArrays.foldl(Reflect.fields(obj),[],function(a : Array,fieldName : String) : Array {
				var value : * = Reflect.field(obj,fieldName);
				return ((fieldName == field)?stx.Arrays.append(a,value):((Type._typeof(value) == ValueType.TObject)?a.concat(stx.Objects.extractFieldValues(value,field)):a));
			});
		}
		
		static public function extractAll(d : *) : Array {
			return Prelude.SArrays.map(Reflect.fields(d),function(name : String) : stx.Tuple2 {
				return stx.Tuples.t2(name,Reflect.field(d,name));
			});
		}
		
		static public function extractAllAny(d : *) : Array {
			return stx.Objects.extractAll(d);
		}
		
		static public function extractValuesAny(d : *,names : *,def : *) : Array {
			return stx.Objects.extractValues(d,names,def);
		}
		
		static public function extractValues(d : *,names : *,def : *) : Array {
			var result : Array = [];
			{ var $it : * = names.iterator();
			while( $it.hasNext() ) { var field : String = $it.next();
			{
				var value : * = Reflect.field(d,field);
				result.push(((value != null)?value:def));
			}
			}}
			return result;
		}
		
		static public function iterator(d : *) : * {
			return Reflect.fields(d).iterator();
		}
		
		static public function toObject(a : Array) : * {
			return Prelude.SArrays.foldl(a,{ },function(init : *,el : stx.Tuple2) : * {
				Reflect.setField(init,el._1,el._2);
				return init;
			});
		}
		
	}
}
