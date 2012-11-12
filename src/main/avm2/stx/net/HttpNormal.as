package stx.net {
	import stx.net.HttpSuccess;
	import stx.net.HttpRedirection;
	import stx.net.HttpInformational;
	public final class HttpNormal extends enum {
		public static const __isenum : Boolean = true;
		public function HttpNormal( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Informational(v : stx.net.HttpInformational) : HttpNormal { return new HttpNormal("Informational",0,[v]); }
		public static function Redirection(v : stx.net.HttpRedirection) : HttpNormal { return new HttpNormal("Redirection",2,[v]); }
		public static function Success(v : stx.net.HttpSuccess) : HttpNormal { return new HttpNormal("Success",1,[v]); }
		public static var __constructs__ : Array = ["Informational","Success","Redirection"];;
	}
}
