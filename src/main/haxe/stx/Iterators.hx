package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
using stx.Options;
using Std;

class Iterators {
	static public function toArray<T>( iterator : Iterator<T>) : Array<T>{
		var o = [];
		while (iterator.hasNext()){
			o.push(iterator.next());
		}
		return o;
	}
}
class LazyIterator<T>{
	public static function create(fn,stack){
		return new LazyIterator(fn,stack);
	}
	public function new(f:Void -> Option<T>,stack:Array<Option<T>>){
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
	private var fn 		: Int->Option<T>;
	private var index : Int;

	public function next():T{
		//trace('next $index '.format() + fn(index));
		var o =  fn(index).get();
		index++;
		return o;
	}
	public function hasNext():Bool{
		var o = switch (fn(index)) {
			case Some(v) 	: true;
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