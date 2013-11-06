package stx;

import Prelude;
using stx.Tuples;
import stx.Eventual;

using stx.Anys;

class Contract<T>{
	@:noUsing
	static public function pure<A>(v:A){
		return new Contract().ok(v);
	}
	public var impl : Eventual<Either<Fail,T>>;

	public function new(){
		impl = new Eventual();
	}
	public function cancel(){
		impl.cancel();
	}
	public function ok(v:T){
		impl.deliver(Right(v));
		return this;
	}
	public function no(e:Fail){
		impl.deliver(Left(e));
		return this;
	}
	public function onIntact(fn:T->Void){
		this.impl.each(
			function(e){
				switch (e){
					case		Left(_)			:
					case 		Right(r) 		: fn(r);
				}
			}
		);
		return this;
	}
	public function onBreach(fn:Fail->Void){
		this.impl.each(
			function(e){
				switch (e){
					case		Left(l)			: fn(l);
					case 		Right(_) 		: 
				}
			}
		);
		return this;	
	}
	public function map<U>(fn:T->U){
		var ctr = new Contract();
		ctr.impl = 
			this.impl.map(
				function(v){
					return switch (v){
						case		Left(l)			: Left(l);
						case 		Right(r) 		: Right(fn(r));
					}
				}
			);
		return ctr;
	}
	public function flatMap<U>(fn:T->Contract<U>):Contract<U>{
		var ctr = new Contract();
		ctr.impl = 
			this.impl.flatMap(
				function(e){
					return switch (e){
						case		Left(l)			: Eventual.pure(Left(l));
						case 		Right(r) 		: fn(r).impl;
					}
				}
			);
		return ctr;
	}
}	
class SetContract extends Contract<Bool>{

}