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

import hx.ds.sort.DListInsertionSort;
import hx.ds.sort.DListMergeSort;

/**
    A doubly-linked list with reversable iteration and additional sorting 
    methods.
**/
class DList<T> implements Collection<T> {
    
  public var head : DListNode<T>;
  public var tail : DListNode<T>;

  /**
        The length of the list.
  **/
  public var length(get_length, null) : Int;
    
  private var _length : Int;
  private function get_length(){
    return _length;
  }

  /**
        Creates a new double-linked list.
  **/
  public function new(){
    _length = 0;  
  }
    
    public function clear() {
        head = tail = null;
    }
    
    public function isEmpty() {
        return head == null && tail == null;
    }

  /**
        Adds a value to the end of the list and returns the DListNode
        associated with that value.
  **/
  public function add(value : Null<T>) : DListNode<T> {
    var node = new DListNode(value);
        
    if (head != null) {
      tail.insertAfter(node);
      tail = tail.next;
    } else {
      head = tail = node; 
    }
        
    _length++;
        
    return node;
  }
  /**
        Adds several values to the end of the list.
        Useful as haxe does not support indeterminate numbers of parameters.
        
        Does nothing if a null value or an empty array is passed.
  **/
  public function addAll(value : Array<Null<T>>) {
        if (value == null) return;
        
    var len = value.length;
        if (len == 0) return;
        
    var node = new DListNode(value[0]);

    if (head != null) {
      tail.insertAfter(node);
      tail = tail.next;
    } else {
      head = tail = node;
    }
        
        _length += len;
        
        if (len == 1) return;

    var t = node;
            
    for (i in 1...len){
      node = new DListNode(value[i]);
      tail.insertAfter(node);
      tail = tail.next;   
    }
  }

  /** 
        Adds a value to the front of the list and returns the associated 
        DListNode.
  **/
  public function push(value : Null<T>) {
    var node = new DListNode(value);
        
    if (head != null) {
      head.insertBefore(node);
      head = head.prev;
    } else {
      head = tail = node;
    }
        
    _length++;
        
    return node;
  }
    
  /**
        Adds multiple values to the front of the list.
        They're added to the list in the order that they were given in the 
        array.
  **/
  public function pushAll(value : Array<Null<T>>) {
    if (value == null) return;
        
    var len = value.length;
        if (len == 0) return;
        
        _length += len;
        
        var chain = new DListNode(value[0]);
        var newTop = chain;
        
        for (i in 1...len) {
            var prev = chain;
            
            chain.next = new DListNode(value[i]);
            chain = chain.next;
            chain.prev = prev;
        }
        
        head.prev = chain;
        chain.next = head;
        head = newTop;
  }
    
  /**
        Places a value in the list before the cursor specified in the DIterator
        and returns the DListNode associated with that value.
        
        If the target of the iterator is not this list, then this returns null.
        If the iterator cursor is null, then the node is added to the top of 
        the list.
  **/
  public function insertBefore(itr : DIterator<T>, value : Null<T>) 
                    : DListNode<T> {
    if (itr.target != this) return null;
    
    if (itr.cursor != null) {
      var node = new DListNode(value);
      itr.cursor.insertBefore(node);
            
      if (itr.cursor == head) {
        head = head.prev;
      }
            
      _length++;
            
      return node;
    }

    return push(value);
  }
    
  /**
        Places a value in the list after the cursor specified in the DIterator.
        
        If the target of the iterator is not this list, then this returns null.
        If the iterator cursor is null, then the node is added to the top of 
        the list.
  **/
  public function insertAfter(itr : DIterator<T>, value : Null<T>) 
                    : DListNode<T> {
    if (itr.target != this) return null;
    
    if (itr.target != null) {
      var node = new DListNode(value);
            
      itr.cursor.insertBefore(node);
      if (itr.cursor == head){
        head = head.prev;
      }
            
      _length++;
            
      return node;
    }
        
    return push(value);
  }
    
