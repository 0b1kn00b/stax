package stx;

class Identity<T>{
	public function new(val){
		this.value = val;
	}
	public var value(default,null) : T;
}

class Functional{
	static public function unit<A>(v:A):Identity<A>{
		return new Identity(v);
	}
	
}