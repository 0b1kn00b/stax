package  {
	public class Prelude.SArrays {
		static public function map(a : Array,f : Function) : Array {
			var n : Array = [];
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					n.push(f(e));
				}
			}
			return n;
		}
		
		static public function flatMap(a : Array,f : Function) : Array {
			var n : Array = [];
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e1 : * = a[_g];
					++_g;
					{ var $it : * = f(e1).iterator();
					while( $it.hasNext() ) { var e2 : * = $it.next();
					n.push(e2);
					}}
				}
			}
			return n;
		}
		
		static public function foldl(a : Array,z : *,f : Function) : * {
			var r : * = z;
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					r = f(r,e);
				}
			}
			return r;
		}
		
		static public function filter(a : Array,f : Function) : Array {
			var n : Array = [];
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					if(f(e)) n.push(e);
				}
			}
			return n;
		}
		
		static public function size(a : Array) : int {
			return a.length;
		}
		
		static public function snapshot(a : Array) : Array {
			return [].concat(a);
		}
		
		static public function foreach(a : Array,f : Function) : Array {
			{
				var _g : int = 0;
				while(_g < a.length) {
					var e : * = a[_g];
					++_g;
					f(e);
				}
			}
			return a;
		}
		
	}
}
