package stx;

import stx.async.Future;

import stx.test.Proof;
import stx.async.Eventual;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Iterables;
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
  /*public function testLoadsOfTests(u:TestCase):TestCase{
    return u.append(0.to(100).map(function(x) return true).map(isTrue.bind(_,here())).toArray());
  }*/
}