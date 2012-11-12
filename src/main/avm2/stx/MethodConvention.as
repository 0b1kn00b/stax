package stx {
	public final class MethodConvention extends enum {
		public static const __isenum : Boolean = true;
		public function MethodConvention( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Ignore : MethodConvention = new MethodConvention("Ignore",2);
		public static var Patch : MethodConvention = new MethodConvention("Patch",1);
		public static var Replace : MethodConvention = new MethodConvention("Replace",0);
		public static var __constructs__ : Array = ["Replace","Patch","Ignore"];;
	}
}
