package stx {
	public final class Unit extends enum {
		public static const __isenum : Boolean = true;
		public function Unit( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Unit : Unit = new Unit("Unit",0);
		public static var __constructs__ : Array = ["Unit"];;
	}
}
