package stx;

using stx.UnitTest;

import stx.Compare.*;
import stx.Log.*;

import stx.Period;
import stx.time.DateSpan;

//using stx.Dates;

class TimeTest extends Suite{
  public function testTime(u:TestCase):TestCase{
    /*var a = Time.now();
    trace(a.sub(Time.hour(1)).toDate());
    var b = a.toDate().day(Monday).snap(Day).sub(Time.hour());
    trace(b);*/
    return u;
  }
}