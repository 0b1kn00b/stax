package stx.rx.ifs;

@doc("
  Typically, if you enter a stx.rx.ifs.Observer it is transformed automatically to it's abstract counterpart:
  stx.rx.Observer. Likewise stx.rx.ifs.Disposable.
")
interface Observable<T>{
  public function subscribe(obs:stx.rx.Observer<T>):stx.rx.Disposable;
}