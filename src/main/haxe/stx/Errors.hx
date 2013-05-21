package stx;

import haxe.PosInfos;
import stx.err.*;

using stx.Error;

class Errors{
  static public function err(message:String,?pos:PosInfos){
    return new Error(message,pos);
  }
  static public function null_reference_error(fieldname:String,?pos):Error {
    return new NullReferenceError(fieldname,pos).asError();
  }
  static public function argument_error(msg:String,?pos):Error {
    return new ArgumentError(msg,pos);    
  }
  static public function out_of_bounds_error(?pos):Error{
    return new OutOfBoundsError(pos);
  }
}