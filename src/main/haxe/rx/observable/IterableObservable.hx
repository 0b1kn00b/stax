package rx.observable;

import stx.Chunk;

using stx.Iterables;

import rx.ifs.Observable in IObservable;

import rx.disposable.CompositeDisposable;

class IterableObservable<T> implements IObservable<T>{
  private var iterable : Iterable<Chunk<T>>;

  public function new(iterable){
    this.iterable = iterable;
  }
  public function subscribe(o:Observer<T>):Disposable{
    iterable.each(o.apply);
    return Disposable.unit();
  }
}