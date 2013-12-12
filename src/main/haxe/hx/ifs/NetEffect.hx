package hx.ifs;

import Prelude;

import rx.Future;
import stx.ifs.Arrowlet;

interface NetEffect{
  public function invoke():Future<Unit>;
}