  /**
        Removes the item at the cursor specified in the DListITerator.
        Returns true if the operation completed successfully.
  **/
  public function removeAtCursor(itr : DIterator<T>) : Bool {
    var node = itr.cursor;
    if ( itr.target != this || itr.cursor == null) return false;
    
    if (node == head) head = head.next;
    else if (node == tail) tail = tail.prev;
    
    if (itr.cursor != null) itr.cursor = itr.cursor.next;
    
    if (node.prev != null) node.prev.next = node.next;
    
    if (node.next != null) node.next.prev = node.prev;
    
    node.next = node.prev = null;

    if (head == null) tail = null;
    
    _length--;
        
    return true;
  }
    
    /**
        Tries to remove the item from the list.
        Returns true if the operation completed successfully.
    **/
    public function remove(item : Null<T>) : Bool {
        var len = length;
        if (len == 0) return false;
        
        var match : DListNode<T> = null;
        var node = head;
        while (node != null) {
            if (node.data == item) {
                match = node;
                break;
            }
            node = node.next;
        }
        
        if (match == null) return false;
        
        if (len == 1) {
            head = tail = null;
            _length--;
        } else if (len == 2) {
            if (match == head) removeHead();
            else removeTail();
        } else {
            match.unlink();
            _length--;
        }
        
        return true;
    }
    
    public function contains(obj : Null<T>) : Bool {
        for (data in this) {
            if (data == obj) {
                return true;
            }
        }
        
        return false;
    }
    
  /**
        Removes and returns the first item of the list.
  **/
  public function removeHead() {
    if (head != null){
      var data = head.data;
      head = head.next;
      if (head != null) head.prev = null;
      else tail = null;
            
      _length--;
      return data;
    }
        
    return null;
  }
    
  /**
        Removes and returns the last item of the list.
  **/
  public function removeTail() {
    if (tail != null){
      var data = tail.data;
      tail = tail.prev;
            
      if (tail != null) tail.next = null;
      else head = null;
            
      _length--;
      return data;
    }
        
    return null;
  }
    
  /**
        Destructively links lists.
  **/
  public function merge(value : Array<DList<T>>){
    var c = new DList<T>();
    var a = value[0];
        
    if (head != null ){
      tail.next = a.head;
      a.head.prev = tail;
      tail = a.tail;
    } else {
      head = a.head;
      tail = a.tail;
    }
        
    _length += a.length;

    var len = value.length;

    for (i in 0...len){
      a = value[i];
      tail.next = a.head;
      a.head.prev = tail;
      tail = a.tail;
      _length += a.length;
    }
  }
    
  /**
        Links and returns new list.
  **/
  public function concat(value : Array<DList<T>>) : DList<T> {
    var c = new DList();
        
    var n = head;
    while (n != null) {
      c.add(n.data);
      n = n.next;
    }

    var len = value.length;
    
    for (i in 0...len){
      var a = value[i];
      n = a.head;
      while (n != null) {
        c.add(n.data);
        n = n.next;
      }
    }
        
    return c;
  }


  /**
        Returns a dual direction iterator
  **/
  public function getDualIterator() : DIterator<T> {
    var it = new DIterator(this);
    it.start();
    return it;
  }
    
    public function toArray() : Array<Null<T>> {
        var a = new Array<Null<T>>();
        if (length == 0) return a;
        
        var n = head;
        while (n != null) {
            a.push(n.data);
            n = n.next;
        }
        
        return a;
    }
    
  public function iterator() : Iterator<Null<T>> {
        return toArray().iterator();
  }
    
  public function sort(?merge = false, 
                         ?comparator : Null<T> -> Null<T> -> Int) {
    if (merge) DListMergeSort.sort(this, comparator);
    else DListInsertionSort.sort(this, comparator);
  }
  
  /**
        Return the node containing the inputted object.
        Returns null if no node was found.
        
        If [from] is specified, then the search starts as the cursor of the 
        "from" iterator. Also, if the iterator target isn't this list, it
        returns null.
  **/
  public function nodeOf(value : Null<T>, ?from : DIterator<T>) 
                    : DListNode<T> {
    if (from != null) {
      if (from.target != this) {
        return null;
      }
    }
        
    var node = if (from == null) head else from.cursor;
        
    while (node != null){
      if (node.data == value) return node;
      
      node = node.next;
    }
        
    return null;
  }

