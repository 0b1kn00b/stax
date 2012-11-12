package stx {
	public final class Either extends enum {
		public static const __isenum : Boolean = true;
		public function Either( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Left(v : *) : Either { return new Either("Left",0,[v]); }
		public static function Right(v : *) : Either { return new Either("Right",1,[v]); }
		public static var __constructs__ : Array = ["Left","Right"];;
	}
}
