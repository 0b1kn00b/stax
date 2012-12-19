package stx.arw;
using stx.arw.Arrows;
using stx.Tuples;

class EitherArrow<I,O> extends Arrow<I,O>{
	var a : Arrow<I,O>;
	var b : Arrow<I,O>;
	public function new(a,b){
		super();
		this.a = a;
		this.b = b;
	}
	override public function withInput(?i:I,cont : O->Void){
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
						cont(o);
					}
				}.spread();

		a_0 = a.appFt(i);
		b_0 = b.appFt(i);

		a_1 = a.appFt(i).map(function(x) return Tuples.t2(a_0,x)).foreach(handler);
		b_1 = b.appFt(i).map(function(x) return Tuples.t2(b_0,x)).foreach(handler);
	}
}