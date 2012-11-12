package stx {
	import stx.plus.Equal;
	import stx.Option;
	import stx.Tuple2;
	import stx.Options;
	import stx.Entuple;
	import stx.Floats;
	import stx.Tuples;
	import stx.Ints;
	public class Arrays {
		static public function partition(arr : Array,f : Function) : stx.Tuple2 {
			return Prelude.SArrays.foldl(arr,stx.Tuples.t2([],[]),function(a : stx.Tuple2,b : *) : stx.Tuple2 {
				if(f(b)) a._1.push(b);
				else a._2.push(b);
				return a;
			});
		}
		
		static public function partitionWhile(arr : Array,f : Function) : stx.Tuple2 {
			var partitioning : Boolean = true;
			return Prelude.SArrays.foldl(arr,stx.Tuples.t2([],[]),function(a : stx.Tuple2,b : *) : stx.Tuple2 {
				if(partitioning) {
					if(f(b)) a._1.push(b);
					else {
						partitioning = false;
						a._2.push(b);
					}
				}
				else a._2.push(b);
				return a;
			});
		}
		
		static public function mapTo(src : Array,dest : Array,f : Function) : Array {
			return Prelude.SArrays.foldl(src,Prelude.SArrays.snapshot(dest),function(a : Array,b : *) : Array {
				a.push(f(b));
				return a;
			});
		}
		
		static public function flatten(arrs : Array) : Array {
			var res : Array = [];
			{
				var _g : int = 0;
				while(_g < arrs.length) {
					var arr : Array = arrs[_g];
					++_g;
					{
						var _g1 : int = 0;
						while(_g1 < arr.length) {
							var e : * = arr[_g1];
							++_g1;
							res.push(e);
						}
					}
				}
			}
			return res;
		}
		
		static public function interleave(alls : Array) : Array {
			var res : Array = [];
			if(alls.length > 0) {
				var length : int = function() : int {
					var $r : int;
					var minLength : Number = stx.Ints.toFloat(alls[0].length);
					{
						var _g : int = 0;
						while(_g < alls.length) {
							var e : Array = alls[_g];
							++_g;
							minLength = Math.min(minLength,stx.Ints.toFloat(e.length));
						}
					}
					$r = stx.Floats._int(minLength);
					return $r;
				}();
				var i : int = 0;
				while(i < length) {
					{
						var _g1 : int = 0;
						while(_g1 < alls.length) {
							var arr : Array = alls[_g1];
							++_g1;
							res.push(arr[i]);
						}
					}
					i++;
				}
			}
			return res;
		}
		
		static public function flatMapTo(src : Array,dest : Array,f : Function) : Array {
			return Prelude.SArrays.foldl(src,dest,function(a : Array,b : *) : Array {
				{
					var _g : int = 0, _g1 : Array = f(b);
					while(_g < _g1.length) {
						var e : * = _g1[_g];
						++_g;
						a.push(e);
					}
				}
				return a;
			});
		}
		
		static public function count(arr : Array,f : Function) : int {
			return Prelude.SArrays.foldl(arr,0,function(a : int,b : *) : int {
				return a + (((f(b))?1:0));
			});
		}
		
		static public function countWhile(arr : Array,f : Function) : int {
			var counting : Boolean = true;
			return Prelude.SArrays.foldl(arr,0,function(a : int,b : *) : int {
				return ((!counting)?a:((f(b))?a + 1:function() : int {
					var $r : int;
					counting = false;
					$r = a;
					return $r;
				}()));
			});
		}
		
		static public function scanl(arr : Array,init : *,f : Function) : Array {
			var accum : * = init;
			var result : Array = [init];
			{
				var _g : int = 0;
				while(_g < arr.length) {
					var e : * = arr[_g];
					++_g;
					result.push(f(e,accum));
				}
			}
			return result;
		}
		
		static public function scanr(arr : Array,init : *,f : Function) : Array {
			var a : Array = Prelude.SArrays.snapshot(arr);
			a.reverse();
			return stx.Arrays.scanl(a,init,f);
		}
		
		static public function scanl1(arr : Array,f : Function) : Array {
			var result : Array = [];
			if(0 == arr.length) return result;
			var accum : * = arr[0];
			result.push(accum);
			{
				var _g1 : int = 1, _g : int = arr.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					result.push(f(arr[i],accum));
				}
			}
			return result;
		}
		
		static public function scanr1(arr : Array,f : Function) : Array {
			var a : Array = Prelude.SArrays.snapshot(arr);
			a.reverse();
			return stx.Arrays.scanl1(a,f);
		}
		
		static public function elements(arr : Array) : * {
			return Prelude.SArrays.snapshot(arr);
		}
		
		static public function appendAll(arr : Array,i : *) : Array {
			var acc : Array = Prelude.SArrays.snapshot(arr);
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			acc.push(e);
			}}
			return acc;
		}
		
		static public function isEmpty(arr : Array) : Boolean {
			return arr.length == 0;
		}
		
		static public function find(arr : Array,f : Function) : stx.Option {
			return Prelude.SArrays.foldl(arr,stx.Option.None,function(a : stx.Option,b : *) : stx.Option {
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
		
		static public function findIndexOf(arr : Array,obj : *) : stx.Option {
			var index : int = stx.Arrays.indexOf(arr,obj);
			return ((index == -1)?stx.Option.None:stx.Option.Some(index));
		}
		
		static public function forAll(arr : Array,f : Function) : Boolean {
			return Prelude.SArrays.foldl(arr,true,function(a : Boolean,b : *) : Boolean {
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
		
		static public function forAny(arr : Array,f : Function) : Boolean {
			return Prelude.SArrays.foldl(arr,false,function(a : Boolean,b : *) : Boolean {
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
		
		static public function exists(arr : Array,f : Function) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (stx.Arrays.find(arr,f));
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
		
		static public function reversed(arr : Array) : Array {
			return Prelude.SIterables.foldl(arr,[],function(a : Array,b : *) : Array {
				a.unshift(b);
				return a;
			});
		}
		
		static public function existsP(arr : Array,ref : *,f : Function) : Boolean {
			var result : Boolean = false;
			{
				var _g : int = 0;
				while(_g < arr.length) {
					var e : * = arr[_g];
					++_g;
					if(f(e,ref)) return true;
				}
			}
			return false;
		}
		
		static public function nubBy(arr : Array,f : Function) : Array {
			return Prelude.SArrays.foldl(arr,[],function(a : Array,b : *) : Array {
				return ((stx.Arrays.existsP(a,b,f))?a:stx.Arrays.append(a,b));
			});
		}
		
		static public function nub(arr : Array) : Array {
			return stx.Arrays.nubBy(arr,stx.plus.Equal.getEqualFor(arr[0]));
		}
		
		static public function intersectBy(arr1 : Array,arr2 : Array,f : Function) : Array {
			return Prelude.SArrays.foldl(arr1,[],function(a : Array,b : *) : Array {
				return ((stx.Arrays.existsP(arr2,b,f))?stx.Arrays.append(a,b):a);
			});
		}
		
		static public function intersect(arr1 : Array,arr2 : Array) : Array {
			return stx.Arrays.intersectBy(arr1,arr2,stx.plus.Equal.getEqualFor(arr1[0]));
		}
		
		static public function splitAt(srcArr : Array,index : int) : stx.Tuple2 {
			return stx.Tuples.t2(srcArr.slice(0,index),srcArr.slice(index));
		}
		
		static public function indexOf(a : Array,t : *) : int {
			var index : int = 0;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(e == t) return index;
					++index;
				}
			}
			return -1;
		}
		
		static public function mapWithIndex(a : Array,f : Function) : Array {
			var n : Array = [];
			var i : int = 0;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					n.push(f(e,i++));
				}
			}
			return n;
		}
		
		static public function then(a1 : Array,a2 : Array) : Array {
			return a2;
		}
		
		static public function foldr(a : Array,z : *,f : Function) : * {
			var r : * = z;
			{
				var _g1 : int = 0, _g : int = a.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					var e : * = a[a.length - 1 - i];
					r = f(e,r);
				}
			}
			return r;
		}
		
		static public function zip(a : Array,b : Array) : Array {
			return stx.Arrays.zipWith(a,b,stx.Tuples.t2);
		}
		
		static public function zipWith(a : Array,b : Array,f : Function) : Array {
			var len : int = Math.floor(Math.min(a.length,b.length));
			var r : Array = [];
			{
				var _g : int = 0;
				while(_g < len) {
					var i : int = _g++;
					r.push(f(a[i],b[i]));
				}
			}
			return r;
		}
		
		static public function zipWithIndex(a : Array) : Array {
			return stx.Arrays.zipWithIndexWith(a,stx.Tuples.t2);
		}
		
		static public function zipWithIndexWith(a : Array,f : Function) : Array {
			var len : int = a.length;
			var r : Array = [];
			{
				var _g : int = 0;
				while(_g < len) {
					var i : int = _g++;
					r.push(f(a[i],i));
				}
			}
			return r;
		}
		
		static public function append(a : Array,t : *) : Array {
			var copy : Array = Prelude.SArrays.snapshot(a);
			copy.push(t);
			return copy;
		}
		
		static public function prepend(a : Array,t : *) : Array {
			var copy : Array = Prelude.SArrays.snapshot(a);
			copy.unshift(t);
			return copy;
		}
		
		static public function first(a : Array) : * {
			return a[0];
		}
		
		static public function firstOption(a : Array) : stx.Option {
			return ((a.length == 0)?stx.Option.None:stx.Option.Some(a[0]));
		}
		
		static public function last(a : Array) : * {
			return a[a.length - 1];
		}
		
		static public function lastOption(a : Array) : stx.Option {
			return ((a.length == 0)?stx.Option.None:stx.Option.Some(a[a.length - 1]));
		}
		
		static public function contains(a : Array,t : *) : Boolean {
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(t == e) return true;
				}
			}
			return false;
		}
		
		static public function foreachWithIndex(a : Array,f : Function) : Array {
			var i : int = 0;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					f(e,i++);
				}
			}
			return a;
		}
		
		static public function take(a : Array,n : int) : Array {
			return a.slice(0,stx.Ints.min(n,a.length));
		}
		
		static public function takeWhile(a : Array,p : Function) : Array {
			var r : Array = [];
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(p(e)) r.push(e);
					else break;
				}
			}
			return r;
		}
		
		static public function drop(a : Array,n : int) : Array {
			return ((n >= a.length)?[]:a.slice(n));
		}
		
		static public function dropWhile(a : Array,p : Function) : Array {
			var r : Array = [].concat(a);
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(p(e)) r.shift();
					else break;
				}
			}
			return r;
		}
		
		static public function sliceBy(srcArr : Array,sizeSrc : Array) : Array {
			return function() : Array {
				var $r : Array;
				var slices : Array = [];
				var restIndex : int = 0;
				{
					var _g : int = 0;
					while(_g < sizeSrc.length) {
						var size : int = sizeSrc[_g];
						++_g;
						var newRestIndex : int = restIndex + size;
						var slice : Array = srcArr.slice(restIndex,newRestIndex);
						slices.push(slice);
						restIndex = newRestIndex;
					}
				}
				$r = slices;
				return $r;
			}();
		}
		
		static public function fromHash(hash : Hash) : Array {
			return Prelude.SIterables.toArray(Prelude.SIterables.map(Prelude.SIterables.toIterable(hash.keys()),function(x : String) : stx.Tuple2 {
				return stx.Entuple.entuple(x,hash.get(x));
			}));
		}
		
	}
}
