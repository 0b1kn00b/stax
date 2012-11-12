package haxe.macro {
	public final class MethodKind extends enum {
		public static const __isenum : Boolean = true;
		public function MethodKind( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var MethDynamic : MethodKind = new MethodKind("MethDynamic",2);
		public static var MethInline : MethodKind = new MethodKind("MethInline",1);
		public static var MethMacro : MethodKind = new MethodKind("MethMacro",3);
		public static var MethNormal : MethodKind = new MethodKind("MethNormal",0);
		public static var __constructs__ : Array = ["MethNormal","MethInline","MethDynamic","MethMacro"];;
	}
}
