package stx.fnc.mnd;

import Array in NativeArray;

import stx.fnc.Pure;

class Array<T> extends Base<NativeArray<T>,T>{
  public function new(array:NativeArray<T>){
    super(array);
  }
  override public function pure<U>(v:U){
    var o : Monad<U> =  new Array([v]);
    return o;
  }
  override public function flatMap<U>(fn:T->Monad<U>,?self:Array<T>):Monad<U>{
    self = self == null ? this : self;
    var n: NativeArray<U> = [];
    
    for (e1 in self){
      for (e2 in fn(e1)) n.push(e2);
    }
    
    var o : Monad<U> = new Array(n);
    return o;
  }
  override public function iterator():Iterator<T>{
    return box().unbox().iterator();
  }
}