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
  
  var fut:Future<Either<A,B>>;
  public var userCancel:Arrow<A,A>;
  private var done : Bool;
  
  public var id : Int;
  
  var err: Option<A>;
  
  public function new(?cancel:Arrow < A, A > ) {    
    done    = false;
    id      = count++;
    //trace(this + 'new');
    fut     = new Future();
    err     = None;
    if (cancel != null) {
        onError(cancel);
    }
  }
  public function toString() {
    return 'Promise: [' + id + '] ';
  }
  public function isDone() {
    return fut.isDone() && this.done;
  }
  function onCancel(e:A):Void {
    //trace(this + ' cancel: ' + e + ' already done? ' + isDone());
    if (isDone()) return;
      err = Some(e);
      if (userCancel != null) {
        userCancel.run(e);
        //trace(this + 'running canceller');
      }else {
        //trace(this + ' no canceller');
      }     
      done = true;
  }
  public function foreach(f): Promise<A,B> {
    return deliverTo(f);
  }
  public function future():Future<Either<A,B>> {
    return fut;
  }
  public function onError(cb:Arrow<A,A>) : Promise < A, B > {
    if (cb == null) { throw new stx.error.NullReferenceError('cb'); }
    
    //trace(this + ' onError set ' + userCancel + ' ' + cb + 'with error ' + err);
    if (userCancel == null) {
      userCancel = cb;
    }else {
      //userCancel = cb;
      userCancel = userCancel.then(cb);
    }
    switch (err) {
      case Some(v):
        //trace(this + ' calling on set error handler');
        switch (err) {
          case Some(v):
            err = Some(v);
            if (userCancel != null) {
                userCancel.run(v);
                //trace(this + 'running canceller');
              }
          default:
            
        }
      default:
        
    }
    return cast this;
  }
  public function error() : Option<A> {
    return err;
  }
  public function deliverTo(cb:B->Void): Promise<A,B> {
    
    fut.deliverTo(function(e) {
      //trace(this + 'deliver future');
        switch(e) {
        case Right(v):
          cb(v);
          //trace(this + 'success delivered');
        case Left(v):
          //trace(this + 'fail delivered');
          onCancel(v);
        }
      });
    return cast this;
  }
  
  public function resolve(e:Either < A, B > , ?pos ) {
    //trace(this + 'resolve: ' + e);
    fut.deliver(e, pos);
    switch (e) {
      case Left(v):
          if (!isDone()) {
            onCancel(v);
          }
      default:
        
    }
  }
  public function left(a:A):Promise<A,B> {
    resolve(Left(a));
    return cast this;
  }
  public function right(b:B):Promise<A,B> {
    resolve(Right(b));
    return cast this;
  }
  public function map<S>(f: B -> S): Promise < A, S > {
    //trace(this + 'map');
    var nf = new Promise();
    var uc = userCancel;
    nf.err = err;
    
    this.onError(
        function(x) {
          //trace( this + 'next future fail');
          nf.onCancel(x);
          return x;
        }.lift()
    );
    fut.deliverTo(function(e) {
      //trace(this + 'calling map');
        switch(e) {
        case Right(t):
          //trace(this + 'map ok ' + e);
          nf.right(f(t));
        case Left(msg):
          //trace(this + 'map fail ' + msg);
          onCancel(msg);
          //nf.onCancel(msg);
          //nf.cancel();
          //nf.left(msg);//cancel();
        }
      });
    return nf;
  }
  public function flatMap<S>(cb:B->Promise < A, S > ):Promise < A, S > {    
    //trace(this + 'flatmap');
    var nf = new Promise();
    nf.err = err;
    this.onError(
        function(x) {
          nf.onCancel(x);
          return x;
        }.lift()
    );
    fut.deliverTo(function(either) {
      //trace(this + 'calling flatmap: ' + either);
        switch(either) {
        case Right(result):
            var op = cb(result);
                //trace( 'flatmap result is ' + op);
                op.onError(
                    function(x) {
                      //trace(this + 'flatmapped fail: ' + nf);
                      nf.onCancel(x);
                      return x;
                    }.lift()
                );
    /*            this.onError( 
                    function(x) {
                      //trace(this + 'this fail in flatmap');
                      nf.left(x);
                      return x;
                    }.lift()
                );*/
            op.deliverTo(function(r) {
              //trace(this + 'flatmap ok ' + err);
              nf.resolve(Right(r));
            });
        case Left(msg):
            //trace(this + 'flatmap fail ' + err);
            /*onCancel(msg);
            nf.onCancel(msg);*/
            //nf.left(msg);
            //nf.cancel();
            //nf.onCancel(msg);//nf.cancel();
        }
      });
    return nf;
  }

  public function cancel() {
    fut.cancel();
  }

  public static function success<A>(value:A):Promise < Dynamic, A > {
    var o = new Promise();
        o.right(value);
    return o;
  }
  
  public static function failure<A>(value:A):  Promise<A,Dynamic>{
    var o = new Promise();
        o.left(value);
    return o;
  }
  public static function fromCallback<T>(promise:Promise<Dynamic,T>):Dynamic -> Dynamic -> Void {
    return function(err, val) {
      if (err != null) {
        promise.left(err);
      }else {
        promise.right(val);
      }
    }
  }
  public function toCallback(cb:A -> B -> Void) {
    if (cb == null) {
      throw new NullReferenceError('cb');
    }
    this.deliverTo( 
        function(b) {
          //trace(this + 'cb');
          cb(null, b);
        }
    );
    //trace(this + 'callback set');
    onError(function(x) { //trace(this + 'cb error');
      cb(x, null); return x; }.lift()  );
    return cast this;
  }
  public static function
  waitFor(toJoin:Array<Promise<Dynamic,Dynamic>>):Promise<String,Array<Dynamic>> {
    //trace('wait for');
    var f0 = false;
    var
      oc = new Promise(),
      results = [];
      toJoin.foreach(
        function(x) {
          //trace('wait failer setup');
          x.onError(
            function(x) {
              if (oc.userCancel != null && !f0) {
                oc.userCancel.run(x);
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
              //trace(oc + 'wait fail ' + el.left().get());
              oc.resolve(Left(el.left().get()));
              return;
            }
            results.push(el.right().get());
          }
        });
        if (!failed ) {
          //trace(oc + 'wait succeed' );
          oc.resolve(Right(results));
        }
      });
    return oc;
  }

}