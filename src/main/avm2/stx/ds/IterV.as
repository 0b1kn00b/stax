package stx.ds {
	import stx.ds.Input;
	public final class IterV extends enum {
		public static const __isenum : Boolean = true;
		public function IterV( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Cont(k : Function) : IterV { return new IterV("Cont",1,[k]); }
		public static function Done(a : *, e : stx.ds.Input) : IterV { return new IterV("Done",0,[a,e]); }
		public static var __constructs__ : Array = ["Done","Cont"];;
	}
}
