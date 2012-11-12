package stx {
	import stx.LogItem;
	import stx.LogListing;
	import stx.Enums;
	import stx.framework.Injector;
	import stx.Logger;
	import stx.LogLevel;
	public class Log {
		static public function debug(v : *) : stx.LogItem {
			return new stx.LogItem(stx.LogLevel.Debug,v);
		}
		
		static public function info(v : *) : stx.LogItem {
			return new stx.LogItem(stx.LogLevel.Info,v);
		}
		
		static public function warning(v : *) : stx.LogItem {
			return new stx.LogItem(stx.LogLevel.Warning,v);
		}
		
		static public function error(v : *) : stx.LogItem {
			return new stx.LogItem(stx.LogLevel.Error,v);
		}
		
		static public function fatal(v : *) : stx.LogItem {
			return new stx.LogItem(stx.LogLevel.Fatal,v);
		}
		
		static public function _trace(v : *,pos : * = null) : void {
			var log : stx.Logger = stx.framework.Injector.inject(stx.Logger,pos);
			{
				var $e : enum = (Type._typeof(v));
				switch( $e.index ) {
				case 6:
				var c : Class = $e.params[0];
				if(Type.getClassName(c) == Type.getClassName(stx.LogItem)) {
					var e : enum = v.level;
					if(stx.Enums.indexOf(e) >= stx.Enums.indexOf(log.level)) {
						if(log.check(v,pos)) log._trace(v.toString(),pos);
					}
				}
				else log._trace(v,pos);
				break;
				default:
				log._trace(v,pos);
				break;
				}
			}
			var log1 : stx.Logger = stx.framework.Injector.inject(stx.Logger,pos);
		}
		
		static public function format(p : *) : String {
			return p.fileName + ":" + p.lineNumber + " (" + p.className + ":" + p.methodName + "): ";
		}
		
		static public function whitelist(s : String) : stx.LogListing {
			return stx.LogListing.Include(s);
		}
		
		static public function blacklist(s : String) : stx.LogListing {
			return stx.LogListing.Exclude(s);
		}
		
		static public function pack(s : String) : String {
			return ".*\\(" + s + ".*:.*\\)";
		}
		
		static public function func(s : String) : String {
			return ".*\\(.*:" + s + "\\)";
		}
		
		static public function file(s : String) : String {
			return "" + s + ".*\\(.*:";
		}
		
	}
}
