package stx.test {
	public final class Assertation extends enum {
		public static const __isenum : Boolean = true;
		public function Assertation( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function AsyncError(e : *, stack : Array) : Assertation { return new Assertation("AsyncError",6,[e,stack]); }
		public static function Error(e : *, stack : Array) : Assertation { return new Assertation("Error",2,[e,stack]); }
		public static function Failure(msg : String, pos : *) : Assertation { return new Assertation("Failure",1,[msg,pos]); }
		public static function SetupError(e : *, stack : Array) : Assertation { return new Assertation("SetupError",3,[e,stack]); }
		public static function Success(pos : *) : Assertation { return new Assertation("Success",0,[pos]); }
		public static function TeardownError(e : *, stack : Array) : Assertation { return new Assertation("TeardownError",4,[e,stack]); }
		public static function TimeoutError(missedAsyncs : int, stack : Array) : Assertation { return new Assertation("TimeoutError",5,[missedAsyncs,stack]); }
		public static function Warning(msg : String) : Assertation { return new Assertation("Warning",7,[msg]); }
		public static var __constructs__ : Array = ["Success","Failure","Error","SetupError","TeardownError","TimeoutError","AsyncError","Warning"];;
	}
}
