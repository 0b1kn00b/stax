package stx.rx.observable;

using stx.Iterables;

import stx.rx.ifs.Observable in IObservable;

import stx.rx.disposable.CompositeDisposable;

class IterableObservable<T> implements IObservable<T>{
  private var iterable : Iterable<Chunk<T>>;

  public function new(iterable){
    this.iterable = iterable;
  }
  public function subscribe(o:Observer<T>):Disposable{
    iterable.foreach(o.apply);
    return Disposable.unit();
  }
}