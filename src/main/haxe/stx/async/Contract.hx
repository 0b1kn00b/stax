package stx.async;

import stx.type.*;
import Stax.*;
import stx.Compare.*;
import stx.Fail.*;

import stx.Fail;
import stx.Tuples;

using stx.Iterables;
using stx.Outcome;
using Prelude;
using stx.Tuples;
using stx.async.Eventual;
using stx.Option;
using stx.Either;
using stx.Arrays;
using stx.Functions;
using stx.Compose;

abstract Contract<A>(Eventual<Outcome<A>>) from Eventual<Outcome<A>> to Eventual<Outcome<A>>{
  @:noUsing static public function pure<A>(e:Outcome<A>):Contract<A>{
    var o = new Contract();
    o.deliver(e);
    return o;
  }
  @:from static public function fromFail(f:Fail):Contract<A>{
    var o = new Contract();
        o.deliver(Failure(f));
    return o;
  }
  @:to public function toEventual():Eventual<A>{
    var evt = new Eventual();
    onSuccess(
      function(x){
        evt.deliver(x);
      }
    ).onFailure(
      function(err){
        throw err;
      }
    );
    return evt;
  }
  public function ensure():Eventual<A>{
    return toEventual();
  }
  @:to public function toPromise():Promise<A>{
    return function(fn:Outcome<A>->Void):Void{
      this.each(fn);
    }
  }
  @:noUsing static public function unit<A>():Contract<A>{
    return new Contract();
  }
  public function deliver<A>(v:Outcome<A>){
    this.deliver(v);
    return this;
  }
  public function ok(val:A){
    this.deliver(Success(val));
  }
  public function no(err:Fail){
    this.deliver(Failure(err));
  }
  public function onSuccess(fn:A->Void):Contract<A>{
    return each(Outcomes.onSuccess.bind(_,fn));
  }
  public function onFailure(fn:Fail->Void):Contract<A>{
    return each(Outcomes.onFailure.bind(_,fn));
  }
  public function onComplete(fn:Void->Void):Contract<A>{
    return each(fn.promote());
  }
  public function new(?p){
    this = nl().apply(p) ? Eventual.unit() : p;
  }
  public function orTry<B>(fn:Fail->Outcome<A>):Contract<A>{
    return this.map(
      function(e:Outcome<A>):Outcome<A>{
        return switch (e){
          case   Success(r)     : Success(r);
          case   Failure(l)     : fn(l);
        }
      }
    );
  }
  public function orUse<A>(val:A):Contract<A>{
    return this.map(
      function(e:Outcome<A>):Outcome<A>{
        return switch (e) {
          case Success(v) : Success(v);
          case Failure(e) : Success(val);
        }
      }
    );
  }
  public function verify<B>(fn:A->Outcome<B>):Contract<B>{
    return this.map(
      function(e:Outcome<A>):Outcome<B>{
        return switch (e){
          case    Failure(l)     : Failure(l);
          case    Success(r)     : fn(r);
        }
      }
    );
  }
  public function success(fn:A->Void):Contract<A>{
    return this.each(
      function(x){
        switch (x) {
          case Success(success) : fn(success);
          default               : 
        }
      }
    );
  }
  public function failure(fn:Fail->Void):Contract<A>{
    return this.each(
      function(x){
        switch (x) {
          case Failure(failure) : fn(failure);
          default               : 
        }
      }
    );
  }
  public function complete(fn:Void->Void):Contract<A>{
    return this.each(
      function(x){
        fn();
      }
    );
  }
  public function val(){
    return this.val();
  }
  @doc("Calls callback, placing a left value in the first parameter or a right in the second.")
  public function callback(fn:Fail->A->Void):Contract<A>{
    return this.each(
      function(x){
        switch (x){
          case      Failure(l)     : fn(l,null);
          case      Success(r)     : fn(null,r);
        }
      }
    );
  }
  @doc("Does a map if the Either is Failure.")
  public function map<B>(fn:A->B):Contract<B>{
    return this.map(
      function(x:Outcome<A>):Outcome<B>{
        return Outcomes.map(x,
          function(y:A):B{
            return fn(y);
          }
        );
      }
    );
  }
  public function transform<B>(fn:Outcome<A>->Outcome<B>):Contract<B>{
    return this.map(fn);
  }
  @doc("Zips the right hand value with function `fn`")
  public function zipWith<B,C>(f1:Contract<B>,fn : A -> B -> C):Contract<C>{
    return this.zipWith(f1,
        function(a,b):Outcome<C>{
          return 
            switch (a) {
              case Failure(v1)       : Failure(v1);
              case Success(v1)       :
                switch (b) {
                  case Failure(v2)   : Failure(v2);
                  case Success(v2)   : Success(fn(v1,v2));
                }
              }
          }
      );
  }
  @doc("Zips the right hand value.")
  public function zip<A,B>(f1:Contract<B>):Contract<Tuple2<A,B>>{
    return zipWith(f1,tuple2);
  }
  @doc("flatMaps the right hand value")
  public function flatMap<B>(fn : A -> Contract<B>):Contract<B>{
    return this.flatMap(
        function(x){
          return switch (x) {
              case Failure(v1)  : new Contract().deliver(Failure(v1));
              case Success(v2)  : fn(v2);
            }
        }
      );
  }
  public function each(f:Outcome<A>->Void):Contract<A>{
    return this.each(f);
  }
  public function asEventual():Eventual<Outcome<A>>{
    return this;
  }
  public var delivered(get,never):Bool;
  private function get_delivered(){
    return this.delivered;
  }
}
class Contracts{
  static public function toContract<A>(e:Eventual<Outcome<A>>):Contract<A>{
    var o : Contract<A> = e.map(
      function(o:Outcome<A>):Outcome<A>{
        var o2 : Outcome<A> = o;
        return o2;
      }
    );
    return o;
  }
  static public function intact<A>(v:A):Contract<A>{
    return Contract.pure(Success(v)); 
  }
  static public function breach<A>(v:Fail):Contract<A>{
    return Contract.pure(Failure(v));
  }
  @doc("
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldLeft( Eventual.pure(Failure([])), Contracts.waitfold )
    This op stops when there is a single failure
  ")
  static public function waitfold<A>(init:Contract<Array<A>>,ft:Contract<A>):Contract<Array<A>>{
    return 
      init.flatMap(
        function(arr:Array<A>){
          return 
            ft.map(
              function(v:A):Array<A>{
                return arr.add(v);
              }
            );
        }
      );
  }
  @doc("
    Returns a single future with an Array of the results, or an Fail.
  ")
  static public function wait<A>(a:Array<Contract<A>>):Contract<Array<A>>{
    return a.foldLeft(
        intact([])
      , waitfold
    );
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Contract<B>):Contract<B>{
    return iter.foldLeft(
      Contract.pure(Success(start)),
      function(memo : Contract<B>, next : A){
        return memo.flatMap(
            function(b: B){
              return fm(b,next);
            }
          );
      }
    );
  }
  static public function unzip<A,B,C>(tp:Tuple2<Contract<A>,Contract<B>>):Contract<Tuple2<A,B>>{
    return 
      tp.fst().flatMap(
        function(b:A){
          return tp.snd().map( tuple2.bind(b) );
        }
      );
  }
  public static function chain<A>(a:Array<Thunk<Contract<A>>>):Contract<Array<A>>{
    return 
      a.foldLeft(
        intact([])
      , function(init,fn){
          return 
            init.flatMap(function(x) return fn().map(function(y) return x.add(y)));
        }
    );
  }
  static public function asContract<T>(evt:Eventual<Outcome<T>>):Contract<T>{
    return evt;
  }
}
class Contracts1{
  @doc("
    Returns a Contract where the only result of a function may be an Fail, returning the result of ´success´
    where no Fail is found.
  ")
  static public function toContract<A>(f:(String->Void)->Void,success:Void->A):Contract<A>{
    var fut = Contract.unit();
    f(
      function(er){
        if(er!=null){
          fut.deliver(Failure(fail(NativeError(er))));
        }else{
          fut.deliver(Success(success()));
        }
      }
    );
    return fut;
  }
  @doc("
    As with ´toContract´ but using a constant rather than a Thunk.
  ")
  static public function toContractC<A>(f:(String->Void)->Void,success:A):Contract<A>{
    return toContract(f,Anys.toThunk(success));
  }
}
class Contracts2{
  @doc("
    Creates a Contract from a callback of function (err,res).
  ")
  static public function toContract<A>(f:(Dynamic->A->Void)->Void):Contract<A>{
    var ft = new Contract();
    f( 
      function(a,b){
        if(a!=null){
          ft.deliver(Failure(fail(NativeError(a))));
        }else{
          ft.deliver(Success(b));
        }
      }
     );
    return ft;
  }
}
class Contracts3{
  static public function toContract<A,B>(f:(String->A->B->Void)->Void):Contract<Tuple2<A,B>>{
    var ft = new Contract();
    f(
      function(a,b,c){
        if(a!=null){
          ft.deliver(Failure(fail(NativeError(a))));
        }else{
          ft.deliver(Success(tuple2(b,c)));
        }
      }
    );
    return ft;
  }
}
class Contracts4{
  static public function toContract<A,B,C>(f:(String->A->B->C->Void)->Void):Contract<Tuple3<A,B,C>>{
    var ft = Contract.unit();
    f(
      function(e,a,b,c){
        if(e!=null){
          ft.deliver(Failure(fail(NativeError(e))));
        }else{
          ft.deliver(Success(tuple3(a,b,c)));
        }
      }
    );
    return ft;
  }
}