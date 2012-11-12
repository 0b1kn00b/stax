package haxe.rtti {
	public final class Rights extends enum {
		public static const __isenum : Boolean = true;
		public function Rights( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function RCall(m : String) : Rights { return new Rights("RCall",2,[m]); }
		public static var RDynamic : Rights = new Rights("RDynamic",4);
		public static var RInline : Rights = new Rights("RInline",5);
		public static var RMethod : Rights = new Rights("RMethod",3);
		public static var RNo : Rights = new Rights("RNo",1);
		public static var RNormal : Rights = new Rights("RNormal",0);
		public static var __constructs__ : Array = ["RNormal","RNo","RCall","RMethod","RDynamic","RInline"];;
	}
}
