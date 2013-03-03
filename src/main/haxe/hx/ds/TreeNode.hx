/**
* Copyright (c) 2008 Chase Kernan, Laurence Taylor
* chase.kernan@gmail.com, polysemantic@gmail.com
* Based off of Michael Baczynski's as3ds project, http://www.polygonal.de.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package hx.ds;

import hx.ds.DList;

/**
    A tree node for building a tree data structure.
    
    Every tree node has a linked list of child nodes and a pointer to its
    parent node. Note that a tree data structure is build of TreeNode
    objects, so there is no class that manages a tree structure. 
**/
class TreeNode<T> implements Collection<T> {       
    
    /**
        The parent node being referenced.
    **/
    public var parent : TreeNode<T>;
    
    /**
        A list of child nodes being referenced.
    **/
    public var children : DList<TreeNode<T>>;
    
    /**
        The data being referened.
    **/
    public var data : Null<T>;
    
    /**
        Counts the total number of tree nodes starting from the current
        tree node.
    **/
    public var length(get_length, null) : Int;
    
    /**
        Creates a tree node.
    **/
    public function new(obj : T, ?parent : TreeNode<T>) {
        data = obj;
        children = new DList();
        
        this.parent = parent;
        if (parent != null) parent.children.add(this);
    }
    
    private function get_length() : Int {
        var l = 1;
        for (node in children) l += node.length;
        
        return l;
    }
                
    /**
        Checks if the tree node is a root node.
    **/
    public function isRoot() : Bool {
        return parent == null;
    }
    
    /**
        Checks if the tree node is a leaf node.
    **/
    public function isLeaf() : Bool {
        return children.length == 0;
    }
                
    /**
        Checks if the tree node has child nodes.
    **/
    public function hasChildren() : Bool {
        return children.length > 0;
    }
                
    /**
        Checks if the tree node has siblings.
    **/
    public function hasSiblings() : Bool {
        return parent != null && parent.children.length > 1;
    }
                
    /**
        Checks is the tree node is empty (has no children).
    **/
    public function isEmpty() : Bool {
        return children.length == 0;
    }
    
    /**
        Computes the depth of the tree, using this node as the base.
        Returns 0 if the node doesn't have a parent.
    **/
    public function getDepth() : Int {
        if (parent == null) return 0;
                        
        var node = this;
        var depth = 0;
        while (node.parent != null) {
            depth++;
            node = node.parent;
        }
        
        return depth;
    }
                
    /**
        The total number of children (not including the children's children, 
        etc...).
    **/
    public function getNumChildren() : Int {
        return children.length;
    }
                
    /**
        The total number of siblings.
    **/
    public function getNumSiblings() : Int {
        return if (parent != null) parent.children.length else 0;
    }
    
    /**
        Visits each node in the tree, using the given node as the root of the 
        tree. The visit function is called at every node.
        
        If preorder is true, then the function visits a node then its children,
        otherwise it visits its children first, then the node.
    */
    public static function visitTree<E>(node : TreeNode<E>, 
                                        visit : TreeNode<E> -> Void,
                                        ?preorder = true) {
        if (node != null) {
            if (preorder) visit(node);
            
            for (child in node.children) visitTree(child, visit, preorder);
            
            if (!preorder) visit(node);
        }
    }
    
    /**
        Right now this searches the whole tree everytime. 
        TODO: this needs to be optimized.
    **/
    public function contains(obj : Null<T>) : Bool {
        var found = false;
        
        visitTree(this, function(node : TreeNode<T>) {
            if (!found && obj == node.data) found = true;
        });
        
        return found;
    }
    
    public function clear() {
        children.clear();
    }
                
    public function iterator() : Iterator<Null<T>> {
        return toArray().iterator();
    }
    
    public function toArray() : Array<Null<T>> {
        var a = new Array<T>();
        
        visitTree(this, function(node : TreeNode<T>) {
            a.push(node.data);
        });
        
        return a;
    }
                
    /**
        Prints out a string representing the current object.
    **/
    public function toString() : String {
        var s = "[TreeNode > " + if (parent == null) "(root)" else "";
        
        var size = length;
        
        s += if (children.length == 0)  "(leaf)" 
             else " has " + children.length + " child node" + 
                  if (size > 1 || size == 0) "s" else "";
        
        s += ", data=" + Std.string(data) + "]";    
                        
        return s;
    }
                
    /**
        Prints out all elements (for debug/demo purposes).
    **/
    public function dump() : String {
        var s = "";
        
        visitTree(this, function(node : TreeNode<T>) {
            var d = node.getDepth();
            for (i in 0...node.getDepth()) {
                s += if (i == d - 1) "+----" else "|    ";
            }
            
             s += node.toString() + "\n";
        });
        
        return s;
    }
    
    public function getTreeIterator() : TreeIterator<T> {
        return new TreeIterator(this);
    }
}


class TreeIterator<T> {
    
    /**
        The tree node being referenced.
    **/
    public var node : TreeNode<T>;
                
