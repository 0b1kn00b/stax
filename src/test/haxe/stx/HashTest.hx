package stx;

import stx.ds.Map;

import Prelude;
using stx.UnitTest;
import stx.Compare.*;
import stx.io.Log.*;

using stx.Tuples;


class HashTest extends Suite{
  public function testTupleMapCode(u:TestCase):TestCase {    
    //var p /*: Product */= tuple5("a",0,0.1,"a",1);
    var tests : Array<Int> = [
      Hasher.getHashFor(tuple2("b",0))(tuple2("b",0)),
      Hasher.getHashFor(tuple2("a",1))(tuple2("a",1)),
      Hasher.getHashFor(tuple3("a",0,1.1))(tuple3("a",0,1.1)),
      Hasher.getHashFor(tuple4("a",0,0.1,"b"))(tuple4("a",0,0.1,"b")),
      Hasher.getHashFor(tuple5("a",0,0.1,"a",1))(tuple5("a",0,0.1,"a",1)),
    ];
    while(tests.length > 0){
      var value = tests.pop();
      var tst   = tests.remove(value);
      u = u.add(
        it(
          "should be a unique hash",
          no(),
          tst
        )
      ).add(
        it(
          "should not be 0",
          eq(0).not(),
          value
        )
      );
    }
    return u;
  }
  public function assertMapCodeForIsZero<T>(v : T):Bool{
    return eq(0).apply(Hasher.getHashFor(v)(v));
  }
  public function assertMapCodeForIsNotZero<T>(v : T) {
    return eq(0).not().apply(Hasher.getHashFor(v)(v));
  }
  public function testMap(u:TestCase):TestCase {
    var msg = function(x) return 'it should not produce 0 for $x';

    return u.append([
      it('should produce 0 for null'           , assertMapCodeForIsZero),
      it('should produce 0 for 0'              , assertMapCodeForIsZero),  
      it(msg('true')                           , assertMapCodeForIsNotZero,true),
      it(msg('false')                          , assertMapCodeForIsNotZero,false),
      it(msg('""')                             , assertMapCodeForIsNotZero,""),
      it(msg('"a"')                            , assertMapCodeForIsNotZero,"a"),
      it(msg('1')                              , assertMapCodeForIsNotZero,1),
      it(msg('0.1')                            , assertMapCodeForIsNotZero,0.1),
      it(msg('[]')                             , assertMapCodeForIsNotZero,[]),
      it(msg('[1]')                            , assertMapCodeForIsNotZero,[1]),
      it(msg('{}')                             , assertMapCodeForIsNotZero,{}),
      it(msg('{n:"a"}')                        , assertMapCodeForIsNotZero,{n:"a"}),
      it(msg('Map.create()')                   , assertMapCodeForIsNotZero,Map.create()),
      it(msg('Data.fromString("2000-01-01")')  , assertMapCodeForIsNotZero,Date.fromString("2000-01-01")),
      it(msg('None')                           , assertMapCodeForIsNotZero,None),
      it(msg('Some("a")')                      , assertMapCodeForIsNotZero,Some("a")),
    ]);
  }
}