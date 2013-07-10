package stx;

import haxe.PosInfos;
import stx.err.*;

using stx.Error;

enum StaxError{
  AbstractMethodError(?pos:PosInfos);
  ArgumentError(field:String,?pos:PosInfos);
  AssertionError(?should:String,butis:String);
  ErrorStack(arr:Array<Error>);
  TypeError(msg:String,?pos:PosInfos);
  NullReferenceError(field:String,?pos:PosInfos);
  OutOfBoundsError(?pos:PosInfos);
  NativeError(msg:String);
  FrameworkError(flag:EnumValue,?pos:PosInfos);
}