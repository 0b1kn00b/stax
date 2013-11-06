package stx;

import Prelude;
import Stax.*;
import stx.Compare.*;

import stx.Fail;

import stx.Outcome;
import stx.Anys;
import stx.Fail;
import stx.Contract;

using stx.Iterables;
using stx.Arrays;
using stx.Tuples;
using stx.Eventual;
using stx.Option;
using stx.Compose;

using stx.Chunk;

abstract Vouch<T>(Eventual<Chunk<T>>) from Eventual<Chunk<T>> to Eventual<Chunk<T>>{
  @:noUsing static public function unit<A>():Vouch<A>{
    return new Vouch(Eventual.unit());
  }
  @:noUsing static public function pure<A>(v:Chunk<A>):Vouch<A>{
    return new Vouch(Eventual.pure(v));
  }
  @:noUsing static public function create<A>():Vouch<A>{
    return new Vouch(Eventual.unit());
  }
  @:from static public function fromContract<A>(prm:stx.Contract<A>):Vouch<A>{
    return prm.asEventual().map(Outcomes.toChunk);
  }
  public function new(?v){
    this = nl().apply(v) ? Eventual.unit() : v;
  }
  public function map<U>(fn:T->U):Vouch<U>{
    return this.map(
      function(x){
        return switch (x){
          case Nil      : Nil;
          case Val(v)   : Val(fn(v));
          case End(err) : End(err);
    }});
  }
  public function flatMap<U>(fn:T->Vouch<U>):Vouch<U>{
    return this.flatMap(
      function(x:Chunk<T>):Vouch<U>{
        return switch (x){
          case Nil      : Vouch.pure(Nil);
          case Val(v)   : fn(v);
          case End(err) : Vouch.pure(End(err));
    }});
  }
  public function each(fn:T->Void):Vouch<T>{
    return this.each(
      function(x){
        switch (x){
          case Nil      :
          case Val(v)   : fn(v);
          case End(_) :
    }});
  }
  public function recover(fn:Fail->Chunk<T>):Vouch<T>{
    return this.map(
      function(x:Chunk<T>):Chunk<T>{
        return switch (x){
          case Nil      : Nil;
          case Val(v)   : Val(v);
          case End(err) : err != null ? fn(err) : End(null);
    }});
  }
  public function verify<U>(fn:T->Chunk<U>):Vouch<U>{
    return this.map(
      function(x){
        return switch (x){
          case Nil      : Nil;
          case Val(v)   : fn(v);
          case End(err) : End(err);
    }});
  }
  public function value():Chunk<T>{
    return this.value;
  }
  public function success(f:T->Void):Vouch<T>{
    return this.each(
      function(x){
        return switch (x){
          case Nil      :
          case Val(v)   : f(v);
          case End(_)   :
    }});
  }
  public function failure(f:Null<Fail>->Void):Vouch<T>{
    return this.each(
      function(x){
        switch (x){
          case Nil      :
          case Val(_)   :
          case End(err) : f(err);
    }});
  }
  public function nothing(f:Void->Void):Vouch<T>{
    return this.each(
      function(x){
        switch (x) {
          case Nil : f();
          default  : 
        }
      }
    );
  }
  public function complete(f:Chunk<T>->Void){
    return this.each(f);
  }
  public function orConst<T>(v:T):Vouch<T>{
    return this.map(
      function(x){
        return switch (x) {
          case Nil    : Val(v);
          case End(e) : End(e);
          case Val(v) : Val(v);
        }
      }
    );
  }
  public function val(val:T):Vouch<T>{
    return this.deliver(Val(val));
  }
  public function end(?err:Fail):Vouch<T>{
    return this.deliver(End(err));
  }
  public function nil():Vouch<T>{
    return this.deliver(Nil);
  }
  public function deliver(v:Chunk<T>){
    return this.deliver(v);
  }
  public function isDelivered(): Bool {
    return this.isDelivered();
  }
  public function asEventual():Eventual<Chunk<T>>{
    return this;
  }
}
class Vouches{
  static public function zip<A,B>(vch0:Vouch<A>,vch1:Vouch<B>):Vouch<Tuple2<A,B>>{
    return vch0.asEventual().zip(vch1.asEventual()).map(Chunks.zip.tupled());
  }
  static public function zipWith<A,B,C>(vch0:Vouch<A>,vch1:Vouch<B>,fn:A->B->C):Vouch<C>{
    return vch0.asEventual().zip(vch1.asEventual()).map(Chunks.zipWith.bind(_,_,fn).tupled());
  }
  static public function intact<A>(v:A):Vouch<A>{
    return Vouch.pure(Val(v)); 
  }
  static public function breach<A>(v:Fail):Vouch<A>{
    return Vouch.pure(End(v));
  }
  static public function empty<A>():Vouch<A>{
    return Vouch.pure(Nil);
  }
  static public function map<U,T>(vch:Vouch<T>,fn:T->U):Vouch<U>{
    return vch.map(fn);
  }
  static public function bindFold<A,B>(it:Array<A>,start:B,fm:B->A->Vouch<B>):Vouch<B>{
    return stx.Eventuals.bindFold(
      it,
      Val(start),
      function(memo:Chunk<B>,next:A){
        return switch (memo){
          case Nil      : Vouches.empty();
          case Val(v)   : fm(v,next);
          case End(err) : Vouches.breach(err);
        }
      }
    );
  }
  static public function waitfold<A>(init:Vouch<Array<A>>,ft:Vouch<A>):Vouch<Array<A>>{
    return init.flatMap(
        function(arr:Array<A>){
          return ft.map(
              function(v:A):Array<A>{
                return arr.add(v);
              }
            );
        }
      );
  }
  static public function wait<A>(it:Array<Vouch<A>>):Vouch<Array<A>>{
    return it.foldLeft(intact([]), waitfold);
  }
  static public function fold<A,Z>(vch:Vouch<A>,val:A->Z,ers:Null<Fail>->Z,nil:Void->Z):Eventual<Z>{
    return vch.asEventual().map(Chunks.fold.bind(_,val,ers,nil));
  }
  static public function toContract<A>(vch:Vouch<A>):stx.Contract<A>{
    var p : stx.Contract<A> = Contracts.toContract(fold(vch,
        Success,
        function(o){return Failure(o == null ? fail(NullReferenceError('Contract breached without specific error')) : o); },
        function() return Failure(fail(NullReferenceError('Empty Contract.')))
    ));
    return p;
  }
}
class Vouches1{
  static public function vouchOf<A>(f:(String->Void)->Void,success:Void->A):Vouch<A>{
    var fut = new Eventual();
    f(
      function(er){
        if(er!=null){
          fut.deliver(End(fail(NativeError(er))));
        }else{
          fut.deliver(Chunks.create(success()));
        }
      }
    );
    return fut;
  }
  /**
    As with ´vouchOf´ but using a constant rather than a Thunk.
  */
  static public function vouchOfC<A>(f:(String->Void)->Void,success:A):Vouch<A>{
    return vouchOf(f,Anys.toThunk(success));
  }
  static public function asVouch<A>(ft:Eventual<Chunk<A>>):Vouch<A>{
    return new Vouch(ft);
  }
  static public function toVouch<A>(p:stx.Contract<A>):Vouch<A>{
    return Vouch.fromContract(p);
  }
}
class Vouches2{
  /**
    Creates a Vouch from a callback of function (err,res).
  */  
  static public function vouchOf<A>(f:(String->A->Void)->Void):Vouch<A>{
    var ft = new Vouch();
    f( 
      function(a,b){
        if(a!=null){
          ft.deliver(End(fail(NativeError(a))));
        }else{
          ft.deliver(Chunks.create(b));
        }
      }
     );
    return ft;
  }
}
class Vouches3{
  static public function vouchOf<A,B>(f:(String->A->B->Void)->Void):Vouch<Tuple2<A,B>>{
    var ft = new Vouch();
    f(
      function(a,b,c){
        if(a!=null){
          ft.deliver(End(fail(NativeError(a))));
        }else{
          ft.deliver(Chunks.create(tuple2(b,c)));
        }
      }
    );
    return ft;
  }
}
class Vouches4{
  static public function vouchOf<A,B,C>(f:(String->A->B->C->Void)->Void):Vouch<Tuple3<A,B,C>>{
    var ft = new Eventual();
    f(
      function(e,a,b,c){
        if(e!=null){
          ft.deliver(End(fail(NativeError(e))));
        }else{
          ft.deliver(Chunks.create(tuple3(a,b,c)));
        }
      }
    );
    return ft;
  }
}