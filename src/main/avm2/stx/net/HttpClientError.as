package stx.net {
	public final class HttpClientError extends enum {
		public static const __isenum : Boolean = true;
		public function HttpClientError( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var BadRequest : HttpClientError = new HttpClientError("BadRequest",0);
		public static var Conflict : HttpClientError = new HttpClientError("Conflict",9);
		public static var ExpectationFailed : HttpClientError = new HttpClientError("ExpectationFailed",17);
		public static var FailedDependency : HttpClientError = new HttpClientError("FailedDependency",21);
		public static var Forbidden : HttpClientError = new HttpClientError("Forbidden",3);
		public static var Gone : HttpClientError = new HttpClientError("Gone",10);
		public static var LengthRequired : HttpClientError = new HttpClientError("LengthRequired",11);
		public static var Locked : HttpClientError = new HttpClientError("Locked",20);
		public static var MethodNotAllowed : HttpClientError = new HttpClientError("MethodNotAllowed",5);
		public static var NotAcceptable : HttpClientError = new HttpClientError("NotAcceptable",6);
		public static var NotFound : HttpClientError = new HttpClientError("NotFound",4);
		public static var PaymentRequired : HttpClientError = new HttpClientError("PaymentRequired",2);
		public static var PreconditionFailed : HttpClientError = new HttpClientError("PreconditionFailed",12);
		public static var ProxyAuthenticationRequired : HttpClientError = new HttpClientError("ProxyAuthenticationRequired",7);
		public static var Request : HttpClientError = new HttpClientError("Request",14);
		public static var RequestEntityTooLarge : HttpClientError = new HttpClientError("RequestEntityTooLarge",13);
		public static var RequestTimeout : HttpClientError = new HttpClientError("RequestTimeout",8);
		public static var RequestedRangeNotSatisfiable : HttpClientError = new HttpClientError("RequestedRangeNotSatisfiable",16);
		public static var RetryWith : HttpClientError = new HttpClientError("RetryWith",24);
		public static var TooManyConnections : HttpClientError = new HttpClientError("TooManyConnections",18);
		public static var Unauthorized : HttpClientError = new HttpClientError("Unauthorized",1);
		public static var UnorderedCollection : HttpClientError = new HttpClientError("UnorderedCollection",22);
		public static var UnprocessableEntity : HttpClientError = new HttpClientError("UnprocessableEntity",19);
		public static var UnsupportedMediaType : HttpClientError = new HttpClientError("UnsupportedMediaType",15);
		public static var UpgradeRequired : HttpClientError = new HttpClientError("UpgradeRequired",23);
		public static var __constructs__ : Array = ["BadRequest","Unauthorized","PaymentRequired","Forbidden","NotFound","MethodNotAllowed","NotAcceptable","ProxyAuthenticationRequired","RequestTimeout","Conflict","Gone","LengthRequired","PreconditionFailed","RequestEntityTooLarge","Request","UnsupportedMediaType","RequestedRangeNotSatisfiable","ExpectationFailed","TooManyConnections","UnprocessableEntity","Locked","FailedDependency","UnorderedCollection","UpgradeRequired","RetryWith"];;
	}
}
