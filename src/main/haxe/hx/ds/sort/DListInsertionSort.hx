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

class DListInsertionSort {
    
	public static function sort<T>(value : DList<T>, 
                                   ?comparator : Null<T> -> Null<T> -> Int) {
		var node = value.head;

		if (node == null) return;

		var compare = if (comparator == null) Reflect.compare else comparator;

		var h = node;
		var n = h.next;

		while(n != null){
			var m = n.next;
			var p = n.prev;
            
			if (compare(p.data, n.data) > 0) {
				var i = p;

				while(i.prev != null){
					if (compare(i.prev.data, n.data) > 0) i = i.prev;
                    else break;
				}
                
				if (m != null) {
					p.next = m;
					m.prev = p;
				} else {
					p.next = null;
				}
                
				if (i == h) {
					n.prev = null;
					n.next = i;

					i.prev  = n;
					h = n;
				} else {
					n.prev = i.prev;
					i.prev.next = n;

					n.next = i;
					i.prev = n;
				}
			}
            
			n = m;
		}
        
		value.head = h;
	}
}