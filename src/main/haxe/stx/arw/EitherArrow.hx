package stx.arw;

import Prelude;
import stx.Tuples;
import stx.Continuation.*;

using stx.Arrow;
using stx.Tuples;

abstract EitherArrow<I,O>(Arrow<I,O>) from Arrow<I,O> to Arrow<I,O>{
	public function new(a:Arrow<I,O>,b:Arrow<I,O>){	
		this = new Arrow(
			inline function(?i:I,cnt : O->Void){
				var done = false;
				var a_0 :Eventual<O>	= null;
				var b_0 :Eventual<O>	= null;

				var a_1 :Eventual<Tuple2<Eventual<O>,O>>= null;
				var b_1 :Eventual<Tuple2<Eventual<O>,O>>= null;

				var handler 
					= function(f:Eventual<O>,o:O):Void{
							if(!done){
								if(f==a_0){
									b_0.cancel();
								}else if(f==b_0){
									a_0.cancel();
								}else{
									throw 'some error';
								}
								done = true;
								//trace('either done');
								cnt(o);
							}
						}.tupled();

				a_0 = Eventual.unit();
				a.withInput(i,a_0.deliver);
				b_0 = Eventual.unit();
				b.withInput(i,b_0.deliver);

				a_1 = a_0.map(function(x) return tuple2(a_0,x)).each(handler);
				b_1 = b_0.map(function(x) return tuple2(b_0,x)).each(handler);
			}
		);
	}
}