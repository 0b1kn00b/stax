package haxe.macro {
	import haxe.macro.VarAccess;
	import haxe.macro.MethodKind;
	public final class FieldKind extends enum {
		public static const __isenum : Boolean = true;
		public function FieldKind( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function FMethod(k : haxe.macro.MethodKind) : FieldKind { return new FieldKind("FMethod",1,[k]); }
		public static function FVar(read : haxe.macro.VarAccess, write : haxe.macro.VarAccess) : FieldKind { return new FieldKind("FVar",0,[read,write]); }
		public static var __constructs__ : Array = ["FVar","FMethod"];;
	}
}
