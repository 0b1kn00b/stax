package haxe.macro {
	public final class VarAccess extends enum {
		public static const __isenum : Boolean = true;
		public function VarAccess( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function AccCall(m : String) : VarAccess { return new VarAccess("AccCall",4,[m]); }
		public static var AccInline : VarAccess = new VarAccess("AccInline",5);
		public static var AccNever : VarAccess = new VarAccess("AccNever",2);
		public static var AccNo : VarAccess = new VarAccess("AccNo",1);
		public static var AccNormal : VarAccess = new VarAccess("AccNormal",0);
		public static function AccRequire(r : String) : VarAccess { return new VarAccess("AccRequire",6,[r]); }
		public static var AccResolve : VarAccess = new VarAccess("AccResolve",3);
		public static var __constructs__ : Array = ["AccNormal","AccNo","AccNever","AccResolve","AccCall","AccInline","AccRequire"];;
	}
}
