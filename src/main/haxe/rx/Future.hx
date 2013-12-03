package rx;

import rx.deferred.Future in CFuture;

abstract Future<T>(CFuture<T>) from CFuture<T> to CFuture<T>{
  public function new(?v){
    this = v == null ? new CFuture() : v;
  }
  public function subscribe(cb:Callback<T>):Disposable{
    return this.subscribe(cb);
  }
  public function deliver(v:T){
    this.deliver(v);
  }
  public function map<U>(fn:T->U):Future<U>{
    return this.map(fn);
  }
  public function each(fn:T->Void):Future<T>{
    return this.each(fn);
  }
  public function flatMap<U>(fn:T->Future<U>):Future<U>{
    return this.flatMap(fn);
  }
  @:from static public function fromFunction<T>(fn:(T->Void)->Void):Future<T>{
    var ft      = new CFuture();
    var handler = function(x){
      ft.deliver(x);
    }
    ft = ft.each(handler);
    fn(handler);
    return ft;
  }
}