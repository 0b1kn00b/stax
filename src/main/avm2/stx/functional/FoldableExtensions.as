package stx.functional {
	import stx.plus.Equal;
	import stx.Option;
	import stx.Tuple2;
	import stx.Options;
	import stx.functional.Foldable;
	import stx.Tuples;
	import stx.plus.Show;
	public class FoldableExtensions {
		static public function foldr(foldable : stx.functional.Foldable,z : *,f : Function) : * {
			var a : Array = stx.functional.FoldableExtensions.toArray(foldable);
			a.reverse();
			var acc : * = z;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					acc = f(e,acc);
				}
			}
			return acc;
		}
		
		static public function filter(foldable : stx.functional.Foldable,f : Function) : * {
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((f(b))?a.append(b):a);
			});
		}
		
		static public function partition(foldable : stx.functional.Foldable,f : Function) : stx.Tuple2 {
			return foldable.foldl(stx.Tuples.t2(foldable.empty(),foldable.empty()),function(a : stx.Tuple2,b : *) : stx.Tuple2 {
				return ((f(b))?stx.Tuples.t2(a._1.append(b),a._2):stx.Tuples.t2(a._1,a._2.append(b)));
			});
		}
		
		static public function partitionWhile(foldable : stx.functional.Foldable,f : Function) : stx.Tuple2 {
			var partitioning : Boolean = true;
			return foldable.foldl(stx.Tuples.t2(foldable.empty(),foldable.empty()),function(a : stx.Tuple2,b : *) : stx.Tuple2 {
				return ((partitioning)?((f(b))?stx.Tuples.t2(a._1.append(b),a._2):function() : stx.Tuple2 {
					var $r : stx.Tuple2;
					partitioning = false;
					$r = stx.Tuples.t2(a._1,a._2.append(b));
					return $r;
				}()):stx.Tuples.t2(a._1,a._2.append(b)));
			});
		}
		
		static public function map(src : stx.functional.Foldable,f : Function) : stx.functional.Foldable {
			return stx.functional.FoldableExtensions.mapTo(src,src.empty(),f);
		}
		
		static public function mapTo(src : stx.functional.Foldable,dest : stx.functional.Foldable,f : Function) : * {
			return src.foldl(dest,function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return a.append(f(b));
			});
		}
		
		static public function flatMap(src : stx.functional.Foldable,f : Function) : * {
			return stx.functional.FoldableExtensions.flatMapTo(src,src.empty(),f);
		}
		
		static public function flatMapTo(src : stx.functional.Foldable,dest : stx.functional.Foldable,f : Function) : * {
			return src.foldl(dest,function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return f(b).foldl(a,function(a1 : stx.functional.Foldable,b1 : *) : stx.functional.Foldable {
					return a1.append(b1);
				});
			});
		}
		
		static public function take(foldable : stx.functional.Foldable,n : int) : * {
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((n-- > 0)?a.append(b):a);
			});
		}
		
		static public function takeWhile(foldable : stx.functional.Foldable,f : Function) : * {
			var taking : Boolean = true;
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((taking)?((f(b))?a.append(b):function() : stx.functional.Foldable {
					var $r : stx.functional.Foldable;
					taking = false;
					$r = a;
					return $r;
				}()):a);
			});
		}
		
		static public function drop(foldable : stx.functional.Foldable,n : int) : * {
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((n-- > 0)?a:a.append(b));
			});
		}
		
		static public function dropWhile(foldable : stx.functional.Foldable,f : Function) : * {
			var dropping : Boolean = true;
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((dropping)?((f(b))?a:function() : stx.functional.Foldable {
					var $r : stx.functional.Foldable;
					dropping = false;
					$r = a.append(b);
					return $r;
				}()):a.append(b));
			});
		}
		
		static public function count(foldable : stx.functional.Foldable,f : Function) : int {
			return foldable.foldl(0,function(a : int,b : *) : int {
				return a + (((f(b))?1:0));
			});
		}
		
		static public function countWhile(foldable : stx.functional.Foldable,f : Function) : int {
			var counting : Boolean = true;
			return foldable.foldl(0,function(a : int,b : *) : int {
				return ((!counting)?a:((f(b))?a + 1:function() : int {
					var $r : int;
					counting = false;
					$r = a;
					return $r;
				}()));
			});
		}
		
		static public function scanl(foldable : stx.functional.Foldable,init : *,f : Function) : * {
			var a : Array = stx.functional.FoldableExtensions.toArray(foldable);
			var result : * = foldable.empty().append(init);
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					result = result.append(f(e,init));
				}
			}
			return result;
		}
		
		static public function scanr(foldable : stx.functional.Foldable,init : *,f : Function) : * {
			var a : Array = stx.functional.FoldableExtensions.toArray(foldable);
			a.reverse();
			var result : * = foldable.empty().append(init);
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					result = result.append(f(e,init));
				}
			}
			return result;
		}
		
		static public function scanl1(foldable : stx.functional.Foldable,f : Function) : * {
			var iterator : * = stx.functional.FoldableExtensions.toArray(foldable).iterator();
			var result : stx.functional.Foldable = foldable.empty();
			if(!iterator.hasNext()) return result;
			var accum : * = iterator.next();
			result = result.append(accum);
			while(iterator.hasNext()) result = result.append(f(iterator.next(),accum));
			return result;
		}
		
		static public function scanr1(foldable : stx.functional.Foldable,f : Function) : * {
			var a : Array = stx.functional.FoldableExtensions.toArray(foldable);
			a.reverse();
			var iterator : * = a.iterator();
			var result : stx.functional.Foldable = foldable.empty();
			if(!iterator.hasNext()) return result;
			var accum : * = iterator.next();
			result = result.append(accum);
			while(iterator.hasNext()) result = result.append(f(iterator.next(),accum));
			return result;
		}
		
		static public function elements(foldable : stx.functional.Foldable) : * {
			return stx.functional.FoldableExtensions.toArray(foldable);
		}
		
		static public function concat(foldable : stx.functional.Foldable,rest : stx.functional.Foldable) : * {
			return rest.foldl(foldable,function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return a.append(b);
			});
		}
		
		static public function append(foldable : stx.functional.Foldable,e : *) : * {
			return foldable.append(e);
		}
		
		static public function appendAll(foldable : stx.functional.Foldable,i : *) : * {
			var acc : stx.functional.Foldable = foldable;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			acc = acc.append(e);
			}}
			return acc;
		}
		
		static public function iterator(foldable : stx.functional.Foldable) : * {
			return stx.functional.FoldableExtensions.elements(foldable).iterator();
		}
		
		static public function isEmpty(foldable : stx.functional.Foldable) : Boolean {
			return !stx.functional.FoldableExtensions.iterator(foldable).hasNext();
		}
		
		static public function foreach(foldable : stx.functional.Foldable,f : Function) : stx.functional.Foldable {
			foldable.foldl(1,function(a : int,b : *) : int {
				f(b);
				return a;
			});
			return foldable;
		}
		
		static public function find(foldable : stx.functional.Foldable,f : Function) : stx.Option {
			return foldable.foldl(stx.Option.None,function(a : stx.Option,b : *) : stx.Option {
				return function() : stx.Option {
					var $r : stx.Option;
					{
						var $e2 : enum = (a);
						switch( $e2.index ) {
						case 0:
						$r = stx.Options.filter(stx.Options.toOption(b),f);
						break;
						default:
						$r = a;
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function forAll(foldable : stx.functional.Foldable,f : Function) : Boolean {
			return foldable.foldl(true,function(a : Boolean,b : *) : Boolean {
				return function() : Boolean {
					var $r : Boolean;
					switch(a) {
					case true:
					$r = f(b);
					break;
					case false:
					$r = false;
					break;
					}
					return $r;
				}();
			});
		}
		
		static public function forAny(foldable : stx.functional.Foldable,f : Function) : Boolean {
			return foldable.foldl(false,function(a : Boolean,b : *) : Boolean {
				return function() : Boolean {
					var $r : Boolean;
					switch(a) {
					case false:
					$r = f(b);
					break;
					case true:
					$r = true;
					break;
					}
					return $r;
				}();
			});
		}
		
		static public function exists(foldable : stx.functional.Foldable,f : Function) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (stx.functional.FoldableExtensions.find(foldable,f));
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					$r = true;
					break;
					case 0:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function existsP(foldable : stx.functional.Foldable,ref : *,f : Function) : Boolean {
			var result : Boolean = false;
			var a : Array = stx.functional.FoldableExtensions.toArray(foldable);
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(f(e,ref)) result = true;
				}
			}
			return result;
		}
		
		static public function contains(foldable : stx.functional.Foldable,member : *) : Boolean {
			return stx.functional.FoldableExtensions.exists(foldable,function(e : *) : Boolean {
				return e == member;
			});
		}
		
		static public function nubBy(foldable : stx.functional.Foldable,f : Function) : * {
			return foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((stx.functional.FoldableExtensions.existsP(a,b,f))?a:a.append(b));
			});
		}
		
		static public function nub(foldable : stx.functional.Foldable) : * {
			var it : * = stx.functional.FoldableExtensions.iterator(foldable);
			var first : * = ((it.hasNext())?it.next():null);
			return stx.functional.FoldableExtensions.nubBy(foldable,stx.plus.Equal.getEqualFor(first));
		}
		
		static public function intersectBy(foldable1 : stx.functional.Foldable,foldable2 : stx.functional.Foldable,f : Function) : * {
			return foldable1.foldl(foldable1.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				return ((stx.functional.FoldableExtensions.existsP(foldable2,b,f))?a.append(b):a);
			});
		}
		
		static public function intersect(foldable1 : stx.functional.Foldable,foldable2 : stx.functional.Foldable) : * {
			var it : * = stx.functional.FoldableExtensions.iterator(foldable1);
			var first : * = ((it.hasNext())?it.next():null);
			return stx.functional.FoldableExtensions.intersectBy(foldable1,foldable2,stx.plus.Equal.getEqualFor(first));
		}
		
		static public function mkString(foldable : stx.functional.Foldable,sep : String = ", ",show : Function = null) : String {
			if(sep==null) sep=", ";
			var isFirst : Boolean = true;
			return foldable.foldl("",function(a : String,b : *) : String {
				var prefix : String = ((isFirst)?function() : String {
					var $r : String;
					isFirst = false;
					$r = "";
					return $r;
				}():sep);
				if(null == show) show = stx.plus.Show.getShowFor(b);
				return a + prefix + show(b);
			});
		}
		
		static public function toArray(foldable : stx.functional.Foldable) : Array {
			var es : Array = [];
			foldable.foldl(foldable.empty(),function(a : stx.functional.Foldable,b : *) : stx.functional.Foldable {
				es.push(b);
				return a;
			});
			return es;
		}
		
	}
}
