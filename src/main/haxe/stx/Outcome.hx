package stx;

import Prelude;

abstract Outcome<T>(Prelude.Outcome<T>) from Prelude.Outcome<T> to Prelude.Outcome<T>{
  public function new(v){
    this = v;
  }
  static public function fromFail<T>(f:Fail):Outcome<T>{
    return Failure(f);
  }
  public function flatMap<U>(fn:T->Outcome<U>):Outcome<U>{
    return Outcomes.flatMap(this,fn);
  }
  public function map<U>(fn:T->U):Outcome<U>{
    return Outcomes.map(this,fn);
  }
  @:tinkish
  public function or(fallback:Outcome<T>):Outcome<T>{
    return Outcomes.or(this,fallback);
  }
  public function retry(fn:Fail->Outcome<T>){
    return Outcomes.retry(this,fn);
  }
  public function recover(fn:Fail->T):Outcome<T>{
    return Outcomes.recover(this,fn);
  }
  public function zipWith<U,V>(oc:Outcome<U>,fn:T->U->V):Outcome<V>{
    return Outcomes.zipWith(this,oc,fn);
  }
  public function zip<U>(oc:Outcome<U>):Outcome<Tuple2<T,U>>{
    return Outcomes.zip(this,oc);
  }
  public function success():Option<T>{
    return switch (this) {
      case Success(v) : Some(v);
      default         : None;
    }
  }
}
class Outcomes{
  static public function flatMap<A,B>(o:Prelude.Outcome<A>,fn:A->Prelude.Outcome<B>):Prelude.Outcome<B>{
    return switch (o) {
      case Success(success) : fn(success);
      case Failure(failure) : Failure(failure);
    }
  }
  static public function map<A,B>(o:Prelude.Outcome<A>,fn:A->B):Prelude.Outcome<B>{
    return switch (o) {
      case Success(success) : Success(fn(success));
      case Failure(failure) : Failure(failure);
    }
  }
  @:tinkish
  static public function or<A>(o:Prelude.Outcome<A>,fallback:Prelude.Outcome<A>):Prelude.Outcome<A>{
    return switch (o) {
      case Success(success) : o;
      case Failure(failure) : fallback;
    } 
  }
  static public function retry<A>(o:Prelude.Outcome<A>,fn:Fail->Prelude.Outcome<A>){
    return switch (o) {
      case Success(success) : o;
      case Failure(failure) : fn(failure);
    }
  }
  static public function recover<A>(o:Prelude.Outcome<A>,fn:Fail->A):Prelude.Outcome<A>{
    return switch (o) {
      case Success(success)               : o;
      case Failure(failure)               : Success(fn(failure));
    }
  }
  static public function flatten<A>(o:Prelude.Outcome<Prelude.Outcome<A>>):Prelude.Outcome<A>{
    return switch (o) {
      case Success(Success(success))      : Success(success);
      case Success(Failure(failure))      : Failure(failure);
      case Failure(failure)               : Failure(failure);
    }
  }
  static public function zipWith<A,B,C>(o:Prelude.Outcome<A>,o0:Prelude.Outcome<B>,fn:A->B->C):Prelude.Outcome<C>{
    return switch ([o,o0]) {
      case [Success(v0),Success(v1)]      : Success(fn(v0,v1));
      case [Failure(err),Success(_)]      : Failure(err);
      case [Success(v0),Failure(err)]     : Failure(err);
      case [Failure(err0),Failure(err1)]  : Failure(err0.append(err1));
    }
  }
  static public function zip<A,B>(o:Prelude.Outcome<A>,o0:Prelude.Outcome<B>):Prelude.Outcome<Tuple2<A,B>>{
    return zipWith(o,o0,tuple2);
  }
  static public function isFailure<A>(o:Prelude.Outcome<A>):Bool{
    return switch (o) {
      case Success(_) : false;
      case Failure(_) : true;
    }
  }
  static public function isSuccess<A>(o:Prelude.Outcome<A>):Bool{
    return switch (o) {
      case Success(_) : true;
      case Failure(_) : false; 
    }
  }
  static public function toChunk<A>(oc:Outcome<A>):Chunk<A>{
    return switch (oc){
      case Failure(l)  : End(l);
      case Success(r)  : r == null ? Nil : Val(r);
    }
  }
}