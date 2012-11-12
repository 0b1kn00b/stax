package stx.net {
	public final class HttpInformational extends enum {
		public static const __isenum : Boolean = true;
		public function HttpInformational( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Continue : HttpInformational = new HttpInformational("Continue",0);
		public static var Processing : HttpInformational = new HttpInformational("Processing",2);
		public static var SwitchingProtocols : HttpInformational = new HttpInformational("SwitchingProtocols",1);
		public static var __constructs__ : Array = ["Continue","SwitchingProtocols","Processing"];;
	}
}
