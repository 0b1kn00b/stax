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

using stx.Tuples;
/**
    A set is a collection of values, without any particular order and no
    repeated values. Implementation is through a list.
**/
class Set<T> implements Collection<T> {
    
    private var list : List<Null<T>>;
    
    /**
        Creates a new empty set.
    **/
    public function new() {
        list = new List();
    }
    
    /**
        Returns true if the set contains the given object.
    **/
    public function contains(obj : Null<T>) : Bool {
        for (match in list) {
            if (match == obj) return true;
        }
        
        return false;
    }
    
    /**
        Adds an item to the set.
        Does nothing if the object is already in the set.
    **/
    public function add(obj : T) {
        //repeated for speed
        for (match in list) {
            if (match == obj) return;
        }
        
        list.add(obj);
    }
    
    /**
        Adds all of the objects in the array minus the repeats.
    **/
    public function addAll(objs : Array<Null<T>>) {
        //repeated for speed
        for (obj in objs) {
            var found = false;
            
            for (match in list) {
                if (match == obj) {
                    found = true;
                    break;
                }
            }
            
            if (!found) list.add(obj);
        }
    }
    
    /**
        Returns the internal list used for the set.
        Use with caution
    **/
    public function getInternalList() : List<Null<T>> {
        return list;
    }
    
    /**
        Returns a copy of the set but NOT a copy of the items themselves.
    **/
    public function copy() : Set<Null<T>> {
        var s = new Set();
        var internal = s.getInternalList();
        for (obj in list) internal.add(obj);
        
        return s;
    }
    
    /**
        Removes an item from the set.
        Returns true if the item was in the set and it was removed.
    **/
    public function rem(obj : Null<T>) : Bool {
        return list.remove(obj);
    }
    
    public function clear() {
        list = new List();
    }

    public function iterator() : Iterator<Null<T>> {
        return list.iterator();
    }

    public function size() : Int {
        return list.length;
    }

    public function isEmpty() : Bool {
        return list.length == 0;
    }

    public function toArray() : Array<Null<T>> {
        return Lambda.array(list);
    }

    /**
        Prints out a string representing the current object.
        Example: "[Set, size=3]"
    **/
    public function toString() : String {
        return "[Set, size=" + Std.string(list.length) + "]";
    }

    /**
        Prints out all elements (for debug/demo purposes).
    **/
    public function dump() : String {
        var s = "Set:\n";
        for (item in list) s += "[val: " + Std.string(item) + "]\n";
        return s;
    }
}