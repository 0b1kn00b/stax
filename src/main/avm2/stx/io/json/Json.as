package stx.io.json {
	import stx.io.json.JValueExtensions;
	import stx.Functions1;
	import stx.io.json.JValue;
	import stx.Tuple2;
	public class Json {
		static public var encodeObject : Function = stx.Functions1.compose(stx.io.json.Json.encode,stx.io.json.Json.fromObject);
		static public var decodeObject : Function = stx.Functions1.compose(stx.io.json.Json.toObject,stx.io.json.Json.decode);
		static public function toObject(v : stx.io.json.JValue) : * {
			{
				var $e : enum = (v);
				switch( $e.index ) {
				case 0:
				return null;
				break;
				case 3:
				var v1 : String = $e.params[0];
				return v1;
				break;
				case 2:
				var v2 : Number = $e.params[0];
				return v2;
				break;
				case 1:
				var v3 : Boolean = $e.params[0];
				return v3;
				break;
				case 4:
				var xs : Array = $e.params[0];
				return Prelude.SArrays.map(xs,function(x : stx.io.json.JValue) : * {
					return stx.io.json.Json.toObject(x);
				});
				break;
				case 5:
				var fs : Array = $e.params[0];
				return Prelude.SArrays.foldl(fs,{ },function(o : *,e : stx.io.json.JValue) : * {
					var field : stx.Tuple2 = stx.io.json.JValueExtensions.extractField(e);
					Reflect.setField(o,field._1,stx.io.json.Json.toObject(field._2));
					return o;
				});
				break;
				case 6:
				var v4 : stx.io.json.JValue = $e.params[1], k : String = $e.params[0];
				return Prelude.error("Cannot convert JField to object",{ fileName : "Json.hx", lineNumber : 47, className : "stx.io.json.Json", methodName : "toObject"});
				break;
				}
			}
			return null;
		}
		
		static public function fromObject(d : *) : stx.io.json.JValue {
			{
				var $e : enum = (Type._typeof(d));
				switch( $e.index ) {
				case 8:
				throw "Type of object must be definite: " + Std.string(d);
				break;
				case 6:
				var c : Class = $e.params[0];
				if(Std._is(d,String)) return stx.io.json.JValue.JString(d);
				else if(Std._is(d,Hash)) return stx.io.json.JValue.JObject(d.keys.toArray().map(function(k : String) : stx.io.json.JValue {
					return stx.io.json.JValue.JField(k,d.get(k));
				}));
				else if(Std._is(d,Array)) return stx.io.json.JValue.JArray(Prelude.SArrays.map(function() : Array {
					var $r2 : Array;
					var $t : * = d;
					if(Std._is($t,Array)) (($t) as Array);
					else throw "Class cast error";
					$r2 = $t;
					return $r2;
				}(),stx.io.json.Json.fromObject));
				else return Prelude.error("Unknown object type: " + Std.string(d),{ fileName : "Json.hx", lineNumber : 57, className : "stx.io.json.Json", methodName : "fromObject"});
				break;
				case 7:
				var e : Class = $e.params[0];
				return Prelude.error("Json.fromObject does not support enum conversions.",{ fileName : "Json.hx", lineNumber : 59, className : "stx.io.json.Json", methodName : "fromObject"});
				break;
				case 5:
				return Prelude.error("Json.fromObject does not support function conversions.",{ fileName : "Json.hx", lineNumber : 60, className : "stx.io.json.Json", methodName : "fromObject"});
				break;
				case 0:
				return stx.io.json.JValue.JNull;
				break;
				case 3:
				return stx.io.json.JValue.JBool(d);
				break;
				case 1:
				return stx.io.json.JValue.JNumber(d);
				break;
				case 2:
				return stx.io.json.JValue.JNumber(d);
				break;
				case 4:
				return stx.io.json.JValue.JObject(Prelude.SArrays.map(Reflect.fields(d),function(f : String) : stx.io.json.JValue {
					return stx.io.json.JValue.JField(f,stx.io.json.Json.fromObject(Reflect.field(d,f)));
				}));
				break;
				}
			}
			return null;
		}
		
		static public function encode(v : stx.io.json.JValue) : String {
			{
				var $e : enum = (v);
				switch( $e.index ) {
				case 0:
				return "null";
				break;
				case 3:
				var v1 : String = $e.params[0];
				return "\"" + new EReg(".","").customReplace(new EReg("(\n)","g").replace(new EReg("(\"|\\\\)","g").replace(v1,"\\$1"),"\\n"),function(r : EReg) : String {
					var c : * = r.matched(0)["charCodeAtHX"](0);
					return ((c >= 32 && c <= 127)?String.fromCharCode(c):"\\u" + StringTools.hex(c,4));
				}) + "\"";
				break;
				case 2:
				var v2 : Number = $e.params[0];
				return Std.string(v2);
				break;
				case 1:
				var v3 : Boolean = $e.params[0];
				return ((v3)?"true":"false");
				break;
				case 4:
				var xs : Array = $e.params[0];
				return "[" + Prelude.SArrays.map(xs,stx.io.json.Json.encode).join(",") + "]";
				break;
				case 5:
				var fs : Array = $e.params[0];
				return "{" + Prelude.SArrays.map(fs,function(f : stx.io.json.JValue) : String {
					var field : stx.Tuple2 = stx.io.json.JValueExtensions.extractField(f);
					return stx.io.json.Json.encode(stx.io.json.JValue.JString(field._1)) + ":" + stx.io.json.Json.encode(field._2);
				}).join(",") + "}";
				break;
				case 6:
				var v4 : stx.io.json.JValue = $e.params[1], k : String = $e.params[0];
				return Prelude.error("Cannot encode JField",{ fileName : "Json.hx", lineNumber : 84, className : "stx.io.json.Json", methodName : "encode"});
				break;
				}
			}
			return null;
		}
		
		static public function decode(s : String) : stx.io.json.JValue {
			var i : int = 0, l : int = s.length, mark : int, line : int = 1, temp : String, type : int = 0;
			var current : Array = new Array(), last : stx.io.json.JValue = null;
			var names : Array = new Array(), name : String = null;
			var value : stx.io.json.JValue = null;
			var states : Array = new Array(), state : int = 0;
			while((mark = i) < l) {
				var escaped : Boolean = false;
				while(i < l && "\n\r\t ".indexOf(temp = s.charAt(i)) > -1) {
					mark = ++i;
					if("\n\r".indexOf(temp) > -1) ++line;
				}
				if(i < l) {
					if((temp = s.charAt(i)) == "\"") {
						type = 4;
						while(++i < l && (escaped || (temp = s.charAt(i)) != "\"")) escaped = !escaped && temp == "\\";
					}
					else if("{[,:]}".indexOf(temp) > -1) {
						type = temp["charCodeAtHX"](0) % 12;
						++i;
					}
					else if(temp == "f") {
						type = 2;
						i += 5;
					}
					else if("tn".indexOf(temp) > -1) {
						type = temp["charCodeAtHX"](0) % 5;
						i += 4;
					}
					else if("0123456789.-".indexOf(temp) > -1) {
						type = 6;
						while(++i < l && "0123456789.eE+-".indexOf(s.charAt(i)) > -1) {
						}
					}
					else throw "Invalid JSON lexeme starting at character " + Std.string(i) + ": " + temp + " (character code " + Std.string(temp["charCodeAtHX"](0)) + ", on line " + Std.string(line) + ")";
				}
				if(type == 4) {
					temp = s.substr(mark + 1,i - mark - 1);
					++i;
				}
				else if(type == 6) temp = s.substr(mark,i - mark);
				switch(type) {
				case 3:
				{
					current.push(last = stx.io.json.JValue.JObject(new Array()));
					names.push(name);
					name = null;
					states.push(state);
					state = 2;
					value = null;
				}
				break;
				case 7:
				{
					current.push(last = stx.io.json.JValue.JArray(new Array()));
					states.push(state);
					state = 1;
					value = null;
				}
				break;
				case 8:
				{
					if(state == 1 && value != null) stx.io.json.JValueExtensions.extractArray(last).push(value);
					else if(state == 3 && name != null && value != null) {
						stx.io.json.JValueExtensions.extractArray(last).push(stx.io.json.JValue.JField(name,value));
						state = 2;
					}
					value = null;
				}
				break;
				case 10:
				if(state == 2) {
					name = stx.io.json.JValueExtensions.extractString(value);
					state = 3;
				}
				else throw "Non-sequitur colon on line " + line + " (character " + i + ", state " + state + ")";
				break;
				case 5:
				{
					if(state <= 1) throw "Unmatched closing brace on line " + line + " (character " + i + ")";
					if(name != null && value != null) stx.io.json.JValueExtensions.extractArray(last).push(stx.io.json.JValue.JField(name,value));
					value = current.pop();
					state = states.pop();
					name = names.pop();
					if(current.length > 0) last = current[current.length - 1];
				}
				break;
				case 9:
				{
					if(state != 1) throw "Unmatched closing square bracket on line " + line + " (character " + i + ")";
					if(value != null) stx.io.json.JValueExtensions.extractArray(last).push(value);
					value = current.pop();
					state = states.pop();
					if(current.length > 0) last = current[current.length - 1];
				}
				break;
				case 0:
				value = stx.io.json.JValue.JNull;
				break;
				case 1:
				value = stx.io.json.JValue.JBool(true);
				break;
				case 2:
				value = stx.io.json.JValue.JBool(false);
				break;
				case 4:
				value = stx.io.json.JValue.JString(new EReg("\\\\([bfnrt\\\\/\"]|u[0-9a-fA-F]{4})","").customReplace(temp,function(r : EReg) : String {
					var s1 : String = r.matched(1);
					if(s1 == "n") return "\n";
					else if(s1 == "r") return "\r";
					else if(s1 == "b") return String.fromCharCode(8);
					else if(s1 == "f") return String.fromCharCode(12);
					else if(s1 == "t") return "\t";
					else if(s1 == "\\") return "\\";
					else if(s1 == "\"") return "\"";
					else if(s1 == "/") return "/";
					else return String.fromCharCode(Std._parseInt("0x" + s1.substr(1)));
					return null;
				}));
				break;
				case 6:
				value = stx.io.json.JValue.JNumber(Std._parseFloat(temp));
				break;
				}
			}
			if(current.length > 0) throw "Closing brace/bracket deficit of " + Std.string(current.length);
			return value;
		}
		
	}
}
