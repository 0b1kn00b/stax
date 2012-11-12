package stx.ds {
	public final class BinaryTree extends enum {
		public static const __isenum : Boolean = true;
		public function BinaryTree( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var Empty : BinaryTree = new BinaryTree("Empty",0);
		public static function Node(el : *, left : stx.ds.BinaryTree, right : stx.ds.BinaryTree) : BinaryTree { return new BinaryTree("Node",1,[el,left,right]); }
		public static var __constructs__ : Array = ["Empty","Node"];;
	}
}
