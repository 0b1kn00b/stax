package stx.ds {
	import stx.ds.Input;
	public final class Iteratee extends enum {
		public static const __isenum : Boolean = true;
		public function Iteratee( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Cont(k : Function) : Iteratee { return new Iteratee("Cont",1,[k]); }
		public static function Done(a : *, e : stx.ds.Input) : Iteratee { return new Iteratee("Done",0,[a,e]); }
		public static function Err(s : String) : Iteratee { return new Iteratee("Err",2,[s]); }
		public static var __constructs__ : Array = ["Done","Cont","Err"];;
	}
}
