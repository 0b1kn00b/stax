package stx;

import stx.test.Proof;
import stx.Eventual;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

class UnitTestTest extends Suite{
  public function testUnitTest(u:TestCase):TestCase{
    return u.add(isTrue(true));
  }
  public function testEventualAndFutureProofLiftsAutomatically(u:TestCase):TestCase{
    var p   : Proof                 = isTrue(true);
    var evt : Eventual<Proof>       = Eventual.pure(p); 
    var fut : Future<Proof>         = Future.pure(p);
    u =  u.add(evt).add(fut);
    return u;
  }
}