package stx.net {
	import stx.net.HttpServerError;
	import stx.net.HttpClientError;
	public final class HttpError extends enum {
		public static const __isenum : Boolean = true;
		public function HttpError( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function Client(v : stx.net.HttpClientError) : HttpError { return new HttpError("Client",0,[v]); }
		public static function Server(v : stx.net.HttpServerError) : HttpError { return new HttpError("Server",1,[v]); }
		public static var __constructs__ : Array = ["Client","Server"];;
	}
}
