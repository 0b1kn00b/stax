package stx.test.ui.common {
	public final class HeaderDisplayMode extends enum {
		public static const __isenum : Boolean = true;
		public function HeaderDisplayMode( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var AlwaysShowHeader : HeaderDisplayMode = new HeaderDisplayMode("AlwaysShowHeader",0);
		public static var NeverShowHeader : HeaderDisplayMode = new HeaderDisplayMode("NeverShowHeader",1);
		public static var ShowHeaderWithResults : HeaderDisplayMode = new HeaderDisplayMode("ShowHeaderWithResults",2);
		public static var __constructs__ : Array = ["AlwaysShowHeader","NeverShowHeader","ShowHeaderWithResults"];;
	}
}
