package hx.ds;

import stx.Compare.*;

import stx.Option;
import stx.Tuples;

using stx.Iterables;
using stx.Functions;
using stx.Compose;
using stx.Order;
using stx.Tuples;
using Prelude;
using stx.Arrays;

@:stability(0)
class MultiMap<K,V>{
	private var impl : OrderedMap<K,Array<V>>;

	public function new() {
		impl = new OrderedMap();
	}
	public function set(key:K,val:V){
		if(!impl.has(key)){
			impl.set(key,[val]);
		}else{
			impl.get(key).push(val);
		}
		return this;
	}
	public function at(key:Int):Array<V>{
		return impl.at(key);
	}
	public function get(key:K):Array<V>{
		return impl.get(key);
	}
	public function del(key:K){
		return impl.del(key);
	}
	public function rem(val:V){
		for( arr in impl.vals() ){
			if( arr.remove(val) ){
				return true;
			}
		}
		return false;
	}
	public function has(key:K){
		return impl.has(key);
	}
	public function put(t:Tuple2<K,V>){
		this.set(t.fst(),t.snd());
	}
	public function iterator(){
		return impl.iterator();
	}
	public function toArray(){
		return impl.toArray();
	}
	public function toString():String{
		return impl.toString();		
	}
	public function search(fn:V->Bool):Option<Tuple2<Int,Tuple2<K,Array<V>>>>{
		return impl.search(
			function(x){
				return x.exists(fn);
			}
		);
	}
	public function vals():Iterable<V>{
		return { 
			iterator : 
			function(){
				var idx 		: Int 			= 0;
				var current : Array<V>  = at(idx);
				var idx0 		: Int 			= 0;

				return {
					next : function(){
						if(idx0 == current.length){
							idx0 = 0;
							idx  +=1;
							current = at(idx);
						}
						var o = current[idx0];
						idx0+=1;
						return o;
					},
					hasNext : function(){
						return if(nl().apply(current)){
							false;
						}else{
							if(idx0 == current.length){
								if(nl().apply(at(idx+1))){
									false;
								}else{
									true;
								}
							}else{
								true;
							}
						}
					}
				}
			}
		};
	}
	public function find(v:V):Option<Tuple2<Int,Tuple2<K,Array<V>>>>{
		var eq = eq(v);
		return this.search(eq.apply);
	}
	public function sort(){
		impl.sort();
	}
	public function sortOnKey(){
		impl.sortOnKey();
	}
	public function sortOnKeyWith(fn:Ord<K>){
		impl.sortOnKeyWith(fn);
	}
	public function size(){
		return impl.size();		
	}
	@:noUsing static public function fromArray<A,B>(v:Array<Tuple2<A,B>>):MultiMap<A,B>{
		var hash = new MultiMap();
		v.each(hash.put.enclose());
		return hash;
	}
}