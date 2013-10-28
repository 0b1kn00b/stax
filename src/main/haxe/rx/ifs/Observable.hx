package rx.ifs;

@doc("
  Typically, if you enter a rx.ifs.Observer it is transformed automatically to it's abstract counterpart:
  rx.Observer. Likewise rx.ifs.Disposable.
")
interface Observable<T>{
  public function subscribe(obs:rx.Observer<T>):rx.Disposable;
}