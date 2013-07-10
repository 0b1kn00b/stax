package stx.log;

import haxe.PosInfos;

import stx.Prelude;

import stx.log.Listing;

class ZebraListings{
  private var listings                    : Array<Listing<String>>;
  public function new(?listings){
    this.listings = listings == null ? [] : listings;
  }
  /**
   * If there is no whitelist, make sure there are no matches in the blacklist,
   * If there is a whitelist, make sure it passes at least one, and then chek the blacklist as above.
   * @param v
   * @param ?pos
   * @return
   */
  public function check(v:Dynamic, pos:PosInfos):Bool{
    return switch(Type.typeof(v)){
      case TClass(c) if (Types.hasSuperClass(c,cast LogItem)) : 
        trace(v);
      default                                             : false;
    }
  }
  private function pack(s:String):String { return '.*\\($s.*:.*\\)'; }
  private function func(s:String):String { return '.*\\(.*:$s\\)'; }
  private function file(s:String):String { return '$s.*\\(.*:'; }
}