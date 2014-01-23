package stx.async.ifs;

import stx.async.Future;

interface Arrowlet<I,O>{
  public function apply(v:I):Future<O>;
}