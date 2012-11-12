package stx.reactive {
	public final class RepeatV extends enum {
		public static const __isenum : Boolean = true;
		public function RepeatV( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Done(x : *) : RepeatV { return new RepeatV("Done",1,[x]); }
		public static function Repeat(x : *) : RepeatV { return new RepeatV("Repeat",0,[x]); }
		public static var __constructs__ : Array = ["Repeat","Done"];;
	}
}
