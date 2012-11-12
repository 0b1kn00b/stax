package stx {
	import stx.LazyIterator;
	import stx.Option;
	import stx.Tuple2;
	import stx.Arrays;
	import stx.Options;
	import stx.Tuples;
	public class Iterables {
		static public function foldl1(iter : *,mapper : Function) : * {
			var folded : * = stx.Iterables.head(iter);
			{
				var $e : enum = (stx.Iterables.tailOption(iter));
				switch( $e.index ) {
				case 1:
				var v : * = $e.params[0];
				{
					{ var $it2 : * = v.iterator();
					while( $it2.hasNext() ) { var e : * = $it2.next();
					folded = mapper(folded,e);
					}}
				}
				break;
				default:
				break;
				}
			}
			return folded;
		}
		
		static public function concat(iter1 : *,iter2 : *) : * {
			return Prelude.SIterables.toArray(iter1).concat(Prelude.SIterables.toArray(iter2));
		}
		
		static public function foldr(iterable : *,z : *,f : Function) : * {
			return stx.Arrays.foldr(Prelude.SIterables.toArray(iterable),z,f);
		}
		
		static public function headOption(iter : *) : stx.Option {
			var iterator : * = iter.iterator();
			return ((iterator.hasNext())?function() : stx.Option {
				var $r : stx.Option;
				var o : * = iterator.next();
				$r = stx.Option.Some(o);
				return $r;
			}():stx.Option.None);
		}
		
		static public function head(iter : *) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (stx.Iterables.headOption(iter));
					switch( $e2.index ) {
					case 0:
					$r = Prelude.error("Iterable has no head",{ fileName : "Iterables.hx", lineNumber : 57, className : "stx.Iterables", methodName : "head"});
					break;
					case 1:
					var h : * = $e2.params[0];
					$r = h;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function tailOption(iter : *) : stx.Option {
			var iterator : * = iter.iterator();
			return ((!iterator.hasNext())?stx.Option.None:stx.Option.Some(stx.Iterables.drop(iter,1)));
		}
		
		static public function tail(iter : *) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (stx.Iterables.tailOption(iter));
					switch( $e2.index ) {
					case 0:
					$r = Prelude.error("Iterable has no tail",{ fileName : "Iterables.hx", lineNumber : 74, className : "stx.Iterables", methodName : "tail"});
					break;
					case 1:
					var t : * = $e2.params[0];
					$r = t;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function drop(iter : *,n : int) : * {
			var iterator : * = iter.iterator();
			while(iterator.hasNext() && n > 0) {
				iterator.next();
				--n;
			}
			var result : Array = [];
			while(iterator.hasNext()) result.push(iterator.next());
			return result;
		}
		
		static public function dropWhile(a : *,p : Function) : * {
			var r : * = stx.Iterables.appendAll([],a);
			{ var $it : * = a.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			if(p(e)) {
				{
					var $e2 : enum = (stx.Iterables.tailOption(r));
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					r = v;
					break;
					default:
					r = [];
					break;
					}
				}
			}
			else break;
			}}
			return r;
		}
		
		static public function take(iter : *,n : int) : * {
			var iterator : * = iter.iterator();
			var result : Array = [];
			{
				var _g1 : int = 0, _g : int = n;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(iterator.hasNext()) result.push(iterator.next());
				}
			}
			return result;
		}
		
		static public function takeWhile(a : *,p : Function) : * {
			var r : Array = [];
			{ var $it : * = a.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			if(p(e)) r.push(e);
			else break;
			}}
			return r;
		}
		
		static public function exists(iter : *,fn : Function) : Boolean {
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var element : * = $it.next();
			if(fn(element)) return true;
			}}
			return false;
		}
		
		static public function contains(iter : *,value : *,eq : Function) : Boolean {
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var el : * = $it.next();
			if(eq(value,el)) return true;
			}}
			return false;
		}
		
		static public function nub(iter : *) : * {
			var result : Array = [];
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var element : * = $it.next();
			if(!stx.Iterables.contains(result,element,function(a : *,b : *) : Boolean {
				return a == b;
			})) result.push(element);
			}}
			return result;
		}
		
		static public function at(iter : *,index : int) : * {
			var result : * = null;
			if(index < 0) index = Prelude.SIterables.size(iter) - -1 * index;
			var curIndex : int = 0;
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			if(index == curIndex) return e;
			else ++curIndex;
			}}
			return Prelude.error("Index not found",{ fileName : "Iterables.hx", lineNumber : 163, className : "stx.Iterables", methodName : "at"});
		}
		
		static public function flatten(iter : *) : * {
			var empty : * = [];
			return Prelude.SIterables.foldl(iter,empty,stx.Iterables.concat);
		}
		
		static public function interleave(iter : *) : * {
			var alls : Array = Prelude.SIterables.toArray(Prelude.SIterables.map(iter,function(it : *) : * {
				return it.iterator();
			}));
			var res : Array = [];
			while(stx.Arrays.forAll(alls,function(iter1 : *) : Boolean {
				return iter1.hasNext();
			})) Prelude.SArrays.foreach(alls,function(iter2 : *) : void {
				res.push(iter2.next());
			});
			return res;
		}
		
		static public function zip(iter1 : *,iter2 : *) : * {
			var i1 : * = iter1.iterator();
			var i2 : * = iter2.iterator();
			var result : Array = [];
			while(i1.hasNext() && i2.hasNext()) {
				var t1 : * = i1.next();
				var t2 : * = i2.next();
				result.push(stx.Tuples.t2(t1,t2));
			}
			return result;
		}
		
		static public function zipup(tuple : stx.Tuple2) : * {
			var i1 : * = tuple._1.iterator();
			var i2 : * = tuple._2.iterator();
			var result : Array = [];
			while(i1.hasNext() && i2.hasNext()) {
				var t1 : * = i1.next();
				var t2 : * = i2.next();
				result.push(stx.Tuples.t2(t1,t2));
			}
			return result;
		}
		
		static public function append(iter : *,e : *) : * {
			return stx.Iterables.foldr(iter,[e],function(a : *,b : Array) : Array {
				b.unshift(a);
				return b;
			});
		}
		
		static public function cons(iter : *,e : *) : * {
			return Prelude.SIterables.foldl(iter,[e],function(b : Array,a : *) : Array {
				b.push(a);
				return b;
			});
		}
		
		static public function reversed(iter : *) : * {
			return Prelude.SIterables.foldl(iter,[],function(a : Array,b : *) : Array {
				a.unshift(b);
				return a;
			});
		}
		
		static public function and(iter : *) : Boolean {
			var iterator : * = iter.iterator();
			while(iterator.hasNext()) {
				var element : Boolean = iterator.next();
				if(element == false) return false;
			}
			return true;
		}
		
		static public function or(iter : *) : Boolean {
			var iterator : * = iter.iterator();
			while(iterator.hasNext()) if(iterator.next() == true) return true;
			return false;
		}
		
		static public function scanl(iter : *,init : *,f : Function) : * {
			var result : Array = [init];
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			result.push(f(e,init));
			}}
			return result;
		}
		
		static public function scanr(iter : *,init : *,f : Function) : * {
			return stx.Iterables.scanl(stx.Iterables.reversed(iter),init,f);
		}
		
		static public function scanl1(iter : *,f : Function) : * {
			var iterator : * = iter.iterator();
			var result : Array = [];
			if(!iterator.hasNext()) return result;
			var accum : * = iterator.next();
			result.push(accum);
			while(iterator.hasNext()) result.push(f(iterator.next(),accum));
			return result;
		}
		
		static public function scanr1(iter : *,f : Function) : * {
			return stx.Iterables.scanl1(stx.Iterables.reversed(iter),f);
		}
		
		static public function existsP(iter : *,ref : *,f : Function) : Boolean {
			var result : Boolean = false;
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			if(f(ref,e)) result = true;
			}}
			return result;
		}
		
		static public function nubBy(iter : *,f : Function) : * {
			return Prelude.SIterables.foldl(iter,[],function(a : Array,b : *) : Array {
				return ((stx.Iterables.existsP(a,b,f))?a:function() : Array {
					var $r : Array;
					a.push(b);
					$r = a;
					return $r;
				}());
			});
		}
		
		static public function intersectBy(iter1 : *,iter2 : *,f : Function) : * {
			return Prelude.SIterables.foldl(iter1,[],function(a : *,b : *) : * {
				return ((stx.Iterables.existsP(iter2,b,f))?stx.Iterables.append(a,b):a);
			});
		}
		
		static public function intersect(iter1 : *,iter2 : *) : * {
			return Prelude.SIterables.foldl(iter1,[],function(a : *,b : *) : * {
				return ((stx.Iterables.existsP(iter2,b,function(a1 : *,b1 : *) : Boolean {
					return a1 == b1;
				}))?stx.Iterables.append(a,b):a);
			});
		}
		
		static public function unionBy(iter1 : *,iter2 : *,f : Function) : * {
			var result : * = iter1;
			{ var $it : * = iter2.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			{
				var exists : Boolean = false;
				{ var $it2 : * = iter1.iterator();
				while( $it2.hasNext() ) { var i : * = $it2.next();
				if(f(i,e)) exists = true;
				}}
				if(!exists) result = stx.Iterables.append(result,e);
			}
			}}
			return result;
		}
		
		static public function union(iter1 : *,iter2 : *) : * {
			return stx.Iterables.unionBy(iter1,iter2,function(a : *,b : *) : Boolean {
				return a == b;
			});
		}
		
		static public function partition(iter : *,f : Function) : stx.Tuple2 {
			return stx.Arrays.partition(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function partitionWhile(iter : *,f : Function) : stx.Tuple2 {
			return stx.Iterables.partitionWhile(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function count(iter : *,f : Function) : int {
			return stx.Iterables.count(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function countWhile(iter : *,f : Function) : int {
			return stx.Iterables.countWhile(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function elements(iter : *) : * {
			return Prelude.SIterables.toArray(iter);
		}
		
		static public function appendAll(iter : *,i : *) : * {
			return stx.Arrays.appendAll(Prelude.SIterables.toArray(iter),i);
		}
		
		static public function isEmpty(iter : *) : Boolean {
			return !iter.iterator().hasNext();
		}
		
		static public function find(iter : *,f : Function) : stx.Option {
			return stx.Arrays.find(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function forAll(iter : *,f : Function) : Boolean {
			return stx.Arrays.forAll(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function forAny(iter : *,f : Function) : Boolean {
			return stx.Arrays.forAny(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function first(iter : *) : * {
			return stx.Iterables.head(iter);
		}
		
		static public function unwind(root : *,children : Function,depth : Boolean = false) : * {
			var index : int = 0;
			var stack : Array = [root];
			var visit : Function = null;
			visit = function(x : *) : void {
				var _g : int = 0, _g1 : Array = children(x);
				while(_g < _g1.length) {
					var v : * = _g1[_g];
					++_g;
					visit(v);
					stack.push(v);
				}
			}
			visit(root);
			return stx.Iterables.yield(function() : stx.Option {
				var val : * = stack[index];
				index++;
				return stx.Options.toOption(val);
			});
		}
		
		static public function yield(fn : Function) : * {
			var stack : Array = [];
			return { iterator : function() : * {
				return stx.LazyIterator.create(fn,stack).iterator();
			}}
		}
		
	}
}
