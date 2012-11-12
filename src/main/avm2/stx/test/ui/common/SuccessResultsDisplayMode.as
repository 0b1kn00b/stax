package stx.test.ui.common {
	public final class SuccessResultsDisplayMode extends enum {
		public static const __isenum : Boolean = true;
		public function SuccessResultsDisplayMode( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var AlwaysShowSuccessResults : SuccessResultsDisplayMode = new SuccessResultsDisplayMode("AlwaysShowSuccessResults",0);
		public static var NeverShowSuccessResults : SuccessResultsDisplayMode = new SuccessResultsDisplayMode("NeverShowSuccessResults",1);
		public static var ShowSuccessResultsWithNoErrors : SuccessResultsDisplayMode = new SuccessResultsDisplayMode("ShowSuccessResultsWithNoErrors",2);
		public static var __constructs__ : Array = ["AlwaysShowSuccessResults","NeverShowSuccessResults","ShowSuccessResultsWithNoErrors"];;
	}
}
