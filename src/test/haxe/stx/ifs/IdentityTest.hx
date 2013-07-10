package stx.ifs;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

using stx.ifs.Pure;
using stx.ifs.Identity;

class IdentityTest extends TestCase{
  
  public function testIdentity(u:UnitArrow):UnitArrow{
    //trace(Array.unit());
    trace(Eventual.pure(1));
    trace(Eventual.unit());
    //var a : Identity<Array<Dynamic>> = Array;
    return u;
  }
}
