package pax;

import funk.Funk.Fails in FunkFail;

 
import stx.Fail.*;

import stx.Fail in StaxFailType;
import stx.err.*;

class FunkFails{
  static public function toStaxFail(e:FunkFail):StaxFailType{
    return fail(FrameworkFail(e));
  }
}