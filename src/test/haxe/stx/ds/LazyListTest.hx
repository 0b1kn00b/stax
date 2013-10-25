package stx.ds;

import stx.Muster;
import Stax.*;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

using stx.Iterables;

import stx.ds.LispList;
using stx.ds.LispList;


class LazyListTest extends TestCase{
  public function testLispList(u:UnitArrow):UnitArrow{
    var itr                         = 0.until(3);
    var l  : LispList<Int>          = itr;//constructor
    var l2 : LispList<Int>          = 3.until(5);
    var l3                          = l.append(l2);
    var l4                          = l3.cons(-1);
    var l5                          = Nil.add(9).add(10);
    var l6                          = l4.flatMap(
      function(x){
        var o = Nil.add(x).add(x+10);
        return o;
      }
    );
    var t : LispList<Int>           = Cons(-1,Cons(9,Cons(0,Cons(10,Cons(1,Cons(11,Cons(2,Cons(12,Cons(3,Cons(13,Cons(4,Cons(14,Nil))))))))))));
    return u.add(
      it('should be equal',eq(t),l6)
    );
  }
  public function testEquality(u:UnitArrow):UnitArrow{
    var l  : LispList<Int>        = Cons(1,Nil);
    var r                         = 1;
    var o                         = l.equals(r);
    var r0                        = Cons(1,Nil);
    var o2                        = l.equals(r0);
    return u
      .add(it('should be true',ok(),o))
      .add(it('should be true',ok(),o2));
  }
}

