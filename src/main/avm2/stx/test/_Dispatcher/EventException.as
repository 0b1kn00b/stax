package stx.test._Dispatcher {
	public final class EventException extends enum {
		public static const __isenum : Boolean = true;
		public function EventException( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var StopPropagation : EventException = new EventException("StopPropagation",0);
		public static var __constructs__ : Array = ["StopPropagation"];;
	}
}
