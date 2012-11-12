package haxe.macro {
	public final class ClassKind extends enum {
		public static const __isenum : Boolean = true;
		public function ClassKind( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function KExpr(expr : *) : ClassKind { return new ClassKind("KExpr",3,[expr]); }
		public static function KExtension(cl : *, params : Array) : ClassKind { return new ClassKind("KExtension",2,[cl,params]); }
		public static var KGeneric : ClassKind = new ClassKind("KGeneric",4);
		public static function KGenericInstance(cl : *, params : Array) : ClassKind { return new ClassKind("KGenericInstance",5,[cl,params]); }
		public static var KMacroType : ClassKind = new ClassKind("KMacroType",6);
		public static var KNormal : ClassKind = new ClassKind("KNormal",0);
		public static var KTypeParameter : ClassKind = new ClassKind("KTypeParameter",1);
		public static var __constructs__ : Array = ["KNormal","KTypeParameter","KExtension","KExpr","KGeneric","KGenericInstance","KMacroType"];;
	}
}
