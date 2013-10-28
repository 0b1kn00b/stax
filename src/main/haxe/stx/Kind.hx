package stx;

import Type;
import haxe.Constraints;

import Stax.*;
import stx.Objects;

using Stax;
using stx.Types;
using stx.Compose;
using stx.Option;

enum Kind{
  KNull;
  KInt(i:Int);
  KFloat(f:Float);
  KBool(b:Bool);
  KObject(o:Object);
  KFunction(f:Function);
  KClass(v:Dynamic,cls:Class<Dynamic>);
  KEnum(e:Enum<Dynamic>);
  KUnknown(v:Dynamic);
}
class Kinds{
  static public function kind(v:Dynamic):Kind{
    return switch (vtype(v)) {
      case TNull     : KNull;
      case TInt      : KInt(v);
      case TFloat    : KFloat(v);
      case TBool     : KBool(v);
      case TObject   : KObject(v);
      case TFunction : KFunction(v);
      case TClass(c) : KClass(v,c);
      case TEnum(_)  : KEnum(v);
      case TUnknown  : KUnknown(v);
    }
  }
}