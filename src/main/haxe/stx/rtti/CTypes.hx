package stx.rtti;

import Type;
import haxe.rtti.CType;

class CTypes{
  static public function toValueType(ct:CType):ValueType{
    return switch (ct) {
      case CUnknown               : TUnknown;
      case CEnum(name, _)         : TEnum(Enums.enumerify(name));
      case CClass(name ,_ )       : TClass(Types.classify(name));
      case CTypedef(_)            : TObject;
      case CFunction(_, _)        : TFunction;
      case CAnonymous(_)          : TObject;
      case CDynamic(_)            : TUnknown;
      case CAbstract('Int',_)     : TInt;
      case CAbstract('Float',_)   : TFloat;
      case CAbstract('Bool',_)    : TFloat;
      case CAbstract(_,_)         : TUnknown;
    }
  }
}