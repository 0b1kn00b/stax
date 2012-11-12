package stx.ds {
	import stx.functional.Foldable;
	public interface Collection extends stx.functional.Foldable{
		function removeAll(t : *) : * ;
		function remove(t : *) : * ;
		function addAll(t : *) : * ;
		function add(t : *) : * ;
		function contains(t : *) : Boolean ;
		function size() : int ;
	}
}
