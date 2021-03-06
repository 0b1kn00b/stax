package stx.io;

using stx.UnitTest;

import Stax.*;
import stx.io.Log.*;
import stx.ioc.Inject.*;

import stx.io.log.*;
import stx.io.log.Listing;

import stx.io.Log.*;
import stx.io.log.*;
import stx.io.log.LogListing;
import stx.io.log.LogListing.LogListings.*;

using stx.Types;

class LogTest extends Suite{
  public function testLog(u:TestCase):TestCase{
    var ll = new LogListings();
    var b = new ZebraListings([ll.include(ll.type(definition(this)))]);
    u = u.add(isTrue(b.check(here())));
    u = u.add(isFalse(b.check(Other.there0())));
    var c = new ZebraListings([ll.exclude(ll.type(definition(this))),ll.include(ll.type(Other)),ll.exclude(ll.line(YetOther,41))]);
    u = u.add(isFalse(c.check(here())));
    u = u.add(isTrue(c.check(Other.there0())));       //whitelisted
    u = u.add(isFalse(c.check(YetOther.there1())));   //not in shitelist
    u = u.add(isFalse(c.check(YetOther.there2())));   //Line exclude within whitelist
    var d = new ZebraListings();
        u = u.add(isTrue(d.check(Other.there0())));   //no white nor black list
    var e = new Test();
    var f = e.there3();
    //trace(f);//hmmm, does have a classname, but is generally unreachable 
    //trace(e.vtype());//reports as String
    //trace(Reflect.fields(e));//no fields, predictably
    //ll.abstracted(e); no typed workaround
    return u;
  }
  public function testResource(u:TestCase):TestCase{
    Further.something();
    return u;
  }
  public function testInjection(u:TestCase):TestCase{
    return u;
  }
}
private class Other{
  static public function there0(){
    return here();
  }
}
private class YetOther{
  static public function there1(){
    return here();
  }
  static public function there2(){
    return here();
  }
}
private abstract Test(String) from String to String{
  public function new(?v){
    this = v == null ? '' : v;
  }
  public function there3(){
    return here();
  }
  public function classname(){
    return here().className;
  }
}
private class Further{
  public static function something(){
    var a = new DefaultLogger();
        a.apply(error('hello'));
  }
}