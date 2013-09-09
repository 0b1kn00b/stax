/**
 * ...
 * @author 0b1kn00b
 */

package stx.ds.abstract;

interface TreeNode<C:Enumerable<V>,V>, implements Data<V> {
	public var children : C;
}