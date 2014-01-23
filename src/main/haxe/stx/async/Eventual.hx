package stx.async;

using stx.Functions;
using stx.Arrays;

import stx.async.Dissolvable;

import stx.async.Callback;
import stx.async.impl.Eventual in CEventual;

@:bug("#0b1kn00n: hung compiler for auto-lifting")
abstract Eventual<T>(CEventual<T>) from CEventual<T> to CEventual<T>{
  @:noUsing static public function unit<T>():Eventual<T>{
    return new CEventual();
  }
  @:noUsing static public function pure<T>(v:T):Eventual<T>{
    return new CEventual().deliver(v);
  }
  public function new(?v){
    this = v == null ? new CEventual() : v;
  }
  public function subscribe(cb:Callback<T>):Dissolvable{
    return this.subscribe(cb);
  }
  public var delivered(get,never):Bool;
  private function get_delivered():Bool{
    return this.delivered;
  }
  public function deliver(v:T){
    this.deliver(v);
    return this;
  }
  public function map<U>(fn:T->U):Eventual<U>{
    return this.map(fn);
  }
  public function each(fn:T->Void):Eventual<T>{
    return this.each(fn);
  }
  public function flatMap<U>(fn:T->Eventual<U>):Eventual<U>{
    return this.flatMap(fn);
  }
  public function zipWith<U,V>(evt:Eventual<U>,fn:T->U->V):Eventual<V>{
    return this.zipWith(evt,fn);
  }
  public function val(){
    return this.val();
  }
  @:from static public function fromFunction<T>(fn:(T->Void)->Void):Eventual<T>{
    var ft : CEventual<T>   = new CEventual();
    fn(ft.deliver.enclose());
    return ft;
  }
/*  @:from static public function fromFuture<T>(ft:Future<T>):Eventual<T>{
    var nxt = unit();
    ft.apply(nxt.deliver);
    return nxt;
  }
  @:to public function toFunction():Callback<T>->Dissolvable{
    return this.subscribe;
  }*/
}
class Eventuals{
  static public function bindFold<A,B>(arr:Array<A>,init:B,fold:B->A->Eventual<B>){
    return stx.Arrays.foldLeft(arr,
      Eventual.pure(init),
      function(memo:Eventual<B>,next:A):Eventual<B>{
        return memo.flatMap(
          function(b:B){
            return fold(b,next);
          }
        );
      }
    );
  }
  /*static public function wait<T>(arr:Array<Eventual<T>>):Eventual<Array<T>>{
    return function(fn:Array<T>->Void):Void{
      var stk = [];
      arr.each(
        function(ft0){
          ft0.each(
            function(v:T){
              stk.push(v);
              if(stk.length == arr.length){
                fn(stk);
              }
            }
          );
        }
      );
    }
  }*/
}