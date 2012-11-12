package stx.functional {
	public interface Foldable {
		function foldl(t : *,f : Function) : * ;
		function append(b : *) : * ;
		function empty() : stx.functional.Foldable ;
	}
}
