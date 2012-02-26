package stax.reactive;

/**
 * ...
 * @author 0b1kn00b
 */
import stax.reactive.Arrows; using stax.reactive.Arrows;
import stax.Methods;
import stax.Future;

class FutureArrow<I> implements Arrow<Future<I>,I>{

	public function new() {
		
	}
	public function withInput(i : Future<I>, cont : Method < I, Void, I->Void > ) : Void {
		i.deliverTo(
				function(p1:I) {
					cont.execute(p1);
				}
		);
	}
	
}