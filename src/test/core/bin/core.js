var $hxClasses = $hxClasses || {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var AllClasses = $hxClasses["AllClasses"] = function() {
	haxe.Log.trace("This is a generated main class",{ fileName : "AllClasses.hx", lineNumber : 57, className : "AllClasses", methodName : "new"});
};
AllClasses.__name__ = ["AllClasses"];
AllClasses.main = function() {
	return new AllClasses();
}
AllClasses.prototype = {
	__class__: AllClasses
}
var EReg = $hxClasses["EReg"] = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.b += Std.string(this.matchedLeft());
			buf.b += Std.string(f(this));
			s = this.matchedRight();
		}
		buf.b += Std.string(s);
		return buf.b;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,r: null
	,__class__: EReg
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += " => ";
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += ", ";
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,h: null
	,__class__: Hash
}
var HxOverrides = $hxClasses["HxOverrides"] = function() { }
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
	case 10:
		var k = s.split("-");
		return new Date(k[0],k[1] - 1,k[2],0,0,0);
	case 19:
		var k = s.split(" ");
		var y = k[0].split("-");
		var t = k[1].split(":");
		return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
	default:
		throw "Invalid date format : " + s;
	}
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !$iterator(it)().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = $iterator(b)();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b += Std.string(sep);
			s.b += Std.string(l[0]);
			l = l[1];
		}
		return s.b;
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b += "{";
		while(l != null) {
			if(first) first = false; else s.b += ", ";
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += "}";
		return s.b;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,length: null
	,q: null
	,h: null
	,__class__: List
}
var Main = $hxClasses["Main"] = function() {
	new AllClasses();
	stx.Future.waitFor(SArrays.map(SArrays.map([1,2,3],function(a) {
		return a + 1;
	}),stx.Future.pure)).foreach(stx.Log.printer({ fileName : "Main.hx", lineNumber : 24, className : "Main", methodName : "new"}));
	haxe.Log.trace(stx.plus.ArrayEqual.equals([1,2,3],[1,2,3]),{ fileName : "Main.hx", lineNumber : 26, className : "Main", methodName : "new"});
	haxe.Log.trace(stx.plus.ArrayEqual.equals([1,2,3],[1,2,5]),{ fileName : "Main.hx", lineNumber : 27, className : "Main", methodName : "new"});
	var a = stx.Functions1.lazy(stx.plus.ArrayOrder.sort,[99,2,6,-55]);
	haxe.Log.trace(a(),{ fileName : "Main.hx", lineNumber : 30, className : "Main", methodName : "new"});
	var b = { a : 123, b : [4,5,6]};
	haxe.Log.trace(stx.io.json.Json.decode(stx.io.json.Json.encode(stx.io.json.Json.fromObject(b))),{ fileName : "Main.hx", lineNumber : 33, className : "Main", methodName : "new"});
};
Main.__name__ = ["Main"];
Main.main = function() {
	new Main();
}
Main.prototype = {
	__class__: Main
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && (v.__name__ || v.__ename__);
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
var SBase = $hxClasses["SBase"] = function() { }
SBase.__name__ = ["SBase"];
SBase.here = function(pos) {
	return pos;
}
SBase.tool = function(order,equal,hash,show) {
	return { order : order, equal : equal, show : show, hash : hash};
}
SBase.identity = function() {
	return function(a) {
		return a;
	};
}
SBase.unfold = function(initial,unfolder) {
	return { iterator : function() {
		var _next = stx.Option.None;
		var _progress = initial;
		var precomputeNext = function() {
			var $e = (unfolder(_progress));
			switch( $e[1] ) {
			case 0:
				_progress = null;
				_next = stx.Option.None;
				break;
			case 1:
				var tuple = $e[2];
				_progress = tuple._1;
				_next = stx.Option.Some(tuple._2);
				break;
			}
		};
		precomputeNext();
		return { hasNext : function() {
			return !stx.Options.isEmpty(_next);
		}, next : function() {
			var n = stx.Options.get(_next);
			precomputeNext();
			return n;
		}};
	}};
}
SBase.error = function(msg,pos) {
	throw "" + msg + " at " + Std.string(pos);
	return null;
}
var SArrays = $hxClasses["SArrays"] = function() { }
SArrays.__name__ = ["SArrays"];
SArrays.map = function(a,f) {
	var n = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		n.push(f(e));
	}
	return n;
}
SArrays.flatMap = function(a,f) {
	var n = [];
	var _g = 0;
	while(_g < a.length) {
		var e1 = a[_g];
		++_g;
		var $it0 = $iterator(f(e1))();
		while( $it0.hasNext() ) {
			var e2 = $it0.next();
			n.push(e2);
		}
	}
	return n;
}
SArrays.foldl = function(a,z,f) {
	var r = z;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		r = f(r,e);
	}
	return r;
}
SArrays.filter = function(a,f) {
	var n = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(f(e)) n.push(e);
	}
	return n;
}
SArrays.size = function(a) {
	return a.length;
}
SArrays.snapshot = function(a) {
	return [].concat(a);
}
SArrays.foreach = function(a,f) {
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		f(e);
	}
	return a;
}
var SIterables = $hxClasses["SIterables"] = function() { }
SIterables.__name__ = ["SIterables"];
SIterables.toArray = function(i) {
	var a = [];
	var $it0 = $iterator(i)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		a.push(e);
	}
	return a;
}
SIterables.toIterable = function(it) {
	return { iterator : function() {
		return { next : $bind(it,it.next), hasNext : $bind(it,it.hasNext)};
	}};
}
SIterables.map = function(iter,f) {
	return SIterables.foldl(iter,[],function(a,b) {
		a.push(f(b));
		return a;
	});
}
SIterables.flatMap = function(iter,f) {
	return SIterables.foldl(iter,[],function(a,b) {
		var $it0 = $iterator(f(b))();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			a.push(e);
		}
		return a;
	});
}
SIterables.foldl = function(iter,seed,mapper) {
	var folded = seed;
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		folded = mapper(folded,e);
	}
	return folded;
}
SIterables.filter = function(iter,f) {
	return SArrays.filter(SIterables.toArray(iter),f);
}
SIterables.size = function(iterable) {
	var size = 0;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		++size;
	}
	return size;
}
SIterables.foreach = function(iter,f) {
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		f(e);
	}
}
var IntIters = $hxClasses["IntIters"] = function() { }
IntIters.__name__ = ["IntIters"];
IntIters.to = function(start,end) {
	return { iterator : function() {
		var cur = start;
		return { hasNext : function() {
			return cur <= end;
		}, next : function() {
			var next = cur;
			++cur;
			return next;
		}};
	}};
}
IntIters.until = function(start,end) {
	return IntIters.to(start,end - 1);
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return x <= 0?0:Math.floor(Math.random() * x);
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += HxOverrides.substr(c,0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.charCodeAt(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = $hxClasses["Type"] = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ || v.__ename__) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
var haxe = haxe || {}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.StackItem = $hxClasses["haxe.StackItem"] = { __ename__ : ["haxe","StackItem"], __constructs__ : ["CFunction","Module","FilePos","Method","Lambda"] }
haxe.StackItem.CFunction = ["CFunction",0];
haxe.StackItem.CFunction.toString = $estr;
haxe.StackItem.CFunction.__enum__ = haxe.StackItem;
haxe.StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.StackItem.Lambda = function(v) { var $x = ["Lambda",4,v]; $x.__enum__ = haxe.StackItem; $x.toString = $estr; return $x; }
haxe.Stack = $hxClasses["haxe.Stack"] = function() { }
haxe.Stack.__name__ = ["haxe","Stack"];
haxe.Stack.callStack = function() {
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe.StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe.StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe.Stack.makeStack(new Error().stack);
	a.shift();
	Error.prepareStackTrace = oldValue;
	return a;
}
haxe.Stack.exceptionStack = function() {
	return [];
}
haxe.Stack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe.Stack.itemToString(b,s);
	}
	return b.b;
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = $e[2];
		b.b += "module ";
		b.b += Std.string(m);
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += Std.string(file);
		b.b += " line ";
		b.b += Std.string(line);
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b += Std.string(cname);
		b.b += ".";
		b.b += Std.string(meth);
		break;
	case 4:
		var n = $e[2];
		b.b += "local function #";
		b.b += Std.string(n);
		break;
	}
}
haxe.Stack.makeStack = function(s) {
	if(typeof(s) == "string") {
		var stack = s.split("\n");
		var m = [];
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			m.push(haxe.StackItem.Module(line));
		}
		return m;
	} else return s;
}
if(!haxe.macro) haxe.macro = {}
haxe.macro.Context = $hxClasses["haxe.macro.Context"] = function() { }
haxe.macro.Context.__name__ = ["haxe","macro","Context"];
haxe.macro.Constant = $hxClasses["haxe.macro.Constant"] = { __ename__ : ["haxe","macro","Constant"], __constructs__ : ["CInt","CFloat","CString","CIdent","CRegexp","CType"] }
haxe.macro.Constant.CInt = function(v) { var $x = ["CInt",0,v]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CFloat = function(f) { var $x = ["CFloat",1,f]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CString = function(s) { var $x = ["CString",2,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CIdent = function(s) { var $x = ["CIdent",3,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CRegexp = function(r,opt) { var $x = ["CRegexp",4,r,opt]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CType = function(s) { var $x = ["CType",5,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Binop = $hxClasses["haxe.macro.Binop"] = { __ename__ : ["haxe","macro","Binop"], __constructs__ : ["OpAdd","OpMult","OpDiv","OpSub","OpAssign","OpEq","OpNotEq","OpGt","OpGte","OpLt","OpLte","OpAnd","OpOr","OpXor","OpBoolAnd","OpBoolOr","OpShl","OpShr","OpUShr","OpMod","OpAssignOp","OpInterval"] }
haxe.macro.Binop.OpAdd = ["OpAdd",0];
haxe.macro.Binop.OpAdd.toString = $estr;
haxe.macro.Binop.OpAdd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpMult = ["OpMult",1];
haxe.macro.Binop.OpMult.toString = $estr;
haxe.macro.Binop.OpMult.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpDiv = ["OpDiv",2];
haxe.macro.Binop.OpDiv.toString = $estr;
haxe.macro.Binop.OpDiv.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpSub = ["OpSub",3];
haxe.macro.Binop.OpSub.toString = $estr;
haxe.macro.Binop.OpSub.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAssign = ["OpAssign",4];
haxe.macro.Binop.OpAssign.toString = $estr;
haxe.macro.Binop.OpAssign.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpEq = ["OpEq",5];
haxe.macro.Binop.OpEq.toString = $estr;
haxe.macro.Binop.OpEq.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpNotEq = ["OpNotEq",6];
haxe.macro.Binop.OpNotEq.toString = $estr;
haxe.macro.Binop.OpNotEq.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpGt = ["OpGt",7];
haxe.macro.Binop.OpGt.toString = $estr;
haxe.macro.Binop.OpGt.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpGte = ["OpGte",8];
haxe.macro.Binop.OpGte.toString = $estr;
haxe.macro.Binop.OpGte.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpLt = ["OpLt",9];
haxe.macro.Binop.OpLt.toString = $estr;
haxe.macro.Binop.OpLt.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpLte = ["OpLte",10];
haxe.macro.Binop.OpLte.toString = $estr;
haxe.macro.Binop.OpLte.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAnd = ["OpAnd",11];
haxe.macro.Binop.OpAnd.toString = $estr;
haxe.macro.Binop.OpAnd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpOr = ["OpOr",12];
haxe.macro.Binop.OpOr.toString = $estr;
haxe.macro.Binop.OpOr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpXor = ["OpXor",13];
haxe.macro.Binop.OpXor.toString = $estr;
haxe.macro.Binop.OpXor.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpBoolAnd = ["OpBoolAnd",14];
haxe.macro.Binop.OpBoolAnd.toString = $estr;
haxe.macro.Binop.OpBoolAnd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpBoolOr = ["OpBoolOr",15];
haxe.macro.Binop.OpBoolOr.toString = $estr;
haxe.macro.Binop.OpBoolOr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpShl = ["OpShl",16];
haxe.macro.Binop.OpShl.toString = $estr;
haxe.macro.Binop.OpShl.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpShr = ["OpShr",17];
haxe.macro.Binop.OpShr.toString = $estr;
haxe.macro.Binop.OpShr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpUShr = ["OpUShr",18];
haxe.macro.Binop.OpUShr.toString = $estr;
haxe.macro.Binop.OpUShr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpMod = ["OpMod",19];
haxe.macro.Binop.OpMod.toString = $estr;
haxe.macro.Binop.OpMod.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAssignOp = function(op) { var $x = ["OpAssignOp",20,op]; $x.__enum__ = haxe.macro.Binop; $x.toString = $estr; return $x; }
haxe.macro.Binop.OpInterval = ["OpInterval",21];
haxe.macro.Binop.OpInterval.toString = $estr;
haxe.macro.Binop.OpInterval.__enum__ = haxe.macro.Binop;
haxe.macro.Unop = $hxClasses["haxe.macro.Unop"] = { __ename__ : ["haxe","macro","Unop"], __constructs__ : ["OpIncrement","OpDecrement","OpNot","OpNeg","OpNegBits"] }
haxe.macro.Unop.OpIncrement = ["OpIncrement",0];
haxe.macro.Unop.OpIncrement.toString = $estr;
haxe.macro.Unop.OpIncrement.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpDecrement = ["OpDecrement",1];
haxe.macro.Unop.OpDecrement.toString = $estr;
haxe.macro.Unop.OpDecrement.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNot = ["OpNot",2];
haxe.macro.Unop.OpNot.toString = $estr;
haxe.macro.Unop.OpNot.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNeg = ["OpNeg",3];
haxe.macro.Unop.OpNeg.toString = $estr;
haxe.macro.Unop.OpNeg.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNegBits = ["OpNegBits",4];
haxe.macro.Unop.OpNegBits.toString = $estr;
haxe.macro.Unop.OpNegBits.__enum__ = haxe.macro.Unop;
haxe.macro.ExprDef = $hxClasses["haxe.macro.ExprDef"] = { __ename__ : ["haxe","macro","ExprDef"], __constructs__ : ["EConst","EArray","EBinop","EField","EParenthesis","EObjectDecl","EArrayDecl","ECall","ENew","EUnop","EVars","EFunction","EBlock","EFor","EIn","EIf","EWhile","ESwitch","ETry","EReturn","EBreak","EContinue","EUntyped","EThrow","ECast","EDisplay","EDisplayNew","ETernary","ECheckType","EType"] }
haxe.macro.ExprDef.EConst = function(c) { var $x = ["EConst",0,c]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArray = function(e1,e2) { var $x = ["EArray",1,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBinop = function(op,e1,e2) { var $x = ["EBinop",2,op,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EField = function(e,field) { var $x = ["EField",3,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EParenthesis = function(e) { var $x = ["EParenthesis",4,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EObjectDecl = function(fields) { var $x = ["EObjectDecl",5,fields]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArrayDecl = function(values) { var $x = ["EArrayDecl",6,values]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECall = function(e,params) { var $x = ["ECall",7,e,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ENew = function(t,params) { var $x = ["ENew",8,t,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EUnop = function(op,postFix,e) { var $x = ["EUnop",9,op,postFix,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EVars = function(vars) { var $x = ["EVars",10,vars]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFunction = function(name,f) { var $x = ["EFunction",11,name,f]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBlock = function(exprs) { var $x = ["EBlock",12,exprs]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFor = function(it,expr) { var $x = ["EFor",13,it,expr]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIn = function(e1,e2) { var $x = ["EIn",14,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIf = function(econd,eif,eelse) { var $x = ["EIf",15,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EWhile = function(econd,e,normalWhile) { var $x = ["EWhile",16,econd,e,normalWhile]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ESwitch = function(e,cases,edef) { var $x = ["ESwitch",17,e,cases,edef]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETry = function(e,catches) { var $x = ["ETry",18,e,catches]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EReturn = function(e) { var $x = ["EReturn",19,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBreak = ["EBreak",20];
haxe.macro.ExprDef.EBreak.toString = $estr;
haxe.macro.ExprDef.EBreak.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EContinue = ["EContinue",21];
haxe.macro.ExprDef.EContinue.toString = $estr;
haxe.macro.ExprDef.EContinue.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EUntyped = function(e) { var $x = ["EUntyped",22,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EThrow = function(e) { var $x = ["EThrow",23,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECast = function(e,t) { var $x = ["ECast",24,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplay = function(e,isCall) { var $x = ["EDisplay",25,e,isCall]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplayNew = function(t) { var $x = ["EDisplayNew",26,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETernary = function(econd,eif,eelse) { var $x = ["ETernary",27,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECheckType = function(e,t) { var $x = ["ECheckType",28,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EType = function(e,field) { var $x = ["EType",29,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ComplexType = $hxClasses["haxe.macro.ComplexType"] = { __ename__ : ["haxe","macro","ComplexType"], __constructs__ : ["TPath","TFunction","TAnonymous","TParent","TExtend","TOptional"] }
haxe.macro.ComplexType.TPath = function(p) { var $x = ["TPath",0,p]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TFunction = function(args,ret) { var $x = ["TFunction",1,args,ret]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TAnonymous = function(fields) { var $x = ["TAnonymous",2,fields]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TParent = function(t) { var $x = ["TParent",3,t]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TExtend = function(p,fields) { var $x = ["TExtend",4,p,fields]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TOptional = function(t) { var $x = ["TOptional",5,t]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.TypeParam = $hxClasses["haxe.macro.TypeParam"] = { __ename__ : ["haxe","macro","TypeParam"], __constructs__ : ["TPType","TPExpr"] }
haxe.macro.TypeParam.TPType = function(t) { var $x = ["TPType",0,t]; $x.__enum__ = haxe.macro.TypeParam; $x.toString = $estr; return $x; }
haxe.macro.TypeParam.TPExpr = function(e) { var $x = ["TPExpr",1,e]; $x.__enum__ = haxe.macro.TypeParam; $x.toString = $estr; return $x; }
haxe.macro.Access = $hxClasses["haxe.macro.Access"] = { __ename__ : ["haxe","macro","Access"], __constructs__ : ["APublic","APrivate","AStatic","AOverride","ADynamic","AInline"] }
haxe.macro.Access.APublic = ["APublic",0];
haxe.macro.Access.APublic.toString = $estr;
haxe.macro.Access.APublic.__enum__ = haxe.macro.Access;
haxe.macro.Access.APrivate = ["APrivate",1];
haxe.macro.Access.APrivate.toString = $estr;
haxe.macro.Access.APrivate.__enum__ = haxe.macro.Access;
haxe.macro.Access.AStatic = ["AStatic",2];
haxe.macro.Access.AStatic.toString = $estr;
haxe.macro.Access.AStatic.__enum__ = haxe.macro.Access;
haxe.macro.Access.AOverride = ["AOverride",3];
haxe.macro.Access.AOverride.toString = $estr;
haxe.macro.Access.AOverride.__enum__ = haxe.macro.Access;
haxe.macro.Access.ADynamic = ["ADynamic",4];
haxe.macro.Access.ADynamic.toString = $estr;
haxe.macro.Access.ADynamic.__enum__ = haxe.macro.Access;
haxe.macro.Access.AInline = ["AInline",5];
haxe.macro.Access.AInline.toString = $estr;
haxe.macro.Access.AInline.__enum__ = haxe.macro.Access;
haxe.macro.FieldType = $hxClasses["haxe.macro.FieldType"] = { __ename__ : ["haxe","macro","FieldType"], __constructs__ : ["FVar","FFun","FProp"] }
haxe.macro.FieldType.FVar = function(t,e) { var $x = ["FVar",0,t,e]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.FieldType.FFun = function(f) { var $x = ["FFun",1,f]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.FieldType.FProp = function(get,set,t,e) { var $x = ["FProp",2,get,set,t,e]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.TypeDefKind = $hxClasses["haxe.macro.TypeDefKind"] = { __ename__ : ["haxe","macro","TypeDefKind"], __constructs__ : ["TDEnum","TDStructure","TDClass"] }
haxe.macro.TypeDefKind.TDEnum = ["TDEnum",0];
haxe.macro.TypeDefKind.TDEnum.toString = $estr;
haxe.macro.TypeDefKind.TDEnum.__enum__ = haxe.macro.TypeDefKind;
haxe.macro.TypeDefKind.TDStructure = ["TDStructure",1];
haxe.macro.TypeDefKind.TDStructure.toString = $estr;
haxe.macro.TypeDefKind.TDStructure.__enum__ = haxe.macro.TypeDefKind;
haxe.macro.TypeDefKind.TDClass = function(extend,implement,isInterface) { var $x = ["TDClass",2,extend,implement,isInterface]; $x.__enum__ = haxe.macro.TypeDefKind; $x.toString = $estr; return $x; }
haxe.macro.Error = $hxClasses["haxe.macro.Error"] = function(m,p) {
	this.message = m;
	this.pos = p;
};
haxe.macro.Error.__name__ = ["haxe","macro","Error"];
haxe.macro.Error.prototype = {
	pos: null
	,message: null
	,__class__: haxe.macro.Error
}
haxe.macro.Type = $hxClasses["haxe.macro.Type"] = { __ename__ : ["haxe","macro","Type"], __constructs__ : ["TMono","TEnum","TInst","TType","TFun","TAnonymous","TDynamic","TLazy"] }
haxe.macro.Type.TMono = function(t) { var $x = ["TMono",0,t]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TEnum = function(t,params) { var $x = ["TEnum",1,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TInst = function(t,params) { var $x = ["TInst",2,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TType = function(t,params) { var $x = ["TType",3,t,params]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TFun = function(args,ret) { var $x = ["TFun",4,args,ret]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TAnonymous = function(a) { var $x = ["TAnonymous",5,a]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TDynamic = function(t) { var $x = ["TDynamic",6,t]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.Type.TLazy = function(f) { var $x = ["TLazy",7,f]; $x.__enum__ = haxe.macro.Type; $x.toString = $estr; return $x; }
haxe.macro.ClassKind = $hxClasses["haxe.macro.ClassKind"] = { __ename__ : ["haxe","macro","ClassKind"], __constructs__ : ["KNormal","KTypeParameter","KExtension","KExpr","KGeneric","KGenericInstance","KMacroType"] }
haxe.macro.ClassKind.KNormal = ["KNormal",0];
haxe.macro.ClassKind.KNormal.toString = $estr;
haxe.macro.ClassKind.KNormal.__enum__ = haxe.macro.ClassKind;
haxe.macro.ClassKind.KTypeParameter = function(constraints) { var $x = ["KTypeParameter",1,constraints]; $x.__enum__ = haxe.macro.ClassKind; $x.toString = $estr; return $x; }
haxe.macro.ClassKind.KExtension = function(cl,params) { var $x = ["KExtension",2,cl,params]; $x.__enum__ = haxe.macro.ClassKind; $x.toString = $estr; return $x; }
haxe.macro.ClassKind.KExpr = function(expr) { var $x = ["KExpr",3,expr]; $x.__enum__ = haxe.macro.ClassKind; $x.toString = $estr; return $x; }
haxe.macro.ClassKind.KGeneric = ["KGeneric",4];
haxe.macro.ClassKind.KGeneric.toString = $estr;
haxe.macro.ClassKind.KGeneric.__enum__ = haxe.macro.ClassKind;
haxe.macro.ClassKind.KGenericInstance = function(cl,params) { var $x = ["KGenericInstance",5,cl,params]; $x.__enum__ = haxe.macro.ClassKind; $x.toString = $estr; return $x; }
haxe.macro.ClassKind.KMacroType = ["KMacroType",6];
haxe.macro.ClassKind.KMacroType.toString = $estr;
haxe.macro.ClassKind.KMacroType.__enum__ = haxe.macro.ClassKind;
haxe.macro.FieldKind = $hxClasses["haxe.macro.FieldKind"] = { __ename__ : ["haxe","macro","FieldKind"], __constructs__ : ["FVar","FMethod"] }
haxe.macro.FieldKind.FVar = function(read,write) { var $x = ["FVar",0,read,write]; $x.__enum__ = haxe.macro.FieldKind; $x.toString = $estr; return $x; }
haxe.macro.FieldKind.FMethod = function(k) { var $x = ["FMethod",1,k]; $x.__enum__ = haxe.macro.FieldKind; $x.toString = $estr; return $x; }
haxe.macro.VarAccess = $hxClasses["haxe.macro.VarAccess"] = { __ename__ : ["haxe","macro","VarAccess"], __constructs__ : ["AccNormal","AccNo","AccNever","AccResolve","AccCall","AccInline","AccRequire"] }
haxe.macro.VarAccess.AccNormal = ["AccNormal",0];
haxe.macro.VarAccess.AccNormal.toString = $estr;
haxe.macro.VarAccess.AccNormal.__enum__ = haxe.macro.VarAccess;
haxe.macro.VarAccess.AccNo = ["AccNo",1];
haxe.macro.VarAccess.AccNo.toString = $estr;
haxe.macro.VarAccess.AccNo.__enum__ = haxe.macro.VarAccess;
haxe.macro.VarAccess.AccNever = ["AccNever",2];
haxe.macro.VarAccess.AccNever.toString = $estr;
haxe.macro.VarAccess.AccNever.__enum__ = haxe.macro.VarAccess;
haxe.macro.VarAccess.AccResolve = ["AccResolve",3];
haxe.macro.VarAccess.AccResolve.toString = $estr;
haxe.macro.VarAccess.AccResolve.__enum__ = haxe.macro.VarAccess;
haxe.macro.VarAccess.AccCall = function(m) { var $x = ["AccCall",4,m]; $x.__enum__ = haxe.macro.VarAccess; $x.toString = $estr; return $x; }
haxe.macro.VarAccess.AccInline = ["AccInline",5];
haxe.macro.VarAccess.AccInline.toString = $estr;
haxe.macro.VarAccess.AccInline.__enum__ = haxe.macro.VarAccess;
haxe.macro.VarAccess.AccRequire = function(r) { var $x = ["AccRequire",6,r]; $x.__enum__ = haxe.macro.VarAccess; $x.toString = $estr; return $x; }
haxe.macro.MethodKind = $hxClasses["haxe.macro.MethodKind"] = { __ename__ : ["haxe","macro","MethodKind"], __constructs__ : ["MethNormal","MethInline","MethDynamic","MethMacro"] }
haxe.macro.MethodKind.MethNormal = ["MethNormal",0];
haxe.macro.MethodKind.MethNormal.toString = $estr;
haxe.macro.MethodKind.MethNormal.__enum__ = haxe.macro.MethodKind;
haxe.macro.MethodKind.MethInline = ["MethInline",1];
haxe.macro.MethodKind.MethInline.toString = $estr;
haxe.macro.MethodKind.MethInline.__enum__ = haxe.macro.MethodKind;
haxe.macro.MethodKind.MethDynamic = ["MethDynamic",2];
haxe.macro.MethodKind.MethDynamic.toString = $estr;
haxe.macro.MethodKind.MethDynamic.__enum__ = haxe.macro.MethodKind;
haxe.macro.MethodKind.MethMacro = ["MethMacro",3];
haxe.macro.MethodKind.MethMacro.toString = $estr;
haxe.macro.MethodKind.MethMacro.__enum__ = haxe.macro.MethodKind;
if(!haxe.rtti) haxe.rtti = {}
haxe.rtti.Meta = $hxClasses["haxe.rtti.Meta"] = function() { }
haxe.rtti.Meta.__name__ = ["haxe","rtti","Meta"];
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.rtti.Meta.getStatics = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.statics == null?{ }:meta.statics;
}
haxe.rtti.Meta.getFields = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.fields == null?{ }:meta.fields;
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
var stx = stx || {}
stx.Arrays = $hxClasses["stx.Arrays"] = function() { }
stx.Arrays.__name__ = ["stx","Arrays"];
stx.Arrays.foldl1 = function(a,mapper) {
	var folded = stx.Arrays.first(a);
	var $e = (stx.Iterables.tailOption(a));
	switch( $e[1] ) {
	case 1:
		var v = $e[2];
		var $it0 = $iterator(v)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			folded = mapper(folded,e);
		}
		break;
	default:
	}
	return folded;
}
stx.Arrays.partition = function(arr,f) {
	return SArrays.foldl(arr,new stx.Tuple2([],[]),function(a,b) {
		if(f(b)) a._1.push(b); else a._2.push(b);
		return a;
	});
}
stx.Arrays.partitionWhile = function(arr,f) {
	var partitioning = true;
	return SArrays.foldl(arr,new stx.Tuple2([],[]),function(a,b) {
		if(partitioning) {
			if(f(b)) a._1.push(b); else {
				partitioning = false;
				a._2.push(b);
			}
		} else a._2.push(b);
		return a;
	});
}
stx.Arrays.mapTo = function(src,dest,f) {
	return SArrays.foldl(src,SArrays.snapshot(dest),function(a,b) {
		a.push(f(b));
		return a;
	});
}
stx.Arrays.flatten = function(arrs) {
	var res = [];
	var _g = 0;
	while(_g < arrs.length) {
		var arr = arrs[_g];
		++_g;
		var _g1 = 0;
		while(_g1 < arr.length) {
			var e = arr[_g1];
			++_g1;
			res.push(e);
		}
	}
	return res;
}
stx.Arrays.interleave = function(alls) {
	var res = [];
	if(alls.length > 0) {
		var length = (function($this) {
			var $r;
			var minLength = stx.Ints.toFloat(alls[0].length);
			{
				var _g = 0;
				while(_g < alls.length) {
					var e = alls[_g];
					++_g;
					minLength = Math.min(minLength,stx.Ints.toFloat(e.length));
				}
			}
			$r = stx.Floats["int"](minLength);
			return $r;
		}(this));
		var i = 0;
		while(i < length) {
			var _g = 0;
			while(_g < alls.length) {
				var arr = alls[_g];
				++_g;
				res.push(arr[i]);
			}
			i++;
		}
	}
	return res;
}
stx.Arrays.flatMapTo = function(src,dest,f) {
	return SArrays.foldl(src,dest,function(a,b) {
		var _g = 0, _g1 = f(b);
		while(_g < _g1.length) {
			var e = _g1[_g];
			++_g;
			a.push(e);
		}
		return a;
	});
}
stx.Arrays.count = function(arr,f) {
	return SArrays.foldl(arr,0,function(a,b) {
		return a + (f(b)?1:0);
	});
}
stx.Arrays.countWhile = function(arr,f) {
	var counting = true;
	return SArrays.foldl(arr,0,function(a,b) {
		return !counting?a:f(b)?a + 1:(function($this) {
			var $r;
			counting = false;
			$r = a;
			return $r;
		}(this));
	});
}
stx.Arrays.scanl = function(arr,init,f) {
	var accum = init;
	var result = [init];
	var _g = 0;
	while(_g < arr.length) {
		var e = arr[_g];
		++_g;
		result.push(f(e,accum));
	}
	return result;
}
stx.Arrays.scanr = function(arr,init,f) {
	var a = SArrays.snapshot(arr);
	a.reverse();
	return stx.Arrays.scanl(a,init,f);
}
stx.Arrays.scanl1 = function(arr,f) {
	var result = [];
	if(0 == arr.length) return result;
	var accum = arr[0];
	result.push(accum);
	var _g1 = 1, _g = arr.length;
	while(_g1 < _g) {
		var i = _g1++;
		result.push(f(arr[i],accum));
	}
	return result;
}
stx.Arrays.scanr1 = function(arr,f) {
	var a = SArrays.snapshot(arr);
	a.reverse();
	return stx.Arrays.scanl1(a,f);
}
stx.Arrays.elements = function(arr) {
	return SArrays.snapshot(arr);
}
stx.Arrays.appendAll = function(arr,i) {
	var acc = SArrays.snapshot(arr);
	var $it0 = $iterator(i)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		acc.push(e);
	}
	return acc;
}
stx.Arrays.isEmpty = function(arr) {
	return arr.length == 0;
}
stx.Arrays.hasValues = function(arr) {
	return arr.length > 0;
}
stx.Arrays.find = function(arr,f) {
	return SArrays.foldl(arr,stx.Option.None,function(a,b) {
		return (function($this) {
			var $r;
			switch( (a)[1] ) {
			case 0:
				$r = stx.Options.filter(stx.Options.create(b),f);
				break;
			default:
				$r = a;
			}
			return $r;
		}(this));
	});
}
stx.Arrays.findIndexOf = function(arr,obj) {
	var index = stx.Arrays.indexOf(arr,obj);
	return index == -1?stx.Option.None:stx.Option.Some(index);
}
stx.Arrays.forAll = function(arr,f) {
	return SArrays.foldl(arr,true,function(a,b) {
		return (function($this) {
			var $r;
			switch(a) {
			case true:
				$r = f(b);
				break;
			case false:
				$r = false;
				break;
			}
			return $r;
		}(this));
	});
}
stx.Arrays.forAny = function(arr,f) {
	return SArrays.foldl(arr,false,function(a,b) {
		return (function($this) {
			var $r;
			switch(a) {
			case false:
				$r = f(b);
				break;
			case true:
				$r = true;
				break;
			}
			return $r;
		}(this));
	});
}
stx.Arrays.exists = function(arr,f) {
	return (function($this) {
		var $r;
		var $e = (stx.Arrays.find(arr,f));
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			$r = true;
			break;
		case 0:
			$r = false;
			break;
		}
		return $r;
	}(this));
}
stx.Arrays.existsP = function(arr,ref,f) {
	var result = false;
	var _g = 0;
	while(_g < arr.length) {
		var e = arr[_g];
		++_g;
		if(f(e,ref)) return true;
	}
	return false;
}
stx.Arrays.nubBy = function(arr,f) {
	return SArrays.foldl(arr,[],function(a,b) {
		return stx.Arrays.existsP(a,b,f)?a:stx.Arrays.append(a,b);
	});
}
stx.Arrays.nub = function(arr) {
	return stx.Arrays.nubBy(arr,stx.plus.Equal.getEqualFor(arr[0]));
}
stx.Arrays.intersectBy = function(arr1,arr2,f) {
	return SArrays.foldl(arr1,[],function(a,b) {
		return stx.Arrays.existsP(arr2,b,f)?stx.Arrays.append(a,b):a;
	});
}
stx.Arrays.intersect = function(arr1,arr2) {
	return stx.Arrays.intersectBy(arr1,arr2,stx.plus.Equal.getEqualFor(arr1[0]));
}
stx.Arrays.splitAt = function(srcArr,index) {
	return new stx.Tuple2(srcArr.slice(0,index),srcArr.slice(index));
}
stx.Arrays.indexOf = function(a,t) {
	var index = 0;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(e == t) return index;
		++index;
	}
	return -1;
}
stx.Arrays.mapWithIndex = function(a,f) {
	var n = [];
	var i = 0;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		n.push(f(e,i++));
	}
	return n;
}
stx.Arrays.then = function(a1,a2) {
	return a2;
}
stx.Arrays.foldr = function(a,z,f) {
	var r = z;
	var _g1 = 0, _g = a.length;
	while(_g1 < _g) {
		var i = _g1++;
		var e = a[a.length - 1 - i];
		r = f(e,r);
	}
	return r;
}
stx.Arrays.zip = function(a,b) {
	return stx.Arrays.zipWith(a,b,stx.Tuples.t2);
}
stx.Arrays.zipWith = function(a,b,f) {
	var len = Math.floor(Math.min(a.length,b.length));
	var r = [];
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		r.push(f(a[i],b[i]));
	}
	return r;
}
stx.Arrays.zipWithIndex = function(a) {
	return stx.Arrays.zipWithIndexWith(a,stx.Tuples.t2);
}
stx.Arrays.zipWithIndexWith = function(a,f) {
	var len = a.length;
	var r = [];
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		r.push(f(a[i],i));
	}
	return r;
}
stx.Arrays.append = function(a,t) {
	var copy = SArrays.snapshot(a);
	copy.push(t);
	return copy;
}
stx.Arrays.prepend = function(a,t) {
	var copy = SArrays.snapshot(a);
	copy.unshift(t);
	return copy;
}
stx.Arrays.first = function(a) {
	return a[0];
}
stx.Arrays.firstOption = function(a) {
	return a.length == 0?stx.Option.None:stx.Option.Some(a[0]);
}
stx.Arrays.last = function(a) {
	return a[a.length - 1];
}
stx.Arrays.lastOption = function(a) {
	return a.length == 0?stx.Option.None:stx.Option.Some(a[a.length - 1]);
}
stx.Arrays.has = function(a,t) {
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(t == e) return true;
	}
	return false;
}
stx.Arrays.foreachWithIndex = function(a,f) {
	var i = 0;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		f(e,i++);
	}
	return a;
}
stx.Arrays.take = function(a,n) {
	return a.slice(0,stx.Ints.min(n,a.length));
}
stx.Arrays.takeWhile = function(a,p) {
	var r = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(p(e)) r.push(e); else break;
	}
	return r;
}
stx.Arrays.drop = function(a,n) {
	return n >= a.length?[]:a.slice(n);
}
stx.Arrays.dropWhile = function(a,p) {
	var r = [].concat(a);
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(p(e)) r.shift(); else break;
	}
	return r;
}
stx.Arrays.reversed = function(arr) {
	return SIterables.foldl(arr,[],function(a,b) {
		a.unshift(b);
		return a;
	});
}
stx.Arrays.sliceBy = function(srcArr,sizeSrc) {
	return (function($this) {
		var $r;
		var slices = [];
		var restIndex = 0;
		{
			var _g = 0;
			while(_g < sizeSrc.length) {
				var size = sizeSrc[_g];
				++_g;
				var newRestIndex = restIndex + size;
				var slice = srcArr.slice(restIndex,newRestIndex);
				slices.push(slice);
				restIndex = newRestIndex;
			}
		}
		$r = slices;
		return $r;
	}(this));
}
stx.Arrays.fromHash = function(hash) {
	return SIterables.toArray(SIterables.map(SIterables.toIterable(hash.keys()),function(x) {
		return stx.Entuple.entuple(x,hash.get(x));
	}));
}
stx.Bools = $hxClasses["stx.Bools"] = function() { }
stx.Bools.__name__ = ["stx","Bools"];
stx.Bools.toInt = function(v) {
	return v?1:0;
}
stx.Bools.ifTrue = function(v,f) {
	return v?stx.Option.Some(f()):stx.Option.None;
}
stx.Bools.ifFalse = function(v,f) {
	return !v?stx.Option.Some(f()):stx.Option.None;
}
stx.Bools.ifElse = function(v,f1,f2) {
	return v?f1():f2();
}
stx.Bools.compare = function(v1,v2) {
	return !v1 && v2?-1:v1 && !v2?1:0;
}
stx.Bools.equals = function(v1,v2) {
	return v1 == v2;
}
stx.Bools.and = function(v1,v2) {
	return v1 && v2;
}
stx.Bools.or = function(v1,v2) {
	return v1 || v2;
}
stx.Bools.not = function(v) {
	return !v;
}
stx.Dates = $hxClasses["stx.Dates"] = function() { }
stx.Dates.__name__ = ["stx","Dates"];
stx.Dates.compare = function(v1,v2) {
	var diff = v1.getTime() - v2.getTime();
	return diff < 0?-1:diff > 0?1:0;
}
stx.Dates.equals = function(v1,v2) {
	return v1.getTime() == v2.getTime();
}
stx.Dates.toString = function(v) {
	return HxOverrides.dateStr(v);
}
stx.Dynamics = $hxClasses["stx.Dynamics"] = function() { }
stx.Dynamics.__name__ = ["stx","Dynamics"];
stx.Dynamics.withEffect = function(t,f) {
	f(t);
	return t;
}
stx.Dynamics.withEffectP = function(a,f) {
	f(a);
	return a;
}
stx.Dynamics.into = function(a,f) {
	return f(a);
}
stx.Dynamics.memoize = function(t) {
	var evaled = false;
	var result = null;
	return function() {
		if(!evaled) {
			evaled = true;
			result = t();
		}
		return result;
	};
}
stx.Dynamics.toThunk = function(t) {
	return function() {
		return t;
	};
}
stx.Dynamics.toConstantFunction = function(t) {
	return function(s) {
		return t;
	};
}
stx.Dynamics.apply = function(v,fn) {
	fn(v);
}
stx.Dynamics.then = function(a,b) {
	return b;
}
stx.Eithers = $hxClasses["stx.Eithers"] = function() { }
stx.Eithers.__name__ = ["stx","Eithers"];
stx.Eithers.toLeft = function(v) {
	return stx.Either.Left(v);
}
stx.Eithers.toRight = function(v) {
	return stx.Either.Right(v);
}
stx.Eithers.flip = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = stx.Either.Right(v);
			break;
		case 1:
			var v = $e[2];
			$r = stx.Either.Left(v);
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.left = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = stx.Option.Some(v);
			break;
		default:
			$r = stx.Option.None;
		}
		return $r;
	}(this));
}
stx.Eithers.isLeft = function(e) {
	return (function($this) {
		var $r;
		switch( (e)[1] ) {
		case 0:
			$r = true;
			break;
		case 1:
			$r = false;
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.right = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			$r = stx.Option.Some(v);
			break;
		default:
			$r = stx.Option.None;
		}
		return $r;
	}(this));
}
stx.Eithers.isRight = function(e) {
	return (function($this) {
		var $r;
		switch( (e)[1] ) {
		case 0:
			$r = false;
			break;
		case 1:
			$r = true;
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.get = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = v;
			break;
		case 1:
			var v = $e[2];
			$r = v;
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.mapLeft = function(e,f) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = stx.Either.Left(f(v));
			break;
		case 1:
			var v = $e[2];
			$r = stx.Either.Right(v);
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.map = function(e,f1,f2) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = stx.Either.Left(f1(v));
			break;
		case 1:
			var v = $e[2];
			$r = stx.Either.Right(f2(v));
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.mapR = function(e,f) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = stx.Either.Left(v);
			break;
		case 1:
			var v = $e[2];
			$r = stx.Either.Right(f(v));
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.flatMap = function(e,f1,f2) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = f1(v);
			break;
		case 1:
			var v = $e[2];
			$r = f2(v);
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.flatMapR = function(e,f) {
	return stx.Eithers.flatMap(e,stx.Eithers.toLeft,f);
}
stx.Eithers.composeLeft = function(e1,e2,ac,bc) {
	return (function($this) {
		var $r;
		var $e = (e1);
		switch( $e[1] ) {
		case 0:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (e2);
				switch( $e[1] ) {
				case 0:
					var v2 = $e[2];
					$r = stx.Either.Left(ac(v1,v2));
					break;
				case 1:
					var v2 = $e[2];
					$r = stx.Either.Left(v1);
					break;
				}
				return $r;
			}($this));
			break;
		case 1:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (e2);
				switch( $e[1] ) {
				case 0:
					var v2 = $e[2];
					$r = stx.Either.Left(v2);
					break;
				case 1:
					var v2 = $e[2];
					$r = stx.Either.Right(bc(v1,v2));
					break;
				}
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.Eithers.composeRight = function(e1,e2,ac,bc) {
	return (function($this) {
		var $r;
		var $e = (e1);
		switch( $e[1] ) {
		case 0:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (e2);
				switch( $e[1] ) {
				case 0:
					var v2 = $e[2];
					$r = stx.Either.Left(ac(v1,v2));
					break;
				case 1:
					var v2 = $e[2];
					$r = stx.Either.Right(v2);
					break;
				}
				return $r;
			}($this));
			break;
		case 1:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (e2);
				switch( $e[1] ) {
				case 0:
					var v2 = $e[2];
					$r = stx.Either.Right(v1);
					break;
				case 1:
					var v2 = $e[2];
					$r = stx.Either.Right(bc(v1,v2));
					break;
				}
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.Enums = $hxClasses["stx.Enums"] = function() {
};
stx.Enums.__name__ = ["stx","Enums"];
stx.Enums.create = function(e,constr,params) {
	return Type.createEnum(e,constr,params);
}
stx.Enums.ofIndex = function(e,index) {
	return stx.Enums.constructors(e)[index];
}
stx.Enums.indexOf = function(e) {
	return e[1];
}
stx.Enums.constructorOf = function(value) {
	return value[0];
}
stx.Enums.equals = function(a,b) {
	return Type.enumEq(a,b);
}
stx.Enums.params = function(value) {
	return value.slice(2);
}
stx.Enums.ofValue = function(value) {
	return Type.getEnum(value);
}
stx.Enums.constructors = function(e) {
	return Type.getEnumConstructs(e);
}
stx.Enums.nameOf = function(e) {
	return Type.getEnumName(e);
}
stx.Enums.enumOf = function(name) {
	return Type.resolveEnum(name);
}
stx.Enums.alike = function(e1,e2) {
	return stx.Enums.indexOf(e1) == stx.Enums.indexOf(e2);
}
stx.Enums.prototype = {
	__class__: stx.Enums
}
stx.CodeBlocks = $hxClasses["stx.CodeBlocks"] = function() { }
stx.CodeBlocks.__name__ = ["stx","CodeBlocks"];
stx.CodeBlocks.returningC = function(c,val) {
	return function() {
		c();
		return val;
	};
}
stx.CodeBlocks.catching = function(c) {
	var o = null;
	try {
		o = stx.Either.Right(c());
	} catch( $e0 ) {
		if( js.Boot.__instanceof($e0,stx.error.Error) ) {
			var e = $e0;
			o = stx.Either.Left(e);
		} else {
		var e = $e0;
		o = stx.Either.Left(new stx.error.Error(e,{ fileName : "Functions.hx", lineNumber : 32, className : "stx.CodeBlocks", methodName : "catching"}));
		}
	}
	return o;
}
stx.CodeBlocks.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions0 = $hxClasses["stx.Functions0"] = function() { }
stx.Functions0.__name__ = ["stx","Functions0"];
stx.Functions0.enclose = function(f) {
	return function() {
		f();
	};
}
stx.Functions0.swallow = function(f) {
	return function() {
		try {
			f();
		} catch( e ) {
		}
	};
}
stx.Functions0.thenDo = function(f1,f2) {
	return function() {
		f1();
		f2();
	};
}
stx.Functions0.returning = function(f,thunk) {
	return function() {
		f();
		return thunk();
	};
}
stx.Functions0.returningC = function(f,value) {
	return stx.Functions0.returning(f,stx.Dynamics.toThunk(value));
}
stx.Functions0.promote = function(f) {
	return function(a) {
		return f();
	};
}
stx.Functions0.promoteEffect = function(f) {
	return function(a) {
		f();
	};
}
stx.Functions0.stage = function(f,before,after) {
	var state = before();
	var result = f();
	after(state);
	return result;
}
stx.Functions0.toEffect = function(f) {
	return function() {
		f();
	};
}
stx.Functions0.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions0.andThen = function(a,b) {
	return function() {
		return b(a());
	};
}
stx.Functions1 = $hxClasses["stx.Functions1"] = function() { }
stx.Functions1.__name__ = ["stx","Functions1"];
stx.Functions1.curry = function(f) {
	return function() {
		return function(p1) {
			return f(p1);
		};
	};
}
stx.Functions1.swallow = function(f) {
	return stx.Functions1.toEffect(stx.Functions1.swallowWith(f,null));
}
stx.Functions1.swallowWith = function(f,d) {
	return function(a) {
		try {
			return f(a);
		} catch( e ) {
		}
		return d;
	};
}
stx.Functions1.thenDo = function(f1,f2) {
	return function(p1) {
		f1(p1);
		f2(p1);
	};
}
stx.Functions1.returning = function(f,thunk) {
	return function(p1) {
		f(p1);
		return thunk();
	};
}
stx.Functions1.returningC = function(f,value) {
	return stx.Functions1.returning(f,stx.Dynamics.toThunk(value));
}
stx.Functions1.compose = function(f1,f2) {
	return function(u) {
		return f1(f2(u));
	};
}
stx.Functions1.andThen = function(f1,f2) {
	return stx.Functions1.compose(f2,f1);
}
stx.Functions1.lazy = function(f,p1) {
	var r = null;
	return function() {
		return r == null?(function($this) {
			var $r;
			r = f(p1);
			$r = r;
			return $r;
		}(this)):r;
	};
}
stx.Functions1.toEffect = function(f) {
	return function(p1) {
		f(p1);
	};
}
stx.Functions1.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions2 = $hxClasses["stx.Functions2"] = function() { }
stx.Functions2.__name__ = ["stx","Functions2"];
stx.Functions2.ccw = function(f) {
	return function(p2,p1) {
		return f(p1,p2);
	};
}
stx.Functions2.p1 = function(f,p1) {
	return (stx.Functions2.curry(f))(p1);
}
stx.Functions2.p2 = function(f,p2) {
	return (stx.Functions2.curry(stx.Functions2.flip(f)))(p2);
}
stx.Functions2.swallow = function(f) {
	return stx.Functions2.toEffect(stx.Functions2.swallowWith(f,null));
}
stx.Functions2.swallowWith = function(f,d) {
	return function(p1,p2) {
		try {
			return f(p1,p2);
		} catch( e ) {
		}
		return d;
	};
}
stx.Functions2.thenDo = function(f1,f2) {
	return function(p1,p2) {
		f1(p1,p2);
		f2(p1,p2);
	};
}
stx.Functions2.returning = function(f,thunk) {
	return function(p1,p2) {
		f(p1,p2);
		return thunk();
	};
}
stx.Functions2.andThen = function(f1,f2) {
	return function(u,v) {
		return f2(f1(u,v));
	};
}
stx.Functions2.returningC = function(f,value) {
	return stx.Functions2.returning(f,value.toThunk());
}
stx.Functions2.flip = function(f) {
	return function(p2,p1) {
		return f(p1,p2);
	};
}
stx.Functions2.curry = function(f) {
	return function(p1) {
		return function(p2) {
			return f(p1,p2);
		};
	};
}
stx.Functions2.uncurry = function(f) {
	return function(p1,p2) {
		return (f(p1))(p2);
	};
}
stx.Functions2.lazy = function(f,p1,p2) {
	var r = null;
	return function() {
		return r == null?r = f(p1,p2):r;
	};
}
stx.Functions2.defer = function(f,p1,p2) {
	return function() {
		return f(p1,p2);
	};
}
stx.Functions2.toEffect = function(f) {
	return function(p1,p2) {
		f(p1,p2);
	};
}
stx.Functions2.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions3 = $hxClasses["stx.Functions3"] = function() { }
stx.Functions3.__name__ = ["stx","Functions3"];
stx.Functions3.ccw = function(f) {
	return function(p2,p3,p1) {
		return f(p1,p2,p3);
	};
}
stx.Functions3.a2 = function(f,p1,p2) {
	return function(p3) {
		return f(p1,p2,p3);
	};
}
stx.Functions3.p1 = function(f,p1) {
	return function(p2,p3) {
		return f(p1,p2,p3);
	};
}
stx.Functions3.p2 = function(f,p2) {
	return function(p1,p3) {
		return f(p1,p2,p3);
	};
}
stx.Functions3.p3 = function(f,p3) {
	return function(p1,p2) {
		return f(p1,p2,p3);
	};
}
stx.Functions3.swallow = function(f) {
	return stx.Functions3.toEffect(stx.Functions3.swallowWith(f,null));
}
stx.Functions3.swallowWith = function(f,d) {
	return function(a,b,c) {
		try {
			return f(a,b,c);
		} catch( e ) {
		}
		return d;
	};
}
stx.Functions3.thenDo = function(f1,f2) {
	return function(p1,p2,p3) {
		f1(p1,p2,p3);
		f2(p1,p2,p3);
	};
}
stx.Functions3.returning = function(f,thunk) {
	return function(p1,p2,p3) {
		f(p1,p2,p3);
		return thunk();
	};
}
stx.Functions3.returningC = function(f,value) {
	return stx.Functions3.returning(f,value.toThunk());
}
stx.Functions3.curry = function(f) {
	return function(p1) {
		return function(p2) {
			return function(p3) {
				return f(p1,p2,p3);
			};
		};
	};
}
stx.Functions3.uncurry = function(f) {
	return function(p1,p2,p3) {
		return ((f(p1))(p2))(p3);
	};
}
stx.Functions3.lazy = function(f,p1,p2,p3) {
	var r = null;
	return function() {
		return r == null?(function($this) {
			var $r;
			r = f(p1,p2,p3);
			$r = r;
			return $r;
		}(this)):r;
	};
}
stx.Functions3.toEffect = function(f) {
	return function(p1,p2,p3) {
		f(p1,p2,p3);
	};
}
stx.Functions3.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions4 = $hxClasses["stx.Functions4"] = function() { }
stx.Functions4.__name__ = ["stx","Functions4"];
stx.Functions4.ccw = function(f) {
	return function(p2,p3,p4,p1) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.a2 = function(f,p1,p2) {
	return function(p3,p4) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.a3 = function(f,p1,p2,p3) {
	return function(p4) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.swallow = function(f) {
	return stx.Functions4.toEffect(stx.Functions4.swallowWith(f,null));
}
stx.Functions4.swallowWith = function(f,def) {
	return function(a,b,c,d) {
		try {
			return f(a,b,c,d);
		} catch( e ) {
		}
		return def;
	};
}
stx.Functions4.thenDo = function(f1,f2) {
	return function(p1,p2,p3,p4) {
		f1(p1,p2,p3,p4);
		f2(p1,p2,p3,p4);
	};
}
stx.Functions4.returning = function(f,thunk) {
	return function(p1,p2,p3,p4) {
		f(p1,p2,p3,p4);
		return thunk();
	};
}
stx.Functions4.returningC = function(f,value) {
	return stx.Functions4.returning(f,value.toThunk());
}
stx.Functions4.curry = function(f) {
	return function(p1) {
		return function(p2) {
			return function(p3) {
				return function(p4) {
					return f(p1,p2,p3,p4);
				};
			};
		};
	};
}
stx.Functions4.uncurry = function(f) {
	return function(p1,p2,p3,p4) {
		return (((f(p1))(p2))(p3))(p4);
	};
}
stx.Functions4.lazy = function(f,p1,p2,p3,p4) {
	var r = null;
	return function() {
		return r == null?(function($this) {
			var $r;
			r = f(p1,p2,p3,p4);
			$r = r;
			return $r;
		}(this)):r;
	};
}
stx.Functions4.toEffect = function(f) {
	return function(p1,p2,p3,p4) {
		f(p1,p2,p3,p4);
	};
}
stx.Functions4.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions4.p1 = function(f,p1) {
	return function(p2,p3,p4) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.p2 = function(f,p2) {
	return function(p1,p3,p4) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.p3 = function(f,p3) {
	return function(p1,p2,p4) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions4.p4 = function(f,p4) {
	return function(p1,p2,p3) {
		return f(p1,p2,p3,p4);
	};
}
stx.Functions5 = $hxClasses["stx.Functions5"] = function() { }
stx.Functions5.__name__ = ["stx","Functions5"];
stx.Functions5.ccw = function(f) {
	return function(p2,p3,p4,p5,p1) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.a2 = function(f,p1,p2) {
	return function(p3,p4,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.a3 = function(f,p1,p2,p3) {
	return function(p4,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.a4 = function(f,p1,p2,p3,p4) {
	return function(p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.swallow = function(f) {
	return stx.Functions5.toEffect(stx.Functions5.swallowWith(f,null));
}
stx.Functions5.swallowWith = function(f,def) {
	return function(a,b,c,d,e) {
		try {
			return f(a,b,c,d,e);
		} catch( e1 ) {
		}
		return def;
	};
}
stx.Functions5.thenDo = function(f1,f2) {
	return function(p1,p2,p3,p4,p5) {
		f1(p1,p2,p3,p4,p5);
		f2(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.returning = function(f,thunk) {
	return function(p1,p2,p3,p4,p5) {
		f(p1,p2,p3,p4,p5);
		return thunk();
	};
}
stx.Functions5.returningC = function(f,value) {
	return stx.Functions5.returning(f,value.toThunk());
}
stx.Functions5.curry = function(f) {
	return function(p1) {
		return function(p2) {
			return function(p3) {
				return function(p4) {
					return function(p5) {
						return f(p1,p2,p3,p4,p5);
					};
				};
			};
		};
	};
}
stx.Functions5.uncurry = function(f) {
	return function(p1,p2,p3,p4,p5) {
		return ((((f(p1))(p2))(p3))(p4))(p5);
	};
}
stx.Functions5.lazy = function(f,p1,p2,p3,p4,p5) {
	var r = null;
	return function() {
		return r == null?(function($this) {
			var $r;
			r = f(p1,p2,p3,p4,p5);
			$r = r;
			return $r;
		}(this)):r;
	};
}
stx.Functions5.toEffect = function(f) {
	return function(p1,p2,p3,p4,p5) {
		f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions5.p1 = function(f,p1) {
	return function(p2,p3,p4,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.p2 = function(f,p2) {
	return function(p1,p3,p4,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.p3 = function(f,p3) {
	return function(p1,p2,p4,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.p4 = function(f,p4) {
	return function(p1,p2,p3,p5) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions5.p5 = function(f,p5) {
	return function(p1,p2,p3,p4) {
		return f(p1,p2,p3,p4,p5);
	};
}
stx.Functions6 = $hxClasses["stx.Functions6"] = function() { }
stx.Functions6.__name__ = ["stx","Functions6"];
stx.Functions6.curry = function(f) {
	return function(p1) {
		return function(p2) {
			return function(p3) {
				return function(p4) {
					return function(p5) {
						return function(p6) {
							return f(p1,p2,p3,p4,p5,p6);
						};
					};
				};
			};
		};
	};
}
stx.Future = $hxClasses["stx.Future"] = function() {
	this._listeners = [];
	this._result = null;
	this._isSet = false;
	this._isCanceled = false;
	this._cancelers = [];
	this._canceled = [];
};
stx.Future.__name__ = ["stx","Future"];
stx.Future.dead = function() {
	return stx.Dynamics.withEffect(new stx.Future(),function(future) {
		future.cancel();
	});
}
stx.Future.create = function() {
	return new stx.Future();
}
stx.Future.toFuture = function(t) {
	return stx.Future.create().deliver(t,{ fileName : "Future.hx", lineNumber : 292, className : "stx.Future", methodName : "toFuture"});
}
stx.Future.pure = function(v) {
	return stx.Future.toFuture(v);
}
stx.Future.waitFor = function(toJoin) {
	var joinLen = SArrays.size(toJoin), myprm = stx.Future.create(), combined = [], sequence = 0;
	SArrays.foreach(toJoin,function(xprm) {
		if(!js.Boot.__instanceof(xprm,stx.Future)) throw "not a promise:" + Std.string(xprm);
		xprm.sequence = sequence++;
		xprm.deliverMe(function(r) {
			combined.push({ seq : r.sequence, val : r._result});
			if(combined.length == joinLen) {
				combined.sort(function(x,y) {
					return x.seq - y.seq;
				});
				myprm.deliver(SArrays.map(combined,function(el) {
					return el.val;
				}),{ fileName : "Future.hx", lineNumber : 325, className : "stx.Future", methodName : "waitFor"});
			}
		});
	});
	return myprm;
}
stx.Future.futureOf = function(a) {
	return new stx.Future().deliver(a,{ fileName : "Future.hx", lineNumber : 332, className : "stx.Future", methodName : "futureOf"});
}
stx.Future.prototype = {
	deliverMe: function(f) {
		var _g = this;
		if(this.isCanceled()) return this; else if(this.isDelivered()) f(this); else this._listeners.push(function(g) {
			f(_g);
		});
		return this;
	}
	,forceCancel: function() {
		if(!this._isCanceled) {
			this._isCanceled = true;
			var _g = 0, _g1 = this._canceled;
			while(_g < _g1.length) {
				var canceled = _g1[_g];
				++_g;
				canceled();
			}
		}
		return this;
	}
	,toArray: function() {
		return stx.Options.toArray(this.value());
	}
	,toOption: function() {
		return this.value();
	}
	,value: function() {
		return this._isSet?stx.Option.Some(this._result):stx.Option.None;
	}
	,zipWith: function(f2,fn) {
		var zipped = new stx.Future();
		var f1 = this;
		var deliverZip = function() {
			if(f1.isDelivered() && f2.isDelivered()) zipped.deliver(fn(stx.Options.get(f1.value()),stx.Options.get(f2.value())),{ fileName : "Future.hx", lineNumber : 247, className : "stx.Future", methodName : "zipWith"});
		};
		f1.deliverTo(function(v) {
			deliverZip();
		});
		f2.deliverTo(function(v) {
			deliverZip();
		});
		zipped.allowCancelOnlyIf(function() {
			return f1.cancel() || f2.cancel();
		});
		f1.ifCanceled(function() {
			zipped.forceCancel();
		});
		f2.ifCanceled(function() {
			zipped.forceCancel();
		});
		return zipped;
	}
	,zip: function(f2) {
		return this.zipWith(f2,stx.Tuples.t2);
	}
	,filter: function(f) {
		var fut = new stx.Future();
		this.deliverTo(function(t) {
			if(f(t)) fut.deliver(t,{ fileName : "Future.hx", lineNumber : 224, className : "stx.Future", methodName : "filter"}); else fut.forceCancel();
		});
		this.ifCanceled(function() {
			fut.forceCancel();
		});
		return fut;
	}
	,flatMap: function(f) {
		var fut = new stx.Future();
		this.deliverTo(function(t) {
			f(t).deliverTo(function(s) {
				fut.deliver(s,{ fileName : "Future.hx", lineNumber : 205, className : "stx.Future", methodName : "flatMap"});
			}).ifCanceled(function() {
				fut.forceCancel();
			});
		});
		this.ifCanceled(function() {
			fut.forceCancel();
		});
		return fut;
	}
	,then: function(f) {
		return f;
	}
	,map: function(f) {
		var fut = new stx.Future();
		this.deliverTo(function(t) {
			fut.deliver(f(t),{ fileName : "Future.hx", lineNumber : 173, className : "stx.Future", methodName : "map"});
		});
		this.ifCanceled(function() {
			fut.forceCancel();
		});
		return fut;
	}
	,foreach: function(f) {
		return this.deliverTo(f);
	}
	,deliverTo: function(f) {
		if(this.isCanceled()) return this; else if(this.isDelivered()) f(this._result); else this._listeners.push(f);
		return this;
	}
	,isCanceled: function() {
		return this._isCanceled;
	}
	,isDelivered: function() {
		return this._isSet;
	}
	,isDone: function() {
		return this.isDelivered() || this.isCanceled();
	}
	,cancel: function() {
		return this.isDone()?false:this.isCanceled()?true:(function($this) {
			var $r;
			var r = true;
			{
				var _g = 0, _g1 = $this._cancelers;
				while(_g < _g1.length) {
					var canceller = _g1[_g];
					++_g;
					r = r && canceller();
				}
			}
			if(r) $this.forceCancel();
			$r = r;
			return $r;
		}(this));
	}
	,ifCanceled: function(f) {
		if(this.isCanceled()) f(); else if(!this.isDone()) this._canceled.push(f);
		return this;
	}
	,allowCancelOnlyIf: function(f) {
		if(!this.isDone()) this._cancelers.push(f);
		return this;
	}
	,deliver: function(t,pos) {
		return this._isCanceled?this:this._isSet?SBase.error("Future :" + Std.string(this.value()) + " already delivered at " + stx.error.Positions.toString(pos),{ fileName : "Future.hx", lineNumber : 57, className : "stx.Future", methodName : "deliver"}):(function($this) {
			var $r;
			$this._result = t;
			$this._isSet = true;
			{
				var _g = 0, _g1 = $this._listeners;
				while(_g < _g1.length) {
					var l = _g1[_g];
					++_g;
					l($this._result);
				}
			}
			$this._listeners = [];
			$r = $this;
			return $r;
		}(this));
	}
	,isEmpty: function() {
		return this._listeners.length == 0;
	}
	,_canceled: null
	,_cancelers: null
	,_isCanceled: null
	,_isSet: null
	,_result: null
	,_listeners: null
	,__class__: stx.Future
}
stx.Hashes = $hxClasses["stx.Hashes"] = function() { }
stx.Hashes.__name__ = ["stx","Hashes"];
stx.Hashes.fromHash = function(h) {
	return SIterables.map(SIterables.toIterable(h.keys()),function(x) {
		var val = h.get(x);
		return stx.Entuple.entuple(x,val);
	});
}
stx.Hashes.hasAllKeys = function(h,keys) {
	var ok = true;
	var _g = 0;
	while(_g < keys.length) {
		var val = keys[_g];
		++_g;
		if(!h.exists(val)) {
			ok = false;
			break;
		}
	}
	return ok;
}
stx.Hashes.hasAnyKey = function(h,entries) {
	var _g = 0;
	while(_g < entries.length) {
		var val = entries[_g];
		++_g;
		if(h.exists(val)) return true;
	}
	return false;
}
stx.Iterables = $hxClasses["stx.Iterables"] = function() { }
stx.Iterables.__name__ = ["stx","Iterables"];
stx.Iterables.foldl1 = function(iter,mapper) {
	var folded = stx.Iterables.head(iter);
	var $e = (stx.Iterables.tailOption(iter));
	switch( $e[1] ) {
	case 1:
		var v = $e[2];
		var $it0 = $iterator(v)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			folded = mapper(folded,e);
		}
		break;
	default:
	}
	return folded;
}
stx.Iterables.concat = function(iter1,iter2) {
	return SIterables.toArray(iter1).concat(SIterables.toArray(iter2));
}
stx.Iterables.foldr = function(iterable,z,f) {
	return stx.Arrays.foldr(SIterables.toArray(iterable),z,f);
}
stx.Iterables.headOption = function(iter) {
	var iterator = $iterator(iter)();
	return iterator.hasNext()?(function($this) {
		var $r;
		var o = iterator.next();
		$r = stx.Option.Some(o);
		return $r;
	}(this)):stx.Option.None;
}
stx.Iterables.head = function(iter) {
	return (function($this) {
		var $r;
		var $e = (stx.Iterables.headOption(iter));
		switch( $e[1] ) {
		case 0:
			$r = SBase.error("Iterable has no head",{ fileName : "Iterables.hx", lineNumber : 50, className : "stx.Iterables", methodName : "head"});
			break;
		case 1:
			var h = $e[2];
			$r = h;
			break;
		}
		return $r;
	}(this));
}
stx.Iterables.tailOption = function(iter) {
	var iterator = $iterator(iter)();
	return !iterator.hasNext()?stx.Option.None:stx.Option.Some(stx.Iterables.drop(iter,1));
}
stx.Iterables.tail = function(iter) {
	return (function($this) {
		var $r;
		var $e = (stx.Iterables.tailOption(iter));
		switch( $e[1] ) {
		case 0:
			$r = SBase.error("Iterable has no tail",{ fileName : "Iterables.hx", lineNumber : 70, className : "stx.Iterables", methodName : "tail"});
			break;
		case 1:
			var t = $e[2];
			$r = t;
			break;
		}
		return $r;
	}(this));
}
stx.Iterables.drop = function(iter,n) {
	var iterator = $iterator(iter)();
	while(iterator.hasNext() && n > 0) {
		iterator.next();
		--n;
	}
	var result = [];
	while(iterator.hasNext()) result.push(iterator.next());
	return result;
}
stx.Iterables.dropWhile = function(iter,p) {
	var r = stx.Iterables.appendAll([],iter);
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(p(e)) {
			var $e = (stx.Iterables.tailOption(r));
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				r = v;
				break;
			default:
				r = [];
			}
		} else break;
	}
	return r;
}
stx.Iterables.take = function(iter,n) {
	var iterator = $iterator(iter)();
	var result = [];
	var _g1 = 0, _g = n;
	while(_g1 < _g) {
		var i = _g1++;
		if(iterator.hasNext()) result.push(iterator.next());
	}
	return result;
}
stx.Iterables.takeWhile = function(a,p) {
	var r = [];
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(p(e)) r.push(e); else break;
	}
	return r;
}
stx.Iterables.exists = function(iter,fn) {
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var element = $it0.next();
		if(fn(element)) return true;
	}
	return false;
}
stx.Iterables.has = function(iter,value,eq) {
	if(eq == null) eq = stx.plus.Equal.getEqualFor(value);
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var el = $it0.next();
		if(eq(value,el)) return true;
	}
	return false;
}
stx.Iterables.nubBy = function(iter,f) {
	return SIterables.foldl(iter,[],function(a,b) {
		return stx.Iterables.existsP(a,b,f)?a:(function($this) {
			var $r;
			a.push(b);
			$r = a;
			return $r;
		}(this));
	});
}
stx.Iterables.nub = function(iter) {
	var result = [];
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var element = $it0.next();
		if(!stx.Iterables.has(result,element,stx.plus.Equal.getEqualFor(stx.Iterables.head(iter)))) result.push(element);
	}
	return result;
}
stx.Iterables.at = function(iter,index) {
	var result = null;
	if(index < 0) index = SIterables.size(iter) - -1 * index;
	var curIndex = 0;
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(index == curIndex) return e; else ++curIndex;
	}
	return SBase.error("Index not found",{ fileName : "Iterables.hx", lineNumber : 196, className : "stx.Iterables", methodName : "at"});
}
stx.Iterables.flatten = function(iter) {
	var empty = [];
	return SIterables.foldl(iter,empty,stx.Iterables.concat);
}
stx.Iterables.interleave = function(iter) {
	var alls = SIterables.toArray(SIterables.map(iter,function(it) {
		return $iterator(it)();
	}));
	var res = [];
	while(stx.Arrays.forAll(alls,function(iter1) {
		return iter1.hasNext();
	})) SArrays.foreach(alls,function(iter1) {
		res.push(iter1.next());
	});
	return res;
}
stx.Iterables.zip = function(iter1,iter2) {
	var i1 = $iterator(iter1)();
	var i2 = $iterator(iter2)();
	var result = [];
	while(i1.hasNext() && i2.hasNext()) {
		var t1 = i1.next();
		var t2 = i2.next();
		result.push(new stx.Tuple2(t1,t2));
	}
	return result;
}
stx.Iterables.zipup = function(tuple) {
	var i1 = $iterator(tuple._1)();
	var i2 = $iterator(tuple._2)();
	var result = [];
	while(i1.hasNext() && i2.hasNext()) {
		var t1 = i1.next();
		var t2 = i2.next();
		result.push(new stx.Tuple2(t1,t2));
	}
	return result;
}
stx.Iterables.append = function(iter,e) {
	return stx.Iterables.foldr(iter,[e],function(a,b) {
		b.unshift(a);
		return b;
	});
}
stx.Iterables.cons = function(iter,e) {
	return SIterables.foldl(iter,[e],function(b,a) {
		b.push(a);
		return b;
	});
}
stx.Iterables.reversed = function(iter) {
	return SIterables.foldl(iter,[],function(a,b) {
		a.unshift(b);
		return a;
	});
}
stx.Iterables.and = function(iter) {
	var iterator = $iterator(iter)();
	while(iterator.hasNext()) {
		var element = iterator.next();
		if(element == false) return false;
	}
	return true;
}
stx.Iterables.or = function(iter) {
	var iterator = $iterator(iter)();
	while(iterator.hasNext()) if(iterator.next() == true) return true;
	return false;
}
stx.Iterables.scanl = function(iter,init,f) {
	var result = [init];
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		result.push(f(e,init));
	}
	return result;
}
stx.Iterables.scanr = function(iter,init,f) {
	return stx.Iterables.scanl(stx.Iterables.reversed(iter),init,f);
}
stx.Iterables.scanl1 = function(iter,f) {
	var iterator = $iterator(iter)();
	var result = [];
	if(!iterator.hasNext()) return result;
	var accum = iterator.next();
	result.push(accum);
	while(iterator.hasNext()) result.push(f(iterator.next(),accum));
	return result;
}
stx.Iterables.scanr1 = function(iter,f) {
	return stx.Iterables.scanl1(stx.Iterables.reversed(iter),f);
}
stx.Iterables.existsP = function(iter,ref,f) {
	var result = false;
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(f(ref,e)) result = true;
	}
	return result;
}
stx.Iterables.intersectBy = function(iter1,iter2,f) {
	return SIterables.foldl(iter1,[],function(a,b) {
		return stx.Iterables.existsP(iter2,b,f)?stx.Iterables.append(a,b):a;
	});
}
stx.Iterables.intersect = function(iter1,iter2) {
	return SIterables.foldl(iter1,[],function(a,b) {
		return stx.Iterables.existsP(iter2,b,stx.plus.Equal.getEqualFor(stx.Iterables.head(iter1)))?stx.Iterables.append(a,b):a;
	});
}
stx.Iterables.unionBy = function(iter1,iter2,f) {
	var result = iter1;
	var $it0 = $iterator(iter2)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		var exists = false;
		var $it1 = $iterator(iter1)();
		while( $it1.hasNext() ) {
			var i = $it1.next();
			if(f(i,e)) exists = true;
		}
		if(!exists) result = stx.Iterables.append(result,e);
	}
	return result;
}
stx.Iterables.union = function(iter1,iter2) {
	return stx.Iterables.unionBy(iter1,iter2,stx.plus.Equal.getEqualFor(stx.Iterables.head(iter1)));
}
stx.Iterables.partition = function(iter,f) {
	return stx.Arrays.partition(SIterables.toArray(iter),f);
}
stx.Iterables.partitionWhile = function(iter,f) {
	return stx.Iterables.partitionWhile(SIterables.toArray(iter),f);
}
stx.Iterables.count = function(iter,f) {
	return stx.Iterables.count(SIterables.toArray(iter),f);
}
stx.Iterables.countWhile = function(iter,f) {
	return stx.Iterables.countWhile(SIterables.toArray(iter),f);
}
stx.Iterables.elements = function(iter) {
	return SIterables.toArray(iter);
}
stx.Iterables.appendAll = function(iter,i) {
	return stx.Arrays.appendAll(SIterables.toArray(iter),i);
}
stx.Iterables.isEmpty = function(iter) {
	return !$iterator(iter)().hasNext();
}
stx.Iterables.find = function(iter,f) {
	return stx.Arrays.find(SIterables.toArray(iter),f);
}
stx.Iterables.forAll = function(iter,f) {
	return stx.Arrays.forAll(SIterables.toArray(iter),f);
}
stx.Iterables.forAny = function(iter,f) {
	return stx.Arrays.forAny(SIterables.toArray(iter),f);
}
stx.Iterables.first = function(iter) {
	return stx.Iterables.head(iter);
}
stx.Iterables.unwind = function(root,children,depth) {
	if(depth == null) depth = false;
	var index = 0;
	var stack = [root];
	var visit = null;
	visit = function(x) {
		var _g = 0, _g1 = children(x);
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			visit(v);
			stack.push(v);
		}
	};
	visit(root);
	return stx.Iterables.yield(function() {
		var val = stack[index];
		index++;
		return stx.Options.create(val);
	});
}
stx.Iterables.yield = function(fn) {
	var stack = [];
	return { iterator : function() {
		return stx.LazyIterator.create(fn,stack).iterator();
	}};
}
stx.Iterators = $hxClasses["stx.Iterators"] = function() { }
stx.Iterators.__name__ = ["stx","Iterators"];
stx.Iterators.toArray = function(iterator) {
	var o = [];
	while(iterator.hasNext()) o.push(iterator.next());
	return o;
}
stx.Iterators.forAll = function(iterator,fn) {
	var ok = true;
	while(iterator.hasNext()) {
		ok = fn(iterator.next());
		if(!ok) break;
	}
	return ok;
}
stx.LazyIterator = $hxClasses["stx.LazyIterator"] = function(f,stack) {
	this.fn = function(i) {
		var o = stack[i] == null?stack[i] = f():stack[i];
		return o;
	};
	this.index = 0;
};
stx.LazyIterator.__name__ = ["stx","LazyIterator"];
stx.LazyIterator.create = function(fn,stack) {
	return new stx.LazyIterator(fn,stack);
}
stx.LazyIterator.prototype = {
	iterator: function() {
		return { next : $bind(this,this.next), hasNext : $bind(this,this.hasNext)};
	}
	,hasNext: function() {
		var o = (function($this) {
			var $r;
			var $e = ($this.fn($this.index));
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				$r = true;
				break;
			case 0:
				$r = false;
				break;
			}
			return $r;
		}(this));
		return o;
	}
	,next: function() {
		var o = stx.Options.get(this.fn(this.index));
		this.index++;
		return o;
	}
	,index: null
	,fn: null
	,__class__: stx.LazyIterator
}
stx.LogLevel = $hxClasses["stx.LogLevel"] = { __ename__ : ["stx","LogLevel"], __constructs__ : ["Debug","Info","Warning","Error","Fatal"] }
stx.LogLevel.Debug = ["Debug",0];
stx.LogLevel.Debug.toString = $estr;
stx.LogLevel.Debug.__enum__ = stx.LogLevel;
stx.LogLevel.Info = ["Info",1];
stx.LogLevel.Info.toString = $estr;
stx.LogLevel.Info.__enum__ = stx.LogLevel;
stx.LogLevel.Warning = ["Warning",2];
stx.LogLevel.Warning.toString = $estr;
stx.LogLevel.Warning.__enum__ = stx.LogLevel;
stx.LogLevel.Error = ["Error",3];
stx.LogLevel.Error.toString = $estr;
stx.LogLevel.Error.__enum__ = stx.LogLevel;
stx.LogLevel.Fatal = ["Fatal",4];
stx.LogLevel.Fatal.toString = $estr;
stx.LogLevel.Fatal.__enum__ = stx.LogLevel;
stx.LogItem = $hxClasses["stx.LogItem"] = function(level,value) {
	this.level = level;
	this.value = value;
};
stx.LogItem.__name__ = ["stx","LogItem"];
stx.LogItem.prototype = {
	value: null
	,level: null
	,toString: function() {
		return Std.string(this.level) + "[ " + Std.string(this.value) + " ]";
	}
	,__class__: stx.LogItem
}
stx.LogListing = $hxClasses["stx.LogListing"] = { __ename__ : ["stx","LogListing"], __constructs__ : ["Include","Exclude"] }
stx.LogListing.Include = function(s) { var $x = ["Include",0,s]; $x.__enum__ = stx.LogListing; $x.toString = $estr; return $x; }
stx.LogListing.Exclude = function(s) { var $x = ["Exclude",1,s]; $x.__enum__ = stx.LogListing; $x.toString = $estr; return $x; }
stx.Log = $hxClasses["stx.Log"] = function() { }
stx.Log.__name__ = ["stx","Log"];
stx.Log.debug = function(v) {
	return new stx.LogItem(stx.LogLevel.Debug,v);
}
stx.Log.info = function(v) {
	return new stx.LogItem(stx.LogLevel.Info,v);
}
stx.Log.warning = function(v) {
	return new stx.LogItem(stx.LogLevel.Warning,v);
}
stx.Log.error = function(v) {
	return new stx.LogItem(stx.LogLevel.Error,v);
}
stx.Log.fatal = function(v) {
	return new stx.LogItem(stx.LogLevel.Fatal,v);
}
stx.Log.trace = function(v,pos) {
	var log = null;
	try {
		log = stx.framework.Injector.inject(stx.Logger,pos);
	} catch( e ) {
		log = stx.DefaultLogger.create();
	}
	var $e = (Type["typeof"](v));
	switch( $e[1] ) {
	case 6:
		var c = $e[2];
		if(Type.getClassName(c) == Type.getClassName(stx.LogItem)) {
			var e = v.level;
			if(stx.Enums.indexOf(e) >= stx.Enums.indexOf(log.level)) {
				if(log.check(v,pos)) log.trace(v.toString(),pos);
			}
		} else log.trace(v,pos);
		break;
	default:
		log.trace(v,pos);
	}
}
stx.Log.printer = function(p) {
	return stx.Functions2.p2(haxe.Log.trace,p);
}
stx.Log.tracer = function(p) {
	return stx.Functions2.p2(stx.Log.trace,p);
}
stx.Log.format = function(p) {
	return p.fileName + ":" + p.lineNumber + " (" + p.className + ":" + p.methodName + "): ";
}
stx.Log.whitelist = function(s) {
	return stx.LogListing.Include(s);
}
stx.Log.blacklist = function(s) {
	return stx.LogListing.Exclude(s);
}
stx.Log.pack = function(s) {
	return ".*\\(" + s + ".*:.*\\)";
}
stx.Log.func = function(s) {
	return ".*\\(.*:" + s + "\\)";
}
stx.Log.file = function(s) {
	return "" + s + ".*\\(.*:";
}
stx.Logger = $hxClasses["stx.Logger"] = function() { }
stx.Logger.__name__ = ["stx","Logger"];
stx.Logger.prototype = {
	level: null
	,trace: null
	,check: null
	,__class__: stx.Logger
}
stx.DefaultLogger = $hxClasses["stx.DefaultLogger"] = function(listings,level,permissive) {
	if(permissive == null) permissive = true;
	this.listings = listings == null?[]:listings;
	this.level = level == null?stx.LogLevel.Warning:level;
	this.permissive = permissive;
};
stx.DefaultLogger.__name__ = ["stx","DefaultLogger"];
stx.DefaultLogger.__interfaces__ = [stx.Logger];
stx.DefaultLogger.create = function(listings,level) {
	return new stx.DefaultLogger(listings,level);
}
stx.DefaultLogger.prototype = {
	trace: function(v,infos) {
		js.Boot.__trace(v,infos);
	}
	,checker: function(pos,v) {
		var reg = new EReg(v,"");
		var matches = reg.match(stx.Log.format(pos));
		if(matches) {
		}
		return matches;
	}
	,check: function(v,pos) {
		var _g = this;
		var white = function(includes) {
			return stx.Arrays.forAny(SArrays.map(SArrays.map(includes,stx.Enums.params),stx.Arrays.first),(function(f,a1) {
				return function(v1) {
					return f(a1,v1);
				};
			})($bind(_g,_g.checker),pos));
		};
		var black = function(excludes) {
			return !stx.Arrays.forAll(SArrays.map(SArrays.map(excludes,stx.Enums.params),stx.Arrays.first),(function(f1,a11) {
				return function(v1) {
					return f1(a11,v1);
				};
			})($bind(_g,_g.checker),pos));
		};
		var o = stx.Tuple2.into(stx.Arrays.partition(this.listings,function(x) {
			return stx.Enums.constructorOf(x) == "Include";
		}),function(includes1,excludes1) {
			return stx.Bools.ifElse(includes1.length > 0,function() {
				return white(includes1)?stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes1.length > 0,stx.Functions1.lazy(black,excludes1)),stx.Option.Some(_g.permissive))):false;
			},function() {
				return stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes1.length > 0,stx.Functions1.lazy(black,excludes1)),stx.Option.Some(_g.permissive)));
			});
		});
		return o;
	}
	,level: null
	,permissive: null
	,listings: null
	,__class__: stx.DefaultLogger
}
stx.Maths = $hxClasses["stx.Maths"] = function() { }
stx.Maths.__name__ = ["stx","Maths"];
stx.Maths.rndOne = function(weight) {
	if(weight == null) weight = 0.5;
	return Math.random() - weight | 0;
}
stx.Maths.radians = function(v) {
	return v * (Math.PI / 180);
}
stx.Maths.degrees = function(v) {
	return v * (180 / Math.PI);
}
stx.Ints = $hxClasses["stx.Ints"] = function() { }
stx.Ints.__name__ = ["stx","Ints"];
stx.Ints.max = function(v1,v2) {
	return v2 > v1?v2:v1;
}
stx.Ints.min = function(v1,v2) {
	return v2 < v1?v2:v1;
}
stx.Ints.toBool = function(v) {
	return v == 0?false:true;
}
stx.Ints.toFloat = function(v) {
	return v;
}
stx.Ints.compare = function(v1,v2) {
	return v1 < v2?-1:v1 > v2?1:0;
}
stx.Ints.equals = function(v1,v2) {
	return v1 == v2;
}
stx.Ints.isOdd = function(value) {
	return value % 2 == 0?false:true;
}
stx.Ints.isEven = function(value) {
	return (value % 2 == 0?false:true) == false;
}
stx.Ints.isInteger = function(n) {
	return n % 1 == 0;
}
stx.Ints.isNatural = function(n) {
	return n > 0 && n % 1 == 0;
}
stx.Ints.isPrime = function(n) {
	if(n == 1) return false;
	if(n == 2) return false;
	if(n % 2 == 0) return false;
	var iter = new IntIter(3,Math.ceil(Math.sqrt(n)) + 1);
	while( iter.hasNext() ) {
		var i = iter.next();
		if(n % 1 == 0) return false;
		i++;
	}
	return true;
}
stx.Ints.factorial = function(n) {
	if(!(n > 0 && n % 1 == 0)) throw "function factorial requires natural number as input";
	if(n == 0) return 1;
	var i = n - 1;
	while(i > 0) {
		n = n * i;
		i--;
	}
	return n;
}
stx.Ints.divisors = function(n) {
	var r = new Array();
	var iter = new IntIter(1,Math.ceil(n / 2 + 1));
	while( iter.hasNext() ) {
		var i = iter.next();
		if(n % i == 0) r.push(i);
	}
	if(n != 0) r.push(n);
	return r;
}
stx.Ints.clamp = function(n,min,max) {
	if(n > max) n = max; else if(n < min) n = min;
	return n;
}
stx.Ints.half = function(n) {
	return n / 2;
}
stx.Ints.sum = function(xs) {
	var o = 0;
	var $it0 = $iterator(xs)();
	while( $it0.hasNext() ) {
		var val = $it0.next();
		o += val;
	}
	return o;
}
stx.Ints.add = function(a,b) {
	return a + b;
}
stx.Ints.sub = function(a,b) {
	return a - b;
}
stx.Ints.div = function(a,b) {
	return a / b;
}
stx.Ints.mul = function(a,b) {
	return a * b;
}
stx.Ints.mod = function(a,b) {
	return a % b;
}
stx.Floats = $hxClasses["stx.Floats"] = function() { }
stx.Floats.__name__ = ["stx","Floats"];
stx.Floats.delta = function(n0,n1) {
	return n1 - n0;
}
stx.Floats.normalize = function(v,n0,n1) {
	return (v - n0) / (n1 - n0);
}
stx.Floats.interpolate = function(v,n0,n1) {
	return n0 + (n1 - n0) * v;
}
stx.Floats.map = function(v,min0,max0,min1,max1) {
	return min1 + (max1 - min1) * ((v - min0) / (max0 - min0));
}
stx.Floats.round = function(n,c) {
	if(c == null) c = 1;
	var r = Math.pow(10,c);
	return stx.Floats["int"](Math.round(n * r) / r);
}
stx.Floats.ceil = function(n,c) {
	if(c == null) c = 1;
	var r = Math.pow(10,c);
	return stx.Floats["int"](Math.ceil(n * r) / r);
}
stx.Floats.floor = function(n,c) {
	if(c == null) c = 1;
	var r = Math.pow(10,c);
	return stx.Floats["int"](Math.floor(n * r) / r);
}
stx.Floats.clamp = function(n,min,max) {
	if(n > max) n = max; else if(n < min) n = min;
	return n;
}
stx.Floats.sgn = function(n) {
	return n == 0?0:Math.abs(n) / n;
}
stx.Floats.max = function(v1,v2) {
	return v2 > v1?v2:v1;
}
stx.Floats.min = function(v1,v2) {
	return v2 < v1?v2:v1;
}
stx.Floats["int"] = function(v) {
	return v | 0;
}
stx.Floats.compare = function(v1,v2) {
	return v1 < v2?-1:v1 > v2?1:0;
}
stx.Floats.equals = function(v1,v2) {
	return v1 == v2;
}
stx.Floats.toString = function(v) {
	return "" + v;
}
stx.Floats.add = function(a,b) {
	return a + b;
}
stx.Floats.sub = function(a,b) {
	return a - b;
}
stx.Floats.div = function(a,b) {
	return a / b;
}
stx.Floats.mul = function(a,b) {
	return a * b;
}
stx.Floats.mod = function(a,b) {
	return a % b;
}
stx.Objects = $hxClasses["stx.Objects"] = function() { }
stx.Objects.__name__ = ["stx","Objects"];
stx.Objects.copyDeep = function(d) {
	return stx.Objects.copy(d,false);
}
stx.Objects.copy = function(d,shallow) {
	if(shallow == null) shallow = true;
	var res = { };
	stx.Objects.copyTo(d,res,shallow);
	return res;
}
stx.Objects.copyTypedDeep = function(d) {
	return stx.Objects.copy(d,false);
}
stx.Objects.copyTyped = function(d,shallow) {
	if(shallow == null) shallow = true;
	return stx.Objects.copy(d,shallow);
}
stx.Objects.copyTo = function(src,dest,shallow) {
	if(shallow == null) shallow = true;
	var safecopy = function(d) {
		return (function($this) {
			var $r;
			switch( (Type["typeof"](d))[1] ) {
			case 4:
				$r = stx.Objects.copy(d,shallow);
				break;
			default:
				$r = d;
			}
			return $r;
		}(this));
	};
	var _g = 0, _g1 = Reflect.fields(src);
	while(_g < _g1.length) {
		var field = _g1[_g];
		++_g;
		var value = Reflect.field(src,field);
		dest[field] = shallow?value:safecopy(value);
	}
	return src;
}
stx.Objects.extendWith = function(dest,src,shallow) {
	if(shallow == null) shallow = true;
	stx.Objects.copyTo(src,dest,shallow);
	return dest;
}
stx.Objects.copyExtendedWith = function(a,b,shallow) {
	if(shallow == null) shallow = true;
	var res = stx.Objects.copy(a,shallow);
	stx.Objects.copyTo(b,res,shallow);
	return res;
}
stx.Objects.extendWithDeep = function(dest,src) {
	stx.Objects.copyTo(src,dest,false);
	return dest;
}
stx.Objects.copyExtendedWithDeep = function(a,b) {
	var res = stx.Objects.copy(a,false);
	stx.Objects.copyTo(b,res,false);
	return res;
}
stx.Objects.fields = function(d) {
	return Reflect.fields(d);
}
stx.Objects.mapValues = function(d,f) {
	return stx.Objects.setAll({ },SArrays.map(Reflect.fields(d),function(name) {
		return new stx.Tuple2(name,f(Reflect.field(d,name)));
	}));
}
stx.Objects.set = function(d,k,v) {
	d[k] = v;
	return d;
}
stx.Objects.setAny = function(d,k,v) {
	d[k] = v;
	return d;
}
stx.Objects.setAll = function(d,fields) {
	var $it0 = $iterator(fields)();
	while( $it0.hasNext() ) {
		var field = $it0.next();
		d[field._1] = field._2;
	}
	return d;
}
stx.Objects.replaceAll = function(d1,d2,def) {
	var names = Reflect.fields(d2);
	var oldValues = stx.Objects.extractValues(d1,names,def);
	stx.Objects.extendWith(d1,d2);
	return SArrays.foldl(stx.Arrays.zip(names,oldValues),{ },function(o,t) {
		o[t._1] = t._2;
		return o;
	});
}
stx.Objects.setAllAny = function(d,fields) {
	var $it0 = $iterator(fields)();
	while( $it0.hasNext() ) {
		var field = $it0.next();
		d[field._1] = field._2;
	}
	return d;
}
stx.Objects.replaceAllAny = function(d1,d2,def) {
	var names = Reflect.fields(d2);
	var oldValues = stx.Objects.extractValues(d1,names,def);
	stx.Objects.extendWith(d1,d2);
	return SArrays.foldl(stx.Arrays.zip(names,oldValues),{ },function(o,t) {
		o[t._1] = t._2;
		return o;
	});
}
stx.Objects.get = function(d,k) {
	return Reflect.hasField(d,k)?stx.Option.Some(Reflect.field(d,k)):stx.Option.None;
}
stx.Objects.getAny = function(d,k) {
	return Reflect.hasField(d,k)?stx.Option.Some(Reflect.field(d,k)):stx.Option.None;
}
stx.Objects.extractFieldValues = function(obj,field) {
	return SArrays.foldl(Reflect.fields(obj),[],function(a,fieldName) {
		var value = Reflect.field(obj,fieldName);
		return fieldName == field?stx.Arrays.append(a,value):Type["typeof"](value) == ValueType.TObject?a.concat(stx.Objects.extractFieldValues(value,field)):a;
	});
}
stx.Objects.extractAll = function(d) {
	return SArrays.map(Reflect.fields(d),function(name) {
		return new stx.Tuple2(name,Reflect.field(d,name));
	});
}
stx.Objects.extractAllAny = function(d) {
	return stx.Objects.extractAll(d);
}
stx.Objects.extractValuesAny = function(d,names,def) {
	return stx.Objects.extractValues(d,names,def);
}
stx.Objects.extractValues = function(d,names,def) {
	var result = [];
	var $it0 = $iterator(names)();
	while( $it0.hasNext() ) {
		var field = $it0.next();
		var value = Reflect.field(d,field);
		result.push(value != null?value:def);
	}
	return result;
}
stx.Objects.iterator = function(d) {
	return HxOverrides.iter(Reflect.fields(d));
}
stx.Objects.toObject = function(a) {
	return SArrays.foldl(a,{ },function(init,el) {
		init[el._1] = el._2;
		return init;
	});
}
stx.Untyper = $hxClasses["stx.Untyper"] = function() { }
stx.Untyper.__name__ = ["stx","Untyper"];
stx.Untyper.extractInstanceFields = function(v) {
	var fields = Type.getInstanceFields(Type.getClass(v));
	return SArrays.filter(stx.Arrays.zip(fields,SArrays.map(fields,stx.Functions2.p1(Reflect.field,v))),function(t) {
		return !Reflect.isFunction(t._2);
	});
}
stx.Options = $hxClasses["stx.Options"] = function() { }
stx.Options.__name__ = ["stx","Options"];
stx.Options.create = function(t) {
	return t == null?stx.Option.None:stx.Option.Some(t);
}
stx.Options.toOption = function(v) {
	return stx.Options.create(v);
}
stx.Options.map = function(o,f) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		case 1:
			var v = $e[2];
			$r = stx.Option.Some(f(v));
			break;
		}
		return $r;
	}(this));
}
stx.Options.foreach = function(o,f) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = o;
			break;
		case 1:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				f(v);
				$r = o;
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.Options.flatMap = function(o,f) {
	return stx.Options.flatten(stx.Options.map(o,f));
}
stx.Options.get = function(o) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = (function($this) {
				var $r;
				SBase.error("Error: Option is empty",{ fileName : "Options.hx", lineNumber : 49, className : "stx.Options", methodName : "get"});
				$r = null;
				return $r;
			}($this));
			break;
		case 1:
			var v = $e[2];
			$r = v;
			break;
		}
		return $r;
	}(this));
}
stx.Options.getOrElse = function(o,thunk) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = thunk();
			break;
		case 1:
			var v = $e[2];
			$r = v;
			break;
		}
		return $r;
	}(this));
}
stx.Options.getOrElseC = function(o,c) {
	return stx.Options.getOrElse(o,stx.Dynamics.toThunk(c));
}
stx.Options.orElse = function(o1,thunk) {
	return (function($this) {
		var $r;
		var $e = (o1);
		switch( $e[1] ) {
		case 0:
			$r = thunk();
			break;
		case 1:
			var v = $e[2];
			$r = o1;
			break;
		}
		return $r;
	}(this));
}
stx.Options.orElseC = function(o1,o2) {
	return stx.Options.orElse(o1,stx.Dynamics.toThunk(o2));
}
stx.Options.isEmpty = function(o) {
	return (function($this) {
		var $r;
		switch( (o)[1] ) {
		case 0:
			$r = true;
			break;
		case 1:
			$r = false;
			break;
		}
		return $r;
	}(this));
}
stx.Options.isDefined = function(o) {
	return (function($this) {
		var $r;
		switch( (o)[1] ) {
		case 0:
			$r = false;
			break;
		case 1:
			$r = true;
			break;
		}
		return $r;
	}(this));
}
stx.Options.toArray = function(o) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = [];
			break;
		case 1:
			var v = $e[2];
			$r = [v];
			break;
		}
		return $r;
	}(this));
}
stx.Options.then = function(o1,o2) {
	return o2;
}
stx.Options.filter = function(o,f) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		case 1:
			var v = $e[2];
			$r = f(v)?o:stx.Option.None;
			break;
		}
		return $r;
	}(this));
}
stx.Options.flatten = function(o1) {
	return (function($this) {
		var $r;
		var $e = (o1);
		switch( $e[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		case 1:
			var o2 = $e[2];
			$r = o2;
			break;
		}
		return $r;
	}(this));
}
stx.Options.zip = function(o1,o2) {
	return (function($this) {
		var $r;
		var $e = (o1);
		switch( $e[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		case 1:
			var v1 = $e[2];
			$r = stx.Options.map(o2,(function(f,_1) {
				return function(_2) {
					return f(_1,_2);
				};
			})(stx.Tuples.t2,v1));
			break;
		}
		return $r;
	}(this));
}
stx.Options.zipWith = function(o1,o2,f) {
	return (function($this) {
		var $r;
		var $e = (o1);
		switch( $e[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		case 1:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (o2);
				switch( $e[1] ) {
				case 0:
					$r = stx.Option.None;
					break;
				case 1:
					var v2 = $e[2];
					$r = stx.Option.Some(f(v1,v2));
					break;
				}
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.Options.orEither = function(o1,thunk) {
	return (function($this) {
		var $r;
		var $e = (o1);
		switch( $e[1] ) {
		case 0:
			$r = stx.Eithers.toLeft(thunk());
			break;
		case 1:
			var v = $e[2];
			$r = stx.Eithers.toRight(v);
			break;
		}
		return $r;
	}(this));
}
stx.Options.orEitherC = function(o1,c) {
	return stx.Options.orEither(o1,stx.Dynamics.toThunk(c));
}
stx.Predicates = $hxClasses["stx.Predicates"] = function() { }
stx.Predicates.__name__ = ["stx","Predicates"];
stx.Predicates.isAny = function() {
	return function(value) {
		return true;
	};
}
stx.Predicates.isNull = function() {
	return function(value) {
		return value == null;
	};
}
stx.Predicates.isNotNull = function() {
	return function(value) {
		return value != null;
	};
}
stx.Predicates.isGreaterThan = function(ref) {
	return function(value) {
		return value > ref;
	};
}
stx.Predicates.isLessThan = function(ref) {
	return function(value) {
		return value < ref;
	};
}
stx.Predicates.isGreaterThanInt = function(ref) {
	return function(value) {
		return value > ref;
	};
}
stx.Predicates.isLessThanInt = function(ref) {
	return function(value) {
		return value < ref;
	};
}
stx.Predicates.isEqualTo = function(ref,equal) {
	if(equal == null) equal = stx.plus.Equal.getEqualFor(ref);
	return function(value) {
		return equal(ref,value);
	};
}
stx.Predicates.and = function(p1,p2) {
	return function(value) {
		return p1(value) && p2(value);
	};
}
stx.Predicates.andAll = function(p1,ps) {
	return function(value) {
		var result = p1(value);
		var $it0 = $iterator(ps)();
		while( $it0.hasNext() ) {
			var p = $it0.next();
			if(!result) break;
			result = result && p(value);
		}
		return result;
	};
}
stx.Predicates.or = function(p1,p2) {
	return function(value) {
		return p1(value) || p2(value);
	};
}
stx.Predicates.not = function(p1) {
	return function(value) {
		return !p1(value);
	};
}
stx.Predicates.orAny = function(p1,ps) {
	return function(value) {
		var result = p1(value);
		var $it0 = $iterator(ps)();
		while( $it0.hasNext() ) {
			var p = $it0.next();
			if(result) break;
			result = result || p(value);
		}
		return result;
	};
}
stx.Unit = $hxClasses["stx.Unit"] = { __ename__ : ["stx","Unit"], __constructs__ : ["Unit"] }
stx.Unit.Unit = ["Unit",0];
stx.Unit.Unit.toString = $estr;
stx.Unit.Unit.__enum__ = stx.Unit;
stx.Option = $hxClasses["stx.Option"] = { __ename__ : ["stx","Option"], __constructs__ : ["None","Some"] }
stx.Option.None = ["None",0];
stx.Option.None.toString = $estr;
stx.Option.None.__enum__ = stx.Option;
stx.Option.Some = function(v) { var $x = ["Some",1,v]; $x.__enum__ = stx.Option; $x.toString = $estr; return $x; }
stx.TraversalOrder = $hxClasses["stx.TraversalOrder"] = { __ename__ : ["stx","TraversalOrder"], __constructs__ : ["PreOrder","InOrder","PostOrder","LevelOrder"] }
stx.TraversalOrder.PreOrder = ["PreOrder",0];
stx.TraversalOrder.PreOrder.toString = $estr;
stx.TraversalOrder.PreOrder.__enum__ = stx.TraversalOrder;
stx.TraversalOrder.InOrder = ["InOrder",1];
stx.TraversalOrder.InOrder.toString = $estr;
stx.TraversalOrder.InOrder.__enum__ = stx.TraversalOrder;
stx.TraversalOrder.PostOrder = ["PostOrder",2];
stx.TraversalOrder.PostOrder.toString = $estr;
stx.TraversalOrder.PostOrder.__enum__ = stx.TraversalOrder;
stx.TraversalOrder.LevelOrder = ["LevelOrder",3];
stx.TraversalOrder.LevelOrder.toString = $estr;
stx.TraversalOrder.LevelOrder.__enum__ = stx.TraversalOrder;
stx.Either = $hxClasses["stx.Either"] = { __ename__ : ["stx","Either"], __constructs__ : ["Left","Right"] }
stx.Either.Left = function(v) { var $x = ["Left",0,v]; $x.__enum__ = stx.Either; $x.toString = $estr; return $x; }
stx.Either.Right = function(v) { var $x = ["Right",1,v]; $x.__enum__ = stx.Either; $x.toString = $estr; return $x; }
stx.FieldOrder = $hxClasses["stx.FieldOrder"] = function() { }
stx.FieldOrder.__name__ = ["stx","FieldOrder"];
stx.Promises = $hxClasses["stx.Promises"] = function() { }
stx.Promises.__name__ = ["stx","Promises"];
stx.Promises.onSuccess = function(ft,fn) {
	return stx.Promises.foreachR(ft,fn);
}
stx.Promises.onFailure = function(ft,fn) {
	return stx.Promises.foreachL(ft,fn);
}
stx.Promises.mapR = function(f,fn) {
	return f.map(function(x) {
		return stx.Eithers.mapR(x,function(y) {
			return fn(y);
		});
	});
}
stx.Promises.zipRWith = function(f0,f1,fn) {
	return f0.zipWith(f1,function(a,b) {
		return (function($this) {
			var $r;
			var $e = (a);
			switch( $e[1] ) {
			case 0:
				var v1 = $e[2];
				$r = stx.Either.Left(v1);
				break;
			case 1:
				var v1 = $e[2];
				$r = (function($this) {
					var $r;
					var $e = (b);
					switch( $e[1] ) {
					case 0:
						var v2 = $e[2];
						$r = stx.Either.Left(v2);
						break;
					case 1:
						var v2 = $e[2];
						$r = stx.Either.Right(fn(v1,v2));
						break;
					}
					return $r;
				}($this));
				break;
			}
			return $r;
		}(this));
	});
}
stx.Promises.zipR = function(f0,f1) {
	return stx.Promises.zipRWith(f0,f1,stx.Tuples.t2);
}
stx.Promises.flatMapR = function(f0,fn) {
	return f0.flatMap(function(x) {
		return (function($this) {
			var $r;
			var $e = (x);
			switch( $e[1] ) {
			case 0:
				var v1 = $e[2];
				$r = new stx.Future().deliver(stx.Either.Left(v1),{ fileName : "Promises.hx", lineNumber : 71, className : "stx.Promises", methodName : "flatMapR"});
				break;
			case 1:
				var v2 = $e[2];
				$r = fn(v2);
				break;
			}
			return $r;
		}(this));
	});
}
stx.Promises.flatMapL = function(f0,fn) {
	return f0.flatMap(function(x) {
		return (function($this) {
			var $r;
			var $e = (x);
			switch( $e[1] ) {
			case 1:
				var v1 = $e[2];
				$r = new stx.Future().deliver(stx.Either.Right(v1),{ fileName : "Promises.hx", lineNumber : 86, className : "stx.Promises", methodName : "flatMapL"});
				break;
			case 0:
				var v2 = $e[2];
				$r = fn(v2);
				break;
			}
			return $r;
		}(this));
	});
}
stx.Promises.pure = function(e) {
	return new stx.Future().deliver(e,{ fileName : "Promises.hx", lineNumber : 94, className : "stx.Promises", methodName : "pure"});
}
stx.Promises.right = function(f,v) {
	return f.deliver(stx.Either.Right(v),{ fileName : "Promises.hx", lineNumber : 100, className : "stx.Promises", methodName : "right"});
}
stx.Promises.left = function(f,v) {
	return f.deliver(stx.Either.Left(v),{ fileName : "Promises.hx", lineNumber : 106, className : "stx.Promises", methodName : "left"});
}
stx.Promises.success = function(v) {
	return stx.Promises.pure(stx.Either.Right(v));
}
stx.Promises.failure = function(v) {
	return stx.Promises.pure(stx.Either.Left(v));
}
stx.Promises.waitfold = function(init,ft) {
	return stx.Promises.flatMapR(init,function(arr) {
		return stx.Promises.mapR(ft,function(v) {
			return stx.Arrays.append(arr,v);
		});
	});
}
stx.Promises.wait = function(a) {
	return SArrays.foldl(a,stx.Future.pure(stx.Either.Right([])),stx.Promises.waitfold);
}
stx.Promises.foreachR = function(v,f) {
	return v.foreach(stx.Functions1.toEffect(stx.Functions1.andThen(stx.Eithers.right,stx.Functions2.p2(stx.Options.foreach,f))));
}
stx.Promises.foreachL = function(v,f) {
	return v.foreach(stx.Functions1.toEffect(stx.Functions1.andThen(stx.Eithers.left,stx.Functions2.p2(stx.Options.foreach,f))));
}
stx.Promises.toCallback = function(v,fn) {
	stx.Promises.foreachL(v,stx.Functions2.p2(fn,null));
	stx.Promises.foreachR(v,stx.Functions2.p1(fn,null));
	return v;
}
stx.Strings = $hxClasses["stx.Strings"] = function() { }
stx.Strings.__name__ = ["stx","Strings"];
stx.Strings.toBool = function(v,d) {
	if(v == null) return d;
	var vLower = v.toLowerCase();
	return stx.Options.getOrElseC(vLower == "false" || v == "0"?stx.Option.Some(false):vLower == "true" || v == "1"?stx.Option.Some(true):stx.Option.None,d);
}
stx.Strings["int"] = function(v,d) {
	if(v == null) return d;
	return stx.Options.getOrElseC(stx.Options.filter(stx.Options.toOption(Std.parseInt(v)),function(i) {
		return !Math.isNaN(i);
	}),d);
}
stx.Strings.toFloat = function(v,d) {
	if(v == null) return d;
	return stx.Options.getOrElseC(stx.Options.filter(stx.Options.toOption(Std.parseFloat(v)),function(i) {
		return !Math.isNaN(i);
	}),d);
}
stx.Strings.startsWith = function(v,frag) {
	return v.length >= frag.length && frag == HxOverrides.substr(v,0,frag.length)?true:false;
}
stx.Strings.endsWith = function(v,frag) {
	return v.length >= frag.length && frag == HxOverrides.substr(v,v.length - frag.length,null)?true:false;
}
stx.Strings.urlEncode = function(v) {
	return StringTools.urlEncode(v);
}
stx.Strings.urlDecode = function(v) {
	return StringTools.urlDecode(v);
}
stx.Strings.htmlEscape = function(v) {
	return StringTools.htmlEscape(v);
}
stx.Strings.htmlUnescape = function(v) {
	return StringTools.htmlUnescape(v);
}
stx.Strings.trim = function(v) {
	return StringTools.trim(v);
}
stx.Strings.contains = function(v,s) {
	return v.indexOf(s) != -1;
}
stx.Strings.replace = function(s,sub,by) {
	return StringTools.replace(s,sub,by);
}
stx.Strings.compare = function(v1,v2) {
	return v1 == v2?0:v1 > v2?1:-1;
}
stx.Strings.equals = function(v1,v2) {
	return v1 == v2;
}
stx.Strings.toString = function(v) {
	return v;
}
stx.Strings.surround = function(str,before,after) {
	return before + str + after;
}
stx.Strings.prepend = function(str,before) {
	return before + str;
}
stx.Strings.append = function(str,after) {
	return str + after;
}
stx.Strings.cca = function(str,i) {
	return HxOverrides.cca(str,i);
}
stx.Strings.chunk = function(str,len) {
	var start = 0;
	var end = stx.Ints.min(start + len,str.length);
	return end == 0?[]:(function($this) {
		var $r;
		var prefix = HxOverrides.substr(str,start,end);
		var rest = HxOverrides.substr(str,end,null);
		$r = [prefix].concat(stx.Strings.chunk(rest,len));
		return $r;
	}(this));
}
stx.Strings.chars = function(str) {
	var a = [];
	var _g1 = 0, _g = str.length;
	while(_g1 < _g) {
		var i = _g1++;
		a.push(str.charAt(i));
	}
	return a;
}
stx.Strings.string = function(l) {
	var o = "";
	var $it0 = $iterator(l)();
	while( $it0.hasNext() ) {
		var val = $it0.next();
		o += val;
	}
	return o;
}
stx.Strings.toCamelCase = function(str) {
	return stx.Strings.SepAlphaPattern.customReplace(str,function(e) {
		return e.matched(2).toUpperCase();
	});
}
stx.Strings.fromCamelCase = function(str,sep) {
	return stx.Strings.AlphaUpperAlphaPattern.customReplace(str,function(e) {
		return e.matched(1) + sep + e.matched(2).toLowerCase();
	});
}
stx.Tuples = $hxClasses["stx.Tuples"] = function() { }
stx.Tuples.__name__ = ["stx","Tuples"];
stx.Tuples.t2 = function(_1,_2) {
	return new stx.Tuple2(_1,_2);
}
stx.Tuples.t3 = function(_1,_2,_3) {
	return new stx.Tuple3(_1,_2,_3);
}
stx.Tuples.t4 = function(_1,_2,_3,_4) {
	return new stx.Tuple4(_1,_2,_3,_4);
}
stx.Tuples.t5 = function(_1,_2,_3,_4,_5) {
	return new stx.Tuple5(_1,_2,_3,_4,_5);
}
stx.Tuples.elements = function(p) {
	return p.elements();
}
stx.Product = $hxClasses["stx.Product"] = function() { }
stx.Product.__name__ = ["stx","Product"];
stx.Product.prototype = {
	flatten: null
	,elements: null
	,element: null
	,length: null
	,prefix: null
	,__class__: stx.Product
	,__properties__: {get_prefix:"get_prefix",get_length:"get_length"}
}
stx.AbstractProduct = $hxClasses["stx.AbstractProduct"] = function(elements) {
	this._elements = elements;
};
stx.AbstractProduct.__name__ = ["stx","AbstractProduct"];
stx.AbstractProduct.__interfaces__ = [stx.Product];
stx.AbstractProduct.prototype = {
	flatten: function() {
		var flatn = null;
		flatn = function(p) {
			return SArrays.flatMap(p.elements(),function(v) {
				return js.Boot.__instanceof(v,stx.Product)?SArrays.flatMap(flatn(v),SBase.identity()):[v];
			});
		};
		return flatn(this);
	}
	,elements: function() {
		return (function($this) {
			var $r;
			switch($this.get_length()) {
			case 5:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p._1,p._2,p._3,p._4,p._5];
					return $r;
				}($this));
				break;
			case 4:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p._1,p._2,p._3,p._4];
					return $r;
				}($this));
				break;
			case 3:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p._1,p._2,p._3];
					return $r;
				}($this));
				break;
			case 2:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p._1,p._2];
					return $r;
				}($this));
				break;
			}
			return $r;
		}(this));
	}
	,get_length: function() {
		return SBase.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 65, className : "stx.AbstractProduct", methodName : "get_length"});
	}
	,get_prefix: function() {
		return SBase.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 61, className : "stx.AbstractProduct", methodName : "get_prefix"});
	}
	,toString: function() {
		var s = this.get_prefix() + "(" + (stx.plus.Show.getShowFor(this.element(0)))(this.element(0));
		var _g1 = 1, _g = this.get_length();
		while(_g1 < _g) {
			var i = _g1++;
			s += ", " + (stx.plus.Show.getShowFor(this.element(i)))(this.element(i));
		}
		return s + ")";
	}
	,element: function(n) {
		return this._elements[n];
	}
	,_elements: null
	,length: null
	,prefix: null
	,tools: null
	,__class__: stx.AbstractProduct
	,__properties__: {get_prefix:"get_prefix",get_length:"get_length"}
}
stx.Tuple2 = $hxClasses["stx.Tuple2"] = function(_1,_2) {
	this._1 = _1;
	this._2 = _2;
	stx.AbstractProduct.call(this,[_1,_2]);
};
stx.Tuple2.__name__ = ["stx","Tuple2"];
stx.Tuple2.entuple = function(t,c) {
	return new stx.Tuple3(t._1,t._2,c);
}
stx.Tuple2.into = function(t,f) {
	return f(t._1,t._2);
}
stx.Tuple2.first = function(t) {
	return t._1;
}
stx.Tuple2.second = function(t) {
	return t._2;
}
stx.Tuple2.translate = function(t,f1,f2) {
	return stx.Entuple.entuple(f1(t._1),f2(t._2));
}
stx.Tuple2.swap = function(t) {
	return new stx.Tuple2(t._2,t._1);
}
stx.Tuple2.create = function(_1,_2) {
	return new stx.Tuple2(_1,_2);
}
stx.Tuple2.patch = function(t0,t1) {
	var _1 = t1._1 == null?t0._1:t1._1;
	var _2 = t1._2 == null?t0._2:t1._2;
	return new stx.Tuple2(_1,_2);
}
stx.Tuple2.__super__ = stx.AbstractProduct;
stx.Tuple2.prototype = $extend(stx.AbstractProduct.prototype,{
	get_length: function() {
		return 2;
	}
	,get_prefix: function() {
		return "stx.Tuple2";
	}
	,_2: null
	,_1: null
	,__class__: stx.Tuple2
});
stx.Tuple3 = $hxClasses["stx.Tuple3"] = function(_1,_2,_3) {
	this._1 = _1;
	this._2 = _2;
	this._3 = _3;
	stx.AbstractProduct.call(this,[_1,_2,_3]);
};
stx.Tuple3.__name__ = ["stx","Tuple3"];
stx.Tuple3.into = function(t,f) {
	return f(t._1,t._2,t._3);
}
stx.Tuple3.translate = function(t,f1,f2,f3) {
	return stx.Tuple2.entuple(stx.Entuple.entuple(f1(t._1),f2(t._2)),f3(t._3));
}
stx.Tuple3.entuple = function(t,d) {
	return new stx.Tuple4(t._1,t._2,t._3,d);
}
stx.Tuple3.first = function(t) {
	return t._1;
}
stx.Tuple3.second = function(t) {
	return t._2;
}
stx.Tuple3.third = function(t) {
	return t._3;
}
stx.Tuple3.create = function(_1,_2,_3) {
	return new stx.Tuple3(_1,_2,_3);
}
stx.Tuple3.patch = function(t0,t1) {
	var _1 = t1._1 == null?t0._1:t1._1;
	var _2 = t1._2 == null?t0._2:t1._2;
	var _3 = t1._3 == null?t0._3:t1._3;
	return new stx.Tuple3(_1,_2,_3);
}
stx.Tuple3.__super__ = stx.AbstractProduct;
stx.Tuple3.prototype = $extend(stx.AbstractProduct.prototype,{
	get_length: function() {
		return 3;
	}
	,get_prefix: function() {
		return "stx.Tuple3";
	}
	,_3: null
	,_2: null
	,_1: null
	,__class__: stx.Tuple3
});
stx.Tuple4 = $hxClasses["stx.Tuple4"] = function(first,second,third,fourth) {
	stx.AbstractProduct.call(this,[first,second,third,fourth]);
	this._1 = first;
	this._2 = second;
	this._3 = third;
	this._4 = fourth;
};
stx.Tuple4.__name__ = ["stx","Tuple4"];
stx.Tuple4.into = function(t,f) {
	return f(t._1,t._2,t._3,t._4);
}
stx.Tuple4.first = function(t) {
	return t._1;
}
stx.Tuple4.second = function(t) {
	return t._2;
}
stx.Tuple4.third = function(t) {
	return t._3;
}
stx.Tuple4.fourth = function(t) {
	return t._4;
}
stx.Tuple4.create = function(_1,_2,_3,_4) {
	return new stx.Tuple4(_1,_2,_3,_4);
}
stx.Tuple4.patch = function(t0,t1) {
	var _1 = t1._1 == null?t0._1:t1._1;
	var _2 = t1._2 == null?t0._2:t1._2;
	var _3 = t1._3 == null?t0._3:t1._3;
	var _4 = t1._4 == null?t0._4:t1._4;
	return new stx.Tuple4(_1,_2,_3,_4);
}
stx.Tuple4.__super__ = stx.AbstractProduct;
stx.Tuple4.prototype = $extend(stx.AbstractProduct.prototype,{
	entuple: function(_5) {
		return new stx.Tuple5(this._1,this._2,this._3,this._4,_5);
	}
	,get_length: function() {
		return 4;
	}
	,get_prefix: function() {
		return "stx.Tuple4";
	}
	,_4: null
	,_3: null
	,_2: null
	,_1: null
	,__class__: stx.Tuple4
});
stx.Tuple5 = $hxClasses["stx.Tuple5"] = function(first,second,third,fourth,fifth) {
	stx.AbstractProduct.call(this,[first,second,third,fourth,fifth]);
	this._1 = first;
	this._2 = second;
	this._3 = third;
	this._4 = fourth;
	this._5 = fifth;
};
stx.Tuple5.__name__ = ["stx","Tuple5"];
stx.Tuple5.into = function(t,f) {
	return f(t._1,t._2,t._3,t._4,t._5);
}
stx.Tuple5.first = function(t) {
	return t._1;
}
stx.Tuple5.second = function(t) {
	return t._2;
}
stx.Tuple5.third = function(t) {
	return t._3;
}
stx.Tuple5.fourth = function(t) {
	return t._4;
}
stx.Tuple5.fifth = function(t) {
	return t._5;
}
stx.Tuple5.create = function(_1,_2,_3,_4,_5) {
	return new stx.Tuple5(_1,_2,_3,_4,_5);
}
stx.Tuple5.patch = function(t0,t1) {
	var _1 = t1._1 == null?t0._1:t1._1;
	var _2 = t1._2 == null?t0._2:t1._2;
	var _3 = t1._3 == null?t0._3:t1._3;
	var _4 = t1._4 == null?t0._4:t1._4;
	var _5 = t1._5 == null?t0._5:t1._5;
	return new stx.Tuple5(_1,_2,_3,_4,_5);
}
stx.Tuple5.__super__ = stx.AbstractProduct;
stx.Tuple5.prototype = $extend(stx.AbstractProduct.prototype,{
	get_length: function() {
		return 5;
	}
	,get_prefix: function() {
		return "stx.Tuple5";
	}
	,_5: null
	,_4: null
	,_3: null
	,_2: null
	,_1: null
	,__class__: stx.Tuple5
});
stx.Entuple = $hxClasses["stx.Entuple"] = function() { }
stx.Entuple.__name__ = ["stx","Entuple"];
stx.Entuple.entuple = function(a,b) {
	return new stx.Tuple2(a,b);
}
if(!stx.error) stx.error = {}
stx.error.Error = $hxClasses["stx.error.Error"] = function(msg,pos) {
	this.msg = msg;
	this.pos = pos;
};
stx.error.Error.__name__ = ["stx","error","Error"];
stx.error.Error.__properties__ = {get_exception:"get_exception"}
stx.error.Error.exception = null;
stx.error.Error.get_exception = function() {
	if(stx.error.Error.exception == null) stx.error.Error.exception = new stx.Future();
	return stx.error.Error.exception;
}
stx.error.Error.toError = function(msg,pos) {
	return new stx.error.Error(msg,pos);
}
stx.error.Error.prototype = {
	toString: function() {
		return "Error: (" + this.msg + " at " + stx.error.Positions.toString(this.pos) + ")";
	}
	,except: function() {
		stx.error.Error.get_exception().deliver(this,{ fileName : "Error.hx", lineNumber : 22, className : "stx.error.Error", methodName : "except"});
		return this;
	}
	,pos: null
	,msg: null
	,__class__: stx.error.Error
}
stx.error.Positions = $hxClasses["stx.error.Positions"] = function() { }
stx.error.Positions.__name__ = ["stx","error","Positions"];
stx.error.Positions.toString = function(pos) {
	if(pos == null) return "nil";
	var type = pos.className.split(".");
	return type[type.length - 1] + "::" + pos.methodName + "#" + pos.lineNumber;
}
stx.error.Positions.here = function(pos) {
	return pos;
}
if(!stx.framework) stx.framework = {}
stx.framework.BindingType = $hxClasses["stx.framework.BindingType"] = { __ename__ : ["stx","framework","BindingType"], __constructs__ : ["OneToOne","OneToMany"] }
stx.framework.BindingType.OneToOne = ["OneToOne",0];
stx.framework.BindingType.OneToOne.toString = $estr;
stx.framework.BindingType.OneToOne.__enum__ = stx.framework.BindingType;
stx.framework.BindingType.OneToMany = ["OneToMany",1];
stx.framework.BindingType.OneToMany.toString = $estr;
stx.framework.BindingType.OneToMany.__enum__ = stx.framework.BindingType;
stx.framework.InjectorConfig = $hxClasses["stx.framework.InjectorConfig"] = function() { }
stx.framework.InjectorConfig.__name__ = ["stx","framework","InjectorConfig"];
stx.framework.InjectorConfig.prototype = {
	inPackage: null
	,inModule: null
	,inClass: null
	,bindF: null
	,bind: null
	,__class__: stx.framework.InjectorConfig
}
stx.framework.Injector = $hxClasses["stx.framework.Injector"] = function() { }
stx.framework.Injector.__name__ = ["stx","framework","Injector"];
stx.framework.Injector.inject = function(interf,pos) {
	return stx.framework._Injector.InjectorImpl.inject(interf,pos);
}
stx.framework.Injector.enter = function(f) {
	return stx.framework._Injector.InjectorImpl.enter(f);
}
stx.framework.Injector.forever = function(f) {
	return stx.framework._Injector.InjectorImpl.forever(f);
}
if(!stx.framework._Injector) stx.framework._Injector = {}
stx.framework._Injector.InjectorImpl = $hxClasses["stx.framework._Injector.InjectorImpl"] = function() { }
stx.framework._Injector.InjectorImpl.__name__ = ["stx","framework","_Injector","InjectorImpl"];
stx.framework._Injector.InjectorImpl.__properties__ = {get_state:"get_state"}
stx.framework._Injector.InjectorImpl.state = null;
stx.framework._Injector.InjectorImpl.get_state = function() {
	return stx.framework._Injector.InjectorImpl.state == null?stx.framework._Injector.InjectorImpl.state = []:stx.framework._Injector.InjectorImpl.state;
}
stx.framework._Injector.InjectorImpl.classBindingsExtractor = function(b) {
	return b.classBindings;
}
stx.framework._Injector.InjectorImpl.moduleBindingsExtractor = function(b) {
	return b.moduleBindings;
}
stx.framework._Injector.InjectorImpl.packageBindingsExtractor = function(b) {
	return b.packageBindings;
}
stx.framework._Injector.InjectorImpl.inject = function(interf,pos) {
	var binding = stx.framework._Injector.InjectorImpl.getMostSpecificBinding(interf,pos);
	var factory = stx.Options.getOrElse(binding,stx.Functions2.lazy(SBase.error,"No binding defined for " + Type.getClassName(interf),SBase.here({ fileName : "Injector.hx", lineNumber : 142, className : "stx.framework._Injector.InjectorImpl", methodName : "inject"})));
	return factory();
}
stx.framework._Injector.InjectorImpl.forever = function(f) {
	stx.framework._Injector.InjectorImpl.get_state().unshift({ defaultBindings : new Hash(), globalBindings : new Hash(), packageBindings : new Hash(), moduleBindings : new Hash(), classBindings : new Hash()});
	return f(new stx.framework._Injector.InjectorConfigImpl());
}
stx.framework._Injector.InjectorImpl.enter = function(f) {
	stx.framework._Injector.InjectorImpl.get_state().unshift({ defaultBindings : new Hash(), globalBindings : new Hash(), packageBindings : new Hash(), moduleBindings : new Hash(), classBindings : new Hash()});
	var result = null;
	try {
		result = f(new stx.framework._Injector.InjectorConfigImpl());
		stx.framework._Injector.InjectorImpl.get_state().shift();
	} catch( e ) {
		stx.framework._Injector.InjectorImpl.get_state().shift();
		throw e;
	}
	return result;
}
stx.framework._Injector.InjectorImpl.bindTo = function(interf,impl,bindingType) {
	return stx.framework._Injector.InjectorImpl.globally().bindTo(interf,impl,bindingType);
}
stx.framework._Injector.InjectorImpl.bindToF = function(interf,f,bindingType) {
	return stx.framework._Injector.InjectorImpl.globally().bindToF(interf,f,bindingType);
}
stx.framework._Injector.InjectorImpl.globally = function() {
	var internalBind = function(interf,f,bindingType) {
		switch( (stx.framework._Injector.InjectorImpl.bindingTypeDef(bindingType))[1] ) {
		case 0:
			stx.framework._Injector.InjectorImpl.addGlobalBinding(interf,f);
			break;
		case 1:
			stx.framework._Injector.InjectorImpl.addGlobalBinding(interf,stx.Dynamics.memoize(f));
			break;
		}
	};
	return { bindToF : internalBind, bindTo : function(interf,impl,bindingType) {
		internalBind(interf,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType);
	}};
}
stx.framework._Injector.InjectorImpl.inClass = function(c) {
	return { bindToF : function(interf,f,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.classBindingsExtractor,interf,Type.getClassName(c),f,bindingType);
	}, bindTo : function(interf,impl,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.classBindingsExtractor,interf,Type.getClassName(c),stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType);
	}};
}
stx.framework._Injector.InjectorImpl.inModule = function(moduleName) {
	return { bindToF : function(interf,f,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,interf,moduleName,f,bindingType);
	}, bindTo : function(interf,impl,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,interf,moduleName,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType);
	}};
}
stx.framework._Injector.InjectorImpl.inPackage = function(packageName) {
	return { bindToF : function(interf,f,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,interf,packageName,f,bindingType);
	}, bindTo : function(interf,impl,bindingType) {
		stx.framework._Injector.InjectorImpl.bindForSpecificF(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,interf,packageName,stx.framework._Injector.InjectorImpl.factoryFor(impl),bindingType);
	}};
}
stx.framework._Injector.InjectorImpl.bindForSpecificF = function(extractor,interf,specific,f,bindingType) {
	switch( (stx.framework._Injector.InjectorImpl.bindingTypeDef(bindingType))[1] ) {
	case 0:
		stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.get_state()[0]),interf,specific,f);
		break;
	case 1:
		stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.get_state()[0]),interf,specific,stx.Dynamics.memoize(f));
		break;
	}
}
stx.framework._Injector.InjectorImpl.getMostSpecificBinding = function(c,pos) {
	var className = stx.framework._Injector.InjectorImpl.classOf(pos);
	var moduleName = stx.framework._Injector.InjectorImpl.moduleOf(pos);
	var packageName = stx.framework._Injector.InjectorImpl.packageOf(pos);
	return stx.Options.orElse(stx.Options.orElse(stx.Options.orElse(stx.Options.orElse(stx.framework._Injector.InjectorImpl.getClassBinding(c,className),stx.Functions2.lazy(stx.framework._Injector.InjectorImpl.getModuleBinding,c,moduleName)),stx.Functions2.lazy(stx.framework._Injector.InjectorImpl.getPackageBinding,c,packageName)),stx.Functions1.lazy(stx.framework._Injector.InjectorImpl.getGlobalBinding,c)),stx.Functions1.lazy(stx.framework._Injector.InjectorImpl.getDefaultImplementationBinding,c));
}
stx.framework._Injector.InjectorImpl.getDefaultImplementationBinding = function(c) {
	if(stx.framework._Injector.InjectorImpl.existsDefaultBinding(c)) return stx.framework._Injector.InjectorImpl.getDefaultBinding(c);
	var f = stx.Options.flatMap(stx.Options.flatMap(stx.Options.flatMap(stx.Options.create(haxe.rtti.Meta.getType(c)),function(m) {
		return stx.Options.create(Reflect.hasField(m,"DefaultImplementation")?Reflect.field(m,"DefaultImplementation"):null);
	}),function(p) {
		var cls = null;
		return null == p || null == p[0] || null == (cls = Type.resolveClass(p[0]))?stx.Option.None:stx.Option.Some(new stx.Tuple2(cls,null != p[1]?Type.createEnum(stx.framework.BindingType,p[1],[]):null));
	}),function(p) {
		return (function($this) {
			var $r;
			switch( (stx.framework._Injector.InjectorImpl.bindingTypeDef(p._2))[1] ) {
			case 0:
				$r = stx.Options.toOption(stx.framework._Injector.InjectorImpl.factoryFor(p._1));
				break;
			case 1:
				$r = stx.Options.toOption(stx.Dynamics.memoize(stx.framework._Injector.InjectorImpl.factoryFor(p._1)));
				break;
			}
			return $r;
		}(this));
	});
	try {
		stx.framework._Injector.InjectorImpl.addDefaultBinding(c,f);
	} catch( e ) {
		throw "No Injector context, use stx.framework.Injector.enter";
	}
	return f;
}
stx.framework._Injector.InjectorImpl.getGlobalBinding = function(c) {
	var className = Type.getClassName(c);
	return SArrays.foldl(stx.framework._Injector.InjectorImpl.get_state(),stx.Option.None,function(a,b) {
		return stx.Options.orElseC(a,stx.Options.toOption(b.globalBindings.get(className)));
	});
}
stx.framework._Injector.InjectorImpl.getClassBinding = function(c,className) {
	return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.classBindingsExtractor,c,className);
}
stx.framework._Injector.InjectorImpl.getModuleBinding = function(c,moduleName) {
	return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.moduleBindingsExtractor,c,moduleName);
}
stx.framework._Injector.InjectorImpl.getPackageBinding = function(c,packageName) {
	return stx.framework._Injector.InjectorImpl.getSpecificBinding(stx.framework._Injector.InjectorImpl.packageBindingsExtractor,c,packageName);
}
stx.framework._Injector.InjectorImpl.addGlobalBinding = function(c,f) {
	stx.framework._Injector.InjectorImpl.get_state()[0].globalBindings.set(Type.getClassName(c),f);
}
stx.framework._Injector.InjectorImpl.existsDefaultBinding = function(c) {
	return stx.framework._Injector.InjectorImpl.get_state()[0] == null?false:stx.framework._Injector.InjectorImpl.get_state()[0].defaultBindings.exists(Type.getClassName(c));
}
stx.framework._Injector.InjectorImpl.addDefaultBinding = function(c,f) {
	stx.framework._Injector.InjectorImpl.get_state()[0].defaultBindings.set(Type.getClassName(c),f);
}
stx.framework._Injector.InjectorImpl.getDefaultBinding = function(c) {
	return stx.framework._Injector.InjectorImpl.get_state()[0].defaultBindings.get(Type.getClassName(c));
}
stx.framework._Injector.InjectorImpl.getSpecificBinding = function(extractor,c,specific) {
	var _g = 0, _g1 = stx.framework._Injector.InjectorImpl.get_state();
	while(_g < _g1.length) {
		var bindings = _g1[_g];
		++_g;
		var binding = extractor(bindings);
		var result = stx.Options.flatMap(stx.Options.toOption(binding.get(Type.getClassName(c))),function(h) {
			return stx.Options.toOption(h.get(specific));
		});
		if(!stx.Options.isEmpty(result)) return result;
	}
	return stx.Option.None;
}
stx.framework._Injector.InjectorImpl.addSpecificBinding = function(bindings,c,specific,f) {
	var h = bindings.get(Type.getClassName(c));
	if(h == null) {
		h = new Hash();
		bindings.set(Type.getClassName(c),h);
	}
	h.set(specific,f);
}
stx.framework._Injector.InjectorImpl.classOf = function(pos) {
	return pos.className;
}
stx.framework._Injector.InjectorImpl.packageOf = function(pos) {
	return HxOverrides.substr(pos.className,0,pos.className.lastIndexOf("."));
}
stx.framework._Injector.InjectorImpl.moduleOf = function(pos) {
	var className = stx.framework._Injector.InjectorImpl.classOf(pos);
	var packageName = stx.framework._Injector.InjectorImpl.packageOf(pos);
	var moduleName = packageName + "." + HxOverrides.substr(pos.fileName,0,pos.fileName.lastIndexOf("."));
	return moduleName;
}
stx.framework._Injector.InjectorImpl.factoryFor = function(impl) {
	return function() {
		return Type.createInstance(impl,[]);
	};
}
stx.framework._Injector.InjectorImpl.bindingTypeDef = function(bindingType) {
	return stx.Options.getOrElseC(stx.Options.toOption(bindingType),stx.framework.BindingType.OneToMany);
}
stx.framework._Injector.InjectorConfigImpl = $hxClasses["stx.framework._Injector.InjectorConfigImpl"] = function() {
};
stx.framework._Injector.InjectorConfigImpl.__name__ = ["stx","framework","_Injector","InjectorConfigImpl"];
stx.framework._Injector.InjectorConfigImpl.__interfaces__ = [stx.framework.InjectorConfig];
stx.framework._Injector.InjectorConfigImpl.prototype = {
	inModule: function(m) {
		var self = this;
		return { bind : function(interf,impl,b) {
			stx.framework._Injector.InjectorImpl.inModule(m).bindTo(interf,impl,b);
			return self;
		}, bindF : function(interf,f,b) {
			stx.framework._Injector.InjectorImpl.inModule(m).bindToF(interf,f,b);
			return self;
		}};
	}
	,inPackage: function(p) {
		var self = this;
		return { bind : function(interf,impl,b) {
			stx.framework._Injector.InjectorImpl.inPackage(p).bindTo(interf,impl,b);
			return self;
		}, bindF : function(interf,f,b) {
			stx.framework._Injector.InjectorImpl.inPackage(p).bindToF(interf,f,b);
			return self;
		}};
	}
	,inClass: function(c) {
		var self = this;
		return { bind : function(interf,impl,b) {
			stx.framework._Injector.InjectorImpl.inClass(c).bindTo(interf,impl,b);
			return self;
		}, bindF : function(interf,f,b) {
			stx.framework._Injector.InjectorImpl.inClass(c).bindToF(interf,f,b);
			return self;
		}};
	}
	,bindF: function(interf,f,b) {
		stx.framework._Injector.InjectorImpl.globally().bindToF(interf,f,b);
		return this;
	}
	,bind: function(interf,impl,b) {
		stx.framework._Injector.InjectorImpl.globally().bindTo(interf,impl,b);
		return this;
	}
	,__class__: stx.framework._Injector.InjectorConfigImpl
}
if(!stx.io) stx.io = {}
if(!stx.io.json) stx.io.json = {}
stx.io.json.JValue = $hxClasses["stx.io.json.JValue"] = { __ename__ : ["stx","io","json","JValue"], __constructs__ : ["JNull","JBool","JNumber","JString","JArray","JObject","JField"] }
stx.io.json.JValue.JNull = ["JNull",0];
stx.io.json.JValue.JNull.toString = $estr;
stx.io.json.JValue.JNull.__enum__ = stx.io.json.JValue;
stx.io.json.JValue.JBool = function(v) { var $x = ["JBool",1,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValue.JNumber = function(v) { var $x = ["JNumber",2,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValue.JString = function(v) { var $x = ["JString",3,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValue.JArray = function(v) { var $x = ["JArray",4,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValue.JObject = function(v) { var $x = ["JObject",5,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValue.JField = function(k,v) { var $x = ["JField",6,k,v]; $x.__enum__ = stx.io.json.JValue; $x.toString = $estr; return $x; }
stx.io.json.JValues = $hxClasses["stx.io.json.JValues"] = function() { }
stx.io.json.JValues.__name__ = ["stx","io","json","JValues"];
stx.io.json.JValues.fold = function(v,initial,f) {
	var cur = initial;
	stx.io.json.JValues.map(v,function(j) {
		cur = f(cur,j);
		return j;
	});
	return cur;
}
stx.io.json.JValues.path = function(v,s) {
	var ss = s.split("/"), c = v;
	var $it0 = HxOverrides.iter(ss);
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x.length > 0) c = stx.io.json.JValues.get(c,x);
	}
	return c;
}
stx.io.json.JValues.map = function(v,f) {
	var $e = (v);
	switch( $e[1] ) {
	case 4:
		var xs = $e[2];
		return f(stx.io.json.JValue.JArray(SArrays.map(xs,function(x) {
			return stx.io.json.JValues.map(x,f);
		})));
	case 6:
		var v1 = $e[3], k = $e[2];
		return f(stx.io.json.JValue.JField(k,stx.io.json.JValues.map(v1,f)));
	case 5:
		var fs = $e[2];
		return f(stx.io.json.JValue.JObject(SArrays.map(fs,function(field) {
			return stx.io.json.JValues.map(field,f);
		})));
	default:
		return f(v);
	}
}
stx.io.json.JValues.getOption = function(v,k) {
	var $e = (v);
	switch( $e[1] ) {
	case 5:
		var xs = $e[2];
		var hash = stx.io.json.JValues.extractHash(v);
		return hash.exists(k)?stx.Option.Some(hash.get(k)):stx.Option.None;
	default:
		return stx.Option.None;
	}
}
stx.io.json.JValues.get = function(v,k) {
	return (function($this) {
		var $r;
		var $e = (stx.io.json.JValues.getOption(v,k));
		switch( $e[1] ) {
		case 1:
			var v1 = $e[2];
			$r = v1;
			break;
		case 0:
			$r = SBase.error("Expected to find field " + k + " in " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 72, className : "stx.io.json.JValues", methodName : "get"});
			break;
		}
		return $r;
	}(this));
}
stx.io.json.JValues.getOrElse = function(v,k,def) {
	return (function($this) {
		var $r;
		var $e = (stx.io.json.JValues.getOption(v,k));
		switch( $e[1] ) {
		case 1:
			var v1 = $e[2];
			$r = v1;
			break;
		case 0:
			$r = def();
			break;
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractString = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			var s = $e[2];
			$r = s;
			break;
		default:
			$r = SBase.error("Expected JString but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 85, className : "stx.io.json.JValues", methodName : "extractString"});
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractNumber = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 2:
			var n = $e[2];
			$r = n;
			break;
		default:
			$r = SBase.error("Expected JNumber but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 92, className : "stx.io.json.JValues", methodName : "extractNumber"});
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractBool = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 1:
			var b = $e[2];
			$r = b;
			break;
		default:
			$r = SBase.error("Expected JBool but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 99, className : "stx.io.json.JValues", methodName : "extractBool"});
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractKey = function(v) {
	return stx.io.json.JValues.extractField(v)._1;
}
stx.io.json.JValues.extractValue = function(v) {
	return stx.io.json.JValues.extractField(v)._2;
}
stx.io.json.JValues.extractField = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 6:
			var v1 = $e[3], k = $e[2];
			$r = new stx.Tuple2(k,v1);
			break;
		default:
			$r = SBase.error("Expected JField but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 111, className : "stx.io.json.JValues", methodName : "extractField"});
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractHash = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 5:
			var xs = $e[2];
			$r = (function($this) {
				var $r;
				var hash = new Hash();
				{
					var _g = 0;
					while(_g < xs.length) {
						var x = xs[_g];
						++_g;
						var field = stx.io.json.JValues.extractField(x);
						hash.set(field._1,field._2);
					}
				}
				$r = hash;
				return $r;
			}($this));
			break;
		default:
			$r = SBase.error("Expected JObject but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 127, className : "stx.io.json.JValues", methodName : "extractHash"});
		}
		return $r;
	}(this));
}
stx.io.json.JValues.extractFields = function(v) {
	return SArrays.flatMap(stx.io.json.JValues.extractArray(v),function(j) {
		return (function($this) {
			var $r;
			var $e = (j);
			switch( $e[1] ) {
			case 6:
				var v1 = $e[3], k = $e[2];
				$r = [new stx.Tuple2(k,v1)];
				break;
			default:
				$r = [];
			}
			return $r;
		}(this));
	});
}
stx.io.json.JValues.extractArray = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var xs = $e[2];
			$r = xs;
			break;
		case 5:
			var xs = $e[2];
			$r = xs;
			break;
		default:
			$r = SBase.error("Expected JArray or JObject but found: " + Std.string(v),{ fileName : "JValue.hx", lineNumber : 145, className : "stx.io.json.JValues", methodName : "extractArray"});
		}
		return $r;
	}(this));
}
stx.io.json.Json = $hxClasses["stx.io.json.Json"] = function() { }
stx.io.json.Json.__name__ = ["stx","io","json","Json"];
stx.io.json.Json.toObject = function(v) {
	var $e = (v);
	switch( $e[1] ) {
	case 0:
		return null;
	case 3:
		var v1 = $e[2];
		return v1;
	case 2:
		var v1 = $e[2];
		return v1;
	case 1:
		var v1 = $e[2];
		return v1;
	case 4:
		var xs = $e[2];
		return SArrays.map(xs,function(x) {
			return stx.io.json.Json.toObject(x);
		});
	case 5:
		var fs = $e[2];
		return SArrays.foldl(fs,{ },function(o,e) {
			var field = stx.io.json.JValues.extractField(e);
			o[field._1] = stx.io.json.Json.toObject(field._2);
			return o;
		});
	case 6:
		var v1 = $e[3], k = $e[2];
		return SBase.error("Cannot convert JField to object",{ fileName : "Json.hx", lineNumber : 45, className : "stx.io.json.Json", methodName : "toObject"});
	}
}
stx.io.json.Json.fromObject = function(d) {
	var $e = (Type["typeof"](d));
	switch( $e[1] ) {
	case 8:
		throw "Type of object must be definite: " + Std.string(d);
		break;
	case 6:
		var c = $e[2];
		if(js.Boot.__instanceof(d,String)) return stx.io.json.JValue.JString(d); else if(js.Boot.__instanceof(d,Hash)) return stx.io.json.JValue.JObject(d.keys.toArray().map(function(k) {
			return stx.io.json.JValue.JField(k,d.get(k));
		})); else if(js.Boot.__instanceof(d,Array)) return stx.io.json.JValue.JArray(SArrays.map(js.Boot.__cast(d , Array),stx.io.json.Json.fromObject)); else return SBase.error("Unknown object type: " + Std.string(d),{ fileName : "Json.hx", lineNumber : 55, className : "stx.io.json.Json", methodName : "fromObject"});
		break;
	case 7:
		var e = $e[2];
		return SBase.error("Json.fromObject does not support enum conversions.",{ fileName : "Json.hx", lineNumber : 57, className : "stx.io.json.Json", methodName : "fromObject"});
	case 5:
		return SBase.error("Json.fromObject does not support function conversions.",{ fileName : "Json.hx", lineNumber : 58, className : "stx.io.json.Json", methodName : "fromObject"});
	case 0:
		return stx.io.json.JValue.JNull;
	case 3:
		return stx.io.json.JValue.JBool(d);
	case 1:
		return stx.io.json.JValue.JNumber(d);
	case 2:
		return stx.io.json.JValue.JNumber(d);
	case 4:
		return stx.io.json.JValue.JObject(SArrays.map(Reflect.fields(d),function(f) {
			return stx.io.json.JValue.JField(f,stx.io.json.Json.fromObject(Reflect.field(d,f)));
		}));
	}
}
stx.io.json.Json.encode = function(v) {
	var $e = (v);
	switch( $e[1] ) {
	case 0:
		return "null";
	case 3:
		var v1 = $e[2];
		return "\"" + new EReg(".","").customReplace(new EReg("(\n)","g").replace(new EReg("(\"|\\\\)","g").replace(v1,"\\$1"),"\\n"),function(r) {
			var c = HxOverrides.cca(r.matched(0),0);
			return c >= 32 && c <= 127?String.fromCharCode(c):"\\u" + StringTools.hex(c,4);
		}) + "\"";
	case 2:
		var v1 = $e[2];
		return Std.string(v1);
	case 1:
		var v1 = $e[2];
		return v1?"true":"false";
	case 4:
		var xs = $e[2];
		return "[" + SArrays.map(xs,stx.io.json.Json.encode).join(",") + "]";
	case 5:
		var fs = $e[2];
		return "{" + SArrays.map(fs,function(f) {
			var field = stx.io.json.JValues.extractField(f);
			return stx.io.json.Json.encode(stx.io.json.JValue.JString(field._1)) + ":" + stx.io.json.Json.encode(field._2);
		}).join(",") + "}";
	case 6:
		var v1 = $e[3], k = $e[2];
		return SBase.error("Cannot encode JField",{ fileName : "Json.hx", lineNumber : 82, className : "stx.io.json.Json", methodName : "encode"});
	}
}
stx.io.json.Json.decode = function(s) {
	var i = 0, l = s.length, mark, line = 1, temp, type = 0;
	var current = new Array(), last = null;
	var names = new Array(), name = null;
	var value = null;
	var states = new Array(), state = 0;
	while((mark = i) < l) {
		var escaped = false;
		while(i < l && "\n\r\t ".indexOf(temp = s.charAt(i)) > -1) {
			mark = ++i;
			if("\n\r".indexOf(temp) > -1) ++line;
		}
		if(i < l) {
			if((temp = s.charAt(i)) == "\"") {
				type = 4;
				while(++i < l && (escaped || (temp = s.charAt(i)) != "\"")) escaped = !escaped && temp == "\\";
			} else if("{[,:]}".indexOf(temp) > -1) {
				type = HxOverrides.cca(temp,0) % 12;
				++i;
			} else if(temp == "f") {
				type = 2;
				i += 5;
			} else if("tn".indexOf(temp) > -1) {
				type = HxOverrides.cca(temp,0) % 5;
				i += 4;
			} else if("0123456789.-".indexOf(temp) > -1) {
				type = 6;
				while(++i < l && "0123456789.eE+-".indexOf(s.charAt(i)) > -1) {
				}
			} else throw "Invalid JSON lexeme starting at character " + Std.string(i) + ": " + temp + " (character code " + Std.string(HxOverrides.cca(temp,0)) + ", on line " + Std.string(line) + ")";
		}
		if(type == 4) {
			temp = HxOverrides.substr(s,mark + 1,i - mark - 1);
			++i;
		} else if(type == 6) temp = HxOverrides.substr(s,mark,i - mark);
		switch(type) {
		case 3:
			current.push(last = stx.io.json.JValue.JObject(new Array()));
			names.push(name);
			name = null;
			states.push(state);
			state = 2;
			value = null;
			break;
		case 7:
			current.push(last = stx.io.json.JValue.JArray(new Array()));
			states.push(state);
			state = 1;
			value = null;
			break;
		case 8:
			if(state == 1 && value != null) stx.io.json.JValues.extractArray(last).push(value); else if(state == 3 && name != null && value != null) {
				stx.io.json.JValues.extractArray(last).push(stx.io.json.JValue.JField(name,value));
				state = 2;
			}
			value = null;
			break;
		case 10:
			if(state == 2) {
				name = stx.io.json.JValues.extractString(value);
				state = 3;
			} else throw "Non-sequitur colon on line " + line + " (character " + i + ", state " + state + ")";
			break;
		case 5:
			if(state <= 1) throw "Unmatched closing brace on line " + line + " (character " + i + ")";
			if(name != null && value != null) stx.io.json.JValues.extractArray(last).push(stx.io.json.JValue.JField(name,value));
			value = current.pop();
			state = states.pop();
			name = names.pop();
			if(current.length > 0) last = current[current.length - 1];
			break;
		case 9:
			if(state != 1) throw "Unmatched closing square bracket on line " + line + " (character " + i + ")";
			if(value != null) stx.io.json.JValues.extractArray(last).push(value);
			value = current.pop();
			state = states.pop();
			if(current.length > 0) last = current[current.length - 1];
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
			value = stx.io.json.JValue.JString(new EReg("\\\\([bfnrt\\\\/\"]|u[0-9a-fA-F]{4})","").customReplace(temp,function(r) {
				var s1 = r.matched(1);
				if(s1 == "n") return "\n"; else if(s1 == "r") return "\r"; else if(s1 == "b") return ""; else if(s1 == "f") return ""; else if(s1 == "t") return "\t"; else if(s1 == "\\") return "\\"; else if(s1 == "\"") return "\""; else if(s1 == "/") return "/"; else return String.fromCharCode(Std.parseInt("0x" + HxOverrides.substr(s1,1,null)));
			}));
			break;
		case 6:
			value = stx.io.json.JValue.JNumber(Std.parseFloat(temp));
			break;
		}
	}
	if(current.length > 0) throw "Closing brace/bracket deficit of " + Std.string(current.length);
	return value;
}
if(!stx.macro) stx.macro = {}
stx.macro.F = $hxClasses["stx.macro.F"] = function() { }
stx.macro.F.__name__ = ["stx","macro","F"];
stx.macro.F.flatMap = function(a,fn) {
	var o = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		o = o.concat(fn(e));
	}
	return o;
}
stx.macro.F.mk_fun = function(args,e) {
	return { args : args, ret : null, expr : e, params : stx.macro.F.gt_prms(e)};
}
stx.macro.F.gt_prms = function(e) {
	return [];
}
stx.macro.F.mk_args = function(e) {
	return (function($this) {
		var $r;
		var $e = (e.expr);
		switch( $e[1] ) {
		case 6:
			var values = $e[2];
			$r = stx.macro.F.flatMap(values,function(x) {
				return (function($this) {
					var $r;
					var $e = (x.expr);
					switch( $e[1] ) {
					case 0:
						var c = $e[2];
						$r = (function($this) {
							var $r;
							var $e = (c);
							switch( $e[1] ) {
							case 3:
								var s = $e[2];
								$r = [stx.macro.F.mk_fn_arg(s)];
								break;
							default:
								$r = [];
							}
							return $r;
						}($this));
						break;
					case 10:
						var vars = $e[2];
						$r = Lambda.array(Lambda.map(vars,function(x1) {
							return stx.macro.F.mk_fn_arg(x1.name,x1.type);
						}));
						break;
					default:
						$r = [];
					}
					return $r;
				}(this));
			});
			break;
		case 0:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (c);
				switch( $e[1] ) {
				case 3:
					var s = $e[2];
					$r = [stx.macro.F.mk_fn_arg(s)];
					break;
				default:
					$r = [];
				}
				return $r;
			}($this));
			break;
		case 10:
			var vars = $e[2];
			$r = Lambda.array(Lambda.map(vars,function(x) {
				return stx.macro.F.mk_fn_arg(x.name,x.type);
			}));
			break;
		default:
			$r = [];
		}
		return $r;
	}(this));
}
stx.macro.F.mk_fn_arg = function(name,t) {
	return { name : name, opt : false, type : t, value : null};
}
stx.macro.Tp = $hxClasses["stx.macro.Tp"] = function() { }
stx.macro.Tp.__name__ = ["stx","macro","Tp"];
if(!stx.plus) stx.plus = {}
stx.plus.Equal = $hxClasses["stx.plus.Equal"] = function() { }
stx.plus.Equal.__name__ = ["stx","plus","Equal"];
stx.plus.Equal.nil = function(a,b) {
	return (stx.plus.Equal._createEqualImpl(function(a1,b1) {
		return SBase.error("at least one of the arguments should be null",{ fileName : "Equal.hx", lineNumber : 18, className : "stx.plus.Equal", methodName : "nil"});
	}))(a,b);
}
stx.plus.Equal.getEqualFor = function(v) {
	var o = stx.plus.Equal.getEqualForType(Type["typeof"](v));
	return o;
}
stx.plus.Equal.getEqualForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.plus.Equal._createEqualImpl(stx.Bools.equals);
			break;
		case 1:
			$r = stx.plus.Equal._createEqualImpl(stx.Ints.equals);
			break;
		case 2:
			$r = stx.plus.Equal._createEqualImpl(stx.Floats.equals);
			break;
		case 8:
			$r = function(a,b) {
				return a == b;
			};
			break;
		case 4:
			$r = stx.plus.Equal._createEqualImpl(function(a,b) {
				var _g = 0, _g1 = Reflect.fields(a);
				while(_g < _g1.length) {
					var key = _g1[_g];
					++_g;
					var va = Reflect.field(a,key);
					if(!(stx.plus.Equal.getEqualFor(va))(va,Reflect.field(b,key))) return false;
				}
				return true;
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.plus.Equal._createEqualImpl(stx.Strings.equals);
					break;
				case "Date":
					$r = stx.plus.Equal._createEqualImpl(stx.Dates.equals);
					break;
				case "Array":
					$r = stx.plus.Equal._createEqualImpl(stx.plus.ArrayEqual.equals);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.plus.Equal._createEqualImpl(stx.plus.ProductEqual.equals);
					break;
				default:
					$r = stx.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var fields = stx.plus.Meta._fieldsWithMeta(c,"equalHash");
						$r = stx.plus.Equal._createEqualImpl(function(a1,b1) {
							var values = SArrays.map(fields,function(v1) {
								return new stx.Tuple2(Reflect.field(a1,v1),Reflect.field(b1,v1));
							});
							var _g = 0;
							while(_g < values.length) {
								var value = values[_g];
								++_g;
								if(Reflect.isFunction(value._1)) continue;
								if(!(stx.plus.Equal.getEqualFor(value._1))(value._1,value._2)) return false;
							}
							return true;
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"equals")?stx.plus.Equal._createEqualImpl(function(a,b) {
						return a.equals(b);
					}):SBase.error("class " + Type.getClassName(c) + " has no equals method",{ fileName : "Equal.hx", lineNumber : 76, className : "stx.plus.Equal", methodName : "getEqualForType"});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.plus.Equal._createEqualImpl(function(a,b) {
				if(0 != a[1] - b[1]) return false;
				var pa = a.slice(2);
				var pb = b.slice(2);
				var _g1 = 0, _g = pa.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(!(stx.plus.Equal.getEqualFor(pa[i]))(pa[i],pb[i])) return false;
				}
				return true;
			});
			break;
		case 0:
			$r = stx.plus.Equal.nil;
			break;
		case 5:
			$r = stx.plus.Equal._createEqualImpl(Reflect.compareMethods);
			break;
		}
		return $r;
	}(this));
}
stx.plus.Equal._createEqualImpl = function(impl) {
	return function(a,b) {
		return a == b || a == null && b == null?true:a == null || b == null?false:impl(a,b);
	};
}
stx.plus.ArrayEqual = $hxClasses["stx.plus.ArrayEqual"] = function() { }
stx.plus.ArrayEqual.__name__ = ["stx","plus","ArrayEqual"];
stx.plus.ArrayEqual.equals = function(v1,v2) {
	return stx.plus.ArrayEqual.equalsWith(v1,v2,stx.plus.Equal.getEqualFor(v1[0]));
}
stx.plus.ArrayEqual.equalsWith = function(v1,v2,equal) {
	if(v1.length != v2.length) return false;
	if(v1.length == 0) return true;
	var _g1 = 0, _g = v1.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(!equal(v1[i],v2[i])) return false;
	}
	return true;
}
stx.plus.ProductEqual = $hxClasses["stx.plus.ProductEqual"] = function() { }
stx.plus.ProductEqual.__name__ = ["stx","plus","ProductEqual"];
stx.plus.ProductEqual.getEqual = function(p,i) {
	return stx.plus.Equal.getEqualFor(p.element(i));
}
stx.plus.ProductEqual.productEquals = function(p,other) {
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		if(!(stx.plus.ProductEqual.getEqual(p,i))(p.element(i),other.element(i))) return false;
	}
	return true;
}
stx.plus.ProductEqual.equals = function(p,other) {
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		if(!(stx.plus.ProductEqual.getEqual(p,i))(p.element(i),other.element(i))) return false;
	}
	return true;
}
stx.plus.Hasher = $hxClasses["stx.plus.Hasher"] = function() { }
stx.plus.Hasher.__name__ = ["stx","plus","Hasher"];
stx.plus.Hasher._createHashImpl = function(impl) {
	return function(v) {
		if(null == v) return 0; else return impl(v);
	};
}
stx.plus.Hasher.getHashFor = function(t) {
	return stx.plus.Hasher.getHashForType(Type["typeof"](t));
}
stx.plus.Hasher.getHashForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.plus.Hasher._createHashImpl(stx.plus.BoolHasher.hashCode);
			break;
		case 1:
			$r = stx.plus.Hasher._createHashImpl(stx.plus.IntHasher.hashCode);
			break;
		case 2:
			$r = stx.plus.Hasher._createHashImpl(stx.plus.FloatHasher.hashCode);
			break;
		case 8:
			$r = stx.plus.Hasher._createHashImpl(function(v1) {
				return SBase.error("can't retrieve hascode for TUnknown: " + Std.string(v1),{ fileName : "Hasher.hx", lineNumber : 35, className : "stx.plus.Hasher", methodName : "getHashForType"});
			});
			break;
		case 4:
			$r = stx.plus.Hasher._createHashImpl(function(v1) {
				var s = (stx.plus.Show.getShowFor(v1))(v1);
				return (stx.plus.Hasher.getHashFor(s))(s);
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.plus.Hasher._createHashImpl(stx.plus.StringHasher.hashCode);
					break;
				case "Date":
					$r = stx.plus.Hasher._createHashImpl(stx.plus.DateHasher.hashCode);
					break;
				case "Array":
					$r = stx.plus.Hasher._createHashImpl(stx.plus.ArrayHasher.hashCode);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.plus.Hasher._createHashImpl(stx.plus.ProductHasher.hashCode);
					break;
				default:
					$r = (function($this) {
						var $r;
						var fields = Type.getInstanceFields(c);
						$r = stx.plus.Meta._hasMetaDataClass(c)?(function($this) {
							var $r;
							var fields1 = stx.plus.Meta._fieldsWithMeta(c,"equalHash");
							$r = stx.plus.Hasher._createHashImpl(function(v2) {
								var className = Type.getClassName(c);
								var values = SArrays.filter(SArrays.map(fields1,function(f) {
									return Reflect.field(v2,f);
								}),function(v1) {
									return !Reflect.isFunction(v1);
								});
								return SArrays.foldl(values,9901 * stx.plus.StringHasher.hashCode(className),function(v1,e) {
									return v1 + 333667 * ((stx.plus.Hasher.getHashFor(e))(e) + 197192);
								});
							});
							return $r;
						}($this)):HxOverrides.remove(Type.getInstanceFields(c),"hashCode")?stx.plus.Hasher._createHashImpl(function(v1) {
							return Reflect.field(v1,"hashCode").apply(v1,[]);
						}):SBase.error("class does not have a hashCode method",{ fileName : "Hasher.hx", lineNumber : 63, className : "stx.plus.Hasher", methodName : "getHashForType"});
						return $r;
					}($this));
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.plus.Hasher._createHashImpl(function(v1) {
				var hash = stx.plus.StringHasher.hashCode(v1[0]) * 6151;
				var _g = 0, _g1 = v1.slice(2);
				while(_g < _g1.length) {
					var i = _g1[_g];
					++_g;
					hash += (stx.plus.Hasher.getHashFor(i))(i) * 6151;
				}
				return hash;
			});
			break;
		case 5:
			$r = stx.plus.Hasher._createHashImpl(function(v1) {
				return SBase.error("function can't provide a hash code",{ fileName : "Hasher.hx", lineNumber : 74, className : "stx.plus.Hasher", methodName : "getHashForType"});
			});
			break;
		case 0:
			$r = stx.plus.Hasher.nil;
			break;
		default:
			$r = function(v1) {
				return -1;
			};
		}
		return $r;
	}(this));
}
stx.plus.Hasher.nil = function(v) {
	return 0;
}
stx.plus.ArrayHasher = $hxClasses["stx.plus.ArrayHasher"] = function() { }
stx.plus.ArrayHasher.__name__ = ["stx","plus","ArrayHasher"];
stx.plus.ArrayHasher.hashCode = function(v) {
	return stx.plus.ArrayHasher.hashCodeWith(v,stx.plus.Hasher.getHashFor(v[0]));
}
stx.plus.ArrayHasher.hashCodeWith = function(v,hash) {
	var h = 12289;
	if(v.length == 0) return h;
	var _g1 = 0, _g = v.length;
	while(_g1 < _g) {
		var i = _g1++;
		h += hash(v[i]) * 12289;
	}
	return h;
}
stx.plus.StringHasher = $hxClasses["stx.plus.StringHasher"] = function() { }
stx.plus.StringHasher.__name__ = ["stx","plus","StringHasher"];
stx.plus.StringHasher.hashCode = function(v) {
	var hash = 49157;
	var _g1 = 0, _g = v.length;
	while(_g1 < _g) {
		var i = _g1++;
		hash += (24593 + stx.Strings.cca(v,i)) * 49157;
	}
	return hash;
}
stx.plus.DateHasher = $hxClasses["stx.plus.DateHasher"] = function() { }
stx.plus.DateHasher.__name__ = ["stx","plus","DateHasher"];
stx.plus.DateHasher.hashCode = function(v) {
	return Math.round(v.getTime() * 49157);
}
stx.plus.FloatHasher = $hxClasses["stx.plus.FloatHasher"] = function() { }
stx.plus.FloatHasher.__name__ = ["stx","plus","FloatHasher"];
stx.plus.FloatHasher.hashCode = function(v) {
	return v * 98317 | 0;
}
stx.plus.IntHasher = $hxClasses["stx.plus.IntHasher"] = function() { }
stx.plus.IntHasher.__name__ = ["stx","plus","IntHasher"];
stx.plus.IntHasher.hashCode = function(v) {
	return v * 196613;
}
stx.plus.BoolHasher = $hxClasses["stx.plus.BoolHasher"] = function() { }
stx.plus.BoolHasher.__name__ = ["stx","plus","BoolHasher"];
stx.plus.BoolHasher.hashCode = function(v) {
	return v?786433:393241;
}
stx.plus.ProductHasher = $hxClasses["stx.plus.ProductHasher"] = function() { }
stx.plus.ProductHasher.__name__ = ["stx","plus","ProductHasher"];
stx.plus.ProductHasher.getHash = function(p,i) {
	return stx.plus.Hasher.getHashFor(p.element(i));
}
stx.plus.ProductHasher._baseHashes = null;
stx.plus.ProductHasher.hashCode = function(p) {
	var h = 0;
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		h += stx.plus.ProductHasher._baseHashes[p.get_length() - 2][i] * (stx.plus.ProductHasher.getHash(p,i))(p.element(i));
	}
	return h;
}
stx.plus.Meta = $hxClasses["stx.plus.Meta"] = function() { }
stx.plus.Meta.__name__ = ["stx","plus","Meta"];
stx.plus.Meta._hasMetaDataClass = function(c) {
	var m = haxe.rtti.Meta.getType(c);
	return null != m && Reflect.hasField(m,"DataClass");
}
stx.plus.Meta._getMetaDataField = function(c,f) {
	var m = haxe.rtti.Meta.getFields(c);
	if(null == m || !Reflect.hasField(m,f)) return null;
	var fm = Reflect.field(m,f);
	if(!Reflect.hasField(fm,"DataField")) return null;
	return (js.Boot.__cast(Reflect.field(fm,"DataField") , Array)).slice().pop();
}
stx.plus.Meta._fieldsWithMeta = function(c,name) {
	var i = 0;
	return SArrays.map(stx.plus.ArrayOrder.sortWith(SArrays.filter(SArrays.map(Type.getInstanceFields(c),function(v) {
		var fieldMeta = stx.plus.Meta._getMetaDataField(c,v);
		var inc = fieldMeta == null || !Reflect.hasField(fieldMeta,name) || Reflect.field(fieldMeta,name);
		return new stx.Tuple3(v,inc,fieldMeta != null && Reflect.hasField(fieldMeta,"index")?Reflect.field(fieldMeta,"index"):i++);
	}),function(v) {
		return v._2;
	}),function(a,b) {
		var c1 = a._3 - b._3;
		if(c1 != 0) return c1;
		return stx.Strings.compare(a._1,b._1);
	}),function(v) {
		return v._1;
	});
}
stx.plus.Order = $hxClasses["stx.plus.Order"] = function() { }
stx.plus.Order.__name__ = ["stx","plus","Order"];
stx.plus.Order._createOrderImpl = function(impl) {
	return function(a,b) {
		return a == b || a == null && b == null?0:a == null?-1:b == null?1:impl(a,b);
	};
}
stx.plus.Order.nil = function(a,b) {
	return (stx.plus.Order._createOrderImpl(function(a1,b1) {
		return SBase.error("at least one of the arguments should be null",{ fileName : "Order.hx", lineNumber : 27, className : "stx.plus.Order", methodName : "nil"});
	}))(a,b);
}
stx.plus.Order.getOrderFor = function(t) {
	return stx.plus.Order.getOrderForType(Type["typeof"](t));
}
stx.plus.Order.getOrderForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.plus.Order._createOrderImpl(stx.Bools.compare);
			break;
		case 1:
			$r = stx.plus.Order._createOrderImpl(stx.Ints.compare);
			break;
		case 2:
			$r = stx.plus.Order._createOrderImpl(stx.Floats.compare);
			break;
		case 8:
			$r = function(a,b) {
				return a == b?0:a > b?1:-1;
			};
			break;
		case 4:
			$r = stx.plus.Order._createOrderImpl(function(a,b) {
				var _g = 0, _g1 = Reflect.fields(a);
				while(_g < _g1.length) {
					var key = _g1[_g];
					++_g;
					var va = Reflect.field(a,key);
					var vb = Reflect.field(b,key);
					var v1 = (stx.plus.Order.getOrderFor(va))(va,vb);
					if(0 != v1) return v1;
				}
				return 0;
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.plus.Order._createOrderImpl(stx.Strings.compare);
					break;
				case "Date":
					$r = stx.plus.Order._createOrderImpl(stx.Dates.compare);
					break;
				case "Array":
					$r = stx.plus.Order._createOrderImpl(stx.plus.ArrayOrder.compare);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.plus.Order._createOrderImpl(stx.plus.ProductOrder.compare);
					break;
				default:
					$r = stx.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var i = 0;
						var fields = stx.plus.ArrayOrder.sortWith(SArrays.filter(SArrays.map(Type.getInstanceFields(c),function(v1) {
							var fieldMeta = stx.plus.Meta._getMetaDataField(c,v1);
							var weight = fieldMeta != null && Reflect.hasField(fieldMeta,"order")?Reflect.field(fieldMeta,"order"):1;
							return new stx.Tuple3(v1,weight,fieldMeta != null && Reflect.hasField(fieldMeta,"index")?Reflect.field(fieldMeta,"index"):i++);
						}),function(v1) {
							return v1._2 != 0;
						}),function(a,b) {
							var c1 = a._3 - b._3;
							if(c1 != 0) return c1;
							return stx.Strings.compare(a._1,b._1);
						});
						$r = stx.plus.Order._createOrderImpl(function(a1,b1) {
							var values = SArrays.map(SArrays.filter(fields,function(v1) {
								return !Reflect.isFunction(Reflect.field(a1,v1._1));
							}),function(v1) {
								return new stx.Tuple3(Reflect.field(a1,v1._1),Reflect.field(b1,v1._1),v1._2);
							});
							var _g = 0;
							while(_g < values.length) {
								var value = values[_g];
								++_g;
								var c1 = (stx.plus.Order.getOrderFor(value._1))(value._1,value._2) * value._3;
								if(c1 != 0) return c1;
							}
							return 0;
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"compare")?stx.plus.Order._createOrderImpl(function(a,b) {
						return a.compare(b);
					}):SBase.error("class " + Type.getClassName(c) + " is not comparable",{ fileName : "Order.hx", lineNumber : 94, className : "stx.plus.Order", methodName : "getOrderForType"});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.plus.Order._createOrderImpl(function(a,b) {
				var v1 = a[1] - b[1];
				if(0 != v1) return v1;
				var pa = a.slice(2);
				var pb = b.slice(2);
				var _g1 = 0, _g = pa.length;
				while(_g1 < _g) {
					var i = _g1++;
					var v2 = (stx.plus.Order.getOrderFor(pa[i]))(pa[i],pb[i]);
					if(v2 != 0) return v2;
				}
				return 0;
			});
			break;
		case 0:
			$r = stx.plus.Order.nil;
			break;
		case 5:
			$r = SBase.error("unable to compare on a function",{ fileName : "Order.hx", lineNumber : 114, className : "stx.plus.Order", methodName : "getOrderForType"});
			break;
		}
		return $r;
	}(this));
}
stx.plus.ArrayOrder = $hxClasses["stx.plus.ArrayOrder"] = function() { }
stx.plus.ArrayOrder.__name__ = ["stx","plus","ArrayOrder"];
stx.plus.ArrayOrder.sort = function(v) {
	return stx.plus.ArrayOrder.sortWith(v,stx.plus.Order.getOrderFor(v[0]));
}
stx.plus.ArrayOrder.sortWith = function(v,order) {
	var r = v.slice();
	r.sort(order);
	return r;
}
stx.plus.ArrayOrder.compare = function(v1,v2) {
	return stx.plus.ArrayOrder.compareWith(v1,v2,stx.plus.Order.getOrderFor(v1[0]));
}
stx.plus.ArrayOrder.compareWith = function(v1,v2,order) {
	var c = v1.length - v2.length;
	if(c != 0) return c;
	if(v1.length == 0) return 0;
	var _g1 = 0, _g = v1.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c1 = order(v1[i],v2[i]);
		if(c1 != 0) return c1;
	}
	return 0;
}
stx.plus.ProductOrder = $hxClasses["stx.plus.ProductOrder"] = function() { }
stx.plus.ProductOrder.__name__ = ["stx","plus","ProductOrder"];
stx.plus.ProductOrder.getOrder = function(p,i) {
	return stx.plus.Order.getOrderFor(p.element(i));
}
stx.plus.ProductOrder.compare = function(one,other) {
	var _g1 = 0, _g = one.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		var c = (stx.plus.ProductOrder.getOrder(one,i))(one.element(i),other.element(i));
		if(c != 0) return c;
	}
	return 0;
}
stx.plus.Orders = $hxClasses["stx.plus.Orders"] = function() { }
stx.plus.Orders.__name__ = ["stx","plus","Orders"];
stx.plus.Orders.greaterThan = function(order) {
	return function(v1,v2) {
		return order(v1,v2) > 0;
	};
}
stx.plus.Orders.greaterThanOrEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) >= 0;
	};
}
stx.plus.Orders.lessThan = function(order) {
	return function(v1,v2) {
		return order(v1,v2) < 0;
	};
}
stx.plus.Orders.lessThanOrEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) <= 0;
	};
}
stx.plus.Orders.equal = function(order) {
	return function(v1,v2) {
		return order(v1,v2) == 0;
	};
}
stx.plus.Orders.notEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) != 0;
	};
}
stx.plus.Show = $hxClasses["stx.plus.Show"] = function() { }
stx.plus.Show.__name__ = ["stx","plus","Show"];
stx.plus.Show._createShowImpl = function(impl) {
	return function(v) {
		return null == v?"null":impl(v);
	};
}
stx.plus.Show.getShowFor = function(t) {
	return stx.plus.Show.getShowForType(Type["typeof"](t));
}
stx.plus.Show.getShowForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.plus.Show._createShowImpl(stx.plus.BoolShow.toString);
			break;
		case 1:
			$r = stx.plus.Show._createShowImpl(stx.plus.IntShow.toString);
			break;
		case 2:
			$r = stx.plus.Show._createShowImpl(stx.plus.FloatShow.toString);
			break;
		case 8:
			$r = stx.plus.Show._createShowImpl(function(v1) {
				return "<unknown>";
			});
			break;
		case 4:
			$r = stx.plus.Show._createShowImpl(function(v1) {
				var buf = [];
				var _g = 0, _g1 = Reflect.fields(v1);
				while(_g < _g1.length) {
					var k = _g1[_g];
					++_g;
					var i = Reflect.field(v1,k);
					buf.push(k + ":" + (stx.plus.Show.getShowFor(i))(i));
				}
				return "{" + buf.join(",") + "}";
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.plus.Show._createShowImpl(stx.Strings.toString);
					break;
				case "Array":
					$r = stx.plus.Show._createShowImpl(stx.plus.ArrayShow.toString);
					break;
				default:
					$r = stx.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var fields = stx.plus.Meta._fieldsWithMeta(c,"show");
						$r = stx.plus.Show._createShowImpl(function(v2) {
							var values = SArrays.map(SArrays.filter(SArrays.map(fields,function(f) {
								return Reflect.field(v2,f);
							}),function(v1) {
								return !Reflect.isFunction(v1);
							}),function(v1) {
								return (stx.plus.Show.getShowFor(v1))(v1);
							});
							return stx.plus.IterableShow.mkString(values,null,Type.getClassName(c) + "(",")",", ");
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"toString")?stx.plus.Show._createShowImpl(function(v1) {
						return Reflect.field(v1,"toString").apply(v1,[]);
					}):stx.plus.Show._createShowImpl(function(v1) {
						return Type.getClassName(Type.getClass(v1));
					});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.plus.Show._createShowImpl(function(v1) {
				var buf = v1[0];
				var params = v1.slice(2);
				if(params.length == 0) return buf; else {
					buf += "(";
					var _g = 0;
					while(_g < params.length) {
						var p = params[_g];
						++_g;
						buf += (stx.plus.Show.getShowFor(p))(p);
					}
					return buf + ")";
				}
			});
			break;
		case 0:
			$r = stx.plus.Show.nil;
			break;
		case 5:
			$r = stx.plus.Show._createShowImpl(function(v1) {
				return "<function>";
			});
			break;
		}
		return $r;
	}(this));
}
stx.plus.Show.nil = function(v) {
	return "null";
}
stx.plus.ArrayShow = $hxClasses["stx.plus.ArrayShow"] = function() { }
stx.plus.ArrayShow.__name__ = ["stx","plus","ArrayShow"];
stx.plus.ArrayShow.toString = function(v) {
	return stx.plus.ArrayShow.toStringWith(v,stx.plus.Show.getShowFor(v[0]));
}
stx.plus.ArrayShow.toStringWith = function(v,show) {
	return "[" + SArrays.map(v,show).join(", ") + "]";
}
stx.plus.ArrayShow.mkString = function(arr,sep,show) {
	if(sep == null) sep = ", ";
	var isFirst = true;
	return SArrays.foldl(arr,"",function(a,b) {
		var prefix = isFirst?(function($this) {
			var $r;
			isFirst = false;
			$r = "";
			return $r;
		}(this)):sep;
		if(null == show) show = stx.plus.Show.getShowFor(b);
		return a + prefix + show(b);
	});
}
stx.plus.IterableShow = $hxClasses["stx.plus.IterableShow"] = function() { }
stx.plus.IterableShow.__name__ = ["stx","plus","IterableShow"];
stx.plus.IterableShow.toString = function(i,show,prefix,suffix,sep) {
	if(sep == null) sep = ", ";
	if(suffix == null) suffix = ")";
	if(prefix == null) prefix = "(";
	return stx.plus.IterableShow.mkString(i,show,prefix,suffix,sep);
}
stx.plus.IterableShow.mkString = function(i,show,prefix,suffix,sep) {
	if(sep == null) sep = ", ";
	if(suffix == null) suffix = ")";
	if(prefix == null) prefix = "(";
	if(show == null) show = Std.string;
	var s = prefix;
	var isFirst = true;
	var $it0 = $iterator(i)();
	while( $it0.hasNext() ) {
		var t = $it0.next();
		if(isFirst) isFirst = false; else s += sep;
		s += show(t);
	}
	return s + suffix;
}
stx.plus.BoolShow = $hxClasses["stx.plus.BoolShow"] = function() { }
stx.plus.BoolShow.__name__ = ["stx","plus","BoolShow"];
stx.plus.BoolShow.toString = function(v) {
	return v?"true":"false";
}
stx.plus.IntShow = $hxClasses["stx.plus.IntShow"] = function() { }
stx.plus.IntShow.__name__ = ["stx","plus","IntShow"];
stx.plus.IntShow.toString = function(v) {
	return "" + v;
}
stx.plus.FloatShow = $hxClasses["stx.plus.FloatShow"] = function() { }
stx.plus.FloatShow.__name__ = ["stx","plus","FloatShow"];
stx.plus.FloatShow.toString = function(v) {
	return "" + v;
}
stx.plus.ProductShow = $hxClasses["stx.plus.ProductShow"] = function() { }
stx.plus.ProductShow.__name__ = ["stx","plus","ProductShow"];
stx.plus.ProductShow.getProductShow = function(p,i) {
	return stx.plus.Show.getShowFor(p.element(i));
}
stx.plus.ProductShow.toString = function(p) {
	var productPrefix = "Tuple" + p.get_length();
	var s = productPrefix + "(" + (stx.plus.ProductShow.getProductShow(p,1))(p.element(1));
	var _g1 = 2, _g = p.get_length() + 1;
	while(_g1 < _g) {
		var i = _g1++;
		s += ", " + (stx.plus.ProductShow.getProductShow(p,i))(p.element(i));
	}
	return s + ")";
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
var Void = $hxClasses.Void = { __ename__ : ["Void"]};
stx.plus.ProductHasher._baseHashes = [[786433,24593],[196613,3079,389],[1543,49157,196613,97],[12289,769,393241,193,53]];
AllClasses.__meta__ = { obj : { IgnoreCover : null}, statics : { main : { IgnoreCover : null}}, fields : { _ : { IgnoreCover : null}}};
stx.Logger.__meta__ = { obj : { DefaultImplementation : ["stx.DefaultLogger"]}};
stx.Objects.__meta__ = { obj : { note : ["0b1kn00b","Does this handle reference loops, should it, could it?"]}};
stx.FieldOrder.Ascending = 1;
stx.FieldOrder.Descending = -1;
stx.FieldOrder.Ignore = 0;
stx.Strings.SepAlphaPattern = new EReg("(-|_)([a-z])","g");
stx.Strings.AlphaUpperAlphaPattern = new EReg("-([a-z])([A-Z])","g");
stx.io.json.Json.encodeObject = stx.Functions1.compose(stx.io.json.Json.encode,stx.io.json.Json.fromObject);
stx.io.json.Json.decodeObject = stx.Functions1.compose(stx.io.json.Json.toObject,stx.io.json.Json.decode);
Main.main();
