package stx {
	public final class TraversalOrder extends enum {
		public static const __isenum : Boolean = true;
		public function TraversalOrder( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static var InOrder : TraversalOrder = new TraversalOrder("InOrder",1);
		public static var LevelOrder : TraversalOrder = new TraversalOrder("LevelOrder",3);
		public static var PostOrder : TraversalOrder = new TraversalOrder("PostOrder",2);
		public static var PreOrder : TraversalOrder = new TraversalOrder("PreOrder",0);
		public static var __constructs__ : Array = ["PreOrder","InOrder","PostOrder","LevelOrder"];;
	}
}
