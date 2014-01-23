package stx.io;

import Stax.*;

import haxe.PosInfos;

import stx.ioc.Inject.*;
import stx.io.log.*;

using stx.Functions;
using stx.Option;


@doc("
  Transform any variable into a LogItem with:
  ```
  import stx.io.Log.*;

  class Test{
    static public function test(){
      var a = 'str';
      var b = error(a);//<--
    }
  }
  ```
")
class Log{
	static public function printer<A>(?p:PosInfos):A->Void{
		return function(x:A){
			haxe.Log.trace(x,p);
		}
	}
	@:noUsing static public function debug(v:Dynamic,?pos) {
    return new LogItem(LogLevel.Debug, v, pos);
  }
  @:noUsing static public function info(v:Dynamic,?pos) {
    return new LogItem(LogLevel.Info, v, pos);
  }
  @:noUsing static public function warning(v:Dynamic,?pos) {
    return new LogItem(LogLevel.Warning, v, pos);
  }
  @:noUsing static public function error(v:Dynamic,?pos) {
    return new LogItem(LogLevel.Error, v, pos);
  }
  @:noUsing static public function fatal(v:Dynamic,?pos) {
    return new LogItem(LogLevel.Fatal, v, pos);
  }
  static public function log(d:Dynamic,?pos:PosInfos):Void{
    inject(Logger).apply(d,pos);
  }
}