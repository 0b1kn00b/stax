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
    A standard FIFO queue. 
    Items are added to the tail and removed at the head.
**/
class Queue<T> implements Collection<T> {
    
    
    public function peek():T{
      return this.getHead();
    }
    private var list : List<Null<T>>;
    
    /**
        Creates a new empy queue.
    **/
    public function new() {
        list = new List();
    }
    
    /**
        Returns the item that was added first (i.e. at the front of the line).
        Returns null if the queue is empty.
    **/
    public function getHead() : Null<T> {
        if (list.isEmpty()) return null;
        
        return list.first();
    }
    
    /**
        Returns the item that was just added.
        Returns null if the queue is empty.
    **/
    public function getTail() : Null<T> {
        if (list.isEmpty()) return null;
        
        return list.last();
    }
    
    /**
        Adds the item to the head of the queue (i.e. the back of the line).
    **/
    public function enqueue(item : Null<T>) {
        list.add(item);
    }
    
    /**
        Removes and returns the item at the head of the queue (i.e. the front 
        of the line). Returns null if the queue is empty.
    **/
    public function dequeue() : Null<T> {
        return list.pop();
    }
    
    @doc("Removes the object from the queue. Returns true if it was actually in the queue.")
    public function rem(obj : Null<T>) : Bool {
        return list.remove(obj);
    }
    
    public function clear() {
        list = new List();
    }
    
    public function size() {
        return list.length;
    }
    
    public function isEmpty() : Bool {
        return list.isEmpty();
    }
    
    public function contains(obj : Null<T>) : Bool {
        for (match in list) {
            if (obj == match) return true;
        }
        
        return false;
    }
    
    public function toArray() : Array<Null<T>> {
        return Lambda.array(list);
    }
    
    /**
        Prints out a string representing the current object.
        Example: "[Queue, size=4]"
    **/
    public function toString() : String {
        return "[Queue, size=" + Std.string(list.length) + "]";
    }
    
    /**
        Prints out all elements (for debug/demo purposes).
    **/
    public function dump() : String {
        var s = "Queue (Head -> Tail): \n";
        for (obj in list) s += "[val: " + Std.string(obj) + "]\n";
        
        return s;
    }
    
    /**
        Iterates from head to tail (start of the line to the end of the line).
    **/
    public function iterator() : Iterator<Null<T>> {
        return list.iterator();
    }
    
    /**
        Returns the internal list used for the queue.
        Use with caution
    **/
    public function getInternalList() : List<Null<T>> {
        return list;
    }
    
    /**
        Returns a copy of the queue structure, but not a copy of the items 
        themselves.
    **/
    public function copy() : Queue<T> {
        var q = new Queue();
        for (obj in list) q.enqueue(obj);
        
        return q;
    }
    
}