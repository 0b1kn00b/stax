package haxe.rtti {
	public final class CType extends enum {
		public static const __isenum : Boolean = true;
		public function CType( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function CAnonymous(fields : List) : CType { return new CType("CAnonymous",5,[fields]); }
		public static function CClass(name : String, params : List) : CType { return new CType("CClass",2,[name,params]); }
		public static function CDynamic(t : haxe.rtti.CType = null) : CType { return new CType("CDynamic",6,[t]); }
		public static function CEnum(name : String, params : List) : CType { return new CType("CEnum",1,[name,params]); }
		public static function CFunction(args : List, ret : haxe.rtti.CType) : CType { return new CType("CFunction",4,[args,ret]); }
		public static function CTypedef(name : String, params : List) : CType { return new CType("CTypedef",3,[name,params]); }
		public static var CUnknown : CType = new CType("CUnknown",0);
		public static var __constructs__ : Array = ["CUnknown","CEnum","CClass","CTypedef","CFunction","CAnonymous","CDynamic"];;
	}
}
