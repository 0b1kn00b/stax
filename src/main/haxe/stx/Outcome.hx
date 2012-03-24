package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import Prelude;
																	using Stax;
import stx.Future;								using stx.Future;								
																	using stx.Functions;
																	using stx.Iterables;
																	using stx.Eithers;
																	using stx.Options;
import stx.reactive.Arrows;			using stx.reactive.Arrows;

import stx.error.NullReferenceError;

		
class Outcome<A,B>  {

  var fut:Future<Either<A,B>>;
  public var userCancel:Arrow<A,A>;
	
  var err:A;

  public function new(?cancel:Arrow<A,A>) {		
    fut = new Future();
    err = null;
    if (cancel != null){
      userCancel = cancel;
		}else {
			userCancel = function(x:Dynamic):Dynamic { trace( x ); return x; } .lift();
		}
  }
	public function isDone() {
		return fut.isDone();
	}
  function onCancel(e:A) {
		//trace('here' + userCancel);
      err = e;
			userCancel.run(e);
  }
	public function foreach(f) {
		return deliverTo(f);
	}
  public function future():Future<Either<A,B>> {
    return fut;
  }
  
  public function onError(cb:Arrow<A,A>) {
		//trace('set error handler');
    userCancel = userCancel.then(cb);
			//userCancel = cb;
    return cast this;
  }

  public function error():A {
    return err;
  }
  
  public function deliverTo(cb:B->Void) {
    fut.deliverTo(function(e) {
        switch(e) {
        case Right(v):
          cb(v);
        case Left(msg):
          onCancel(msg);
        }
      });
    return cast this;
  }
  
  public function resolve(e:Either < A, B >,?pos ) {
	
    fut.deliver(e,pos);
  }
	public function left(a:A):Outcome<A,B> {
		fut.deliver(Left(a));
		return cast this;
	}
	public function right(b:B):Outcome<A,B> {
		fut.deliver(Right(b));
		return cast this;
	}
  public function map<S>(f: B -> S): Outcome<A,S> {
    var nf = new Outcome(userCancel);
    fut.deliverTo(function(e) {
        switch(e) {
        case Right(t):
          nf.right(f(t));
        case Left(msg):
          onCancel(msg);
          nf.cancel();
        }
      });      
    return nf;
  }
  
  public function flatMap<S>(cb:B->Outcome<A,S>):Outcome<A,S> {
    var nf = new Outcome(userCancel);
    fut.deliverTo(function(either) {
        switch(either) {
        case Right(result):
						var op = cb(result);
						op.onError( nf.userCancel );
						op.deliverTo(function(r) {
              nf.resolve(Right(r));
            });
        case Left(msg):
          onCancel(msg);
          nf.cancel();
        }
      });
    return nf;
  }

  public function cancel() {
    fut.cancel();
  }

	public static function succeed<A>(value:A):Outcome < Dynamic, A > {
		var o = new Outcome();
				o.right(value);
		return o;
	}
	
	public static function failer<A>(value:A):  Outcome<A,Dynamic>{
		var o = new Outcome();
				o.left(value);
		return o;
	}
	public static function fromCallback<T>(outcome:Outcome<Dynamic,T>):Dynamic -> Dynamic -> Void {
		return function(err, val) {
			if (err != null) {
				outcome.left(err);
			}else {
				outcome.right(val);
			}
		}
	}
	public function toCallback(cb:A -> B -> Void) {
		if (cb == null) {
			throw new NullReferenceError('callback');
		}
		this.deliverTo( 
				function(b) {
							cb(null, b);
				}
		);
		onError(function(x) {cb(x, null); return x; } .lift() );
		return cast this;
	}
  public static function
  waitFor(toJoin:Array<Outcome<Dynamic,Dynamic>>):Outcome<String,Array<Dynamic>> {
    var
      oc = new Outcome(),
      results = [];
    
    Future.waitFor(toJoin.map(function(outcome) return outcome.future())).deliverTo(function(aoc) {
				var failed : Bool = false;
        aoc.foreach(function(el:Either < Dynamic, Dynamic > ) {
					if(!failed){
            if (el.isLeft()) {
							failed = true;
              oc.resolve(Left(el.left().get()));
              return;
            }
            results.push(el.right().get());
          }
				});
				if (!failed ) {
					oc.resolve(Right(results));
				}
      });
    return oc;
  }

}