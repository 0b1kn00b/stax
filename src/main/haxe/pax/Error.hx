package pax;

import funk.Funk.Errors in FunkError;

import stx.StaxError;
import stx.Error.*;

import stx.Error in StaxErrorType;
import stx.err.*;

class FunkErrors{
  static public function toStaxError(e:FunkError):StaxErrorType{
    return err(FrameworkError(e));
  }
}