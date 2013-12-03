package rx.ifs;

import stx.Chunk;

@doc("
  Typically, if you enter a rx.ifs.Observer it is transformed automatically to it's abstract counterpart:
  rx.Observer. Likewise rx.ifs.Disposable.
")
interface Observable<T> extends Waiting<Observer<T>>{

}