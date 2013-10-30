package stx.log;

import stx.Log.*;

import haxe.Resource;
import haxe.PosInfos;

import stx.log.prs.LogListingParser;

using stx.Arrays;
using stx.LogLevel;
using stx.Types;

@doc("
  Default Logger implementation, will try to open log.cnf in the cwd, loads and parses 
  the list with LogListingParser and appends to the listings.
")
class DefaultLogger implements Logger{
  @:noUsing static public function create(?listings:Array<LogListing>,?level) {
    return new DefaultLogger(listings,level);
  }
  @doc("Indicates whether non LogItems are traced.")
  private var zebra                       : ZebraListings;
  private var permissive                  : Bool;
  public  var level       (default,null)  : LogLevel;
  
  public function new(?listings:Array<LogListing>, ?level:LogLevel, ?permissive:Bool=true) {
    listings  = listings == null ? [] : listings;
    #if !macro
      var rsc   = Resource.getString('log');
      if(rsc!=null){
        var ls = LogListingParser.parse(rsc);
        listings = listings.append(ls);
      }
    #end
    this.zebra      = new ZebraListings(listings);
    this.level      = level == null ? #if debug Debug #else Info #end: level;
    this.permissive = permissive;
  }
  public function apply(v:Dynamic, ?pos:PosInfos):Void{
    if(v == null) return;
    switch (v.vtype()) {
      case TClass(c) if (c == LogItem)  :
        var x : LogItem = v;
          if((x.tag.toInt() >= level.toInt()) && zebra.check(pos)){
              LogTrace.trace(v,pos);
          }
      default                           :
        if(permissive){
          LogTrace.trace(v,pos);
        }
    }
  }
}