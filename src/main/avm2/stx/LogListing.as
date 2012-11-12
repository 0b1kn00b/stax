package stx {
	public final class LogListing extends enum {
		public static const __isenum : Boolean = true;
		public function LogListing( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Exclude(s : String) : LogListing { return new LogListing("Exclude",1,[s]); }
		public static function Include(s : String) : LogListing { return new LogListing("Include",0,[s]); }
		public static var __constructs__ : Array = ["Include","Exclude"];;
	}
}
