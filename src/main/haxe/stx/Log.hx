package stx;

import haxe.PosInfos;

import stx.log.*;

using stx.Options;

import funk.ioc.*;

using pax.Option;

class Log{
	public static function printer<A>(?p:PosInfos):Dynamic->A{
		return function(x:A){
				haxe.Log.trace(x,p);
				return x;
			}
	}
	public static function debug(v:Dynamic) {
    return new LogItem(LogLevel.Debug, v);
  }
  public static function info(v:Dynamic) {
    return new LogItem(LogLevel.Info, v);
  }
  public static function warning(v:Dynamic) {
    return new LogItem(LogLevel.Warning, v);
  }
  public static function error(v:Dynamic) {
    return new LogItem(LogLevel.Error, v);
  }
  public static function fatal(v:Dynamic) {
    return new LogItem(LogLevel.Fatal, v);
  }
  public static function trace(d:Dynamic,p:PosInfos){
  	var tracer = Inject.as(Logger).toStaxOption().map(function(x) {return x.apply;}).getOrElseC(haxe.Log.trace);
  			tracer(d,p);
  }
}