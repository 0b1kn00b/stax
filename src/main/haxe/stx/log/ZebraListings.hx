package stx.log;

import haxe.PosInfos;

import stx.Prelude;
import stx.Tuples;

using stx.Arrays;
using stx.Bools;

import stx.log.Listing;
import stx.log.LogScope;

class ZebraListings{
  private var listings                    : Array<LogListing>;
  public function new(?listings){
    this.listings = listings == null ? [] : listings;
  }
  /**
   * If there is no whitelist, make sure there are no matches in the blacklist,
   * If there is a whitelist, make sure it passes at least one, and then check the blacklist as above.
   * @param ?pos
   * @return Bool
   */
  public function check(pos:PosInfos):Bool{
    if(listings.length == 0) return true;
    return listings.forAny(
      function(x){
        return switch (x) {
          case Include(_)  : true;
          case Exclude(_)  : false;
        }        
      }
    ) ? listings.forAny(white.bind(_,pos)).and(!listings.forAll(black.bind(_,pos)))
      : !listings.forAll(black.bind(_,pos));
  }
  private function white(x:LogListing,pos:PosInfos){
    return switch (x) {
      case Include(tuple2(LLineScope,pos0))    : (pos.className == pos0.className || pos.fileName == pos0.fileName) && pos.lineNumber == pos0.lineNumber;
      case Include(tuple2(LMethodScope,pos0))  : pos.className == pos0.className && pos.methodName == pos0.methodName;
      case Include(tuple2(LClassScope,pos0))   : pos.className == pos0.className;
      case Include(tuple2(LFileScope,pos0))    : pos.fileName  == pos0.fileName;
      case _                                   : false;
    }
  }
  private function black(x:LogListing,pos:PosInfos){
    return switch (x) {
      case Exclude(tuple2(LLineScope,pos0))    : (pos.className == pos0.className || pos.fileName == pos0.fileName) && pos.lineNumber == pos0.lineNumber;
      case Exclude(tuple2(LMethodScope,pos0))  : pos.className == pos0.className && pos.methodName == pos0.methodName;
      case Exclude(tuple2(LClassScope,pos0))   : pos.className == pos0.className;
      case Exclude(tuple2(LFileScope,pos0))    : pos.fileName  == pos0.fileName;
      case _                                   : false;
    }
  }
}