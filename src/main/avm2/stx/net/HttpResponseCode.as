package stx.net {
	import stx.net.HttpNormal;
	import stx.net.HttpError;
	public final class HttpResponseCode extends enum {
		public static const __isenum : Boolean = true;
		public function HttpResponseCode( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Error(v : stx.net.HttpError) : HttpResponseCode { return new HttpResponseCode("Error",1,[v]); }
		public static function Normal(v : stx.net.HttpNormal) : HttpResponseCode { return new HttpResponseCode("Normal",0,[v]); }
		public static var __constructs__ : Array = ["Normal","Error"];;
	}
}
