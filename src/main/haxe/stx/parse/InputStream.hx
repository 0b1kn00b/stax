package stx.parse;

/**
 * ...
 * @author 0b1kn00b
 */
import Type;

import stx.ds.List;
import stx.parse.Parser;

import stx.plus.Equal;

class Tools {
	public static function enumerable < C, T > (v:C):Enumerable < C, T > {
		var o : Enumerable<C,T> = null;
		cast( switch( Type.typeof(v) ) {
				case 		TClass(c)	: switch (Type.getClassName(c)) {
						case "Array" 	: o = cast new ArrayEnumerable(cast v);
						case "String"	: o = cast new StringEnumerable(cast v);
						default 			: throw "no Enumerable found for " + c;
				}
				default : o = cast new NullEnumerable(cast v);
				}
		);
		return o;
	}
	public static function isSequencable(v:Dynamic) {
			return switch( Type.typeof(v) ) {
				case 		TClass(c)	: switch (Type.getClassName(c)) {
						case "Array" 	: true;
						case "String"	: true;
						default 			: false; 
				}
				default : false;
			}
	}
	public static function isImmutable(x:Dynamic) {
		return ( x == null || Std.is(x, Bool) || Std.is(x, Float) || Std.is(x, String) ) ;
	}
}
class Enumerable<C,T> extends Indexable	<C,T> {
	
	public function new(d,?i) {
		super(d, i);
	}
	public function next():T {
		var o = this.at(this.index);
		index++;
		return o;
	}
	public function hasNext():Bool {
		return index < length;
	}
	public function setIndex(i:Int) {
		this.index = i;
		return this;
	}
	public function prepend(v:T):Enumerable<C,T> {
		throw "abstract function";
		return null;
	}
	public function range(loc:Int,?len:Null<Int>):C {
		throw "abstract function";
		return null;
	}
	public function until(v:T):C{
		throw "abstract function";
		return null;
	}
}
class NullEnumerable extends Enumerable<Dynamic,Dynamic>{
	public function new(v, ?i){
		super(v,i);
	}
	override private function get_length() {
		return 0;
	}
	override public function hasNext():Bool {
		return false;
	}
	override public function prepend(v:Dynamic):Enumerable<Dynamic,Dynamic> {
		return this;
	}
	override public function range(loc:Int,?len:Null<Int>):Dynamic {
		return null;
	}
	override public function until(v:Dynamic):Dynamic{
		return null;
	}	
}
class StringEnumerable extends Enumerable<String,String>{
	public function new(v, ?i) {
		super(v, i);
	}
	override public function at(i:Int) {
		return this.data.charAt(i);
	}
	override private function get_length() {
		return this.data.length;
	}
	override public function prepend(v:String):Enumerable<String,String> {
		var left 	= this.data.substr(0, index);
		var right = this.data.substr(index);
		
		return new StringEnumerable( this.data = left + v + right , this.index );
	}
	override public function range(loc:Int, ?len:Null<Int>):String {
		if (len == null ) len = this.length - loc;
		return data.substr(loc, len);
	}
	override public function until(v:String):String{
		var eq = Equal.getEqualFor(v);
		var next = '';
		while (!eq(at(index),v)){
			next+= at(index);
			index++;
		}
		return next;
	}
}
class ArrayEnumerable<T> extends Enumerable < Array<T>, T > {
	public function new(v,?i) {
		super(v, i);
	}
	override public function at(i:Int) {
		return this.data[i];
	}
	override private function get_length() {
		return this.data.length;
	}
	override public function prepend(v:T):Enumerable<Array<T>,T> {
		var out = this.data.copy();
				out.insert(this.index, v);
		return new ArrayEnumerable( out , this.index );
	}
	override public function range(loc:Int, ?len:Null<Int>):Array<T> {
		len = len == null ? length - loc : len;
		return data.slice(loc, loc + len);
	}
	inline public static function reader<I>(arr : Array<I>) : Input<I> return {
    content : cast new ArrayEnumerable(arr),
		store 						: new Map<String,I>(),
    offset : 0,
    memo : {
      memoEntries 		: new Map<String,MemoEntry>(),
      recursionHeads	: new Map<String,Head>(),
      lrStack 				: List.nil(),
    }
  }
  override public function until(v:T):Array<T>{
		var eq = Equal.getEqualFor(v);
		var next = [];
		while (!eq(at(index),v)){
			next.push(at(index));
			index++;
		}
		return next;
	}
}

class Indexable<C,T>{
	public var data : C;
	public var index : Int;
	public function new(data,?index = 0) {
		this.data 	= data;
		this.index	= index;
	}  
	public function at(i):T {
		throw "abstract method";
		return null;
	}	
	public var length (get_length, null):Int;
	private function get_length():Int {
		throw "abstract method";
		return -1;
	}
	public function toString() {
		return "l :" + this.length +" d :("  + Std.string(data) + ")";
	}
}

class StringIterator {
	private var ln		: Int;
	private var data 	: String;
	public var index 	: Int;
	
	public function new(data) {
		this.data = data;
		this.ln		= data.length;
	}
	public function next():String {
		var o = this.data.charAt(this.index);
		this.index++;
		return o;
	}
	public function hasNext():Bool {
		return this.index < this.ln;
	}
}