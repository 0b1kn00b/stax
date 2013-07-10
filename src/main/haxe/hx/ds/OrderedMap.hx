package hx.ds;

import stx.plus.Show;

import stx.Tuples;

using stx.Compose;
using stx.Functions;
using stx.Prelude;
using stx.Bools;
using stx.Prelude;
using stx.Iterables;
using stx.Arrays;
using stx.Options;
using stx.Tuples;
using stx.Strings;

using stx.plus.Order;

@:stability(1)
class OrderedMap<V>{
	private var impl : Array<Tuple2<String,V>>;
	public function new(){
		impl = [];
	}
	public function put(key:String,val:V){
		var tp = tuple2(key,val);
		findAtKey(key)
			.flatMap(
				function(t){
					return impl.findIndexOf(t);
				}
			).foreach(
				function(idx){
					this.impl = impl.put(idx,tp);
				}	
			).isEmpty()
			 .ifTrue(
			 		function(){
			 			impl.push(tp);
			 			return null;
			 		}
			 	);
	}
	public function exists(key:String){
		return findAtKey(key).isDefined();
	}
	public function get(key:String):V{
		return findAtKey(key).map(Tuples2.snd).getOrElseC(null);
	}
	public function del(key:String){
		findAtKey(key)
		 .foreach(
		 		function(x){
		 			impl.remove(x);
		 		}
		 	);
	}
	public function sort(){
		impl = ArrayOrder.sort(impl);
	}
	public function sortWith(fn:String->String->Int){
		impl =
			impl.sortWith(
				function(t1,t2){
					return fn(t1.fst(),t2.fst());
				}
			);
	}
	public function iterator(){
		return impl.iterator();
	}
	public function vals():Iterator<V>{
		return impl.map( Tuples2.snd ).iterator();
	}
	private function findAtKey(key:String):Option<Tuple2<String,V>>{
		return impl.find(function(t){ return t.fst() == key; });
	}
	public function toString():String{
		var shw 	= null;
		var gsh 	= function(x) {return shw == null ? shw = Show.getShowFor(x) : shw;}

		var vals 	= 
			impl.map(
				function(key,val){
					return '$key : ${gsh(val)(val)}';
				}.spread()
			);
		return vals.foldl('',
			function(memo,next){
				return memo.append('\n\t').append(next);
			}
		);
	}
}	