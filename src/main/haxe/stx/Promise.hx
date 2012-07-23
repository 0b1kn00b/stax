package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;
                                  using Stax;
import stx.Future;                using stx.Future;               
                                  using stx.Functions;
                                  using stx.Iterables;
                                  using stx.Eithers;
                                  using stx.Options;
import stx.reactive.Arrows;     using stx.reactive.Arrows;

import stx.error.NullReferenceError;
    
class Promise<A,B>  {
  public static var count : Int = 0;
  
  /**
  * @private 
  * The underlying Future wrapped by this Promise.
  */
  var fut:Future<Either<A,B>>;

  /**
  * @private
  * An error handler that flows through th monad chain
  */
  public var userCancel(default,null) :Arrow<A,A>;

  /**
  * @private
  * Has this Promise been resolved?
  */
  private var done : Bool;
  
  /**
  * @private 
  * A reference to the error val if this resolves left
  */
  var err: Option<A>;
  
  public function new(?cancel:Arrow < A, A > ) {    
    done    = false;
    //trace(this + 'new');
    fut     = new Future();
    err     = None;
    if (cancel != null) {
        onError(cancel);
    }
  }
  public function toString() {
    return 'Promise';
  }
  public function isDone() {
    return fut.isDone() && this.done;
  }
  /**
  * @private
  * Called internally on failure.
  */
  function onCancel(e:A):Void {
    if (isDone()) return;
      err = Some(e);
      if (userCancel != null) {
        userCancel.run(e);
      }
      done = true;
  }
  /**
  * Calls a method f with a value when the promise is a success.
  */
  public function foreach(f): Promise<A,B> {
    return deliverTo(f);
  }
  /**
  * Returns the future that this object wraps
  */
  public function future():Future<Either<A,B>> {
    return fut;
  }
  /**
  * Add an error handler to be called if the Promise is broken.
  */
  public function onError(cb:Arrow<A,A>) : Promise < A, B > {
    if (cb == null) { throw new stx.error.NullReferenceError('cb'); }
    
    if (userCancel == null) {
      userCancel = cb;
    }else {
      userCancel = userCancel.then(cb);
    }
    switch (err) {
      case Some(v):
        switch (err) {
          case Some(v):
            err = Some(v);
            if (userCancel != null) {
                userCancel.run(v);
            }
          default:
            
        }
      default:
        
    }
    return cast this;
  }
  /**
  * Retrieves the error if the Promise has been broken.
  */
  public function error() : Option<A> {
    return err;
  }
  /**
  * Calls a method f with a value when the promise is a success.
  */
  public function deliverTo(cb:B->Void): Promise<A,B> {
    fut.deliverTo(function(e) {
        switch(e) {
        case Right(v):
          cb(v);
        case Left(v):
          onCancel(v);
        }
      });
    return cast this;
  }
  /**
  * Resolve this promise:
  * Either.Left(value) indicates a failure
  * Either.Right(value) indicates a success
  */
  public function resolve(e:Either < A, B > , ?pos ) {
    fut.deliver(e, pos);
    switch (e) {
      case Left(v):
          if (!isDone()) {
            onCancel(v);
          }
      default:
    }
  }
  /**
  * Notify this Promise that the operation has failed.
  */
  public function left(a:A):Promise<A,B> {
    resolve(Left(a));
    return cast this;
  }
  /**
  * Notify this Promise that the operation has been successful.
  */
  public function right(b:B):Promise<A,B> {
    resolve(Right(b));
    return cast this;
  }
  /**
  * Creates a Promise that delivers the value of the orignal 
  * Promise modified by function 'f'
  */
  public function map<S>(f: B -> S): Promise < A, S > {
    var nf = new Promise();
    var uc = userCancel;
    nf.err = err;
    
    this.onError(
        function(x) {
          nf.onCancel(x);
          return x;
        }.lift()
    );
    fut.deliverTo(function(e) {
        switch(e) {
        case Right(t):
          nf.right(f(t));
        case Left(msg):
          onCancel(msg);
        }
      });
    return nf;
  }
  /**
  * Creates a Promise that first waits for this Promise to resolve, 
  * and then waits for the Promise return by f, and delivers the result of the second.
  */
  public function flatMap<S>(f:B->Promise < A, S > ):Promise < A, S > {    
    var nf = new Promise();
    nf.err = err;
    this.onError(
        function(x) {
          nf.onCancel(x);
          return x;
        }.lift()
    );
    fut.deliverTo(function(either) {
        switch(either) {
        case Right(result):
            var op = f(result);
                op.onError(
                    function(x) {
                      nf.onCancel(x);
                      return x;
                    }.lift()
                );
            op.deliverTo(function(r) {
              nf.resolve(Right(r));
            });
        case Left(msg):
        }
      });
    return nf;
  }
  /**
  * Cancels this Promise
  */
  public function cancel() {
    fut.cancel();
  }
  /**
  * Creates a successful Promise of value
  */
  public static function success<A>(value:A):Promise < Dynamic, A > {
    var o = new Promise();
        o.right(value);
    return o;
  }
  /**
  * Creates a broken promise of value.
  */
  public static function failure<A>(value:A):  Promise<A,Dynamic>{
    var o = new Promise();
        o.left(value);
    return o;
  }
  /**
  * Creates a callback (err,val) that will deliver to promise
  */
  public static function fromCallback<T>(promise:Promise<Dynamic,T>):Dynamic -> Dynamic -> Void {
    return function(err, val) {
      if (err != null) {
        promise.left(err);
      }else {
        promise.right(val);
      }
    }
  }
  /**
  * Pipes the output of this promise to callback cb
  */
  public function toCallback(cb:A -> B -> Void) {
    if (cb == null) {
      throw new NullReferenceError('cb');
    }
    this.deliverTo( 
        function(b) {
          cb(null, b);
        }
    );
    onError(function(x) { 
      cb(x, null); return x; }.lift()  );
    return cast this;
  }
  /**
  * Shortcut for parallel, untyped execution of an Arrays Promises
  */
  public static function
  waitFor(toJoin:Array<Promise<Dynamic,Dynamic>>):Promise<String,Array<Dynamic>> {
    var f0 = false;
    var
      oc = new Promise(),
      results = [];
      toJoin.foreach(
        function(x) {
          x.onError(
            function(x) {
              if (oc.userCancel != null && !f0) {
                //oc.userCancel.run(x);
                f0 = true;
              }
              return x;
            }.lift()
          );
        }
      );
    Future.waitFor(toJoin.map(function(promise) return promise.future())).deliverTo(function(aoc) {
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