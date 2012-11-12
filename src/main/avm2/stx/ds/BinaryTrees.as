package stx.ds {
	import stx.Arrays;
	import stx.ds.BinaryTree;
	public class BinaryTrees {
		static public function tree(el : *,l : stx.ds.BinaryTree = null,r : stx.ds.BinaryTree = null) : stx.ds.BinaryTree {
			l = ((l == null)?stx.ds.BinaryTree.Empty:l);
			r = ((r == null)?stx.ds.BinaryTree.Empty:r);
			return stx.ds.BinaryTree.Node(el,l,r);
		}
		
		static public function inOrder(t : stx.ds.BinaryTree) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = [];
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = stx.Arrays.appendAll(stx.Arrays.append(stx.ds.BinaryTrees.inOrder(l),el),stx.ds.BinaryTrees.inOrder(r));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function preOrder(t : stx.ds.BinaryTree) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = [];
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = stx.Arrays.appendAll(stx.Arrays.appendAll([el],stx.ds.BinaryTrees.preOrder(l)),stx.ds.BinaryTrees.preOrder(r));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function postOrder(t : stx.ds.BinaryTree) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = [];
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = stx.Arrays.append(stx.Arrays.appendAll(stx.ds.BinaryTrees.postOrder(l),stx.ds.BinaryTrees.postOrder(r)),el);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function size(t : stx.ds.BinaryTree) : int {
			return function() : int {
				var $r : int;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = 0;
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = 1 + stx.ds.BinaryTrees.size(l) + stx.ds.BinaryTrees.size(r);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function leafCount(t : stx.ds.BinaryTree) : int {
			return function() : int {
				var $r : int;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = 0;
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = ((l == stx.ds.BinaryTree.Empty && r == stx.ds.BinaryTree.Empty)?1:stx.ds.BinaryTrees.leafCount(l) + stx.ds.BinaryTrees.leafCount(r));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function leaves(t : stx.ds.BinaryTree) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = [];
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = ((l == stx.ds.BinaryTree.Empty && r == stx.ds.BinaryTree.Empty)?[el]:stx.Arrays.appendAll(stx.ds.BinaryTrees.leaves(l),stx.ds.BinaryTrees.leaves(r)));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function height(t : stx.ds.BinaryTree) : int {
			return function() : int {
				var $r : int;
				{
					var $e2 : enum = (t);
					switch( $e2.index ) {
					case 0:
					$r = 0;
					break;
					case 1:
					var r : stx.ds.BinaryTree = $e2.params[2], l : stx.ds.BinaryTree = $e2.params[1], el : * = $e2.params[0];
					$r = 1 + Std._int(Math.max(stx.ds.BinaryTrees.height(l),stx.ds.BinaryTrees.height(r)));
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
