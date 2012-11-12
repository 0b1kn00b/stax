package stx.reactive {
	import stx.ds.Collection;
	import stx.reactive.Signal;
	import stx.ds.List;
	import stx.functional.Foldables;
	import stx.Tuple2;
	public class SignalCollectionExtensions {
		public function SignalCollectionExtensions() : void {
		}
		
		static public function concatS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(c : stx.Tuple2) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.concat(c._1,c._2);
			});
		}
		
		static public function join(b : stx.reactive.Signal,char : String) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : String {
				return stx.functional.FoldableExtensions.mkString(c,char);
			});
		}
		
		static public function size(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : int {
				return c.size();
			});
		}
		
		static public function zipS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(c : stx.Tuple2) : stx.ds.List {
				return c._1.zip(c._2);
			});
		}
		
		static public function append(b : stx.reactive.Signal,element : *) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return c.add(element);
			});
		}
		
		static public function count(b : stx.reactive.Signal,predicate : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : int {
				return stx.functional.FoldableExtensions.count(c,predicate);
			});
		}
		
		static public function all(b : stx.reactive.Signal,tester : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : Boolean {
				return stx.functional.FoldableExtensions.forAll(c,tester);
			});
		}
		
		static public function any(b : stx.reactive.Signal,tester : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : Boolean {
				return stx.functional.FoldableExtensions.forAny(c,tester);
			});
		}
		
		static public function foreach(b : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.foreach(c,f);
			});
		}
		
		static public function _each(b : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.foreach(c,f);
			});
		}
		
		static public function map(b : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.map(c,f);
			});
		}
		
		static public function mapTo(b : stx.reactive.Signal,t : stx.ds.Collection,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.mapTo(c,t,f);
			});
		}
		
		static public function partition(b : stx.reactive.Signal,filter : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.Tuple2 {
				return stx.functional.FoldableExtensions.partition(c,filter);
			});
		}
		
		static public function filter(b : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.filter(c,f);
			});
		}
		
		static public function flatMap(b : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.flatMap(c,f);
			});
		}
		
		static public function toArray(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : Array {
				return stx.functional.FoldableExtensions.toArray(c);
			});
		}
		
		static public function foldr(b : stx.reactive.Signal,initial : *,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : * {
				return stx.functional.FoldableExtensions.foldr(c,initial,f);
			});
		}
		
		static public function foldl(b : stx.reactive.Signal,initial : *,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : * {
				return c.foldl(initial,f);
			});
		}
		
		static public function scanl(b : stx.reactive.Signal,initial : *,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.scanl(c,initial,f);
			});
		}
		
		static public function scanr(b : stx.reactive.Signal,initial : *,f : Function) : stx.reactive.Signal {
			return b.map(function(c : stx.ds.Collection) : stx.ds.Collection {
				return stx.functional.FoldableExtensions.scanr(c,initial,f);
			});
		}
		
	}
}
