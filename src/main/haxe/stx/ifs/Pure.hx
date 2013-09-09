package stx.ifs;

import stx.mcr.Self;

interface Pure<I> extends SelfSupport{
  public function pure<I>(v:I):Self;
}