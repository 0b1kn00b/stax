package stx.net {
	public final class HttpServerError extends enum {
		public static const __isenum : Boolean = true;
		public function HttpServerError( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var BadGateway : HttpServerError = new HttpServerError("BadGateway",2);
		public static var BandwidthLimitExceeded : HttpServerError = new HttpServerError("BandwidthLimitExceeded",8);
		public static var GatewayTimeout : HttpServerError = new HttpServerError("GatewayTimeout",4);
		public static var HTTPVersionNotSupported : HttpServerError = new HttpServerError("HTTPVersionNotSupported",5);
		public static var InsufficientStorage : HttpServerError = new HttpServerError("InsufficientStorage",7);
		public static var InternalServerError : HttpServerError = new HttpServerError("InternalServerError",0);
		public static var NotExtended : HttpServerError = new HttpServerError("NotExtended",9);
		public static var NotImplemented : HttpServerError = new HttpServerError("NotImplemented",1);
		public static var ServiceUnavailable : HttpServerError = new HttpServerError("ServiceUnavailable",3);
		public static var UserAccessDenied : HttpServerError = new HttpServerError("UserAccessDenied",10);
		public static var VariantAlsoNegotiates : HttpServerError = new HttpServerError("VariantAlsoNegotiates",6);
		public static var __constructs__ : Array = ["InternalServerError","NotImplemented","BadGateway","ServiceUnavailable","GatewayTimeout","HTTPVersionNotSupported","VariantAlsoNegotiates","InsufficientStorage","BandwidthLimitExceeded","NotExtended","UserAccessDenied"];;
	}
}
