package stx;

import haxe.PosInfos;

import stx.Prelude;

import stx.macro.F;
import stx.plus.Equal;

using stx.ArrowFn;
using stx.Functions;
using stx.Bools;
using stx.Dynamics;
using stx.Options;
using stx.Tuples;
using stx.Cont;
using stx.Assertion;
//using stx.Predicates;

class Assertion<A,B>{
	public var pos 	: PosInfos;
	public var msg 	: String;
	public var fn 	: A->B->Bool;
}
class Assertions{
	static private function error(p:PosInfos,msg:String = 'ERROR'):Error{
		return Error.create(msg,p);
	}
	static private function equals<A>(a:A,b:A):Bool{
		return equalsWith(a,b,null);
	}
	static private function equalsWith<A>(a:A, b:A, eq:EqualFunction<A>):Bool{
		if (eq == null) eq = function(a,b){ return a == b; };
		return eq(a,b);
	}
	static private function optionOf<A>(fn:A->Bool,msg:String = 'ERROR'):A->Option<String>{
		return fn.andThen( function(b) return b ? None : Some(msg) );
	}
	static private function unop<A>(pos, val:A, ?msg, ?eq){
		return optionOf(equalsWith.p1(val).p2(eq),msg).andThen(Options.map.p2(error.p1(pos)));
	}
	static public function areEqualToWith<A>(eq, ?pos):(Tuple2<A,A> -> Option<Error> ){
		return optionOf(Tuple2.into.p2(equalsWith.p3(eq))).andThen(Options.map.p2(error.p1(pos)));
	}
	static public function areEqualTo<A>(?pos){
		return areEqualToWith(null,pos);
	}
	static public function isEqualToWith<A>(eq, ?pos){ 
		return Tuple2.create.curry().andThen(Functions1.andThen.p2(areEqualToWith(eq,pos)));
	}
	static public function isEqualTo(?pos){
		return isEqualToWith(null,pos);
	}
	static public function isTrue(?pos){
		return unop(pos, true, 'Should be `true`.');
	}
	static public function isFalse(?pos){
		return unop(pos, false, 'Should be `false`.');
	}
}