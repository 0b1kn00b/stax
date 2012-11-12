package  {
	public class Lambda {
		static public function array(it : *) : Array {
			var a : Array = new Array();
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var i : * = $it.next();
			a.push(i);
			}}
			return a;
		}
		
		static public function list(it : *) : List {
			var l : List = new List();
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var i : * = $it.next();
			l.add(i);
			}}
			return l;
		}
		
		static public function map(it : *,f : Function) : List {
			var l : List = new List();
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			l.add(f(x));
			}}
			return l;
		}
		
		static public function mapi(it : *,f : Function) : List {
			var l : List = new List();
			var i : int = 0;
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			l.add(f(i++,x));
			}}
			return l;
		}
		
		static public function has(it : *,elt : *,cmp : Function = null) : Boolean {
			if(cmp == null) {
				{ var $it : * = it.iterator();
				while( $it.hasNext() ) { var x : * = $it.next();
				if(x == elt) return true;
				}}
			}
			else {
				{ var $it2 : * = it.iterator();
				while( $it2.hasNext() ) { var x1 : * = $it2.next();
				if(cmp(x1,elt)) return true;
				}}
			}
			return false;
		}
		
		static public function exists(it : *,f : Function) : Boolean {
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			if(f(x)) return true;
			}}
			return false;
		}
		
		static public function foreach(it : *,f : Function) : Boolean {
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			if(!f(x)) return false;
			}}
			return true;
		}
		
		static public function iter(it : *,f : Function) : void {
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			f(x);
			}}
		}
		
		static public function filter(it : *,f : Function) : List {
			var l : List = new List();
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			if(f(x)) l.add(x);
			}}
			return l;
		}
		
		static public function fold(it : *,f : Function,first : *) : * {
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			first = f(x,first);
			}}
			return first;
		}
		
		static public function count(it : *,pred : Function = null) : int {
			var n : int = 0;
			if(pred == null) {
				{ var $it : * = it.iterator();
				while( $it.hasNext() ) { var _ : * = $it.next();
				n++;
				}}
			}
			else {
				{ var $it2 : * = it.iterator();
				while( $it2.hasNext() ) { var x : * = $it2.next();
				if(pred(x)) n++;
				}}
			}
			return n;
		}
		
		static public function empty(it : *) : Boolean {
			return !it.iterator().hasNext();
		}
		
		static public function indexOf(it : *,v : *) : int {
			var i : int = 0;
			{ var $it : * = it.iterator();
			while( $it.hasNext() ) { var v2 : * = $it.next();
			{
				if(v == v2) return i;
				i++;
			}
			}}
			return -1;
		}
		
		static public function concat(a : *,b : *) : List {
			var l : List = new List();
			{ var $it : * = a.iterator();
			while( $it.hasNext() ) { var x : * = $it.next();
			l.add(x);
			}}
			{ var $it2 : * = b.iterator();
			while( $it2.hasNext() ) { var x1 : * = $it2.next();
			l.add(x1);
			}}
			return l;
		}
		
	}
}
