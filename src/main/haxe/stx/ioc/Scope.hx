package stx.ioc;

import stx.Maths;

enum Scope{
  AnyScope;
  ClassScope(path:String);
  PackageScope(path:String);
  GlobalScope;
}
class Scopes{
  static public function toInt(s:Scope){
    return switch (s) {
      case AnyScope           : 0;
      case ClassScope(_)      : 1;
      case PackageScope(_)    : 2;
      case GlobalScope        : 3;
    }
  }
  static public function compareLevel(sc0:Scope,sc1:Scope):Int{
    return Ints.compare(toInt(sc0),toInt(sc1));
  }
}