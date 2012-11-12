package  {
	public class Prelude.SIterables {
		static public function toArray(i : *) : Array {
			var a : Array = [];
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			a.push(e);
			}}
			return a;
		}
		
		static public function toIterable(it : *) : * {
			return { iterator : function() : * {
				return { next : it.next, hasNext : it.hasNext}
			}}
		}
		
		static public function map(iter : *,f : Function) : * {
			return Prelude.SIterables.foldl(iter,[],function(a : Array,b : *) : Array {
				a.push(f(b));
				return a;
			});
		}
		
		static public function flatMap(iter : *,f : Function) : * {
			return Prelude.SIterables.foldl(iter,[],function(a : Array,b : *) : Array {
				{ var $it : * = f(b).iterator();
				while( $it.hasNext() ) { var e : * = $it.next();
				a.push(e);
				}}
				return a;
			});
		}
		
		static public function foldl(iter : *,seed : *,mapper : Function) : * {
			var folded : * = seed;
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			folded = mapper(folded,e);
			}}
			return folded;
		}
		
		static public function filter(iter : *,f : Function) : * {
			return Prelude.SArrays.filter(Prelude.SIterables.toArray(iter),f);
		}
		
		static public function size(iterable : *) : int {
			var size : int = 0;
			{ var $it : * = iterable.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			++size;
			}}
			return size;
		}
		
		static public function foreach(iter : *,f : Function) : void {
			{ var $it : * = iter.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			f(e);
			}}
		}
		
	}
}
