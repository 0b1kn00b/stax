package stx.concurrent {
	public final class ActorStatus extends enum {
		public static const __isenum : Boolean = true;
		public function ActorStatus( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Failed : ActorStatus = new ActorStatus("Failed",2);
		public static var Running : ActorStatus = new ActorStatus("Running",0);
		public static var Stopped : ActorStatus = new ActorStatus("Stopped",1);
		public static var __constructs__ : Array = ["Running","Stopped","Failed"];;
	}
}
