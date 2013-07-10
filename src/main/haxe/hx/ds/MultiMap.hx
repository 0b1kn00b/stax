package hx.ds;

import stx.Tuples;

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
		
	}
	public function put(key:String,val:V){
		if(impl == null) impl = new OrderedMap();

		if(!impl.exists(key)){
			impl.put(key,[val]);
		}else{
			impl.get(key).push(val);
		}
		return this;
	}
	public function get(key:String):Array<V>{
		if(impl == null) return [];
		return impl.get(key);
	}
	public function del(key:String):Void{
		if(impl == null) return;
		impl.del(key);
	}
	public function set(t:Tuple2<String,V>):Void{
		if(impl == null) impl = new OrderedMap();
		this.put(t.fst(),t.snd());
	}
	public function iterator(){
		return impl.iterator();
	}
	public function sort():Void{
		if(impl == null) return;
		this.impl.sort();
		untyped this.impl.impl = ArrayOrder.sort( (this.impl.impl) );
	}
	public function toArray():Array<Tuple2<String,V>>{
		if(impl == null) return[];
		return impl.toArray().map(
				function(k:String,v:Array<V>){
					return v.map(tuple2.bind(k));
				}.spread()
			).flatten();
	}
	public function toString():String{
		if(impl == null) return '';
		return impl.toString();		
	}
	@:noUsing
	static public function fromArray<A>(v:Array<Tuple2<String,A>>):MultiMap<A>{
		var hash =  new MultiMap();
		v.foreach(
			hash.set.effectOf()
		);
		return hash;
	}
}