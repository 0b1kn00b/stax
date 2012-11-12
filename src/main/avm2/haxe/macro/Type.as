package haxe.macro {
	public final class Type extends enum {
		public static const __isenum : Boolean = true;
		public function Type( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function TAnonymous(a : *) : Type { return new Type("TAnonymous",5,[a]); }
		public static function TDynamic(t : haxe.macro.Type) : Type { return new Type("TDynamic",6,[t]); }
		public static function TEnum(t : *, params : Array) : Type { return new Type("TEnum",1,[t,params]); }
		public static function TFun(args : Array, ret : haxe.macro.Type) : Type { return new Type("TFun",4,[args,ret]); }
		public static function TInst(t : *, params : Array) : Type { return new Type("TInst",2,[t,params]); }
		public static function TLazy(f : Function) : Type { return new Type("TLazy",7,[f]); }
		public static function TMono(t : *) : Type { return new Type("TMono",0,[t]); }
		public static function TType(t : *, params : Array) : Type { return new Type("TType",3,[t,params]); }
		public static var __constructs__ : Array = ["TMono","TEnum","TInst","TType","TFun","TAnonymous","TDynamic","TLazy"];;
	}
}
