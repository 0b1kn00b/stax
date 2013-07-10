package stx.ds;

using stx.Prelude;
using stx.Iterables;

abstract Enumerable<T>(Iterable<T>) from Iterable<T> to Iterable<T>{
  public function new(v){
    this = v;
  }
  public function map<U>(fn:T->U):Enumerable<U>{
    return this.map(fn);
  }
  public function flatMap<U>(fn:T->Enumerable<U>):Enumerable<U>{
    return this.flatMap(fn);
  }
  public function foldl<Z>(memo:Z,fn:Z->T->Z):Z{
    return this.foldl(memo,fn);
  }
  public function foldr<Z>(memo:Z,fn:T->Z->Z):Z{
    return this.foldr(memo,fn);
  }
  public function toArray(){
    return this.toArray();
  }
  public function size(){
    return this.size();
  }
}