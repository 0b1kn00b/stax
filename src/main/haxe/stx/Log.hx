package stx;

import Stax.*;

import haxe.PosInfos;

import stx.ioc.Inject.*;
import stx.log.*;

using stx.Functions;
using stx.Options;

import funk.ioc.*;

class Log{
	static public function printer<A>(?p:PosInfos):A->A{
		return function(x:A){
			haxe.Log.trace(x,p);
			return x;
		}
	}
	@:noUsing static public function debug(v:Dynamic) {
    return new LogItem(LogLevel.Debug, v);
  }
  @:noUsing static public function info(v:Dynamic) {
    return new LogItem(LogLevel.Info, v);
  }
  @:noUsing static public function warning(v:Dynamic) {
    return new LogItem(LogLevel.Warning, v);
  }
  @:noUsing static public function error(v:Dynamic) {
    return new LogItem(LogLevel.Error, v);
  }
  @:noUsing static public function fatal(v:Dynamic) {
    return new LogItem(LogLevel.Fatal, v);
  }
}