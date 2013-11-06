package stx.log;

import Prelude;

import haxe.PosInfos;

import stx.Positions;
import stx.log.LogScope;

using stx.Tuples;
using stx.Strings;
using stx.Types;
using stx.ValueTypes;

typedef LogListing = Listing<Tuple2<LogScope,PosInfos>>;

class LogListings{
  static public var nil : LogListing = Exclude(tuple2(LFileScope,Positions.nil));
  public function new(){

  }
  public function file(name:String){
    if(!name.contains('.')){
      name = '$name.hx';
    }
    return tuple2(LFileScope,Positions.create(name,null,null,null));
  }
  public function type(type:Class<Dynamic>){
    return tuple2(LClassScope,Positions.create(null,type.name(),null,null));
  }
  @:note("0b1kn00b: typesystem doesn't recognise function on abstract at compile time.")
  //<T:{classname : Void->String}>
  public function abstracted(name:String){
    return tuple2(LClassScope,Positions.create(null,name,null,null));
  }
  public function method(type:Class<Dynamic>,name:String){
    return tuple2(LMethodScope,Positions.create(null,type.name(),name,null));
  }
  public function line(type:Class<Dynamic>,line:Int){
    return tuple2(LLineScope,Positions.create(null,type.vtype().name(),null,line));
  }
  public function include(t:Tuple2<LogScope,PosInfos>):LogListing {
    return Include(t);
  }
  public function exclude(t:Tuple2<LogScope,PosInfos>):LogListing {
    return Exclude(t);
  }
}