    private var _childItr : DIterator<TreeNode<T>>;
    private var _stack : Stack<DIterator<TreeNode<T>>>;
                
    /**
        Initializes a tree iterator pointing to a given tree node.
    **/
    public function new(node : TreeNode<T>) {
        this.node = node;
        reset();
                        
        _stack = new Stack();
        _stack.push(_childItr);
    }
                
    public function hasNext() : Bool {
        if (_stack.length == 0) return false;
        else {
            var itr = _stack.getTop();
                                
            if (!itr.hasNext()) {
                _stack.pop();
                return hasNext();
            } else return true;
        }
    }
                
    public function next() : TreeNode<T> {
        var itr = _stack.getTop();
        var node = itr.next();
                                
        if (node.children.length > 0) {
            _stack.push(node.children.getDualIterator());
        }
                                
        return node;
    }
    
    /**
        Resets the vertical iterator so that it points to the root of the
        tree. Also make sures the horizontal iterator points to the first
        child.
    **/
    public function start() {
        root();
        childStart();
                        
        _stack.clear();
        _stack.push(_childItr);
    }
    
    public var data(get_data, set_data) : Null<T>;
    
    private function get_data() : Null<T> {
        return node.data;
    }
                
    private function set_data(to : Null<T>) {
        node.data = to;
        return node.data;
    }
    
    /**
        The current child node being referenced.
    **/
    public var childNode(get_childNode, null) : TreeNode<T>;
                
    private function get_childNode() : TreeNode<T> {
        return _childItr.currentData;
    }
                
    /**
        Checks if the node is valid (i.e. not null).
    **/
    public function valid() : Bool {
        return node != null;
    }
                
    /**
        Moves the iterator to the root of the tree.
    **/
    public function root() {
        if (node != null) {
            while (node.parent != null) node = node.parent;
        }
        
        reset();
    }
                
    /**
        Moves the iterator up by one level of the tree, so that it points to
        the parent of the current tree node.
    **/
    public function up() {
        if (node != null && node.parent != null)  {
            node = node.parent;
            reset();
        }
    }
                
    /**
        Moves the iterator down by one level of the tree, so that it points
        to the first child of the current tree node.
    **/
    public function down() {
        if (_childItr.valid()) {
            node = _childItr.currentData;
            reset();
        }
    }
                
    /**
        Moves the child iterator forward by one position.
    **/
    public function nextChild() {
        _childItr.forward();
    }
                
    /**
        Moves the child iterator back by one position.
    **/
    public function prevChild() {
        _childItr.backward();
    }
                
    /**
        Moves the child iterator to the first child.
    **/
    public function childStart() {
        _childItr.first();
    }
                
    /**
        Moves the child iterator to the last child.
    **/
    public function childEnd() {
        _childItr.last();
    }
                
    /**
        Determines if the child iterator is valid.
    **/
    public function childValid() : Bool {
        return _childItr.valid();
    }
                
    /**
        Appends a child node to the child list.
        The object passed is the data of the child node to be added.
    **/
    public function appendChild(obj : Null<T>) : TreeNode<T> {
        var n = new TreeNode(obj, node);
                        
        if (node.children.length == 1) childStart();
        
        return n;
    }
                
    /**
        Prepends a child node to the child list.
        The object passed is the data of the child node to be added.
    **/
    public function prependChild(obj : Null<T>) : TreeNode<T> {
        var childNode = new TreeNode(obj);
        childNode.parent = node;
        node.children.push(childNode);
                        
        if (node.children.length == 1) childStart();
        
        return childNode;
    }
                
    /**
        Inserts a child node before the current child node.
        The object passed is the data of the child node to be added.
    **/
    public function insertBeforeChild(obj : Null<T>) : TreeNode<T> {
        var childNode = new TreeNode(obj);
        childNode.parent = node;
        node.children.insertBefore(_childItr, childNode);
                        
        if (node.children.length == 1) childStart();
        
        return childNode;
    }
                
    /**
        Inserts a child node after the current child node.
        The object passed is the data of the child node to be added.
    **/
    public function insertAfterChild(obj : Null<T>) : TreeNode<T> {
        var childNode = new TreeNode(obj);
        childNode.parent = node;
        node.children.insertAfter(_childItr, childNode);
                        
        if (node.children.length == 1) childStart();
        
        return childNode;
    }
                
    /**
        Unlinks the current child node from the tree.
        This does not delete the node.
    **/
    public function removeChild() {
        if (node != null && _childItr.valid()) {
            _childItr.currentData.parent = null;
            node.children.removeAtCursor(_childItr);
        }
    }
                
    private function reset() {
        if (node != null) {
            var list = new DList<TreeNode<T>>();
            list.addAll(Lambda.array(node.children));
            _childItr = list.getDualIterator();
        } else {
            _childItr.cursor = null;
            _childItr.target = null;
        }
    }
                
    public function toString() : String {
        return "[TreeIterator > pointing to: [V] " + node + " [H] " + 
                if (_childItr.currentData != null) 
                    Std.string(_childItr.currentData)
                else 
                    "(leaf node)";
    }
}