  /**
        Return the last node containing the inputted object.
        Returns null if no node was found.
        
        If [from] is specified, then the search starts as the cursor of the 
        "from" iterator. Also, if the iterator target isn't this list, it
        returns null.
  */
  public function lastNodeOf(value : Null<T>, ?from : DIterator<T>) 
                    : DListNode<T> {
    if (from != null) {
      if (from.target != this){
        return null;
      }
    }
        
    var node = if (from == null) tail else from.cursor;
        
    while (node != null) {
      if (node.data == value){
        return node;
      }
      node = node.prev;
    }
        
    return null;
  }
    
    public function toString() : String {
        return "[DList, length=" + length + "]";
    }
    
    public function dump() : String {
        var s = toString() + " {\n\t";
        for (item in this) {
            s += Std.string(item) + ", ";
        }
        s += "\n}";
        return s;
    }    
}

class DListNode<T> {
    
    public var next : DListNode<T>;
    public var prev : DListNode<T>;
    public var data : Null<T>;
    
    /**
        Creates a new DListNode with the given data.
        If the previous or next node is not supplied, it is recorded as null.
    **/
    public function new(data : Null<T>, ?next : DListNode<T>, 
                        ?previous : DListNode<T>) {
        this.data = data;
        this.next = next;
        prev = previous;
    }
    
    /**
        Inserts the given node before this node in the list.
    **/
    public function insertBefore(node : DListNode<T>){
    node.next = this;
    node.prev = prev;
        
    if (prev != null) prev.next = node;
        
    prev = node;
  }
    
    /**
        Inserts the given node after this node in the list.
    **/
  public function insertAfter(node : DListNode<T>){
    node.next = next;
    node.prev = this;
        
    if (next != null) next.prev = node;
        
    next = node;
  }
    
    /**
        Removes the node from the list while keeping the list intact.
    **/
  public function unlink() {
    if (prev != null) prev.next = next;
    if (next != null) next.prev = prev;
        
    next = prev = null;
  }
}

class DIterator<T> {
    
    /**
        The DList that is being iterated on.
    **/
    public var target:DList<T>;
    
  
    /**
        The current location of the iterator.
    **/
  public var cursor(get_cursor, set_cursor) : DListNode<T>;
    
    private var _cursor : DListNode<T>;
    
    private function get_cursor() : DListNode<T>{
    return _cursor;
  }
    
  private function set_cursor(value : DListNode<T>){
        _cursor = value;
    return _cursor;
  }
    
    /**
        Current data is the data held under the node specified by the cursor.
    **/
    public var currentData(get_currentData, set_currentData) : Null<T>;
    
    private function get_currentData() : Null<T> {
        return _cursor.data;
    }
    
    private function set_currentData(to : Null<T>) : Null<T> {
        _cursor.data = to;
        return _cursor.data;
    }
    
    /**
        Creates a new iterator for thee list given.
        
        If node is given, then the cursor is placed on that node.
    **/
  public function new(target : DList<T>, ?node : DListNode<T>){
    this.target = target;
    if (node != null) cursor = node;
  }
    
    /**
        Starts the iteration by setting the cursor to the head of the lsit.
        Called automatically by [DList.getDualIterator].
    **/
  public function start(){
    cursor = target.head;
  }
    
    /**
        Sets the cursor to the head of the list.
        
        This does nothing if the cursor is null (i.e. its at the end of the 
        list, use [start()] if it is).
    **/
  public function first() {
    if (cursor != null) cursor = target.head;
  }
    
    /**
        Sets the cursor to the head of the list.
        
        This does nothing if the cursor is null (i.e. its at the end of the 
        list, use [start()] if it is).
    **/
  public function last() {
    if (cursor != null) cursor = target.tail;
  }
    
    /**
        Moves the cursor forward.
    **/
  public function forward() {
    if(cursor != null) cursor = cursor.next;  
  }
    
    /**
        Moves the cursor backward.
    **/
  public function backward() {
    if(cursor != null) cursor = cursor.prev;
  }
    
  public function hasNext() {
    return _cursor != null;
  }
    
  public function next() {
    if (_cursor != null) {
      var value = cursor.data;
      cursor = cursor.next;
      return value;
    } else {
      return null;
    }
  }
    
    /**
        Checks if the current referenced node is valid.
    **/
    public function valid() : Bool {
        return cursor != null;
    }
}

