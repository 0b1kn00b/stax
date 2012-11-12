package stx.time {
	public final class TimeInstruction extends enum {
		public static const __isenum : Boolean = true;
		public function TimeInstruction( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Start(id : int, interval : int) : TimeInstruction { return new TimeInstruction("Start",0,[id,interval]); }
		public static function Stop(id : int) : TimeInstruction { return new TimeInstruction("Stop",1,[id]); }
		public static var __constructs__ : Array = ["Start","Stop"];;
	}
}
