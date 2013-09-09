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
    A standard LIFO stack. 
    IMPORTANT: Items are added to the head and removed at the head.
*/
class Stack<T> implements Collection<T>{
    
    public var length(get_length, null) : Int;
    

    private var list : List<Null<T>>;
    
    /**
        Creates a new empy stack.
    **/
    public function new() {
        list = new List();
    }
    
    /**
        Returns the item at the top of the stack.
    **/
    public function getTop() : Null<T> {
        return list.first();
    }
    
    /**
        Returns the item at the bottom of the stack.
    **/
    public function getBottom() : Null<T> {
        return list.last();
    }
    
    /**
        Adds the item to the top of the stack.
    **/
    public function push(item : Null<T>) {
        list.push(item);
    }
    
    /**
        Removes and returns the item on the top of the stack.
    **/
    public function pop() : Null<T> {
        return list.pop();
    }
    
    /**
        Removes the object from the stack. Returns true if it was actually in
        the stack.
    **/
    public function remove(obj : Null<T>) : Bool {
        return list.remove(obj);
    }
    
    public function clear() {
        list = new List();
    }
    
    private function get_length() {
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
        Iterates from top to bottom.
    **/
    public function iterator() : Iterator<Null<T>> {
        return list.iterator();
    }
    
    /**
        Prints out a string representing the current object.
        Example: "[Stack, size=4]"
    **/
    public function toString() : String {
        return "[Stack, size=" + Std.string(list.length) + "]";
    }
    
    /**
        Prints out all elements (for debug/demo purposes).
    **/
    public function dump() : String {
        var s = "Stack (Top -> Bottom): \n";
        for (obj in list) s += "[val: " + Std.string(obj) + "]\n";
        
        return s;
    }
    
    /**
        Returns the internal list used by the stack. Use with caution.
    **/
    public function getInternalList() : List<Null<T>> {
        return list;
    }
    
    /**
        Returns a copy of the stack structure, but not a copy of the items 
        themselves.
    **/
    public function copy() : Stack<T> {
        var s = new Stack();
        var internal = s.getInternalList();
        for (obj in list) internal.add(obj);
        
        return s;
    }
    
}