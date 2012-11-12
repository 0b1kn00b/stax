package stx {
	public interface Product {
		function flatten() : Array ;
		function elements() : Array ;
		function element(n : int) : * ;
		function get_length() : int;;
		function get_prefix() : String;;
	}
}
