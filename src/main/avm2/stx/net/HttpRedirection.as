package stx.net {
	public final class HttpRedirection extends enum {
		public static const __isenum : Boolean = true;
		public function HttpRedirection( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Found : HttpRedirection = new HttpRedirection("Found",2);
		public static var MovedPermanently : HttpRedirection = new HttpRedirection("MovedPermanently",1);
		public static var MultipleChoices : HttpRedirection = new HttpRedirection("MultipleChoices",0);
		public static var NotModified : HttpRedirection = new HttpRedirection("NotModified",4);
		public static var SeeOther : HttpRedirection = new HttpRedirection("SeeOther",3);
		public static var TemporaryRedirect : HttpRedirection = new HttpRedirection("TemporaryRedirect",6);
		public static var UseProxy : HttpRedirection = new HttpRedirection("UseProxy",5);
		public static var __constructs__ : Array = ["MultipleChoices","MovedPermanently","Found","SeeOther","NotModified","UseProxy","TemporaryRedirect"];;
	}
}
