package stx.log;

import Type;
import haxe.PosInfos;

enum Listing<T> {
  Include(s:T);
  Exclude(s:T);
}
class Listings{
  static public function whitelist(s:String) {
    return Include(s);
  }
  static public function blacklist(s:String) {
    return Exclude(s);
  }
  static public function format(p: PosInfos) {
    return p.fileName + ":" + p.lineNumber + " (" + p.className + ":" + p.methodName + "): ";
  }
  /*static public function create(cls:Class<Dynamic>,?method:String){
    
  }*/
}