package stx.plus;

import stx.ds.Map;

import stx.Prelude;
import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Tuples;


class HashTest extends TestCase{
  public function testTupleMapCode(u:UnitArrow):UnitArrow {    
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
  public function testMap(u:UnitArrow):UnitArrow {
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
  
  /*public function testReflectiveHasher(u:UnitArrow):UnitArrow{
    var zerocodes : Array<Dynamic> = [null, 0];
    for(z in zerocodes)
      u = u.add(it('should be zero',eq(0), Hasher.getHashFor(z)(z)));

    var nonzerocodes : Array<Dynamic> = [true, false, "", "a", 1, 0.1, [],[1], {}, {n:"a"}, new HasNoMapAndShow(1), new HasHash(1), Date.fromString("2000-01-01"), None, Some("a")];
    for(n in nonzerocodes)
      u = u.add(it('should not be zero',eq(0).not(), Hasher.getHashFor(n)(n)));

    return u;
  }*/
}
@DataClass private class HasNoMapAndShow
{ 
  @DataField({show:false})   
  var v : Int;
  public function new(v : Int) this.v = v;
}
private class HasHash
{
  var v : Int;
  public function new(v : Int) this.v = v;
  public function hashCode() return v;
}