package stx.plus;

import stx.Muster;
import Stax.*;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Arrays;
using stx.Types;
using stx.plus.Meta;

class MetaTest extends TestCase{
  public function testMeta(u:UnitArrow):UnitArrow{
    //trace(MorMeta.ancestors().map(Meta.metadata).foldl1(Tables.merge));
    return u.add(
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
    );
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