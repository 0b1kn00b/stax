package stx;

import Stax.*;
import stx.Tuples;

using stx.Outcome;
using stx.Tuples;
using stx.Fail;            
using Prelude;
using stx.Arrays;
using stx.Option;
using stx.Anys;
using stx.Iterables;
using stx.Eventual;
using stx.Either;

@doc("
  An asynchronous operation that may complete in the future unless
  successfully canceled.
  
  Eventuals can be combined and chained together to form complicated
  asynchronous control flows. Often used operations are `map()` and
  `flatMap()`.
")
class Eventual<T> {
  @:isVar public var value(get, set):T;
  
  function get_value():T { 
    return this.value; 
  }
  function set_value(value:T):T {
    return this.value = value;
  }
  var _listeners  : Array<T -> Void>;
  var _isSet      : Bool;
  var _isCanceled : Bool;
  var _cancelers  : Array<Void -> Bool>;
  var _canceled   : Array<Void -> Void>;

  public function new(?v:T) {
    _listeners  = [];
    value       = null;
    _isSet      = false;
    _isCanceled = false;
    _cancelers  = [];
    _canceled   = [];
    if(v!=null) deliver(v);
  }
  public function isEmpty(){
    return _listeners.length == 0;
  }
  @doc("Creates a 'dead' future that is canceled and will never be delivered.")
  public static function dead<T>(): Eventual<T> {
    return new Eventual().affect(function(future) {
      future.cancel();
    });
  }

  @doc("
    Delivers the value of the future to anyone awaiting it. If the value has
    already been delivered, this method will throw an exception.
  ")
  public function deliver(t: T): Eventual<T> {
    return if (_isCanceled) this;
    //else if (_isSet) { except()('Eventual already delivered'); }
    else if (_isSet) except()(IllegalOperationError("Eventual : $value already delivered"));
    else {
      value = t;
      _isSet  = true;

      for (l in _listeners) l(value);

      _listeners = [];

      this;
    }
  }

  @doc("
    Installs the specified canceler on the future. Under ordinary
    circumstances, the future will not be canceled unless all cancelers
    return true. If the future is already done, this method has no effect.
    
    This method does not normally need to be called. It's provided primarily
    for the implementation of future primitives.
  ")
  public function allowCancelOnlyIf(f: Void -> Bool): Eventual<T> {
    if (!isDone()) _cancelers.push(f);

    return this;
  }

  @doc("
    Installs a handler that will be called if and only if the future is
    canceled.
    
    This method does not normally need to be called, since there is no
    difference between a future being canceled and a future taking an
    arbitrarily long amount of time to evaluate. It's provided primarily
    for implementation of future primitives to save resources when it's
    explicitly known the result of a future will not be used.
  ")
  public function ifCanceled(f: Void -> Void): Eventual<T> {
    if (isCanceled()) f();
    else if (!isDone()) _canceled.push(f);

    return this;
  }

  @doc("
    Attempts to cancel the future. This may succeed only if the future is
    not already delivered, and if all cancel conditions are satisfied.
    
    If a future is canceled, the result will never be delivered.
   
    @return true if the future is canceled, false otherwise.
  ")
  public function cancel(): Bool {
    return if (isDone()) false;   // <-- Already done, can't be canceled
    else if (isCanceled()) true;  // <-- Already canceled, nothing to do
    else {                        // <-- Ask to see if everyone's OK with canceling
      var r = true;

      for (canceller in _cancelers) r = r && canceller();
      if (r) {
        // Everyone's OK with canceling, mark state & notify:
        forceCancel();
      }

      r;
    }
  }

  @doc("Determines if the future is 'done' -- that is, delivered or canceled.")
  public function isDone(): Bool {
    return isDelivered() || isCanceled();
  }

  @doc("Determines if the future is delivered.")
  public function isDelivered(): Bool {
    return _isSet;
  }

  @doc("Determines if the future is canceled.")
  public function isCanceled(): Bool {
    return _isCanceled;
  }

  @doc("Delivers the result of the future to the specified handler as soon as it is delivered.")
  public function deliverTo(f: T -> Void): Eventual<T> {
    if (isCanceled()) return this;
    else if (isDelivered()) f(value);
    else _listeners.push(f);

    return this;
  }
  @doc("Alias for deliverTo")
  public function each(f:T->Void):Eventual<T> {
    return deliverTo(f);
  }
  @doc("
    Uses the specified function to transform the result of this future into
    a different value, returning a future of that value.
    
    urlLoader.load('image.png').map(function(data) return new Image(data)).deliverTo(function(image) imageContainer.add(image));
  ")
  public function map<S>(f: T -> S): Eventual<S> {
    var fut: Eventual<S> = new Eventual();

    deliverTo(function(t: T) { fut.deliver(f(t)); });
    ifCanceled(function() { fut.forceCancel(); });

    return fut;
  }
  @doc("
    Maps the result of this future to another future, and returns a future
    of the result of that future. Useful when chaining together multiple
    asynchronous operations that must be completed sequentia
    lly.
    ```
    urlLoader.load('config.xml').flatMap(function(xml){
      return urlLoader.load(parse(xml).mediaUrl);
    }).deliverTo(function(loadedMedia){
      container.add(loadedMedia);
    });
    ```
  ")
  public function flatMap<B>(fn:T->Eventual<B>):Eventual<B>{
    var fut: Eventual<B> = new Eventual();
    var f = this;
    f.deliverTo(function(t: T) {
      fn(t).deliverTo(function(s: B) {
        fut.deliver(s);
      }).ifCanceled(function() {
        untyped fut.forceCancel();
      });
    });

    f.ifCanceled(function() { untyped fut.forceCancel(); });

    return fut;
  }

  @doc("Drop this future, returning `f`.")
  public function then<S>(f: Eventual<S>): Eventual<S> {
    return f;
  }


  @doc("
    Returns a new future that will be delivered only if the result of this
    future is accepted by the specified filter (otherwise, the new future
    will be canceled).
  ")
  public function filter(f: T -> Bool): Eventual<T> {
    var fut: Eventual<T> = new Eventual();

    deliverTo(function(t: T) { if (f(t)) fut.deliver(t); else fut.forceCancel(); });

    ifCanceled(function() fut.forceCancel());

    return fut;
  }

  @doc("
    Zips this future and the specified future into another future, whose
    result is a tuple of the individual results of the futures. Useful when
    an operation requires the result of two futures, but each future may
    execute independently of the other.
  ")
  public function zip<A>(f2: Eventual<A>): Eventual<Tuple2<T, A>> {
    return zipWith( f2, tuple2 );
  }
  public function zipWith<A,B>(f2:Eventual<A>,fn : T -> A -> B):Eventual<B>{
    //trace('zip');
    var zipped: Eventual<B> = new Eventual();
    var sent : Bool       = false;

    var f1 = this;
    var deliverZip = function() {
      if (f1.isDelivered() && f2.isDelivered() && !sent ) {
        sent = true;
        zipped.deliver(
          fn(f1.valueO().get(), f2.valueO().get())
        );
      }
    }
    f1.deliverTo(function(v) deliverZip());
    f2.deliverTo(function(v) deliverZip());

    zipped.allowCancelOnlyIf(function() return f1.cancel() || f2.cancel());

    f1.ifCanceled(function() zipped.forceCancel());
    f2.ifCanceled(function() zipped.forceCancel());

    return zipped; 
  }
  @doc("Retrieves the value of the future, as an `Option`.")
  public function valueO(): Option<T> {
    return if (_isSet) Some(value) else None;
  }
  public function toOption(): Option<T> {
    return valueO();
  }

  public function toArray(): Array<T> {
    return valueO().toArray();
  }

  private function forceCancel(): Eventual<T> {
    if (!_isCanceled) {
      _isCanceled = true;

      for (canceled in _canceled) canceled();
    }

    return this;
  }

  public static function create<T>(): Eventual<T> {
    return new Eventual<T>();
  }
  @:noUsing static public function pure<A>(v:A):Eventual<A>{
    return EventualsT.toEventual(v);
  }
  @:noUsing static public function unit<A>():Eventual<A>{
    return new Eventual();
  }
  public function deliverMe(f:Eventual<T>-> Void): Eventual<T> {
    if (isCanceled()) return this;
    else if (isDelivered()) f(this);
    else _listeners.push(function(g) {
        f(this);
      });
    return this;
  }
  public function equals(f:Eventual<T>):Bool{
    return stx.plus.Equal.getEqualFor(value)(this.value,f.value);
  }
}
class Eventuals{
  static public function each<A>(f:Eventual<A>,fn:A->Void):Eventual<A>{
    return f.each(fn);
  }
  static public function mapLefteft<A,B,C>(f:Eventual<Either<A,B>>,fn:A->C):Eventual<Either<C,B>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(fn(l));
          case      Right(r)     : Right(r);
        };
      }
    );
  }
  static public function mapRight<A,B,C>(f:Eventual<Either<A,B>>,fn:B->C):Eventual<Either<A,C>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(l);
          case      Right(r)     : Right(fn(r));
        }
      }
    );
  }
  static public function map<A,B>(f:Eventual<A>,fn:A->B):Eventual<B>{
    return f.map(fn);
  }
  static public function flatMap<A,B>(f:Eventual<A>,fn:A->Eventual<B>):Eventual<B>{
    var fut: Eventual<B> = new Eventual();
    f.deliverTo(function(t: A) {
      fn(t).deliverTo(function(s: B) {
        fut.deliver(s);
      }).ifCanceled(function() {
        untyped fut.forceCancel();
      });
    });

    f.ifCanceled(function() { untyped fut.forceCancel(); });

    return fut;
  }
  static public function flatMapRight<A,B,C>(f:Eventual<Either<A,B>>,fn:B->Eventual<Either<A,C>>):Eventual<Either<A,C>>{
    return flatMap(f,
      function(x){
        return switch (x){
          case Left(l)     : Eventual.pure(Left(l));
          case Right(r)    : fn(r);
        }
      }
    );
  }
  static public function zip<A,B>(f:Eventual<A>,f2:Eventual<B>):Eventual<Tuple2<A,B>>{
    return f.zip(f2);
  }
  static public function waitFor<A>(toJoin:Array<Eventual<A>>):Eventual<Array<A>> {
    var
      joinLen = toJoin.size(),
      myprm = Eventual.create(),
      combined:Array<{seq:Int,val:Dynamic}> = [],
      sequence = 0;
        
    toJoin.each(function(xprm:Dynamic) {
        if(!Std.is(xprm,Eventual)) {
          throw "not a Eventual:"+xprm;
        }

        xprm.sequence = sequence++; 
        xprm.deliverMe(function(r:Dynamic) {
            combined.push({ seq:r.sequence,val:r.value});
            if (combined.length == joinLen) {
              combined.sort(function(x,y) { return x.seq - y.seq; });

              //trace("combined :"+combined.map(function(el) { return el.seq; }).stringify());              
              myprm.deliver(combined.map(function(el) { return el.val; }));
            }
          });
      });  
    return myprm;
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Eventual<B>):Eventual<B>{
    return iter.foldLeft(
      Eventual.pure(start) ,
      function(memo : Eventual<B>, next : A){
        return memo.flatMap(
            function(b: B){
              return fm(b,next);
            }
          );
      }
    );
  }

  #if (js || flash)
  static public function delayC<A>(s:Int,c:A):Eventual<A>{
    var ft = new Eventual();
    haxe.Timer.delay(
      function(){
        ft.deliver(c);
      },s
    );
    return ft;
  }
  #end
  static public function either<A>(evt:Eventual<Either<A,A>>):Eventual<A>{
    return evt.map(Eithers.either);
  }
}
class EventualsT{
  static public function toEventual<T>(t: T): Eventual<T> {
    return Eventual.create().deliver(t);
  }
}
class Eventuals1{
  @doc("One parameter callback handler, where callback is called exactly once.")
  static public function toEventual<A>(f:(A->Void)->Void):Eventual<A>{
    var fut = new Eventual();
    f(
      function(res){
        fut.deliver(res);
      }
    );
    return fut;
  }
}
class Eventuals2{
  @doc("Creates a Eventual of Tuple2<A,B> from a callback function(a:A,b:B)")
  static public function toEventual<A,B>(f:(A->B->Void)->Void):Eventual<Tuple2<A,B>>{
    var ft = new Eventual();
    f(
      function(a,b){
        ft.deliver( tuple2(a,b) );
      }
    );
    return ft;
  }
}
class Eventuals3{
  @doc("Creates a Eventual of Tuple2<A,B,C> from a callback function(a:A,b:B,c:C)")
  static public function toEventual<A,B,C>(f:(A->B->C->Void)->Void):Eventual<Tuple3<A,B,C>>{
    var ft = new Eventual();
    f(
      function(a,b,c){
        ft.deliver( tuple3(a,b,c) );
      }
    );
    return ft;
  }
}