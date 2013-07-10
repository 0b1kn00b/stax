package pax;

import funk.types.Attempt;

import pax.Error;

import stx.Promise in StaxPromise;
import funk.futures.Promise in FunkPromise;

class FunkPromises{
  static public function toStaxPromise<T>(x:FunkPromise<T>):StaxPromise<T>{
    var pr = new StaxPromise();
    x.when(
      function(x){
        switch (x) {
          case Success(v) : pr.deliver(Right(v));
          case Failure(e) : pr.deliver(Left(FunkErrors.toStaxError(e)));
        }
      }
    );
    return pr;
  }
}