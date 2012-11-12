package stx.net {
	import stx.Option;
	import stx.Options;
	import stx.ds.Map;
	import stx.Entuple;
	import stx.Strings;
	public class HttpHeaderExtensions {
		static protected var HeaderPattern : EReg = new EReg("^([^:]+): *(.+)$","");
		static protected var HeaderLinesPattern : EReg = new EReg("[\r\n]+","");
		static public function toHttpHeader(str : String) : stx.Option {
			return ((stx.net.HttpHeaderExtensions.HeaderPattern.match(str))?stx.Option.Some(stx.Entuple.entuple(stx.Strings.trim(stx.net.HttpHeaderExtensions.HeaderPattern.matched(1)),stx.Strings.trim(stx.net.HttpHeaderExtensions.HeaderPattern.matched(2)))):stx.Option.None);
		}
		
		static public function toHttpHeaders(str : String) : stx.ds.Map {
			return stx.ds.Map.create().addAll(Prelude.SArrays.flatMap(stx.net.HttpHeaderExtensions.HeaderLinesPattern.split(str),function(line : String) : Array {
				return stx.Options.toArray(stx.net.HttpHeaderExtensions.toHttpHeader(stx.Strings.trim(line)));
			}));
		}
		
	}
}
