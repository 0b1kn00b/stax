package stx.ds {
	public final class LList extends enum {
		public static const __isenum : Boolean = true;
		public function LList( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Cons(e : *, t : stx.ds.LList) : LList { return new LList("Cons",0,[e,t]); }
		public static var Nil : LList = new LList("Nil",1);
		public static var __constructs__ : Array = ["Cons","Nil"];;
	}
}
