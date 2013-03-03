package stx;

import stx.Prelude;
using stx.Maybes;
using Std;

class Iterators {
	static public function toArray<T>( iterator : Iterator<T>) : Array<T>{
		var o = [];
		while (iterator.hasNext()){
			o.push(iterator.next());
		}
		return o;
	}
	static public function forAll<T>( iterator : Iterator<T>, fn : T -> Bool):Bool{
		var ok = true;
		while ( iterator.hasNext() ){
			ok = fn( iterator.next() );
			if (!ok) break;
		}
		return ok;
	}
	static public function foreach<T>( iterator : Iterator<T>, fn : T -> Void):Iterator<T>{
		for (o in iterator)
			fn(o);
		return iterator;
	}
}
class LazyIterator<T>{
	public static function create(fn,stack){
		return new LazyIterator(fn,stack);
	}
	public function new(f:Void -> Maybe<T>,stack:Array<Maybe<T>>){
		this.fn 			= 
			function(i:Int){
	      //trace(i);
	      var o = 
	        if (stack[i] == null){
	           stack[i] = f();
	        }else{
	          stack[i];
	        }
	        //trace(stack[i]);
	      return o;
	    };
		this.index 		= 0;
	}
	private var fn 		: Int->Maybe<T>;
	private var index : Int;

	public function next():T{
		//trace('next $index '.format() + fn(index));
		var o =  fn(index).get();
		index++;
		return o;
	}
	public function hasNext():Bool{
		var o = switch (fn(index)) {
			case Some(_) 	: true;
			case None 		: false;
		}
		//trace('hasNext $index '.format() + o + ' ' + fn(index));
		return o;
	}
	public function iterator(){
		//trace('iter');
		return 
		{
			next 			: next,
			hasNext		: hasNext
		}
	}
}