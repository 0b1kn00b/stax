package stx.ds {
	import stx.ds.Examples;
	import stx.ds.IterV;
	import stx.ds.IterVs;
	import haxe.Log;
	import stx.ds.LList;
	public class Main {
		static public function main() : void {
			var list : stx.ds.LList = stx.ds.LList.Cons(5,stx.ds.LList.Cons(7,stx.ds.LList.Cons(6,stx.ds.LList.Nil)));
			var iter : stx.ds.IterV = (stx.ds.Examples.enumerate())(list,stx.ds.Examples.counter());
			haxe.Log._trace("Result " + stx.ds.IterVs.run(iter),{ fileName : "Iteratee.hx", lineNumber : 167, className : "stx.ds.Main", methodName : "main"});
		}
		
	}
}
