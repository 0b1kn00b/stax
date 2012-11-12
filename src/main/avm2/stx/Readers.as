package stx {
	public class Readers {
		static public function map(reader : Function,f : Function) : Function {
			return function(x : *) : * {
				return f(reader(x));
			}
		}
		
		static public function flatMap(reader : Function,f : Function) : Function {
			return function(x : *) : * {
				return (f(reader(x)))(x);
			}
		}
		
	}
}
