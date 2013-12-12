package stx.ifs;

import rx.Future;

interface Arrowlet<I,O>{
  public function apply(v:I):Future<O>;
}