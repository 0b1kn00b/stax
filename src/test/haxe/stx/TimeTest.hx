package stx;

using stx.UnitTest;

import stx.Compare.*;
import stx.Log.*;

import stx.Time;
import stx.time.DateSpan;
using stx.Dates;

class TimeTest extends TestCase{
  public function testTime(u:UnitArrow):UnitArrow{
    var a = Time.now();
    trace(a.sub(Time.hour(1)).toDate());
    var b = a.toDate().day(Monday).snap(Day).sub(Time.hour());
    trace(b);
    return u;
  }
}

