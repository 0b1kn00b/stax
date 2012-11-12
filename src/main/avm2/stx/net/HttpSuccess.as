package stx.net {
	public final class HttpSuccess extends enum {
		public static const __isenum : Boolean = true;
		public function HttpSuccess( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Accepted : HttpSuccess = new HttpSuccess("Accepted",2);
		public static var Created : HttpSuccess = new HttpSuccess("Created",1);
		public static var Multi : HttpSuccess = new HttpSuccess("Multi",7);
		public static var NoContent : HttpSuccess = new HttpSuccess("NoContent",4);
		public static var Non : HttpSuccess = new HttpSuccess("Non",3);
		public static var OK : HttpSuccess = new HttpSuccess("OK",0);
		public static var PartialContent : HttpSuccess = new HttpSuccess("PartialContent",6);
		public static var ResetContent : HttpSuccess = new HttpSuccess("ResetContent",5);
		public static var __constructs__ : Array = ["OK","Created","Accepted","Non","NoContent","ResetContent","PartialContent","Multi"];;
	}
}
