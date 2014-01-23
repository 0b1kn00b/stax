package stx.async.arrowlet;

import Prelude;
import stx.Tuples;
import stx.async.Continuation.*;

using stx.async.Arrowlet;
using stx.Tuples;

abstract Either<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(a:Arrowlet<I,O>,b:Arrowlet<I,O>){	
		this = new Arrowlet(
			inline function(?i:I,cnt : O->Void){
				var done = false;
				var a_0 : stx.async.Eventual<O>	= null;
				var b_0 : stx.async.Eventual<O>	= null;

				var a_1 : stx.async.Eventual<Tuple2<stx.async.Eventual<O>,O>>= null;
				var b_1 : stx.async.Eventual<Tuple2<stx.async.Eventual<O>,O>>= null;

				var handler 
					= function(f:stx.async.Eventual<O>,o:O):Void{
							if(!done){
								done = true;
								//trace('either done');
								cnt(o);
							}
						}.tupled();

				a_0 = stx.async.Eventual.unit();
				a.withInput(i,a_0.deliver);
				b_0 = stx.async.Eventual.unit();
				b.withInput(i,b_0.deliver);

				a_1 = a_0.map(function(x) return tuple2(a_0,x)).each(handler);
				b_1 = b_0.map(function(x) return tuple2(b_0,x)).each(handler);
			}
		);
	}
}