package stx.reactive {
	import stx.reactive.Pulse;
	public final class Propagation extends enum {
		public static const __isenum : Boolean = true;
		public function Propagation( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var doNotPropagate : Propagation = new Propagation("doNotPropagate",1);
		public static function propagate(value : stx.reactive.Pulse) : Propagation { return new Propagation("propagate",0,[value]); }
		public static var __constructs__ : Array = ["propagate","doNotPropagate"];;
	}
}
