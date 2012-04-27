package stx;

/**
 * ...
 * @author 0b1kn00b
 */

class Promise<A,B> {

	private var method : B -> Void;
	
	public function new(fn) {
		this.method = fn;
	}
	public function map(fn : B -> Void) {
		return 
				new Promise(
						function(p:B) {
							return fn(method(p));
						}
				);
	}
	public function flatMap<C>(fn : B -> Promise<A,C>){
		return 
				new Promise(
						function(p:B) {
								return 
										fn(b)
						}
				);
	}
	
}