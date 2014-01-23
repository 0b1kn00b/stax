package stx;

import stx.UnitTest;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Arrays;
using stx.Types;
using stx.Meta;

class MetaTest extends Suite{
  public function testMeta(u:TestCase):TestCase{
    //trace(MorMeta.ancestors().map(Meta.metadata).foldl1(Tables.merge));
    return u;/*.add(
      it('should contain static and field metadata for current class',
        cast eq({
          a : 
          {
            hello : null
          },
          ook : 
          {
            world   : null
          }
        }), Meta.metadata(HasMeta)
      )
    );*/
  }
}

private class HasMeta{
  public function new(){

  }
  @hello
  public var a : Int;

  @world
  static public var ook : String;
}
private class MorMeta extends HasMeta{
  @again
  public var boob : Bool;
}