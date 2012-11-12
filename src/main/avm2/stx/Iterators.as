package stx {
	public class Iterators {
		static public function toArray(iterator : *) : Array {
			var o : Array = [];
			while(iterator.hasNext()) o.push(iterator.next());
			return o;
		}
		
		static public function forAll(iterator : *,fn : Function) : Boolean {
			var ok : Boolean = true;
			while(iterator.hasNext()) {
				ok = fn(iterator.next());
				if(!ok) break;
			}
			return ok;
		}
		
	}
}
