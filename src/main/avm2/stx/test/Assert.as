package stx.test {
	import stx.test.Assertation;
	import stx.plus.Equal;
	import stx.Options;
	import haxe.io.Bytes;
	import stx.Future;
	import haxe.Timer;
	import stx.error.AssertionError;
	public class Assert {
		static public var results : List;
		static public function that(obj : *,cond : Function,msg : String = null,pos : * = null) : void {
			{
				var $e : enum = (cond(obj));
				switch( $e.index ) {
				case 0:
				var result : * = $e.params[0];
				stx.test.Assert.isTrue(false,"Expected: " + result.assertion + ", Found: x = " + stx.test.Assert.q(obj),pos);
				break;
				case 1:
				stx.test.Assert.isTrue(true,null,pos);
				break;
				}
			}
		}
		
		static public function isTrue(cond : Boolean,msg : String = null,pos : * = null) : Boolean {
			if(null == msg) msg = "expected true";
			if(stx.test.Assert.results == null) {
				if(cond) {
				}
				else throw new stx.error.AssertionError(msg,{ fileName : "Assert.hx", lineNumber : 77, className : "stx.test.Assert", methodName : "isTrue"});
			}
			else if(cond) stx.test.Assert.results.add(stx.test.Assertation.Success(pos));
			else stx.test.Assert.results.add(stx.test.Assertation.Failure(msg,pos));
			return cond;
		}
		
		static public function isFalse(value : Boolean,msg : String = null,pos : * = null) : Boolean {
			if(null == msg) msg = "expected false";
			return stx.test.Assert.isTrue(value == false,msg,pos);
		}
		
		static public function isNull(value : *,msg : String = null,pos : * = null) : Boolean {
			if(msg == null) msg = "expected null but was " + stx.test.Assert.q(value);
			return stx.test.Assert.isTrue(value == null,msg,pos);
		}
		
		static public function notNull(value : *,msg : String = null,pos : * = null) : Boolean {
			if(null == msg) msg = "expected false";
			return stx.test.Assert.isTrue(value != null,msg,pos);
		}
		
		static public function _is(value : *,type : *,msg : String = null,pos : * = null) : Boolean {
			if(msg == null) msg = "expected type " + stx.test.Assert.typeToString(type) + " but was " + stx.test.Assert.typeToString(value);
			return stx.test.Assert.isTrue(Std._is(value,type),msg,pos);
		}
		
		static public function notEquals(expected : *,value : *,msg : String = null,pos : * = null) : Boolean {
			if(msg == null) msg = "expected " + stx.test.Assert.q(expected) + " and testa value " + stx.test.Assert.q(value) + " should be different";
			return stx.test.Assert.isFalse(expected == value,msg,pos);
		}
		
		static public function equals(expected : *,value : *,equal : Function = null,msg : String = null,pos : * = null) : Boolean {
			if(equal == null) equal = stx.plus.Equal.getEqualFor(expected);
			if(msg == null) msg = "expected " + stx.test.Assert.q(expected) + " but was " + stx.test.Assert.q(value);
			return stx.test.Assert.isTrue(equal(expected,value),msg,pos);
		}
		
		static public function matches(pattern : EReg,value : *,msg : String = null,pos : * = null) : Boolean {
			if(msg == null) msg = "the value " + stx.test.Assert.q(value) + "does not match the provided pattern";
			return stx.test.Assert.isTrue(pattern.match(value),msg,pos);
		}
		
		static public function floatEquals(expected : Number,value : Number,approx : * = null,msg : String = null,pos : * = null) : Boolean {
			if(msg == null) msg = "expected " + expected + " but was " + value;
			if(Math["isNaN"](expected)) {
				if(Math["isNaN"](value)) return stx.test.Assert.isTrue(true,msg,pos);
				else return stx.test.Assert.isTrue(false,msg,pos);
			}
			else if(Math["isNaN"](value)) return stx.test.Assert.isTrue(false,msg,pos);
			if(null == approx) approx = 1e-5;
			return stx.test.Assert.isTrue(Math.abs(value - expected) < approx,msg,pos);
		}
		
		static protected function getTypeName(v : *) : String {
			{
				var $e : enum = (Type._typeof(v));
				switch( $e.index ) {
				case 0:
				return null;
				break;
				case 1:
				return "Int";
				break;
				case 2:
				return "Float";
				break;
				case 3:
				return "Bool";
				break;
				case 5:
				return "function";
				break;
				case 6:
				var c : Class = $e.params[0];
				return Type.getClassName(c);
				break;
				case 7:
				var e : Class = $e.params[0];
				return Type.getEnumName(e);
				break;
				case 4:
				return "Object";
				break;
				case 8:
				return "Unknown";
				break;
				}
			}
			return null;
		}
		
		static protected function isIterable(v : *,isAnonym : Boolean) : Boolean {
			var fields : Array = ((isAnonym)?Reflect.fields(v):Type.getInstanceFields(Type.getClass(v)));
			if(!Lambda.has(fields,"iterator")) return false;
			return Reflect.isFunction(Reflect.field(v,"iterator"));
		}
		
		static protected function isIterator(v : *,isAnonym : Boolean) : Boolean {
			var fields : Array = ((isAnonym)?Reflect.fields(v):Type.getInstanceFields(Type.getClass(v)));
			if(!Lambda.has(fields,"next") || !Lambda.has(fields,"hasNext")) return false;
			return Reflect.isFunction(Reflect.field(v,"next")) && Reflect.isFunction(Reflect.field(v,"hasNext"));
		}
		
		static protected function sameAs(expected : *,value : *,status : *) : Boolean {
			var texpected : String = stx.test.Assert.getTypeName(expected);
			var tvalue : String = stx.test.Assert.getTypeName(value);
			var isanonym : Boolean = texpected == "Object";
			if(texpected != tvalue) {
				status.error = "expected type " + texpected + " but it is " + tvalue + (((status.path == "")?"":" for field " + status.path));
				return false;
			}
			{
				var $e : enum = (Type._typeof(expected));
				switch( $e.index ) {
				case 0:
				case 1:
				case 2:
				case 3:
				{
					if(expected != value) {
						status.error = "expected " + Std.string(expected) + " but it is " + Std.string(value) + (((status.path == "")?"":" for field " + status.path));
						return false;
					}
					return true;
				}
				break;
				case 5:
				{
					if(!Reflect.compareMethods(expected,value)) {
						status.error = "expected same function reference" + (((status.path == "")?"":" for field " + status.path));
						return false;
					}
					return true;
				}
				break;
				case 6:
				var c : Class = $e.params[0];
				{
					var cexpected : String = Type.getClassName(c);
					var cvalue : String = Type.getClassName(Type.getClass(value));
					if(cexpected != cvalue) {
						status.error = "expected instance of " + cexpected + " but it is " + cvalue + (((status.path == "")?"":" for field " + status.path));
						return false;
					}
					if(Std._is(expected,Array)) {
						if(status.recursive || status.path == "") {
							if(expected.length != value.length) {
								status.error = "expected " + Std.string(expected.length) + " elements but they were " + Std.string(value.length) + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path : String = status.path;
							{
								var _g1 : int = 0, _g : int = expected.length;
								while(_g1 < _g) {
									var i : int = _g1++;
									status.path = ((path == "")?"array[" + i + "]":path + "[" + i + "]");
									if(!stx.test.Assert.sameAs(expected[i],value[i],status)) {
										status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
										return false;
									}
								}
							}
						}
						return true;
					}
					if(Std._is(expected,Date)) {
						if(expected.getTime() != value.getTime()) {
							status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
							return false;
						}
						return true;
					}
					if(Std._is(expected,haxe.io.Bytes)) {
						if(status.recursive || status.path == "") {
							var ebytes : haxe.io.Bytes = expected;
							var vbytes : haxe.io.Bytes = value;
							if(ebytes.length != vbytes.length) return false;
							{
								var _g11 : int = 0, _g2 : int = ebytes.length;
								while(_g11 < _g2) {
									var i1 : int = _g11++;
									if(ebytes.get(i1) != vbytes.get(i1)) {
										status.error = "expected byte " + ebytes.get(i1) + " but wss " + ebytes.get(i1) + (((status.path == "")?"":" for field " + status.path));
										return false;
									}
								}
							}
						}
						return true;
					}
					if(Std._is(expected,Hash) || Std._is(expected,IntHash)) {
						if(status.recursive || status.path == "") {
							var keys : Array = Lambda.array({ iterator : function() : * {
								return expected.keys();
							}});
							var vkeys : Array = Lambda.array({ iterator : function() : * {
								return value.keys();
							}});
							if(keys.length != vkeys.length) {
								status.error = "expected " + keys.length + " keys but they were " + vkeys.length + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path1 : String = status.path;
							{
								var _g3 : int = 0;
								while(_g3 < keys.length) {
									var key : String = keys[_g3];
									++_g3;
									status.path = ((path1 == "")?"hash[" + key + "]":path1 + "[" + key + "]");
									if(!stx.test.Assert.sameAs(expected.get(key),value.get(key),status)) {
										status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
										return false;
									}
								}
							}
						}
						return true;
					}
					if(stx.test.Assert.isIterator(expected,false)) {
						if(status.recursive || status.path == "") {
							var evalues : Array = Lambda.array({ iterator : function() : * {
								return expected;
							}});
							var vvalues : Array = Lambda.array({ iterator : function() : * {
								return value;
							}});
							if(evalues.length != vvalues.length) {
								status.error = "expected " + evalues.length + " values in Iterator but they were " + vvalues.length + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path2 : String = status.path;
							{
								var _g12 : int = 0, _g4 : int = evalues.length;
								while(_g12 < _g4) {
									var i2 : int = _g12++;
									status.path = ((path2 == "")?"iterator[" + i2 + "]":path2 + "[" + i2 + "]");
									if(!stx.test.Assert.sameAs(evalues[i2],vvalues[i2],status)) {
										status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
										return false;
									}
								}
							}
						}
						return true;
					}
					if(stx.test.Assert.isIterable(expected,false)) {
						if(status.recursive || status.path == "") {
							var evalues1 : Array = Lambda.array(expected);
							var vvalues1 : Array = Lambda.array(value);
							if(evalues1.length != vvalues1.length) {
								status.error = "expected " + evalues1.length + " values in Iterable but they were " + vvalues1.length + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path3 : String = status.path;
							{
								var _g13 : int = 0, _g5 : int = evalues1.length;
								while(_g13 < _g5) {
									var i3 : int = _g13++;
									status.path = ((path3 == "")?"iterable[" + i3 + "]":path3 + "[" + i3 + "]");
									if(!stx.test.Assert.sameAs(evalues1[i3],vvalues1[i3],status)) return false;
								}
							}
						}
						return true;
					}
					if(status.recursive || status.path == "") {
						var fields : Array = Type.getInstanceFields(Type.getClass(expected));
						var path4 : String = status.path;
						{
							var _g6 : int = 0;
							while(_g6 < fields.length) {
								var field : String = fields[_g6];
								++_g6;
								status.path = ((path4 == "")?field:path4 + "." + field);
								var e : * = Reflect.field(expected,field);
								if(Reflect.isFunction(e)) continue;
								var v : * = Reflect.field(value,field);
								if(!stx.test.Assert.sameAs(e,v,status)) return false;
							}
						}
					}
					return true;
				}
				break;
				case 7:
				var e1 : Class = $e.params[0];
				{
					var eexpected : String = Type.getEnumName(e1);
					var evalue : String = Type.getEnumName(Type.getEnum(value));
					if(eexpected != evalue) {
						status.error = "expected enumeration of " + eexpected + " but it is " + evalue + (((status.path == "")?"":" for field " + status.path));
						return false;
					}
					if(status.recursive || status.path == "") {
						if(Type.enumIndex(expected) != Type.enumIndex(value)) {
							status.error = "expected " + stx.test.Assert.q(Type.enumConstructor(expected)) + " but is " + stx.test.Assert.q(Type.enumConstructor(value)) + (((status.path == "")?"":" for field " + status.path));
							return false;
						}
						var eparams : Array = Type.enumParameters(expected);
						var vparams : Array = Type.enumParameters(value);
						var path5 : String = status.path;
						{
							var _g14 : int = 0, _g7 : int = eparams.length;
							while(_g14 < _g7) {
								var i4 : int = _g14++;
								status.path = ((path5 == "")?"enum[" + i4 + "]":path5 + "[" + i4 + "]");
								if(!stx.test.Assert.sameAs(eparams[i4],vparams[i4],status)) {
									status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
									return false;
								}
							}
						}
					}
					return true;
				}
				break;
				case 4:
				{
					if(status.recursive || status.path == "") {
						var fields1 : Array = Reflect.fields(expected);
						var path6 : String = status.path;
						{
							var _g8 : int = 0;
							while(_g8 < fields1.length) {
								var field1 : String = fields1[_g8];
								++_g8;
								status.path = ((path6 == "")?field1:path6 + "." + field1);
								if(!Reflect.hasField(value,field1)) {
									status.error = "expected field " + status.path + " does not exist in " + Std.string(value);
									return false;
								}
								var e2 : * = Reflect.field(expected,field1);
								if(Reflect.isFunction(e2)) continue;
								var v1 : * = Reflect.field(value,field1);
								if(!stx.test.Assert.sameAs(e2,v1,status)) return false;
							}
						}
					}
					if(stx.test.Assert.isIterator(expected,true)) {
						if(!stx.test.Assert.isIterator(value,true)) {
							status.error = "expected Iterable but it is not " + (((status.path == "")?"":" for field " + status.path));
							return false;
						}
						if(status.recursive || status.path == "") {
							var evalues2 : Array = Lambda.array({ iterator : function() : * {
								return expected;
							}});
							var vvalues2 : Array = Lambda.array({ iterator : function() : * {
								return value;
							}});
							if(evalues2.length != vvalues2.length) {
								status.error = "expected " + evalues2.length + " values in Iterator but they were " + vvalues2.length + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path7 : String = status.path;
							{
								var _g15 : int = 0, _g9 : int = evalues2.length;
								while(_g15 < _g9) {
									var i5 : int = _g15++;
									status.path = ((path7 == "")?"iterator[" + i5 + "]":path7 + "[" + i5 + "]");
									if(!stx.test.Assert.sameAs(evalues2[i5],vvalues2[i5],status)) {
										status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (((status.path == "")?"":" for field " + status.path));
										return false;
									}
								}
							}
						}
						return true;
					}
					if(stx.test.Assert.isIterable(expected,true)) {
						if(!stx.test.Assert.isIterable(value,true)) {
							status.error = "expected Iterator but it is not " + (((status.path == "")?"":" for field " + status.path));
							return false;
						}
						if(status.recursive || status.path == "") {
							var evalues3 : Array = Lambda.array(expected);
							var vvalues3 : Array = Lambda.array(value);
							if(evalues3.length != vvalues3.length) {
								status.error = "expected " + evalues3.length + " values in Iterable but they were " + vvalues3.length + (((status.path == "")?"":" for field " + status.path));
								return false;
							}
							var path8 : String = status.path;
							{
								var _g16 : int = 0, _g10 : int = evalues3.length;
								while(_g16 < _g10) {
									var i6 : int = _g16++;
									status.path = ((path8 == "")?"iterable[" + i6 + "]":path8 + "[" + i6 + "]");
									if(!stx.test.Assert.sameAs(evalues3[i6],vvalues3[i6],status)) return false;
								}
							}
						}
						return true;
					}
					return true;
				}
				break;
				case 8:
				return function() : Boolean {
					var $r2 : Boolean;
					throw "Unable to compare  two unknown types";
					return $r2;
				}();
				break;
				}
			}
			return function() : Boolean {
				var $r3 : Boolean;
				throw "Unable to compare values: " + stx.test.Assert.q(expected) + " and " + stx.test.Assert.q(value);
				return $r3;
			}();
		}
		
		static protected function q(v : *) : String {
			if(null == v) return "null";
			else if(Std._is(v,String)) return "\"" + StringTools.replace(v,"\"","\\\"") + "\"";
			else return "" + Std.string(v);
			return null;
		}
		
		static public function looksLike(expected : *,value : *,recursive : * = null,msg : String = null,pos : * = null) : Boolean {
			if(null == recursive) recursive = true;
			var status : * = { recursive : recursive, path : "", error : null}
			if(stx.test.Assert.sameAs(expected,value,status)) return stx.test.Assert.isTrue(true,msg,pos);
			else {
				stx.test.Assert.fail(((msg == null)?status.error:msg),pos);
				return false;
			}
			return false;
		}
		
		static public function throwsException(method : Function,type : Class = null,msg : String = null,pos : * = null) : Boolean {
			if(type == null) type = String;
			try {
				method();
				var name : String = Type.getClassName(type);
				if(name == null) name = "" + Std.string(type);
				stx.test.Assert.fail("exception of type " + name + " not raised",pos);
				return false;
			}
			catch( ex : * ){
				var name1 : String = Type.getClassName(type);
				if(name1 == null) name1 = "" + Std.string(type);
				return stx.test.Assert.isTrue(Std._is(ex,type),"expected throw of type " + name1 + " but was " + Std.string(ex),pos);
			}
			return false;
		}
		
		static public function equalsOneOf(value : *,possibilities : Array,msg : String = null,pos : * = null) : Boolean {
			if(Lambda.has(possibilities,value)) return stx.test.Assert.isTrue(true,msg,pos);
			else {
				stx.test.Assert.fail(((msg == null)?"value " + stx.test.Assert.q(value) + " not found in the expected possibilities " + Std.string(possibilities):msg),pos);
				return false;
			}
			return false;
		}
		
		static public function contains(values : *,match : *,msg : String = null,pos : * = null) : Boolean {
			if(Lambda.has(values,match)) return stx.test.Assert.isTrue(true,msg,pos);
			else {
				stx.test.Assert.fail(((msg == null)?"values " + Std.string(values) + " do not contain " + Std.string(match):msg),pos);
				return false;
			}
			return false;
		}
		
		static public function notContains(values : *,match : *,msg : String = null,pos : * = null) : Boolean {
			if(!Lambda.has(values,match)) return stx.test.Assert.isTrue(true,msg,pos);
			else {
				stx.test.Assert.fail(((msg == null)?"values " + Std.string(values) + " do contain " + Std.string(match):msg),pos);
				return false;
			}
			return false;
		}
		
		static public function stringContains(match : String,value : String,msg : String = null,pos : * = null) : Boolean {
			if(value != null && value.indexOf(match) >= 0) return stx.test.Assert.isTrue(true,msg,pos);
			else {
				stx.test.Assert.fail(((msg == null)?"value " + stx.test.Assert.q(value) + " does not contain " + stx.test.Assert.q(match):msg),pos);
				return false;
			}
			return false;
		}
		
		static public function stringSequence(sequence : Array,value : String,msg : String = null,pos : * = null) : Boolean {
			if(null == value) {
				stx.test.Assert.fail(((msg == null)?"null argument value":msg),pos);
				return false;
			}
			var p : int = 0;
			{
				var _g : int = 0;
				while(_g < sequence.length) {
					var s : String = sequence[_g];
					++_g;
					var p2 : int = value.indexOf(s,p);
					if(p2 < 0) {
						if(msg == null) {
							msg = "expected '" + s + "' after ";
							if(p > 0) {
								var cut : String = value.substr(0,p);
								if(cut.length > 30) cut = "..." + cut.substr(-27);
								msg += " '" + cut + "'";
							}
							else msg += " begin";
						}
						stx.test.Assert.fail(msg,pos);
						return false;
					}
					p = p2 + s.length;
				}
			}
			return stx.test.Assert.isTrue(true,msg,pos);
		}
		
		static public function fail(msg : String = "failure expected",pos : * = null) : Boolean {
			if(msg==null) msg="failure expected";
			return stx.test.Assert.isTrue(false,msg,pos);
		}
		
		static public function warn(msg : String) : void {
			stx.test.Assert.results.add(stx.test.Assertation.Warning(msg));
		}
		
		static public var createAsync : Function = function(f : Function,timeout : * = null) : Function {
			return function() : void {
			}
		}
		static public function delivered(future : stx.Future,assertions : Function,timeout : * = null) : void {
			var f : Function = stx.test.Assert.createAsync(function() : void {
				if(future.isCanceled()) stx.test.Assert.fail("expected delivery of future " + stx.test.Assert.q(future) + ", but it was canceled",{ fileName : "Assert.hx", lineNumber : 701, className : "stx.test.Assert", methodName : "delivered"});
				else assertions(stx.Options.get(future.value()));
			},timeout);
			future.deliverTo(function(value : *) : void {
				f();
			});
			future.ifCanceled(f);
		}
		
		static public function canceled(future : stx.Future,assertions : Function,timeout : * = null) : void {
			future.ifCanceled(stx.test.Assert.createAsync(assertions,timeout));
		}
		
		static public function notDelivered(future : stx.Future,timeout : * = null,pos : * = null) : void {
			var f : Function = stx.test.Assert.createAsync(function() : void {
				if(future.isDelivered()) stx.test.Assert.fail("Did not expect delivery of: " + Std.string(stx.Options.get(future.value())),pos);
				else stx.test.Assert.isTrue(true,null,{ fileName : "Assert.hx", lineNumber : 728, className : "stx.test.Assert", methodName : "notDelivered"});
			},timeout + 10);
			haxe.Timer.delay(f,timeout);
			future.deliverTo(function(value : *) : void {
				f();
			});
		}
		
		static public var createEvent : Function = function(f : Function,timeout : * = null) : Function {
			return function(e : *) : void {
			}
		}
		static protected function typeToString(t : *) : String {
			try {
				var _t : Class = Type.getClass(t);
				if(_t != null) t = _t;
			}
			catch( e : * ){
			}
			try {
				return Type.getClassName(t);
			}
			catch( e1 : * ){
			}
			try {
				var _t1 : Class = Type.getEnum(t);
				if(_t1 != null) t = _t1;
			}
			catch( e2 : * ){
			}
			try {
				return Type.getEnumName(t);
			}
			catch( e3 : * ){
			}
			try {
				return Std.string(Type._typeof(t));
			}
			catch( e4 : * ){
			}
			try {
				return Std.string(t);
			}
			catch( e5 : * ){
			}
			return "<unable to retrieve type name>";
		}
		
	}
}
