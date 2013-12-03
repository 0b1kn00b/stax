package rx;

import rx.callback.AnonymousCallback;

import rx.ifs.Callback in ICallback;

abstract Callback<T>(ICallback<T>) from ICallback<T> to ICallback<T>{
  public function new(v){
    this = v;
  }
  @:from public static function fromFunction<T>(c:T->Void){
    return new AnonymousCallback(c);
  }
  public function apply(v:T){
    this.apply(v);
  }
}
class Callbacks{
  static public function apply<T>(c:Callback<T>,v:T):Void{
    c.apply(v);
  }
}