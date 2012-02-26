package stax;

/**
 * ...
 * @author cloudshift
 * let the snarfing live on.
 * https://github.com/cloudshift/cloudshift
 */
import Prelude;
import stax.Future;
class Outcome<A,B> {

  var fut:Future<Either<A,B>>;
  var userCancel:A->Void;
  var err:A;

  public function new(?cancel:A->Void) {
    fut = new Future();
    err = null;
    if (cancel != null)
      userCancel = cancel;
  }

  function onCancel(e:A) {
      err = e;
      if (userCancel != null)
        userCancel(e);
      else
        Stax.error(Std.string(e));
  }

  public function future():Future<Either<A,B>> {
    return fut;
  }
  
  public function onError(cb:A->Void) {
    userCancel = cb;
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
  
  public function deliver(e:Either<A,B>) {
    fut.deliver(e);
		return cast this;
  }

  public function map<S>(f: B -> S): Outcome<A,S> {
    var nf = new Outcome(userCancel);
    fut.deliverTo(function(e) {
        switch(e) {
        case Right(t):
          nf.deliver(Right(f(t)));
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
          cb(result).deliverTo(function(r) {
              nf.deliver(Right(r));
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
	public function isDone() {
		return fut.isDone();
	}
	public function value(){
		return fut.value();
	}
	public static function toOutcome<A>(value:A):Outcome<Dynamic,A> {
		return new Outcome();
	}
}
