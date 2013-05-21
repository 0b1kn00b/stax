package stx.arw;

import stx.Tuples.*;
import stx.Continuation.*;

using stx.arw.Arrows;
using stx.Tuples;

abstract EitherArrow<I,O>(Arrow<I,O>) from Arrow<I,O> to Arrow<I,O>{
	public function new(a:Arrow<I,O>,b:Arrow<I,O>){	
		this = new Arrow(
			inline function(?i:I,cnt : O->Void){
				var done = false;
				var a_0 :Future<O>	= null;
				var b_0 :Future<O>	= null;

				var a_1 :Future<Tuple2<Future<O>,O>>= null;
				var b_1 :Future<Tuple2<Future<O>,O>>= null;

				var handler 
					= function(f:Future<O>,o:O):Void{
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
						}.spread();

				a_0 = a.apply(i);
				b_0 = b.apply(i);

				a_1 = a_0.map(function(x) return tuple2(a_0,x)).foreach(handler);
				b_1 = b_0.map(function(x) return tuple2(b_0,x)).foreach(handler);
			}
		);
	}
	public function apply(?i){
		return this.apply(i);
	}
}