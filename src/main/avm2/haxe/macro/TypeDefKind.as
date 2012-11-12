package haxe.macro {
	public final class TypeDefKind extends enum {
		public static const __isenum : Boolean = true;
		public function TypeDefKind( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function TDClass(extend : * = null, implement : Array = null, isInterface : * = null) : TypeDefKind { return new TypeDefKind("TDClass",2,[extend,implement,isInterface]); }
		public static var TDEnum : TypeDefKind = new TypeDefKind("TDEnum",0);
		public static var TDStructure : TypeDefKind = new TypeDefKind("TDStructure",1);
		public static var __constructs__ : Array = ["TDEnum","TDStructure","TDClass"];;
	}
}
