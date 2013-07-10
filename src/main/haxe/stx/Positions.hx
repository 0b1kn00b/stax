package stx;

import haxe.PosInfos;

class Positions {
  static public function toString(pos:PosInfos){
    if (pos == null) return 'nil';
    var type                = pos.className.split(".");
    return type[type.length-1] + "::" + pos.methodName + "#" + pos.lineNumber;
  }
  static public function here(?pos:PosInfos) {
    return pos;
  }
}