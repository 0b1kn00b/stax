package stx;

import Stax.*;

import stx.time.DateSpan;

using stx.time.Week;
using stx.Option;

@:thx
class Dates {
  @doc("Compare dates")
  static public function compare(v1: Date, v2: Date) {  
    var diff = v1.getTime() - v2.getTime();
      
    return if (diff < 0) -1; else if (diff > 0) 1; else 0;
  }
  @doc("Equality function for Dates")
  static public function equals(v1: Date, v2: Date) {
    return v1.getTime() == v2.getTime();
  }
  @doc("Stringify Date")
  static public function toString(v: Date): String {
    return v.toString();
  }
  static public function copier(d0:Date,?year, ?month, ?day, ?hour, ?min, ?sec):Date{
    return new Date(
      option(year).valOrUse(d0.getFullYear),
      option(month).valOrUse(d0.getMonth),
      option(day).valOrUse(d0.getDay),
      option(hour).valOrUse(d0.getHours),
      option(min).valOrUse(d0.getMinutes),
      option(sec).valOrUse(d0.getSeconds)
    );
  }
  static public function add(d0:Date,d1:Date):Date{
    return Date.fromTime(d0.getTime()+d1.getTime());
  }
  static public function sub(d0:Date,d1:Date):Date{
    return Date.fromTime(d0.getTime()-d1.getTime());
  }
  @doc("snaps `dt` to the nearest `day`")
  static public function day(dt:Date,day:Week):Date{

    return Date.fromTime(dt.getTime() - ((dt.getDay() - day.toInt()) % 7) * 24 * 60 * 60 * 1000);
  }
  @doc("snaps `dt` to a period `s`.")
  static public function snap(dt:Date,s:DateSpan):Date{
    var time = dt.getTime();
    return switch (s) {
      case Second : Date.fromTime(Math.floor(time / 1000.0) * 1000.0);
      case Minute : Date.fromTime(Math.floor(time / 60000.0) * 60000.0);
      case Hour   : Date.fromTime(Math.floor(time / 3600000.0) * 3600000.0);
      case Day    : new Date(dt.getFullYear(), dt.getMonth(), dt.getDate(), 0, 0, 0);
      case Week   : Date.fromTime(Math.floor(time / (7.0 * 24.0 * 3600000.0)) * (7.0 * 24.0 * 3600000.0));
      case Month  : new Date(dt.getFullYear(), dt.getMonth(), 1, 0, 0, 0);
      case Year   : new Date(dt.getFullYear(), 0, 1, 0, 0, 0);
    }
  }
}