package stx {
	public final class Option extends enum {
		public static const __isenum : Boolean = true;
		public function Option( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var None : Option = new Option("None",0);
		public static function Some(v : *) : Option { return new Option("Some",1,[v]); }
		public static var __constructs__ : Array = ["None","Some"];;
	}
}
