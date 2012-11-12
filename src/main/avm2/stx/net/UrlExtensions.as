package stx.net {
	import stx.ds.Map;
	import stx.Option;
	import stx.Tuple2;
	import stx.Options;
	import stx.Strings;
	import stx.Entuple;
	public class UrlExtensions {
		static protected var UrlPattern : EReg = new EReg("^(?:([a-zA-Z]+:)(?:[/][/]))?([^:?/#\\s]*)(?:[:](\\d+))?(/[^\\s?#]*)?([?][^\\s#]*)?(#.*)?$","i");
		static protected var Protocol : int = 1;
		static protected var Hostname : int = 2;
		static protected var Port : int = 3;
		static protected var Pathname : int = 4;
		static protected var Search : int = 5;
		static protected var Hash : int = 6;
		static public function toParsedUrl(s : String) : stx.Option {
			var nonNull : Function = function(s1 : String) : String {
				return ((s1 == null)?"":s1);
			}
			return ((stx.net.UrlExtensions.UrlPattern.match(s))?stx.Option.Some(stx.net.UrlExtensions.formUrl(nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Protocol)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Hostname)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Port)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Pathname)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Search)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Hash)))):stx.Option.None);
		}
		
		static public function toUrl(parsed : *) : String {
			return parsed.href;
		}
		
		static public function withProtocol(parsed : *,protocol : String) : * {
			return stx.net.UrlExtensions.formUrl(protocol,parsed.hostname,parsed.port,parsed.pathname,parsed.search,parsed.hash);
		}
		
		static public function withHostname(parsed : *,hostname : String) : * {
			return stx.net.UrlExtensions.formUrl(parsed.protocol,hostname,parsed.port,parsed.pathname,parsed.search,parsed.hash);
		}
		
		static public function withPort(parsed : *,port : String) : * {
			return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,port,parsed.pathname,parsed.search,parsed.hash);
		}
		
		static public function withPathname(parsed : *,pathname : String) : * {
			return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,pathname,parsed.search,parsed.hash);
		}
		
		static public function withSearch(parsed : *,search : String) : * {
			return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,parsed.pathname,search,parsed.hash);
		}
		
		static public function withSubdomains(parsed : *,subdomains : String) : * {
			var Pattern : EReg = new EReg("([^.]+\\.[^.]+)$","");
			var replaceSubdomains : Function = function(oldHostname : String,subdomains1 : String) : String {
				return ((Pattern.match(oldHostname))?function() : String {
					var $r : String;
					var prefix : String = subdomains1 + (((stx.Strings.endsWith(subdomains1,".") || subdomains1.length == 0)?"":"."));
					$r = prefix + Pattern.matched(1);
					return $r;
				}():oldHostname);
			}
			return stx.net.UrlExtensions.formUrl(parsed.protocol,replaceSubdomains(parsed.hostname,subdomains),parsed.port,parsed.pathname,parsed.search,parsed.hash);
		}
		
		static public function withHash(parsed : *,hash : String) : * {
			return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,parsed.pathname,parsed.search,hash);
		}
		
		static public function withFile(parsed : *,file : String) : * {
			var filePattern : EReg = new EReg("[/]([^/]*)$","i");
			var newPathname : String = filePattern.replace(parsed.pathname,"/" + file);
			return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,newPathname,parsed.search,parsed.hash);
		}
		
		static public function withoutProtocol(parsed : *) : * {
			return stx.net.UrlExtensions.withProtocol(parsed,"");
		}
		
		static public function withoutHostname(parsed : *) : * {
			return stx.net.UrlExtensions.withHostname(parsed,"");
		}
		
		static public function withoutPort(parsed : *) : * {
			return stx.net.UrlExtensions.withPort(parsed,"");
		}
		
		static public function withoutPathname(parsed : *) : * {
			return stx.net.UrlExtensions.withPathname(parsed,"");
		}
		
		static public function withoutSearch(parsed : *) : * {
			return stx.net.UrlExtensions.withSearch(parsed,"");
		}
		
		static public function withoutSubdomains(parsed : *) : * {
			return stx.net.UrlExtensions.withSubdomains(parsed,"");
		}
		
		static public function withoutHash(parsed : *) : * {
			return stx.net.UrlExtensions.withHash(parsed,"");
		}
		
		static public function withoutFile(parsed : *) : * {
			return stx.net.UrlExtensions.withFile(parsed,"");
		}
		
		static public function addQueryParameters(url : String,params : stx.ds.Map) : String {
			var tqs : String = stx.net.UrlExtensions.toQueryString(params);
			return function() : String {
				var $r : String;
				{
					var $e2 : enum = (stx.net.UrlExtensions.toParsedUrl(url));
					switch( $e2.index ) {
					case 0:
					$r = url + tqs;
					break;
					case 1:
					var parsed : * = $e2.params[0];
					$r = ((parsed.search.length == 0)?url + tqs:((parsed.search.length == 1)?url + tqs.substr(1):url + "&" + tqs.substr(1)));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function extractQueryParameters(url : String) : stx.ds.Map {
			return stx.net.UrlExtensions.toQueryParameters(stx.net.UrlExtensions.extractSearch(url));
		}
		
		static public function extractSearch(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"search");
		}
		
		static public function extractProtocol(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"protocol");
		}
		
		static public function extractHash(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"hash");
		}
		
		static public function extractPathname(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"pathname");
		}
		
		static public function extractHostname(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"hostname");
		}
		
		static public function extractHost(url : String) : String {
			return stx.net.UrlExtensions.extractField(url,"host");
		}
		
		static public function extractPort(url : String) : int {
			return stx.Strings._int(stx.net.UrlExtensions.extractField(url,"port"));
		}
		
		static public function toQueryParameters(query : String) : stx.ds.Map {
			return ((!stx.Strings.startsWith(query,"?"))?stx.ds.Map.create():Prelude.SArrays.foldl(Prelude.SArrays.flatMap(query.substr(1).split("&"),function(kv : String) : Array {
				var a : Array = Prelude.SArrays.map(kv.split("="),function(s : String) : String {
					return stx.Strings.urlDecode(s);
				});
				return ((a.length == 0)?[]:((a.length == 1)?[stx.Entuple.entuple(a[0],"")]:[stx.Entuple.entuple(a[0],a[1])]));
			}),stx.ds.Map.create(),function(m : stx.ds.Map,t : stx.Tuple2) : stx.ds.Map {
				return m.add(t);
			}));
		}
		
		static public function toQueryString(query : stx.ds.Map) : String {
			return query.foldl("?",function(url : String,tuple : stx.Tuple2) : String {
				var fieldName : String = tuple._1;
				var fieldValue : String = tuple._2;
				var rest : String = StringTools.urlEncode(fieldName) + "=" + StringTools.urlEncode(fieldValue);
				return url + (((url == "?")?rest:"&" + rest));
			});
		}
		
		static protected function formUrl(protocol : String,hostname : String,port : String,pathname : String,search : String,hash : String) : * {
			var host : String = hostname + (((port == "")?"":":" + port));
			var _final : String = host + pathname + search + hash;
			return { hash : hash, host : host, hostname : hostname, href : ((protocol.length > 0)?protocol + "//" + _final:_final), pathname : pathname, port : port, protocol : protocol, search : search}
		}
		
		static protected function extractField(url : String,field : String) : String {
			return stx.Options.getOrElseC(stx.Options.map(stx.net.UrlExtensions.toParsedUrl(url),function(parsed : *) : String {
				return Reflect.field(parsed,field);
			}),"");
		}
		
	}
}
