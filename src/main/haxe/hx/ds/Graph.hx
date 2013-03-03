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

/**
    A linked uni-directional weighted graph structure.
    
    The Graph class manages all graph nodes. Each graph node has an array
    of arcs, pointing to different nodes.
**/
class Graph<T> implements Collection<T> {
    
    public var length(get_length, null) : Int;
    
    private var nodes : Array<GraphNode<Null<T>>>;
    
    /**
        Creates an empty graph.
    **/
    public function new(?size : Int) {
        nodes = new Array();
    }
    
    /**
        Returns the first node in the nodes array.
        Returns null if there is no root node.
    **/
    public function getRoot() : GraphNode<Null<T>> {
        return nodes[0];
    }
    
    /**
        Performs an iterative depth-first traversal starting at a given node.
        
        Example: The following code shows an example callback function.
        The graph traversal runs until the value '5' is found in the data
        property of a node instance.
        [
            myGraph.depthFirst(myGraph.getRoot(), 
                function(node : GraphNode<Int>) {
                    return node.data != 5;
                }
            );
        ]
        
        [visit] is a callback function which is invoked every time a node
        is visited. The visited node is accessible through
        the function's first argument. You can terminate the
        traversal by returning false in the callback function.
    **/
    public function depthFirst(node : GraphNode<Null<T>>, 
                               visit : GraphNode<Null<T>> -> Bool) {
        if (node == null) return;
        clearMarks();
                        
        var stack = new Stack<GraphNode<Null<T>>>();
                        
        while (stack.length > 0) {
            var n = stack.pop();
                                
            if (n.marked) continue;
            n.marked = true;
                                
            visit(n);
                
            for (arc in n.arcs) stack.push(arc.node);
                
        }
    }
    
    /**
        Performs a breadth-first traversal starting at a given node.
        
        Example: The following code shows an example callback function.
        The graph traversal runs until the value '5' is found in the data
        property of a node instance.
        [
            myGraph.breadthFirst(myGraph.getRoot(), 
                function(node : GraphNode<Int>) {
                    return node.data != 5;
                }
            );
        ]
        
        [visit] is a callback function which is invoked every time a node
        is visited. The visited node is accessible through
        the function's first argument. You can terminate the
        traversal by returning false in the callback function.
    **/
    public function breadthFirst(node : GraphNode<Null<T>>, 
                                 visit : GraphNode<Null<T>> -> Bool) {
        if (node == null) return;
        clearMarks();
                        
        var queue = new Queue<GraphNode<Null<T>>>();
        queue.enqueue(node);
        node.marked = true;
                        
        while (queue.length > 0) {
            var v = queue.dequeue();
            if (!visit(v)) return;
                                
            for (arc in v.arcs) {
                var n = arc.node;
                
                if (n.marked) continue;
                n.marked = true;
                queue.enqueue(n);
            }
        }
    }
    
    /**
        Adds a node to the graph.
        
        Returns the graph node created.
        
        [obj] is the data in the node to be added.
    **/
    public function addNode(?obj : Null<T>) : GraphNode<Null<T>> {
        var node = new GraphNode(obj);
        nodes.push(node);
        return node;
    }
                
    /**
        Removes a node from the graph.
        Returns true if the node was removed successfully
    **/
    public function removeNode(node : GraphNode<Null<T>>) : Bool {
        for (i in 0...nodes.length) {
            if (nodes[i] == node) {
                for (arc in node.arcs) removeArc(node, arc.node);
                nodes.splice(i, 1);
                return true;
            }
        }
        
        return false;
    }
    
    /**
        Finds an arc pointing to the 'from' to the 'to' node.
        Returns null if the arc doesn't exist.
    **/
    public function getArc(from : GraphNode<Null<T>>, to : GraphNode<Null<T>>) 
                    : GraphArc<Null<T>> {
        return if (from != null && to != null) from.getArc(to);
               else null;
    }
                
    /**
        Adds an arc pointing to the 'from' to the 'to' node.
        Returns true if the arc was successfully added.
    **/
    public function addArc(from : GraphNode<Null<T>>, to : GraphNode<Null<T>>, 
                           ?weight = 1.0) : Bool {
        if (from != null && to != null) {
            if (from.getArc(to) != null) return false;
                        
            from.addArc(to, weight);
            return true;
        }
        return false;
    }
                
    /**
        Removes an arc ppointing to the 'from' to the 'to' node.
        Returns true if the arc was removed, otherwise false.
    **/
    public function removeArc(from : GraphNode<Null<T>>, 
                              to : GraphNode<Null<T>>) : Bool {
        if (from != null && to != null) {
            return from.removeArc(to);
        }
        return false;
    }
    
    private function clearMarks() {
        for (node in nodes) {
            if (node != null) node.marked = false;
        }
    }
    
    public function contains(obj : Null<T>) : Bool {
        for (match in nodes) {
            if (match != null && match.data == obj) return true;
        }
        return false;
    }
                
    public function clear() {
        nodes = new Array();
    }

    public function iterator() : Iterator<Null<T>> {
        return toArray().iterator();   
    }
    
    private function get_length() : Int {
        return nodes.length;
    }
                
    public function isEmpty() : Bool {
        return nodes.length == 0;
    }
                
    public function toArray() : Array<Null<T>> {
        var a = new Array<Null<T>>();
        for (node in nodes) a.push(node.data);
        
        return a;
    }
    
    public function getNodes() : Array<GraphNode<Null<T>>> {
        return nodes.copy();
    }
	public function addGraph(g:Graph<T>) {
		for (node in g.getNodes()) {
			addNode(cast node);
		}
	}
}

/**
    A weighted arc pointing to a graph node.
**/
class GraphArc<U> {
    
    /**
        The node that the arc points to.
    **/
    public var node : GraphNode<U>;
    
    /**
        The weight (or cost) of the arc.
    **/
    public var weight : Float;
                
    /**
        Creates a new graph arc with a given weight.
    **/
    public function new(node : GraphNode<U>, ?weight = 1.0) {
        this.node = node;
        this.weight = weight;
    }
}

/**
    A graph node.
**/
class GraphNode<V> {
    
    /**
        The node's data being referenced.
    **/
    public var data : V;
                
    /**
        An array of arcs connecting this node to other nodes.
    **/
    public var arcs : Array<GraphArc<V>>;
                
    /**
        A flag indicating whether the node is marked or not. Used by the
        depthFirst and breadthFirst methods only.
    **/
    public var marked : Bool;
                
    /**
        Creates a new graph node.
    **/
    public function new(?obj : V) {
        data = obj;
        arcs = new Array();
        marked = false;
    }
    
    /**
        Adds an arc to the current graph node, pointing to a different
        graph node and with a given weight.
    **/
    public function addArc(target : GraphNode<V>, ?weight : Float) {
        arcs.push(new GraphArc(target, weight));
    }

    /**
        Removes the arc that points to the given node.
        Returns true if removal was successful, otherwise false.
    **/
    public function removeArc(target : GraphNode<V>) : Bool {
        for (i in 0...arcs.length) {
            if (arcs[i].node == target) {
                arcs.splice(i, 1);
                return true;
            }
        }
        return false;
    }
    
    /**
        Finds the arc that points to the given node.
        Retursn null if the arc doesn't exist.
    **/
    public function getArc(target : GraphNode<V>) : GraphArc<V> {
        for (arc in arcs) {
            if (arc.node == target) return arc;
        }
        return null;
    }
                
    /**
        The number of arcs extending from this node.
    **/
    public function getNumArcs() : Int {
        return arcs.length;
    }
}