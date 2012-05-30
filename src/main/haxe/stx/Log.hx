package stx;
import haxe.PosInfos;
import Prelude;
import Type;
														using Std;
														using Stax;
														using stx.Enums;
														using stx.Tuples;
														using stx.Arrays;
														using stx.Enums;
														using stx.Bools;
														using stx.Options;
														using stx.Functions;
														
														using stx.Log;
/**
 * ...
 * @author 0b1kn00b
 */
																using stx.framework.Injector;
 /**
  * To use the Log 
	* 	haxe.Log.//trace = stx.io.log.Logger.trace;
	* then
	* 	//trace('any normal string');
	* 	//trace('any string'.debug());
	* 	//trace(obj.warning());
  */
enum LogLevel {
	Debug; 
	Info;
	Warning;
	Error;
	Fatal;
}
class LogItem {
	public function new(level, value) {
		this.level = level;
		this.value = value;
	}
	public function toString() {
		return level + '[ ' + value + ' ]';
	}
	public var level : LogLevel;
	public var value : Dynamic;
}
enum LogListing {
	Include(s:String);
	Exclude(s:String);
}
class Logger {
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
	public static function trace(v:Dynamic, ?pos:PosInfos) {
		var log = Log.inject(pos);
		switch (Type.typeof(v)) {
			case TClass(c)	:
					if ( Type.getClassName(c) == Type.getClassName(LogItem) ){
							var e : EnumValue = v.level;
							if (e.indexOf() >= log.level.indexOf() ) {
								if (log.check(v, pos)) {
										log.trace( v.toString(), pos );
								}
							}
					}else {
						log.trace(v,pos);
					}
			default				:
				log.trace(v,pos);
		}
		var log = Log.inject(pos);
	}
	public static function format(p: PosInfos) {
    return p.fileName + ":" + p.lineNumber + " (" + p.className + ":" + p.methodName + "): ";
  }
	public static function whitelist(s:String) {
		return LogListing.Include(s);
	}
	public static function blacklist(s:String) {
		return LogListing.Exclude(s);
	}
	public static function pack(s:String):String { return '.*\\($s.*:.*\\)'.format(); }
	public static function func(s:String):String { return '.*\\(.*:$s\\)'.format(); }
	public static function file(s:String):String { return '$s.*\\(.*:'.format(); }
}
@DefaultImplementation('stx.io.log.DefaultLog')
interface Log {
	public function check(v:Dynamic, ?pos:PosInfos):Bool;
	public function trace(v:Dynamic, ?pos:PosInfos):Void;
	public 	var level				: LogLevel;
}
class DefaultLog {
	public static function create(listings) {
		return new DefaultLog(listings);
	}
	private var listings 										: Array<LogListing>;
	private var permissive									: Bool;
	public 	var level				(default,null) 	: LogLevel;
	
	public function new(?listings:Array<LogListing>, ?level: LogLevel, ?permissive : Bool = true) {
		this.listings 	= listings == null ? [] : listings;
		this.level			= level == null ? Debug : level;
		this.permissive = permissive;
	}
	/**
	 * If there is no whitelist, make sure there are no matches in the blacklist,
	 * If there is a whitelist, make sure it passes at least one, and then chek the blacklist as above.
	 * @param	v
	 * @param	?pos
	 * @return
	 */
	public function check(v:Dynamic, pos:PosInfos):Bool {
		var white = 
				function(includes:Array<LogListing>) {
					trace('white'.debug());
					return 
						includes
								.map( Enums.params )
								.map( Arrays.first )
								.forAny( callback(checker, pos) );
				}
		var black =
				function(excludes:Array<LogListing>) {
					trace('black'.debug());
					return
						!(excludes
								.map( Enums.params )
								.map( Arrays.first )
								.forAll( callback(checker, pos) ));
				}
		trace('________________'.debug());
		trace(listings.debug());
		var o = (listings
						.partition(function(x:EnumValue):Bool { return (x.constructorOf() == 'Include'); })
						.apply( 
								function(includes, excludes){
									return
											(includes.length > 0)
												.ifElse(
													function() { 
														return white(includes) ? 
																(excludes.length > 0)
																		.ifTrue( black.lazy(excludes) )
																		.orElseC( Some(permissive) ).get() : false;
													}
												,
													function() {
														return
																(excludes.length > 0)
																		.ifTrue( black.lazy(excludes) )
																		.orElseC( Some(permissive) ).get();
													}
											);
								}
						));	
		trace( ('output : ' + Logger.format(pos) + ' ' + o).debug() );
		trace('________________'.debug());
		return o;
	}
	private function checker(pos:PosInfos, v:String):Bool {	
		trace(v.debug());
		trace(Logger.format(pos).debug());
		var reg = new EReg(v, '');
		var matches = reg.match( Logger.format(pos) );
		if (matches) {
			trace( ('matched = ' + reg.matched(0)).debug() );
		}
		trace(matches.debug());
		return matches;
				
	}
	
	public function trace( v : Dynamic, ?infos : PosInfos ) : Void {
		#if flash
			#if (fdb || nativetrace)
		var pstr = infos == null ? "(null)" : infos.fileName+":"+infos.lineNumber;
		untyped __global__["trace"](pstr+": "+flash.Boot.__string_rec(v,""));
			#else
		untyped flash.Boot.__trace(v,infos);
			#end
		#elseif neko
		untyped __dollar__print(infos.fileName+":"+infos.lineNumber+": ",v,"\n");
		#elseif js
		untyped js.Boot.__trace(v,infos);
		#elseif php
		untyped __call__('_hx_trace', v,infos);
		#elseif cpp
		untyped __trace(v,infos);
		#elseif cs
		var str = infos.fileName + ":" + infos.lineNumber + ": " + v;
		untyped __cs__("System.Console.WriteLine(str)");
		#elseif java
		var str = infos.fileName + ":" + infos.lineNumber + ": " + v;
		untyped __java__("java.lang.System.out.println(str)");
		#end
	}
}