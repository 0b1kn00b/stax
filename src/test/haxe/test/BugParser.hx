package test;

/**
 * ...
 * @author 0b1kn00b
 */

import com.mindrocks.text.Parser;
using com.mindrocks.text.Parser;

import com.mindrocks.functional.Functional;
using com.mindrocks.functional.Functional;

using com.mindrocks.macros.LazyMacro;
import com.mindrocks.monads.Monad;

import com.mindrocks.text.ParserMonad;
using com.mindrocks.text.ParserMonad;

using com.mindrocks.text.StringParsers;
using Lambda;

class BugParser {
	//	using:
	//	static var oneP = "1".identifier();
	//	is just fine.
	static var oneP = ParserM.dO({ "1".identifier(); ret("1"); });

	static var addP = "+".identifier();
	
	static function chainl1<S,T>(p:Void->Parser<S,T>, op:Void->Parser<S,T->T->T>):Void->Parser<S,T> {
		function rest(x:T) return ParserM.dO({
			f <= op;
			y <= p;
			rest(f(x,y));
		}).or(x.success());
		return ParserM.dO({ x <= p; rest(x); });
	}

	static var addOpP = ParserM.dO({ addP; ret(function (x:String,y:String) return x+y); });
	static var addChainP = chainl1(oneP, addOpP).lazyF();

	public static function test_Issue1() {
		trace(addChainP()("1+1+1".reader()));
	}
	
}