package hx.ds;

import stx.Tuples.*;

using stx.Functions;
using stx.Compose;
using stx.plus.Order;
using stx.Tuples;
using stx.Prelude;
using stx.Arrays;

@:stability(0)
class MultiMap<V>{
	private var impl : OrderedMap<Array<V>>;

	public function new() {
		this.impl = new OrderedMap();
	}
	public function put(key:String,val:V){
		if(!impl.exists(key)){
			impl.put(key,[val]);
		}else{
			impl.get(key).push(val);
		}
		return this;
	}
	public function get(key:String):Array<V>{
		return impl.get(key);
	}
	public function del(key:String){
		impl.del(key);
		return this;
	}
	public function set(t:Tuple2<String,V>){
		this.put(t.fst(),t.snd());
		return this;
	}
	public function iterator(){
		return impl.iterator();
	}
	public function sort():Void{
		this.impl.sort();
		untyped this.impl.impl = ArrayOrder.sort( (this.impl.impl) );
	}
	public function toArray():Array<Tup2<String,V>>{
		return impl.toArray().map(
				function(k:String,v:Array<V>){
					return v.map(tuple2.bind(k));
				}.spread()
			).flatten();
	}
	public function toString():String{
		return impl.toString();		
	}
	@:noUsing
	static public function fromArray<A>(v:Array<Tuple2<String,A>>){
		var hash =  new MultiMap();
		v.foreach(
			hash.set.effectOf()
		);
		return hash;
	}
}