package hx.ifs;

import Prelude;

import stx.async.Future;
import stx.async.ifs.Arrowlet;

interface NetEffect{
  public function invoke():Future<Unit>;
}