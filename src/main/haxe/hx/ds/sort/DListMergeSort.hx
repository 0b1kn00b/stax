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

package hx.ds.sort;

import hx.ds.DList;

class DListMergeSort {
	
	public static function sort<T>(value : DList<T>, 
                                   ?comparator : Null<T> -> Null<T> -> Int) {
		if (value.head == null) return;
        
        var h = value.head;
        var p : DListNode<T> = null;
        var q : DListNode<T> = null;
        var e : DListNode<T> = null;
        var tail : DListNode<T> = null;
        var insize = 1;
        var nmerges = 0;
        var psize = 0;
        var qsize = 0;
		
		var compare = if (comparator == null) Reflect.compare else comparator;
		
        while (true) {
            p = h;
            h = tail = null;
            nmerges = 0;
                                
            while (p != null) {
                nmerges++;
                
                psize = 0;
                q = p;
                for (i in 0...insize) { 
                    psize++;
                    q = q.next;
                    if (q == null) break;
                }
                                        
                qsize = insize;
                                        
                while (psize > 0 || (qsize > 0 && q != null)) {
                    if (psize == 0) {
                        e = q; 
                        q = q.next; 
                        qsize--;
                    } else if (qsize == 0 || q == null) {
                        e = p; 
                        p = p.next; 
                        psize--;
                    } else if (compare(p.data, q.data) <= 0) {
                        e = p; 
                        p = p.next; 
                        psize--;
                    } else {
                        e = q; 
                        q = q.next; 
                        qsize--;
                    }
                                                
                    if (tail != null) tail.next = e;
                    else h = e;
                                                
                    e.prev = tail;
                    tail = e;
                }
                
                p = q;
            }
                                
            tail.next = null;
            if (nmerges <= 1) {
                value.head = h;
                return;
            }
            
            insize <<= 1;
        }
    }
}