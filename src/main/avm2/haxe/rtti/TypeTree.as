package haxe.rtti {
	public final class TypeTree extends enum {
		public static const __isenum : Boolean = true;
		public function TypeTree( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function TClassdecl(c : *) : TypeTree { return new TypeTree("TClassdecl",1,[c]); }
		public static function TEnumdecl(e : *) : TypeTree { return new TypeTree("TEnumdecl",2,[e]); }
		public static function TPackage(name : String, full : String, subs : Array) : TypeTree { return new TypeTree("TPackage",0,[name,full,subs]); }
		public static function TTypedecl(t : *) : TypeTree { return new TypeTree("TTypedecl",3,[t]); }
		public static var __constructs__ : Array = ["TPackage","TClassdecl","TEnumdecl","TTypedecl"];;
	}
}
