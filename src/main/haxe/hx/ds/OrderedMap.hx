package hx.ds;

using stx.Compose;
using stx.Functions;

using stx.Prelude;
using stx.Bools;
using stx.Prelude;
using stx.Iterables;
using stx.Arrays;
using stx.Maybes;
using stx.Tuples;


using stx.plus.Order;

@:stability(1)
class OrderedMap<V>{
	private var impl : Array<Tuple2<String,V>>;
	public function new(){
		impl = [];
	}
	public function put(key:String,val:V){
		var tp = Tups.t2(key,val);
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
		return findAtKey(key).map(Tup2.snd).getOrElseC(null);
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
					return fn(t1._1,t2._1);
				}
			);
	}
	public function iterator(){
		return impl.iterator();
	}
	public function vals():Iterator<V>{
		return impl.map( Tup2.snd ).iterator();
	}
	private function findAtKey(key:String):Maybe<Tuple2<String,V>>{
		return impl.find(function(t){ return t._1 == key; });
	}
}