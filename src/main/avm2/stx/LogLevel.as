package stx {
	public final class LogLevel extends enum {
		public static const __isenum : Boolean = true;
		public function LogLevel( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Debug : LogLevel = new LogLevel("Debug",0);
		public static var Error : LogLevel = new LogLevel("Error",3);
		public static var Fatal : LogLevel = new LogLevel("Fatal",4);
		public static var Info : LogLevel = new LogLevel("Info",1);
		public static var Warning : LogLevel = new LogLevel("Warning",2);
		public static var __constructs__ : Array = ["Debug","Info","Warning","Error","Fatal"];;
	}
}
