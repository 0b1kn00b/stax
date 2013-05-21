var $hxClasses = $hxClasses || {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var AllClasses = $hxClasses["AllClasses"] = function() {
	haxe.Log.trace("This is a generated main class",{ fileName : "AllClasses.hx", lineNumber : 152, className : "AllClasses", methodName : "new"});
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
var Map = $hxClasses["Map"] = function() {
	this.h = { };
};
Map.__name__ = ["Map"];
Map.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
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
	,__class__: Map
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
var IntMap = $hxClasses["IntMap"] = function() {
	this.h = { };
};
IntMap.__name__ = ["IntMap"];
IntMap.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,h: null
	,__class__: IntMap
}
var IntIterator = $hxClasses["IntIterator"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIterator.__name__ = ["IntIterator"];
IntIterator.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIterator
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
		s.b += Std.string("{");
		while(l != null) {
			if(first) first = false; else s.b += Std.string(", ");
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += Std.string("}");
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
var Stax = $hxClasses["Stax"] = function() { }
Stax.__name__ = ["Stax"];
Stax.here = function(pos) {
	return pos;
}
SCore.tool = function(order,equal,hash,show) {
	return { order : order, equal : equal, show : show, hash : hash};
}
Stax.noop0 = function() {
	return function() {
	};
}
Stax.noop1 = function() {
	return function(a) {
	};
}
Stax.noop2 = function() {
	return function(a,b) {
	};
}
Stax.noop3 = function() {
	return function(a,b,c) {
	};
}
Stax.noop4 = function() {
	return function(a,b,c,d) {
	};
}
Stax.noop5 = function() {
	return function(a,b,c,d,e) {
	};
}
SCore.unfold
SCore.unfold = function() {
	return function(a) {
		return a;
	};
}
SCore.unfold = function(initial,unfolder) {
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
				_progress = tuple.fst();
				_next = stx.Option.Some(tuple.snd());
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
SCore.error = function(msg,pos) {
	throw "" + msg + " at " + Std.string(pos);
	return null;
}
var ArrayLambda = $hxClasses["ArrayLambda"] = function() { }
ArrayLambda.__name__ = ["ArrayLambda"];
ArrayLambda.map = function(a,f) {
	var n = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		n.push(f(e));
	}
	return n;
}
ArrayLambda.flatMap = function(a,f) {
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
ArrayLambda.foldl = function(a,z,f) {
	var r = z;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		r = f(r,e);
	}
	return r;
}
ArrayLambda.filter = function(a,f) {
	var n = [];
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(f(e)) n.push(e);
	}
	return n;
}
ArrayLambda.size = function(a) {
	return a.length;
}
ArrayLambda.snapshot = function(a) {
	return [].concat(a);
}
ArrayLambda.foreach = function(a,f) {
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		f(e);
	}
	return a;
}
var IterableLambda = $hxClasses["IterableLambda"] = function() { }
IterableLambda.__name__ = ["IterableLambda"];
IterableLambda.toArray = function(i) {
	var a = [];
	var $it0 = $iterator(i)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		a.push(e);
	}
	return a;
}
IterableLambda.toIterable = function(it) {
	return { iterator : function() {
		return { next : $bind(it,it.next), hasNext : $bind(it,it.hasNext)};
	}};
}
IterableLambda.map = function(iter,f) {
	return IterableLambda.foldl(iter,[],function(a,b) {
		a.push(f(b));
		return a;
	});
}
IterableLambda.flatMap = function(iter,f) {
	return IterableLambda.foldl(iter,[],function(a,b) {
		var $it0 = $iterator(f(b))();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			a.push(e);
		}
		return a;
	});
}
IterableLambda.foldl = function(iter,seed,mapper) {
	var folded = seed;
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		folded = mapper(folded,e);
	}
	return folded;
}
IterableLambda.filter = function(iter,f) {
	return ArrayLambda.filter(IterableLambda.toArray(iter),f);
}
IterableLambda.size = function(iterable) {
	var size = 0;
	var $it0 = $iterator(iterable)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		++size;
	}
	return size;
}
IterableLambda.foreach = function(iter,f) {
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		f(e);
	}
}
var IntIterators = $hxClasses["IntIterators"] = function() { }
IntIterators.__name__ = ["IntIterators"];
IntIterators.to = function(start,end) {
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
IntIterators.until = function(start,end) {
	return IntIterators.to(start,end - 1);
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
	return Math.floor(Math.random() * x);
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
var Xml = $hxClasses["Xml"] = function() {
};
Xml.__name__ = ["Xml"];
Xml.Element = null;
Xml.PCData = null;
Xml.CData = null;
Xml.Comment = null;
Xml.DocType = null;
Xml.Prolog = null;
Xml.Document = null;
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
}
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new Map();
	r.setNodeName(name);
	return r;
}
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.setNodeValue(data);
	return r;
}
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.setNodeValue(data);
	return r;
}
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.setNodeValue(data);
	return r;
}
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.setNodeValue(data);
	return r;
}
Xml.createProlog = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Prolog;
	r.setNodeValue(data);
	return r;
}
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
}
Xml.prototype = {
	toString: function() {
		if(this.nodeType == Xml.PCData) return this._nodeValue;
		if(this.nodeType == Xml.CData) return "<![CDATA[" + this._nodeValue + "]]>";
		if(this.nodeType == Xml.Comment) return "<!--" + this._nodeValue + "-->";
		if(this.nodeType == Xml.DocType) return "<!DOCTYPE " + this._nodeValue + ">";
		if(this.nodeType == Xml.Prolog) return "<?" + this._nodeValue + "?>";
		var s = new StringBuf();
		if(this.nodeType == Xml.Element) {
			s.b += Std.string("<");
			s.b += Std.string(this._nodeName);
			var $it0 = this._attributes.keys();
			while( $it0.hasNext() ) {
				var k = $it0.next();
				s.b += Std.string(" ");
				s.b += Std.string(k);
				s.b += Std.string("=\"");
				s.b += Std.string(this._attributes.get(k));
				s.b += Std.string("\"");
			}
			if(this._children.length == 0) {
				s.b += Std.string("/>");
				return s.b;
			}
			s.b += Std.string(">");
		}
		var $it1 = this.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			s.b += Std.string(x.toString());
		}
		if(this.nodeType == Xml.Element) {
			s.b += Std.string("</");
			s.b += Std.string(this._nodeName);
			s.b += Std.string(">");
		}
		return s.b;
	}
	,insertChild: function(x,pos) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.splice(pos,0,x);
	}
	,removeChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		var b = HxOverrides.remove(this._children,x);
		if(b) x._parent = null;
		return b;
	}
	,addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,firstElement: function() {
		if(this._children == null) throw "bad nodetype";
		var cur = 0;
		var l = this._children.length;
		while(cur < l) {
			var n = this._children[cur];
			if(n.nodeType == Xml.Element) return n;
			cur++;
		}
		return null;
	}
	,firstChild: function() {
		if(this._children == null) throw "bad nodetype";
		return this._children[0];
	}
	,elementsNamed: function(name) {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				if(n.nodeType == Xml.Element && n._nodeName == name) break;
				k++;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k++;
				if(n.nodeType == Xml.Element && n._nodeName == name) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,elements: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				if(this.x[k].nodeType == Xml.Element) break;
				k += 1;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k += 1;
				if(n.nodeType == Xml.Element) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,iterator: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			return this.cur < this.x.length;
		}, next : function() {
			return this.x[this.cur++];
		}};
	}
	,attributes: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.keys();
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,remove: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.remove(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,getParent: function() {
		return this._parent;
	}
	,setNodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,getNodeValue: function() {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue;
	}
	,setNodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,getNodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,_parent: null
	,_children: null
	,_attributes: null
	,_nodeValue: null
	,_nodeName: null
	,parent: null
	,nodeValue: null
	,nodeName: null
	,nodeType: null
	,__class__: Xml
	,__properties__: {set_nodeName:"setNodeName",get_nodeName:"getNodeName",set_nodeValue:"setNodeValue",get_nodeValue:"getNodeValue",get_parent:"getParent"}
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
		b.b += Std.string("\nCalled from ");
		haxe.Stack.itemToString(b,s);
	}
	return b.b;
}
haxe.Stack.itemToString = function(b,s) {
	var $e = (s);
	switch( $e[1] ) {
	case 0:
		b.b += Std.string("a C function");
		break;
	case 1:
		var m = $e[2];
		b.b += Std.string("module ");
		b.b += Std.string(m);
		break;
	case 2:
		var line = $e[4], file = $e[3], s1 = $e[2];
		if(s1 != null) {
			haxe.Stack.itemToString(b,s1);
			b.b += Std.string(" (");
		}
		b.b += Std.string(file);
		b.b += Std.string(" line ");
		b.b += Std.string(line);
		if(s1 != null) b.b += Std.string(")");
		break;
	case 3:
		var meth = $e[3], cname = $e[2];
		b.b += Std.string(cname);
		b.b += Std.string(".");
		b.b += Std.string(meth);
		break;
	case 4:
		var n = $e[2];
		b.b += Std.string("local function #");
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
haxe.Timer = $hxClasses["haxe.Timer"] = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return new Date().getTime() / 1000;
}
haxe.Timer.prototype = {
	run: function() {
	}
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,id: null
	,__class__: haxe.Timer
}
if(!haxe.io) haxe.io = {}
haxe.io.Bytes = $hxClasses["haxe.io.Bytes"] = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0, _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.charCodeAt(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype = {
	getData: function() {
		return this.b;
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g1 = 0, _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length?this.length:other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,get: function(pos) {
		return this.b[pos];
	}
	,b: null
	,length: null
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
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
haxe.macro.ClassKind.KTypeParameter = ["KTypeParameter",1];
haxe.macro.ClassKind.KTypeParameter.toString = $estr;
haxe.macro.ClassKind.KTypeParameter.__enum__ = haxe.macro.ClassKind;
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
haxe.rtti.CType = $hxClasses["haxe.rtti.CType"] = { __ename__ : ["haxe","rtti","CType"], __constructs__ : ["CUnknown","CEnum","CClass","CTypedef","CFunction","CAnonymous","CDynamic"] }
haxe.rtti.CType.CUnknown = ["CUnknown",0];
haxe.rtti.CType.CUnknown.toString = $estr;
haxe.rtti.CType.CUnknown.__enum__ = haxe.rtti.CType;
haxe.rtti.CType.CEnum = function(name,params) { var $x = ["CEnum",1,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CClass = function(name,params) { var $x = ["CClass",2,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CTypedef = function(name,params) { var $x = ["CTypedef",3,name,params]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CFunction = function(args,ret) { var $x = ["CFunction",4,args,ret]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CAnonymous = function(fields) { var $x = ["CAnonymous",5,fields]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.CType.CDynamic = function(t) { var $x = ["CDynamic",6,t]; $x.__enum__ = haxe.rtti.CType; $x.toString = $estr; return $x; }
haxe.rtti.Rights = $hxClasses["haxe.rtti.Rights"] = { __ename__ : ["haxe","rtti","Rights"], __constructs__ : ["RNormal","RNo","RCall","RMethod","RDynamic","RInline"] }
haxe.rtti.Rights.RNormal = ["RNormal",0];
haxe.rtti.Rights.RNormal.toString = $estr;
haxe.rtti.Rights.RNormal.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RNo = ["RNo",1];
haxe.rtti.Rights.RNo.toString = $estr;
haxe.rtti.Rights.RNo.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RCall = function(m) { var $x = ["RCall",2,m]; $x.__enum__ = haxe.rtti.Rights; $x.toString = $estr; return $x; }
haxe.rtti.Rights.RMethod = ["RMethod",3];
haxe.rtti.Rights.RMethod.toString = $estr;
haxe.rtti.Rights.RMethod.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RDynamic = ["RDynamic",4];
haxe.rtti.Rights.RDynamic.toString = $estr;
haxe.rtti.Rights.RDynamic.__enum__ = haxe.rtti.Rights;
haxe.rtti.Rights.RInline = ["RInline",5];
haxe.rtti.Rights.RInline.toString = $estr;
haxe.rtti.Rights.RInline.__enum__ = haxe.rtti.Rights;
haxe.rtti.TypeTree = $hxClasses["haxe.rtti.TypeTree"] = { __ename__ : ["haxe","rtti","TypeTree"], __constructs__ : ["TPackage","TClassdecl","TEnumdecl","TTypedecl"] }
haxe.rtti.TypeTree.TPackage = function(name,full,subs) { var $x = ["TPackage",0,name,full,subs]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TClassdecl = function(c) { var $x = ["TClassdecl",1,c]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TEnumdecl = function(e) { var $x = ["TEnumdecl",2,e]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeTree.TTypedecl = function(t) { var $x = ["TTypedecl",3,t]; $x.__enum__ = haxe.rtti.TypeTree; $x.toString = $estr; return $x; }
haxe.rtti.TypeApi = $hxClasses["haxe.rtti.TypeApi"] = function() { }
haxe.rtti.TypeApi.__name__ = ["haxe","rtti","TypeApi"];
haxe.rtti.TypeApi.typeInfos = function(t) {
	var inf;
	var $e = (t);
	switch( $e[1] ) {
	case 1:
		var c = $e[2];
		inf = c;
		break;
	case 2:
		var e = $e[2];
		inf = e;
		break;
	case 3:
		var t1 = $e[2];
		inf = t1;
		break;
	case 0:
		throw "Unexpected Package";
		break;
	}
	return inf;
}
haxe.rtti.TypeApi.isVar = function(t) {
	return (function($this) {
		var $r;
		switch( (t)[1] ) {
		case 4:
			$r = false;
			break;
		default:
			$r = true;
		}
		return $r;
	}(this));
}
haxe.rtti.TypeApi.leq = function(f,l1,l2) {
	var it = l2.iterator();
	var $it0 = l1.iterator();
	while( $it0.hasNext() ) {
		var e1 = $it0.next();
		if(!it.hasNext()) return false;
		var e2 = it.next();
		if(!f(e1,e2)) return false;
	}
	if(it.hasNext()) return false;
	return true;
}
haxe.rtti.TypeApi.rightsEq = function(r1,r2) {
	if(r1 == r2) return true;
	var $e = (r1);
	switch( $e[1] ) {
	case 2:
		var m1 = $e[2];
		var $e = (r2);
		switch( $e[1] ) {
		case 2:
			var m2 = $e[2];
			return m1 == m2;
		default:
		}
		break;
	default:
	}
	return false;
}
haxe.rtti.TypeApi.typeEq = function(t1,t2) {
	var $e = (t1);
	switch( $e[1] ) {
	case 0:
		return t2 == haxe.rtti.CType.CUnknown;
	case 1:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 1:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 2:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 2:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 3:
		var params = $e[3], name = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 3:
			var params2 = $e[3], name2 = $e[2];
			return name == name2 && haxe.rtti.TypeApi.leq(haxe.rtti.TypeApi.typeEq,params,params2);
		default:
		}
		break;
	case 4:
		var ret = $e[3], args = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 4:
			var ret2 = $e[3], args2 = $e[2];
			return haxe.rtti.TypeApi.leq(function(a,b) {
				return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
			},args,args2) && haxe.rtti.TypeApi.typeEq(ret,ret2);
		default:
		}
		break;
	case 5:
		var fields = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 5:
			var fields2 = $e[2];
			return haxe.rtti.TypeApi.leq(function(a,b) {
				return a.name == b.name && haxe.rtti.TypeApi.typeEq(a.t,b.t);
			},fields,fields2);
		default:
		}
		break;
	case 6:
		var t = $e[2];
		var $e = (t2);
		switch( $e[1] ) {
		case 6:
			var t21 = $e[2];
			if(t == null != (t21 == null)) return false;
			return t == null || haxe.rtti.TypeApi.typeEq(t,t21);
		default:
		}
		break;
	}
	return false;
}
haxe.rtti.TypeApi.fieldEq = function(f1,f2) {
	if(f1.name != f2.name) return false;
	if(!haxe.rtti.TypeApi.typeEq(f1.type,f2.type)) return false;
	if(f1.isPublic != f2.isPublic) return false;
	if(f1.doc != f2.doc) return false;
	if(!haxe.rtti.TypeApi.rightsEq(f1.get,f2.get)) return false;
	if(!haxe.rtti.TypeApi.rightsEq(f1.set,f2.set)) return false;
	if(f1.params == null != (f2.params == null)) return false;
	if(f1.params != null && f1.params.join(":") != f2.params.join(":")) return false;
	return true;
}
haxe.rtti.TypeApi.constructorEq = function(c1,c2) {
	if(c1.name != c2.name) return false;
	if(c1.doc != c2.doc) return false;
	if(c1.args == null != (c2.args == null)) return false;
	if(c1.args != null && !haxe.rtti.TypeApi.leq(function(a,b) {
		return a.name == b.name && a.opt == b.opt && haxe.rtti.TypeApi.typeEq(a.t,b.t);
	},c1.args,c2.args)) return false;
	return true;
}
haxe.rtti.Infos = $hxClasses["haxe.rtti.Infos"] = function() { }
haxe.rtti.Infos.__name__ = ["haxe","rtti","Infos"];
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
haxe.rtti.XmlParser = $hxClasses["haxe.rtti.XmlParser"] = function() {
	this.root = new Array();
};
haxe.rtti.XmlParser.__name__ = ["haxe","rtti","XmlParser"];
haxe.rtti.XmlParser.prototype = {
	defplat: function() {
		var l = new List();
		if(this.curplatform != null) l.add(this.curplatform);
		return l;
	}
	,xtypeparams: function(x) {
		var p = new List();
		var $it0 = x.getElements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			p.add(this.xtype(c));
		}
		return p;
	}
	,xtype: function(x) {
		return (function($this) {
			var $r;
			switch(x.getName()) {
			case "unknown":
				$r = haxe.rtti.CType.CUnknown;
				break;
			case "e":
				$r = haxe.rtti.CType.CEnum($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
			case "c":
				$r = haxe.rtti.CType.CClass($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
			case "t":
				$r = haxe.rtti.CType.CTypedef($this.mkPath(x.att.resolve("path")),$this.xtypeparams(x));
				break;
			case "f":
				$r = (function($this) {
					var $r;
					var args = new List();
					var aname = x.att.resolve("a").split(":");
					var eargs = HxOverrides.iter(aname);
					var $it0 = x.getElements();
					while( $it0.hasNext() ) {
						var e = $it0.next();
						var opt = false;
						var a = eargs.next();
						if(a == null) a = "";
						if(a.charAt(0) == "?") {
							opt = true;
							a = HxOverrides.substr(a,1,null);
						}
						args.add({ name : a, opt : opt, t : $this.xtype(e)});
					}
					var ret = args.last();
					args.remove(ret);
					$r = haxe.rtti.CType.CFunction(args,ret.t);
					return $r;
				}($this));
				break;
			case "a":
				$r = (function($this) {
					var $r;
					var fields = new List();
					var $it1 = x.getElements();
					while( $it1.hasNext() ) {
						var f = $it1.next();
						fields.add({ name : f.getName(), t : $this.xtype(new haxe.xml.Fast(f.x.firstElement()))});
					}
					$r = haxe.rtti.CType.CAnonymous(fields);
					return $r;
				}($this));
				break;
			case "d":
				$r = (function($this) {
					var $r;
					var t = null;
					var tx = x.x.firstElement();
					if(tx != null) t = $this.xtype(new haxe.xml.Fast(tx));
					$r = haxe.rtti.CType.CDynamic(t);
					return $r;
				}($this));
				break;
			default:
				$r = $this.xerror(x);
			}
			return $r;
		}(this));
	}
	,xtypedef: function(x) {
		var doc = null;
		var t = null;
		var $it0 = x.getElements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			if(c.getName() == "haxe_doc") doc = c.getInnerData(); else if(c.getName() == "meta") {
			} else t = this.xtype(c);
		}
		var types = new Map();
		if(this.curplatform != null) types.set(this.curplatform,t);
		return { path : this.mkPath(x.att.resolve("path")), module : x.has.resolve("module")?this.mkPath(x.att.resolve("module")):null, doc : doc, isPrivate : x.x.exists("private"), params : this.mkTypeParams(x.att.resolve("params")), type : t, types : types, platforms : this.defplat()};
	}
	,xenumfield: function(x) {
		var args = null;
		var xdoc = x.x.elementsNamed("haxe_doc").next();
		if(x.has.resolve("a")) {
			var names = x.att.resolve("a").split(":");
			var elts = x.getElements();
			args = new List();
			var _g = 0;
			while(_g < names.length) {
				var c = names[_g];
				++_g;
				var opt = false;
				if(c.charAt(0) == "?") {
					opt = true;
					c = HxOverrides.substr(c,1,null);
				}
				args.add({ name : c, opt : opt, t : this.xtype(elts.next())});
			}
		}
		return { name : x.getName(), args : args, doc : xdoc == null?null:new haxe.xml.Fast(xdoc).getInnerData(), platforms : this.defplat()};
	}
	,xenum: function(x) {
		var cl = new List();
		var doc = null;
		var $it0 = x.getElements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			if(c.getName() == "haxe_doc") doc = c.getInnerData(); else if(c.getName() == "meta") {
			} else cl.add(this.xenumfield(c));
		}
		return { path : this.mkPath(x.att.resolve("path")), module : x.has.resolve("module")?this.mkPath(x.att.resolve("module")):null, doc : doc, isPrivate : x.x.exists("private"), isExtern : x.x.exists("extern"), params : this.mkTypeParams(x.att.resolve("params")), constructors : cl, platforms : this.defplat()};
	}
	,xclassfield: function(x) {
		var e = x.getElements();
		var t = this.xtype(e.next());
		var doc = null;
		while( e.hasNext() ) {
			var c = e.next();
			switch(c.getName()) {
			case "haxe_doc":
				doc = c.getInnerData();
				break;
			case "meta":
				break;
			default:
				this.xerror(c);
			}
		}
		return { name : x.getName(), type : t, isPublic : x.x.exists("public"), isOverride : x.x.exists("override"), doc : doc, get : x.has.resolve("get")?this.mkRights(x.att.resolve("get")):haxe.rtti.Rights.RNormal, set : x.has.resolve("set")?this.mkRights(x.att.resolve("set")):haxe.rtti.Rights.RNormal, params : x.has.resolve("params")?this.mkTypeParams(x.att.resolve("params")):null, platforms : this.defplat()};
	}
	,xclass: function(x) {
		var csuper = null;
		var doc = null;
		var tdynamic = null;
		var interfaces = new List();
		var fields = new List();
		var statics = new List();
		var $it0 = x.getElements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			switch(c.getName()) {
			case "haxe_doc":
				doc = c.getInnerData();
				break;
			case "extends":
				csuper = this.xpath(c);
				break;
			case "implements":
				interfaces.add(this.xpath(c));
				break;
			case "haxe_dynamic":
				tdynamic = this.xtype(new haxe.xml.Fast(c.x.firstElement()));
				break;
			case "meta":
				break;
			default:
				if(c.x.exists("static")) statics.add(this.xclassfield(c)); else fields.add(this.xclassfield(c));
			}
		}
		return { path : this.mkPath(x.att.resolve("path")), module : x.has.resolve("module")?this.mkPath(x.att.resolve("module")):null, doc : doc, isPrivate : x.x.exists("private"), isExtern : x.x.exists("extern"), isInterface : x.x.exists("interface"), params : this.mkTypeParams(x.att.resolve("params")), superClass : csuper, interfaces : interfaces, fields : fields, statics : statics, tdynamic : tdynamic, platforms : this.defplat()};
	}
	,xpath: function(x) {
		var path = this.mkPath(x.att.resolve("path"));
		var params = new List();
		var $it0 = x.getElements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			params.add(this.xtype(c));
		}
		return { path : path, params : params};
	}
	,processElement: function(x) {
		var c = new haxe.xml.Fast(x);
		return (function($this) {
			var $r;
			switch(c.getName()) {
			case "class":
				$r = haxe.rtti.TypeTree.TClassdecl($this.xclass(c));
				break;
			case "enum":
				$r = haxe.rtti.TypeTree.TEnumdecl($this.xenum(c));
				break;
			case "typedef":
				$r = haxe.rtti.TypeTree.TTypedecl($this.xtypedef(c));
				break;
			default:
				$r = $this.xerror(c);
			}
			return $r;
		}(this));
	}
	,xroot: function(x) {
		var $it0 = x.x.elements();
		while( $it0.hasNext() ) {
			var c = $it0.next();
			this.merge(this.processElement(c));
		}
	}
	,xerror: function(c) {
		return (function($this) {
			var $r;
			throw "Invalid " + c.getName();
			return $r;
		}(this));
	}
	,mkRights: function(r) {
		return (function($this) {
			var $r;
			switch(r) {
			case "null":
				$r = haxe.rtti.Rights.RNo;
				break;
			case "method":
				$r = haxe.rtti.Rights.RMethod;
				break;
			case "dynamic":
				$r = haxe.rtti.Rights.RDynamic;
				break;
			case "inline":
				$r = haxe.rtti.Rights.RInline;
				break;
			default:
				$r = haxe.rtti.Rights.RCall(r);
			}
			return $r;
		}(this));
	}
	,mkTypeParams: function(p) {
		var pl = p.split(":");
		if(pl[0] == "") return new Array();
		return pl;
	}
	,mkPath: function(p) {
		return p;
	}
	,merge: function(t) {
		var inf = haxe.rtti.TypeApi.typeInfos(t);
		var pack = inf.path.split(".");
		var cur = this.root;
		var curpack = new Array();
		pack.pop();
		var _g = 0;
		while(_g < pack.length) {
			var p = pack[_g];
			++_g;
			var found = false;
			var _g1 = 0;
			try {
				while(_g1 < cur.length) {
					var pk = cur[_g1];
					++_g1;
					var $e = (pk);
					switch( $e[1] ) {
					case 0:
						var subs = $e[4], pname = $e[2];
						if(pname == p) {
							found = true;
							cur = subs;
							throw "__break__";
						}
						break;
					default:
					}
				}
			} catch( e ) { if( e != "__break__" ) throw e; }
			curpack.push(p);
			if(!found) {
				var pk = new Array();
				cur.push(haxe.rtti.TypeTree.TPackage(p,curpack.join("."),pk));
				cur = pk;
			}
		}
		var prev = null;
		var _g = 0;
		while(_g < cur.length) {
			var ct = cur[_g];
			++_g;
			var tinf;
			try {
				tinf = haxe.rtti.TypeApi.typeInfos(ct);
			} catch( e ) {
				continue;
			}
			if(tinf.path == inf.path) {
				var sameType = true;
				if(tinf.doc == null != (inf.doc == null)) {
					if(inf.doc == null) inf.doc = tinf.doc; else tinf.doc = inf.doc;
				}
				if(tinf.module == inf.module && tinf.doc == inf.doc && tinf.isPrivate == inf.isPrivate) {
					var $e = (ct);
					switch( $e[1] ) {
					case 1:
						var c = $e[2];
						var $e = (t);
						switch( $e[1] ) {
						case 1:
							var c2 = $e[2];
							if(this.mergeClasses(c,c2)) return;
							break;
						default:
							sameType = false;
						}
						break;
					case 2:
						var e = $e[2];
						var $e = (t);
						switch( $e[1] ) {
						case 2:
							var e2 = $e[2];
							if(this.mergeEnums(e,e2)) return;
							break;
						default:
							sameType = false;
						}
						break;
					case 3:
						var td = $e[2];
						var $e = (t);
						switch( $e[1] ) {
						case 3:
							var td2 = $e[2];
							if(this.mergeTypedefs(td,td2)) return;
							break;
						default:
						}
						break;
					case 0:
						sameType = false;
						break;
					}
				}
				var msg = tinf.module != inf.module?"module " + inf.module + " should be " + tinf.module:tinf.doc != inf.doc?"documentation is different":tinf.isPrivate != inf.isPrivate?"private flag is different":!sameType?"type kind is different":"could not merge definition";
				throw "Incompatibilities between " + tinf.path + " in " + tinf.platforms.join(",") + " and " + this.curplatform + " (" + msg + ")";
			}
		}
		cur.push(t);
	}
	,mergeTypedefs: function(t,t2) {
		if(this.curplatform == null) return false;
		t.platforms.add(this.curplatform);
		t.types.set(this.curplatform,t2.type);
		return true;
	}
	,mergeEnums: function(e,e2) {
		if(e.isExtern != e2.isExtern) return false;
		if(this.curplatform != null) e.platforms.add(this.curplatform);
		var $it0 = e2.constructors.iterator();
		while( $it0.hasNext() ) {
			var c2 = $it0.next();
			var found = null;
			var $it1 = e.constructors.iterator();
			while( $it1.hasNext() ) {
				var c = $it1.next();
				if(haxe.rtti.TypeApi.constructorEq(c,c2)) {
					found = c;
					break;
				}
			}
			if(found == null) return false;
			if(this.curplatform != null) found.platforms.add(this.curplatform);
		}
		return true;
	}
	,mergeClasses: function(c,c2) {
		if(c.isInterface != c2.isInterface) return false;
		if(this.curplatform != null) c.platforms.add(this.curplatform);
		if(c.isExtern != c2.isExtern) c.isExtern = false;
		var $it0 = c2.fields.iterator();
		while( $it0.hasNext() ) {
			var f2 = $it0.next();
			var found = null;
			var $it1 = c.fields.iterator();
			while( $it1.hasNext() ) {
				var f = $it1.next();
				if(this.mergeFields(f,f2)) {
					found = f;
					break;
				}
			}
			if(found == null) {
				this.newField(c,f2);
				c.fields.add(f2);
			} else if(this.curplatform != null) found.platforms.add(this.curplatform);
		}
		var $it2 = c2.statics.iterator();
		while( $it2.hasNext() ) {
			var f2 = $it2.next();
			var found = null;
			var $it3 = c.statics.iterator();
			while( $it3.hasNext() ) {
				var f = $it3.next();
				if(this.mergeFields(f,f2)) {
					found = f;
					break;
				}
			}
			if(found == null) {
				this.newField(c,f2);
				c.statics.add(f2);
			} else if(this.curplatform != null) found.platforms.add(this.curplatform);
		}
		return true;
	}
	,newField: function(c,f) {
	}
	,mergeFields: function(f,f2) {
		return haxe.rtti.TypeApi.fieldEq(f,f2) || f.name == f2.name && (this.mergeRights(f,f2) || this.mergeRights(f2,f)) && this.mergeDoc(f,f2) && haxe.rtti.TypeApi.fieldEq(f,f2);
	}
	,mergeDoc: function(f1,f2) {
		if(f1.doc == null) f2.doc = f2.doc; else if(f2.doc == null) f2.doc = f1.doc;
		return true;
	}
	,mergeRights: function(f1,f2) {
		if(f1.get == haxe.rtti.Rights.RInline && f1.set == haxe.rtti.Rights.RNo && f2.get == haxe.rtti.Rights.RNormal && f2.set == haxe.rtti.Rights.RMethod) {
			f1.get = haxe.rtti.Rights.RNormal;
			f1.set = haxe.rtti.Rights.RMethod;
			return true;
		}
		return false;
	}
	,process: function(x,platform) {
		this.curplatform = platform;
		this.xroot(new haxe.xml.Fast(x));
	}
	,sortFields: function(fl) {
		var a = Lambda.array(fl);
		a.sort(function(f1,f2) {
			var v1 = haxe.rtti.TypeApi.isVar(f1.type);
			var v2 = haxe.rtti.TypeApi.isVar(f2.type);
			if(v1 && !v2) return -1;
			if(v2 && !v1) return 1;
			if(f1.name == "new") return -1;
			if(f2.name == "new") return 1;
			if(f1.name > f2.name) return 1;
			return -1;
		});
		return Lambda.list(a);
	}
	,sort: function(l) {
		if(l == null) l = this.root;
		l.sort(function(e1,e2) {
			var n1 = (function($this) {
				var $r;
				var $e = (e1);
				switch( $e[1] ) {
				case 0:
					var p = $e[2];
					$r = " " + p;
					break;
				default:
					$r = haxe.rtti.TypeApi.typeInfos(e1).path;
				}
				return $r;
			}(this));
			var n2 = (function($this) {
				var $r;
				var $e = (e2);
				switch( $e[1] ) {
				case 0:
					var p = $e[2];
					$r = " " + p;
					break;
				default:
					$r = haxe.rtti.TypeApi.typeInfos(e2).path;
				}
				return $r;
			}(this));
			if(n1 > n2) return 1;
			return -1;
		});
		var _g = 0;
		while(_g < l.length) {
			var x = l[_g];
			++_g;
			var $e = (x);
			switch( $e[1] ) {
			case 0:
				var l1 = $e[4];
				this.sort(l1);
				break;
			case 1:
				var c = $e[2];
				c.fields = this.sortFields(c.fields);
				c.statics = this.sortFields(c.statics);
				break;
			case 2:
				var e = $e[2];
				break;
			case 3:
				break;
			}
		}
	}
	,curplatform: null
	,root: null
	,__class__: haxe.rtti.XmlParser
}
if(!haxe.xml) haxe.xml = {}
if(!haxe.xml._Fast) haxe.xml._Fast = {}
haxe.xml._Fast.NodeAccess = $hxClasses["haxe.xml._Fast.NodeAccess"] = function(x) {
	this.__x = x;
};
haxe.xml._Fast.NodeAccess.__name__ = ["haxe","xml","_Fast","NodeAccess"];
haxe.xml._Fast.NodeAccess.prototype = {
	resolve: function(name) {
		var x = this.__x.elementsNamed(name).next();
		if(x == null) {
			var xname = this.__x.nodeType == Xml.Document?"Document":this.__x.getNodeName();
			throw xname + " is missing element " + name;
		}
		return new haxe.xml.Fast(x);
	}
	,__x: null
	,__class__: haxe.xml._Fast.NodeAccess
}
haxe.xml._Fast.AttribAccess = $hxClasses["haxe.xml._Fast.AttribAccess"] = function(x) {
	this.__x = x;
};
haxe.xml._Fast.AttribAccess.__name__ = ["haxe","xml","_Fast","AttribAccess"];
haxe.xml._Fast.AttribAccess.prototype = {
	resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
		var v = this.__x.get(name);
		if(v == null) throw this.__x.getNodeName() + " is missing attribute " + name;
		return v;
	}
	,__x: null
	,__class__: haxe.xml._Fast.AttribAccess
}
haxe.xml._Fast.HasAttribAccess = $hxClasses["haxe.xml._Fast.HasAttribAccess"] = function(x) {
	this.__x = x;
};
haxe.xml._Fast.HasAttribAccess.__name__ = ["haxe","xml","_Fast","HasAttribAccess"];
haxe.xml._Fast.HasAttribAccess.prototype = {
	resolve: function(name) {
		if(this.__x.nodeType == Xml.Document) throw "Cannot access document attribute " + name;
		return this.__x.exists(name);
	}
	,__x: null
	,__class__: haxe.xml._Fast.HasAttribAccess
}
haxe.xml._Fast.HasNodeAccess = $hxClasses["haxe.xml._Fast.HasNodeAccess"] = function(x) {
	this.__x = x;
};
haxe.xml._Fast.HasNodeAccess.__name__ = ["haxe","xml","_Fast","HasNodeAccess"];
haxe.xml._Fast.HasNodeAccess.prototype = {
	resolve: function(name) {
		return this.__x.elementsNamed(name).hasNext();
	}
	,__x: null
	,__class__: haxe.xml._Fast.HasNodeAccess
}
haxe.xml._Fast.NodeListAccess = $hxClasses["haxe.xml._Fast.NodeListAccess"] = function(x) {
	this.__x = x;
};
haxe.xml._Fast.NodeListAccess.__name__ = ["haxe","xml","_Fast","NodeListAccess"];
haxe.xml._Fast.NodeListAccess.prototype = {
	resolve: function(name) {
		var l = new List();
		var $it0 = this.__x.elementsNamed(name);
		while( $it0.hasNext() ) {
			var x = $it0.next();
			l.add(new haxe.xml.Fast(x));
		}
		return l;
	}
	,__x: null
	,__class__: haxe.xml._Fast.NodeListAccess
}
haxe.xml.Fast = $hxClasses["haxe.xml.Fast"] = function(x) {
	if(x.nodeType != Xml.Document && x.nodeType != Xml.Element) throw "Invalid nodeType " + Std.string(x.nodeType);
	this.x = x;
	this.node = new haxe.xml._Fast.NodeAccess(x);
	this.nodes = new haxe.xml._Fast.NodeListAccess(x);
	this.att = new haxe.xml._Fast.AttribAccess(x);
	this.has = new haxe.xml._Fast.HasAttribAccess(x);
	this.hasNode = new haxe.xml._Fast.HasNodeAccess(x);
};
haxe.xml.Fast.__name__ = ["haxe","xml","Fast"];
haxe.xml.Fast.prototype = {
	getElements: function() {
		var it = this.x.elements();
		return { hasNext : $bind(it,it.hasNext), next : function() {
			var x = it.next();
			if(x == null) return null;
			return new haxe.xml.Fast(x);
		}};
	}
	,getInnerHTML: function() {
		var s = new StringBuf();
		var $it0 = this.x.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			s.b += Std.string(x.toString());
		}
		return s.b;
	}
	,getInnerData: function() {
		var it = this.x.iterator();
		if(!it.hasNext()) throw this.getName() + " does not have data";
		var v = it.next();
		var n = it.next();
		if(n != null) {
			if(v.nodeType == Xml.PCData && n.nodeType == Xml.CData && StringTools.trim(v.getNodeValue()) == "") {
				var n2 = it.next();
				if(n2 == null || n2.nodeType == Xml.PCData && StringTools.trim(n2.getNodeValue()) == "" && it.next() == null) return n.getNodeValue();
			}
			throw this.getName() + " does not only have data";
		}
		if(v.nodeType != Xml.PCData && v.nodeType != Xml.CData) throw this.getName() + " does not have data";
		return v.getNodeValue();
	}
	,getName: function() {
		return this.x.nodeType == Xml.Document?"Document":this.x.getNodeName();
	}
	,elements: null
	,hasNode: null
	,has: null
	,att: null
	,nodes: null
	,node: null
	,innerHTML: null
	,innerData: null
	,name: null
	,x: null
	,__class__: haxe.xml.Fast
	,__properties__: {get_name:"getName",get_innerData:"getInnerData",get_innerHTML:"getInnerHTML",get_elements:"getElements"}
}
haxe.xml.Parser = $hxClasses["haxe.xml.Parser"] = function() { }
haxe.xml.Parser.__name__ = ["haxe","xml","Parser"];
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
}
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.getNodeName()) throw "Expected </" + parent.getNodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProlog(str1));
				state = 1;
			}
			break;
		}
		c = str.charCodeAt(++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
}
haxe.xml.Parser.isValidChar = function(c) {
	return c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45;
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
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.document = null;
js.Lib.window = null;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var sf = sf || {}
if(!sf.event) sf.event = {}
sf.event.Event = $hxClasses["sf.event.Event"] = function(name,source) {
	this.name = name;
	this.source = source;
};
sf.event.Event.__name__ = ["sf","event","Event"];
sf.event.Event.prototype = {
	source: null
	,name: null
	,__class__: sf.event.Event
}
sf.event.EventDispatcher = $hxClasses["sf.event.EventDispatcher"] = function() { }
sf.event.EventDispatcher.__name__ = ["sf","event","EventDispatcher"];
sf.event.EventDispatcher.prototype = {
	dispatchEvent: null
	,__class__: sf.event.EventDispatcher
}
sf.event.EventListener = $hxClasses["sf.event.EventListener"] = function() { }
sf.event.EventListener.__name__ = ["sf","event","EventListener"];
sf.event.EventListener.prototype = {
	hasEventListener: null
	,removeEventListener: null
	,addEventListener: null
	,__class__: sf.event.EventListener
}
sf.event.EventSystem = $hxClasses["sf.event.EventSystem"] = function() { }
sf.event.EventSystem.__name__ = ["sf","event","EventSystem"];
sf.event.EventSystem.__interfaces__ = [sf.event.EventListener,sf.event.EventDispatcher];
var stx = stx || {}
stx.Arrays = $hxClasses["stx.Arrays"] = function() { }
stx.Arrays.__name__ = ["stx","Arrays"];
stx.Arrays.partition = function(arr,f) {
	return ArrayLambda.foldl(arr,new stx.Tuple2([],[]),function(a,b) {
		if(f(b)) a.fst().push(b); else a.snd().push(b);
		return a;
	});
}
stx.Arrays.partitionWhile = function(arr,f) {
	var partitioning = true;
	return ArrayLambda.foldl(arr,new stx.Tuple2([],[]),function(a,b) {
		if(partitioning) {
			if(f(b)) a.fst().push(b); else {
				partitioning = false;
				a.snd().push(b);
			}
		} else a.snd().push(b);
		return a;
	});
}
stx.Arrays.mapTo = function(src,dest,f) {
	return ArrayLambda.foldl(src,ArrayLambda.snapshot(dest),function(a,b) {
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
	return ArrayLambda.foldl(src,dest,function(a,b) {
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
	return ArrayLambda.foldl(arr,0,function(a,b) {
		return a + (f(b)?1:0);
	});
}
stx.Arrays.countWhile = function(arr,f) {
	var counting = true;
	return ArrayLambda.foldl(arr,0,function(a,b) {
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
	var a = ArrayLambda.snapshot(arr);
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
	var a = ArrayLambda.snapshot(arr);
	a.reverse();
	return stx.Arrays.scanl1(a,f);
}
stx.Arrays.elements = function(arr) {
	return ArrayLambda.snapshot(arr);
}
stx.Arrays.appendAll = function(arr,i) {
	var acc = ArrayLambda.snapshot(arr);
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
stx.Arrays.find = function(arr,f) {
	return ArrayLambda.foldl(arr,stx.Option.None,function(a,b) {
		return (function($this) {
			var $r;
			switch( (a)[1] ) {
			case 0:
				$r = stx.Options.filter(stx.Options.toOption(b),f);
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
	return ArrayLambda.foldl(arr,true,function(a,b) {
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
	return ArrayLambda.foldl(arr,false,function(a,b) {
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
stx.Arrays.reversed = function(arr) {
	return IterableLambda.foldl(arr,[],function(a,b) {
		a.unshift(b);
		return a;
	});
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
	return ArrayLambda.foldl(arr,[],function(a,b) {
		return stx.Arrays.existsP(a,b,f)?a:stx.Arrays.add(a,b);
	});
}
stx.Arrays.nub = function(arr) {
	return stx.Arrays.nubBy(arr,stx.ds.plus.Equal.getEqualFor(arr[0]));
}
stx.Arrays.intersectBy = function(arr1,arr2,f) {
	return ArrayLambda.foldl(arr1,[],function(a,b) {
		return stx.Arrays.existsP(arr2,b,f)?stx.Arrays.add(a,b):a;
	});
}
stx.Arrays.intersect = function(arr1,arr2) {
	return stx.Arrays.intersectBy(arr1,arr2,stx.ds.plus.Equal.getEqualFor(arr1[0]));
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
	return stx.Arrays.zipWith(a,b,tuple2);
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
	return stx.Arrays.zipWithIndexWith(a,tuple2);
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
	var copy = ArrayLambda.snapshot(a);
	copy.push(t);
	return copy;
}
stx.Arrays.prepend = function(a,t) {
	var copy = ArrayLambda.snapshot(a);
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
stx.Arrays.contains = function(a,t) {
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
stx.Arrays.fromMap = function(hash) {
	return IterableLambda.toArray(IterableLambda.map(IterableLambda.toIterable(hash.keys()),function(x) {
		return stx.Entuple.entuple(x,hash.get(x));
	}));
}
stx.ArrayType = $hxClasses["stx.ArrayType"] = function() { }
stx.ArrayType.__name__ = ["stx","ArrayType"];
stx.ArrayType.find = function(a) {
	return stx.Functions2.flip(stx.Arrays.find);
}
stx.ArrayType.map = function(a) {
	return stx.Functions2.flip(ArrayLambda.map);
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
stx.Anys = $hxClasses["stx.Anys"] = function() { }
stx.Anys.__name__ = ["stx","Dynamics"];
stx.Anys.withEffect = function(t,f) {
	f(t);
	return t;
}
stx.Anys.withEffectP = function(a,f) {
	f(a);
	return a;
}
stx.Anys.into = function(a,f) {
	return f(a);
}
stx.Anys.memoize = function(t) {
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
stx.Anys.toThunk = function(t) {
	return function() {
		return t;
	};
}
stx.Anys.toConstantFunction = function(t) {
	return function(s) {
		return t;
	};
}
stx.Anys.apply = function(v,fn) {
	fn(v);
}
stx.Anys.then = function(a,b) {
	return b;
}
stx.Eithers = $hxClasses["stx.Eithers"] = function() { }
stx.Eithers.__name__ = ["stx","Eithers"];
stx.Eithers.toTuple = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = new stx.Tuple2(v,null);
			break;
		case 1:
			var v = $e[2];
			$r = new stx.Tuple2(null,v);
			break;
		default:
			$r = (function($this) {
				var $r;
				throw "Either is neither Left not Right";
				$r = null;
				return $r;
			}($this));
		}
		return $r;
	}(this));
}
stx.Eithers.toTupleO = function(e) {
	return (function($this) {
		var $r;
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = new stx.Tuple2(stx.Option.Some(v),stx.Option.None);
			break;
		case 1:
			var v = $e[2];
			$r = new stx.Tuple2(stx.Option.None,stx.Option.Some(v));
			break;
		default:
			$r = (function($this) {
				var $r;
				throw "Either is neither Left not Right";
				return $r;
			}($this));
		}
		return $r;
	}(this));
}
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
stx.Eithers.mapRight = function(e,f) {
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
stx.Filters = $hxClasses["stx.Filters"] = function() { }
stx.Filters.__name__ = ["stx","Filters"];
stx.Filters.filterIsNotNull = function(iter) {
	return IterableLambda.filter(iter,function(e) {
		return e != null;
	});
}
stx.Filters.filterIsNull = function(iter) {
	return IterableLambda.filter(iter,function(e) {
		return e == null;
	});
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
	} catch( e ) {
		o = stx.Either.Left(e);
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
	return stx.Functions0.returning(f,stx.Anys.toThunk(value));
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
stx.Functions0.map = function(f,f1) {
	return function() {
		return f1(f());
	};
}
stx.Functions0.equals = function(a,b) {
	return Reflect.compareMethods(a,b);
}
stx.Functions1 = $hxClasses["stx.Functions1"] = function() { }
stx.Functions1.__name__ = ["stx","Functions1"];
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
stx.Functions1.curry = function(f) {
	return function() {
		return function(p1) {
			return f(p1);
		};
	};
}
stx.Functions1.returning = function(f,thunk) {
	return function(p1) {
		f(p1);
		return thunk();
	};
}
stx.Functions1.returningC = function(f,value) {
	return stx.Functions1.returning(f,stx.Anys.toThunk(value));
}
stx.Functions1.compose = function(f1,f2) {
	return function(u) {
		return f1(f2(u));
	};
}
stx.Functions1.then = function(f1,f2) {
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
stx.Functions2.then = function(f1,f2) {
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
		return r == null?(function($this) {
			var $r;
			r = f(p1,p2);
			$r = r;
			return $r;
		}(this)):r;
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
stx.Functions5 = $hxClasses["stx.Functions5"] = function() { }
stx.Functions5.__name__ = ["stx","Functions5"];
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
	return stx.Anys.withEffect(new stx.Future(),function(future) {
		future.cancel();
	});
}
stx.Future.create = function() {
	return new stx.Future();
}
stx.Future.toFuture = function(t) {
	return stx.Future.create().deliver(t,{ fileName : "Future.hx", lineNumber : 273, className : "stx.Future", methodName : "toFuture"});
}
stx.Future.waitFor = function(toJoin) {
	var joinLen = ArrayLambda.size(toJoin), myprm = stx.Future.create(), combined = [], sequence = 0;
	ArrayLambda.foreach(toJoin,function(xprm) {
		if(!js.Boot.__instanceof(xprm,stx.Future)) throw "not a promise:" + Std.string(xprm);
		xprm.sequence = sequence++;
		xprm.deliverMe(function(r) {
			combined.push({ seq : r.sequence, val : r._result});
			if(combined.length == joinLen) {
				combined.sort(function(x,y) {
					return x.seq - y.seq;
				});
				myprm.deliver(ArrayLambda.map(combined,function(el) {
					return el.val;
				}),{ fileName : "Future.hx", lineNumber : 302, className : "stx.Future", methodName : "waitFor"});
			}
		});
	});
	return myprm;
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
	,zip: function(f2) {
		var zipped = new stx.Future();
		var f1 = this;
		var deliverZip = function() {
			if(f1.isDelivered() && f2.isDelivered()) zipped.deliver(new stx.Tuple2(stx.Options.get(f1.value()),stx.Options.get(f2.value())),{ fileName : "Future.hx", lineNumber : 228, className : "stx.Future", methodName : "zip"});
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
	,filter: function(f) {
		var fut = new stx.Future();
		this.deliverTo(function(t) {
			if(f(t)) fut.deliver(t,{ fileName : "Future.hx", lineNumber : 209, className : "stx.Future", methodName : "filter"}); else fut.forceCancel();
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
				fut.deliver(s,{ fileName : "Future.hx", lineNumber : 191, className : "stx.Future", methodName : "flatMap"});
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
			fut.deliver(f(t),{ fileName : "Future.hx", lineNumber : 162, className : "stx.Future", methodName : "map"});
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
		return this._isCanceled?this:this._isSet?SCore.error("Future :" + Std.string(this.value()) + " already delivered at " + stx.err.Positions.toString(pos),{ fileName : "Future.hx", lineNumber : 57, className : "stx.Future", methodName : "deliver"}):(function($this) {
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
stx.Mapes = $hxClasses["stx.Mapes"] = function() { }
stx.Mapes.__name__ = ["stx","Mapes"];
stx.Mapes.fromMap = function(h) {
	return IterableLambda.map(IterableLambda.toIterable(h.keys()),function(x) {
		var val = h.get(x);
		return stx.Entuple.entuple(x,val);
	});
}
stx.Mapes.hasAll = function(h,entries) {
	var ok = true;
	var _g = 0;
	while(_g < entries.length) {
		var val = entries[_g];
		++_g;
		if(!h.exists(val)) {
			ok = false;
			break;
		}
	}
	return ok;
}
stx.Mapes.hasAny = function(h,entries) {
	var _g = 0;
	while(_g < entries.length) {
		var val = entries[_g];
		++_g;
		if(h.exists(val)) return true;
	}
	return false;
}
stx.MapType = $hxClasses["stx.MapType"] = function() { }
stx.MapType.__name__ = ["stx","MapType"];
stx.MapType.exists = function(h,str) {
	return h.exists(str);
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
	return IterableLambda.toArray(iter1).concat(IterableLambda.toArray(iter2));
}
stx.Iterables.foldr = function(iterable,z,f) {
	return stx.Arrays.foldr(IterableLambda.toArray(iterable),z,f);
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
			$r = SCore.error("Iterable has no head",{ fileName : "Iterables.hx", lineNumber : 57, className : "stx.Iterables", methodName : "head"});
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
			$r = SCore.error("Iterable has no tail",{ fileName : "Iterables.hx", lineNumber : 74, className : "stx.Iterables", methodName : "tail"});
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
stx.Iterables.dropWhile = function(a,p) {
	var r = stx.Iterables.append([],a);
	var $it0 = $iterator(a)();
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
stx.Iterables.contains = function(iter,value,eq) {
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var el = $it0.next();
		if(eq(value,el)) return true;
	}
	return false;
}
stx.Iterables.nub = function(iter) {
	var result = [];
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var element = $it0.next();
		if(!stx.Iterables.contains(result,element,function(a,b) {
			return a == b;
		})) result.push(element);
	}
	return result;
}
stx.Iterables.at = function(iter,index) {
	var result = null;
	if(index < 0) index = IterableLambda.size(iter) - -1 * index;
	var curIndex = 0;
	var $it0 = $iterator(iter)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		if(index == curIndex) return e; else ++curIndex;
	}
	return SCore.error("Index not found",{ fileName : "Iterables.hx", lineNumber : 163, className : "stx.Iterables", methodName : "at"});
}
stx.Iterables.flatten = function(iter) {
	var empty = [];
	return IterableLambda.foldl(iter,empty,stx.Iterables.concat);
}
stx.Iterables.interleave = function(iter) {
	var alls = IterableLambda.toArray(IterableLambda.map(iter,function(it) {
		return $iterator(it)();
	}));
	var res = [];
	while(stx.Arrays.forAll(alls,function(iter1) {
		return iter1.hasNext();
	})) ArrayLambda.foreach(alls,function(iter1) {
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
	var i1 = $iterator(tuple.fst())();
	var i2 = $iterator(tuple.snd())();
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
	return IterableLambda.foldl(iter,[e],function(b,a) {
		b.push(a);
		return b;
	});
}
stx.Iterables.reversed = function(iter) {
	return IterableLambda.foldl(iter,[],function(a,b) {
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
stx.Iterables.nubBy = function(iter,f) {
	return IterableLambda.foldl(iter,[],function(a,b) {
		return stx.Iterables.existsP(a,b,f)?a:(function($this) {
			var $r;
			a.push(b);
			$r = a;
			return $r;
		}(this));
	});
}
stx.Iterables.intersectBy = function(iter1,iter2,f) {
	return IterableLambda.foldl(iter1,[],function(a,b) {
		return stx.Iterables.existsP(iter2,b,f)?stx.Iterables.add(a,b):a;
	});
}
stx.Iterables.intersect = function(iter1,iter2) {
	return IterableLambda.foldl(iter1,[],function(a,b) {
		return stx.Iterables.existsP(iter2,b,function(a1,b1) {
			return a1 == b1;
		})?stx.Iterables.add(a,b):a;
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
		if(!exists) result = stx.Iterables.add(result,e);
	}
	return result;
}
stx.Iterables.union = function(iter1,iter2) {
	return stx.Iterables.unionBy(iter1,iter2,function(a,b) {
		return a == b;
	});
}
stx.Iterables.partition = function(iter,f) {
	return stx.Arrays.partition(IterableLambda.toArray(iter),f);
}
stx.Iterables.partitionWhile = function(iter,f) {
	return stx.Iterables.partitionWhile(IterableLambda.toArray(iter),f);
}
stx.Iterables.count = function(iter,f) {
	return stx.Iterables.count(IterableLambda.toArray(iter),f);
}
stx.Iterables.countWhile = function(iter,f) {
	return stx.Iterables.countWhile(IterableLambda.toArray(iter),f);
}
stx.Iterables.elements = function(iter) {
	return IterableLambda.toArray(iter);
}
stx.Iterables.appendAll = function(iter,i) {
	return stx.Arrays.append(IterableLambda.toArray(iter),i);
}
stx.Iterables.isEmpty = function(iter) {
	return !$iterator(iter)().hasNext();
}
stx.Iterables.find = function(iter,f) {
	return stx.Arrays.find(IterableLambda.toArray(iter),f);
}
stx.Iterables.forAll = function(iter,f) {
	return stx.Arrays.forAll(IterableLambda.toArray(iter),f);
}
stx.Iterables.forAny = function(iter,f) {
	return stx.Arrays.forAny(IterableLambda.toArray(iter),f);
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
		return stx.Options.toOption(val);
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
stx.Lenses = $hxClasses["stx.Lenses"] = function() { }
stx.Lenses.__name__ = ["stx","Lenses"];
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
	var log = stx.framework.Injector.inject(stx.Logger,pos);
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
	var log1 = stx.framework.Injector.inject(stx.Logger,pos);
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
			return stx.Arrays.forAny(ArrayLambda.map(ArrayLambda.map(includes,stx.Enums.params),stx.Arrays.first),(function(f,a1) {
				return function(v1) {
					return f(a1,v1);
				};
			})($bind(_g,_g.checker),pos));
		};
		var black = function(excludes) {
			return !stx.Arrays.forAll(ArrayLambda.map(ArrayLambda.map(excludes,stx.Enums.params),stx.Arrays.first),(function(f,a1) {
				return function(v1) {
					return f(a1,v1);
				};
			})($bind(_g,_g.checker),pos));
		};
		var o = stx.Tuple2.into(stx.Arrays.partition(this.listings,function(x) {
			return stx.Enums.constructorOf(x) == "Include";
		}),function(includes,excludes) {
			return stx.Bools.ifElse(includes.length > 0,function() {
				return white(includes)?stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes.length > 0,stx.Functions1.lazy(black,excludes)),stx.Option.Some(_g.permissive))):false;
			},function() {
				return stx.Options.get(stx.Options.orElseC(stx.Bools.ifTrue(excludes.length > 0,stx.Functions1.lazy(black,excludes)),stx.Option.Some(_g.permissive)));
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
	var iter = new IntIterator(3,Math.ceil(Math.sqrt(n)) + 1);
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
	var iter = new IntIterator(1,Math.ceil(n / 2 + 1));
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
stx.MethodConvention = $hxClasses["stx.MethodConvention"] = { __ename__ : ["stx","MethodConvention"], __constructs__ : ["Replace","Patch","Ignore"] }
stx.MethodConvention.Replace = ["Replace",0];
stx.MethodConvention.Replace.toString = $estr;
stx.MethodConvention.Replace.__enum__ = stx.MethodConvention;
stx.MethodConvention.Patch = ["Patch",1];
stx.MethodConvention.Patch.toString = $estr;
stx.MethodConvention.Patch.__enum__ = stx.MethodConvention;
stx.MethodConvention.Ignore = ["Ignore",2];
stx.MethodConvention.Ignore.toString = $estr;
stx.MethodConvention.Ignore.__enum__ = stx.MethodConvention;
stx.Method = $hxClasses["stx.Method"] = function(fn,name,pos) {
	this.pos = pos;
	this.name = name;
	if(fn == null) haxe.Log.trace(stx.Log.warning("Setting null function"),{ fileName : "Methods.hx", lineNumber : 52, className : "stx.Method", methodName : "new"});
	this.convention = stx.MethodConvention.Patch;
	this.fn = fn;
};
stx.Method.__name__ = ["stx","Method"];
stx.Method.prototype = {
	toString: function() {
		return "Method " + this.name + "[ " + Std.string(this.pos) + " ]";
	}
	,isEmpty: function() {
		return this.fn == null;
	}
	,requals: function(f) {
		return Reflect.compareMethods(this.fn,f);
	}
	,equals: function(m) {
		return Reflect.compareMethods(this.fn,m.fn);
	}
	,replaceAt: function(i,v) {
		throw new stx.err.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 66, className : "stx.Method", methodName : "replaceAt"});
		return null;
	}
	,patch: function(args) {
		throw new stx.err.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 62, className : "stx.Method", methodName : "patch"});
		return null;
	}
	,execute: function(v,pos) {
		if(this.isEmpty()) throw new stx.err.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 58, className : "stx.Method", methodName : "execute"});
		return null;
	}
	,get_length: function() {
		throw new stx.err.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 45, className : "stx.Method", methodName : "get_length"});
		return -1;
	}
	,length: null
	,args: null
	,fn: null
	,convention: null
	,setName: function(n) {
		this.name = n;
		return this;
	}
	,name: null
	,pos: null
	,__class__: stx.Method
	,__properties__: {get_length:"get_length"}
}
stx.Method0 = $hxClasses["stx.Method0"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method0.__name__ = ["stx","Method0"];
stx.Method0.toMethod = function(fn,name) {
	return new stx.Method0(fn,name,{ fileName : "Methods.hx", lineNumber : 92, className : "stx.Method0", methodName : "toMethod"});
}
stx.Method0.__super__ = stx.Method;
stx.Method0.prototype = $extend(stx.Method.prototype,{
	execute: function(v,pos) {
		stx.Method.prototype.execute.call(this,null,{ fileName : "Methods.hx", lineNumber : 88, className : "stx.Method0", methodName : "execute"});
		return this.fn();
	}
	,__class__: stx.Method0
});
stx.Method1 = $hxClasses["stx.Method1"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method1.__name__ = ["stx","Method1"];
stx.Method1.toMethod = function(v,name,pos) {
	return new stx.Method1(v,name,pos);
}
stx.Method1.__super__ = stx.Method;
stx.Method1.prototype = $extend(stx.Method.prototype,{
	replaceAt: function(i,v) {
		if(i != 0) throw new stx.err.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 128, className : "stx.Method1", methodName : "replaceAt"});
		this.args = v;
		return this;
	}
	,patch: function(args) {
		this.args = args;
		return this;
	}
	,execute: function(v,pos) {
		if(this.fn == null || this.isEmpty()) throw new stx.err.AbstractMethodError({ fileName : "Methods.hx", lineNumber : 104, className : "stx.Method1", methodName : "execute"});
		var o = null;
		try {
			o = (function($this) {
				var $r;
				switch( ($this.convention)[1] ) {
				case 0:
				case 1:
					$r = $this.fn(v);
					break;
				case 2:
					$r = $this.fn($this.args);
					break;
				}
				return $r;
			}(this));
		} catch( e ) {
			haxe.Log.trace("Declared " + Std.string(this) + " \n called " + Std.string(e),{ fileName : "Methods.hx", lineNumber : 114, className : "stx.Method1", methodName : "execute"});
		}
		return o;
	}
	,get_length: function() {
		return 1;
	}
	,__class__: stx.Method1
});
stx.Method2 = $hxClasses["stx.Method2"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method2.__name__ = ["stx","Method2"];
stx.Method2.toMethod = function(v,name) {
	return new stx.Method2(v,name,{ fileName : "Methods.hx", lineNumber : 170, className : "stx.Method2", methodName : "toMethod"});
}
stx.Method2.__super__ = stx.Method;
stx.Method2.prototype = $extend(stx.Method.prototype,{
	replaceAt: function(i,v) {
		if(i > 1) throw new stx.err.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 157, className : "stx.Method2", methodName : "replaceAt"}); else switch(i) {
		case 0:
			this.args.fst() = v;
			break;
		case 1:
			this.args.snd() = v;
			break;
		}
		return this;
	}
	,patch: function(args) {
		this.args = stx.Tuple2.patch(this.args,args);
		return this;
	}
	,execute: function(v,pos) {
		switch( (this.convention)[1] ) {
		case 1:
			v = stx.Tuple2.patch(this.args,v);
			break;
		case 2:
			v = this.args;
			break;
		default:
		}
		return this.fn(v.fst(),v.snd());
	}
	,get_length: function() {
		return 2;
	}
	,__class__: stx.Method2
});
stx.Method3 = $hxClasses["stx.Method3"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method3.__name__ = ["stx","Method3"];
stx.Method3.toMethod = function(v,name) {
	return new stx.Method3(v,name,{ fileName : "Methods.hx", lineNumber : 212, className : "stx.Method3", methodName : "toMethod"});
}
stx.Method3.__super__ = stx.Method;
stx.Method3.prototype = $extend(stx.Method.prototype,{
	replaceAt: function(i,v) {
		if(i > 2) throw new stx.err.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 198, className : "stx.Method3", methodName : "replaceAt"}); else switch(i) {
		case 0:
			this.args.fst() = v;
			break;
		case 1:
			this.args.snd() = v;
			break;
		case 2:
			this.args.thd() = v;
			break;
		}
		return this;
	}
	,patch: function(args) {
		this.args = stx.Tuple3.patch(this.args,args);
		return this;
	}
	,execute: function(v,pos) {
		switch( (this.convention)[1] ) {
		case 1:
			v = stx.Tuple3.patch(this.args,v);
			break;
		case 2:
			v = this.args;
			break;
		default:
		}
		return this.fn(v.fst(),v.snd(),v.thd());
	}
	,get_length: function() {
		return 3;
	}
	,__class__: stx.Method3
});
stx.Method4 = $hxClasses["stx.Method4"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method4.__name__ = ["stx","Method4"];
stx.Method4.toMethod = function(v,name) {
	return new stx.Method4(v,name,{ fileName : "Methods.hx", lineNumber : 253, className : "stx.Method4", methodName : "toMethod"});
}
stx.Method4.__super__ = stx.Method;
stx.Method4.prototype = $extend(stx.Method.prototype,{
	replaceAt: function(i,v) {
		if(i > 3) throw new stx.err.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 238, className : "stx.Method4", methodName : "replaceAt"}); else switch(i) {
		case 0:
			this.args.fst() = v;
			break;
		case 1:
			this.args.snd() = v;
			break;
		case 2:
			this.args.thd() = v;
			break;
		case 3:
			this.args.frt() = v;
			break;
		}
		return this;
	}
	,patch: function(args) {
		this.args = stx.Tuple4.patch(this.args,args);
		return this;
	}
	,execute: function(v,pos) {
		switch( (this.convention)[1] ) {
		case 1:
			v = stx.Tuple4.patch(this.args,v);
			break;
		case 2:
			v = this.args;
			break;
		default:
		}
		return this.fn(v.fst(),v.snd(),v.thd(),v.frt());
	}
	,get_length: function() {
		return 4;
	}
	,__class__: stx.Method4
});
stx.Method5 = $hxClasses["stx.Method5"] = function(fn,name,pos) {
	stx.Method.call(this,fn,name,pos);
};
stx.Method5.__name__ = ["stx","Method5"];
stx.Method5.toMethod = function(v,name) {
	return new stx.Method5(v,name,{ fileName : "Methods.hx", lineNumber : 294, className : "stx.Method5", methodName : "toMethod"});
}
stx.Method5.__super__ = stx.Method;
stx.Method5.prototype = $extend(stx.Method.prototype,{
	replaceAt: function(i,v) {
		if(i > 4) throw new stx.err.OutOfBoundsError({ fileName : "Methods.hx", lineNumber : 279, className : "stx.Method5", methodName : "replaceAt"}); else switch(i) {
		case 0:
			this.args.fst() = v;
			break;
		case 1:
			this.args.snd() = v;
			break;
		case 2:
			this.args.thd() = v;
			break;
		case 3:
			this.args.frt() = v;
			break;
		case 4:
			this.args.fth() = v;
			break;
		}
		this.args = v;
		return this;
	}
	,patch: function(args) {
		this.args = stx.Tuple5.patch(this.args,args);
		return this;
	}
	,execute: function(v,pos) {
		switch( (this.convention)[1] ) {
		case 1:
			v = stx.Tuple5.patch(this.args,v);
			break;
		case 2:
			v = this.args;
			break;
		default:
		}
		return this.fn(v.fst(),v.snd(),v.thd(),v.frt(),v.fth());
	}
	,get_length: function() {
		return 5;
	}
	,__class__: stx.Method5
});
stx.Methods = $hxClasses["stx.Methods"] = function() { }
stx.Methods.__name__ = ["stx","Methods"];
stx.Methods.apply = function(f,v,pos) {
	return (function($this) {
		var $r;
		var $e = (f);
		switch( $e[1] ) {
		case 1:
			var f1 = $e[2];
			$r = f1.execute(v,pos);
			break;
		case 0:
			$r = null;
			break;
		}
		return $r;
	}(this));
}
stx.Methods.applyOr = function(o,x,f0,pos) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 1:
			var f = $e[2];
			$r = stx.Options.toOption(f.execute(x,pos));
			break;
		case 0:
			$r = (function($this) {
				var $r;
				f0();
				$r = stx.Option.None;
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.Term1 = $hxClasses["stx.Term1"] = function() { }
stx.Term1.__name__ = ["stx","Term1"];
stx.Term1.toMethod = function(v,name) {
	return new stx.Method1(v,name,{ fileName : "Methods.hx", lineNumber : 313, className : "stx.Term1", methodName : "toMethod"});
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
	return stx.Objects.setAll({ },ArrayLambda.map(Reflect.fields(d),function(name) {
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
		d[field.fst()] = field.snd();
	}
	return d;
}
stx.Objects.replaceAll = function(d1,d2,def) {
	var names = Reflect.fields(d2);
	var oldValues = stx.Objects.extractValues(d1,names,def);
	stx.Objects.extendWith(d1,d2);
	return ArrayLambda.foldl(stx.Arrays.zip(names,oldValues),{ },function(o,t) {
		o[t.fst()] = t.snd();
		return o;
	});
}
stx.Objects.setAllAny = function(d,fields) {
	var $it0 = $iterator(fields)();
	while( $it0.hasNext() ) {
		var field = $it0.next();
		d[field.fst()] = field.snd();
	}
	return d;
}
stx.Objects.replaceAllAny = function(d1,d2,def) {
	var names = Reflect.fields(d2);
	var oldValues = stx.Objects.extractValues(d1,names,def);
	stx.Objects.extendWith(d1,d2);
	return ArrayLambda.foldl(stx.Arrays.zip(names,oldValues),{ },function(o,t) {
		o[t.fst()] = t.snd();
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
	return ArrayLambda.foldl(Reflect.fields(obj),[],function(a,fieldName) {
		var value = Reflect.field(obj,fieldName);
		return fieldName == field?stx.Arrays.add(a,value):Type["typeof"](value) == ValueType.TObject?a.concat(stx.Objects.extractFieldValues(value,field)):a;
	});
}
stx.Objects.extractAll = function(d) {
	return ArrayLambda.map(Reflect.fields(d),function(name) {
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
	return ArrayLambda.foldl(a,{ },function(init,el) {
		init[el.fst()] = el.snd();
		return init;
	});
}
stx.Options = $hxClasses["stx.Options"] = function() { }
stx.Options.__name__ = ["stx","Options"];
stx.Options.toOption = function(t) {
	return t == null?stx.Option.None:stx.Option.Some(t);
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
stx.Options.then = function(o1,o2) {
	return o2;
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
stx.Options.flatMap = function(o,f) {
	return stx.Options.flatten(stx.Options.map(o,f));
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
			})(tuple2,v1));
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
stx.Options.get = function(o) {
	return (function($this) {
		var $r;
		var $e = (o);
		switch( $e[1] ) {
		case 0:
			$r = (function($this) {
				var $r;
				SCore.error("Error: Option is empty",{ fileName : "Options.hx", lineNumber : 104, className : "stx.Options", methodName : "get"});
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
	return stx.Options.orElse(o1,stx.Anys.toThunk(o2));
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
	return stx.Options.orEither(o1,stx.Anys.toThunk(c));
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
	return stx.Options.getOrElse(o,stx.Anys.toThunk(c));
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
stx.Pepsi = $hxClasses["stx.Pepsi"] = function() { }
stx.Pepsi.__name__ = ["stx","Pepsi"];
stx.Pepsi["with"] = function(v,fns) {
	var $e = (stx.rtti.RTypes.typetree(fns));
	switch( $e[1] ) {
	case 1:
		var c = $e[2];
		IterableLambda.foreach(c.statics,function(x) {
			var $e = (x.type);
			switch( $e[1] ) {
			case 4:
				var ret = $e[3], args = $e[2];
				switch(IterableLambda.size(args)) {
				case 1:
					var f = Reflect.field(fns,x.name);
					v[x.name] = (function(f1,a1) {
						return function() {
							return f1(a1);
						};
					})(f,v);
					break;
				case 2:
					var f = Reflect.field(fns,x.name);
					v[x.name] = stx.Functions2.p1(f,v);
					break;
				case 3:
					var f = Reflect.field(fns,x.name);
					v[x.name] = stx.Functions3.p1(f,v);
					break;
				case 4:
					var f = Reflect.field(fns,x.name);
					v[x.name] = (function(f1,a1) {
						return function(a2,a3,a4) {
							return f1(a1,a2,a3,a4);
						};
					})(f,v);
					break;
				case 5:
					var f = Reflect.field(fns,x.name);
					v[x.name] = (function(f1,a1) {
						return function(a2,a3,a4,a5) {
							return f1(a1,a2,a3,a4,a5);
						};
					})(f,v);
					break;
				case 6:
					var f = Reflect.field(fns,x.name);
					v[x.name] = (function(f1,a1) {
						return function(a2,a3,a4,a5,a6) {
							return f1(a1,a2,a3,a4,a5,a6);
						};
					})(f,v);
					break;
				}
				break;
			default:
			}
		});
		break;
	default:
	}
	return v;
}
stx.Predicates = $hxClasses["stx.Predicates"] = function() { }
stx.Predicates.__name__ = ["stx","Predicates"];
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
	if(equal == null) equal = stx.ds.plus.Equal.getEqualFor(ref);
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
stx.Predicates.negate = function(p) {
	return function(value) {
		return !p(value);
	};
}
stx.StringPredicates = $hxClasses["stx.StringPredicates"] = function() { }
stx.StringPredicates.__name__ = ["stx","StringPredicates"];
stx.StringPredicates.startsWith = function(s) {
	return function(value) {
		return stx.Strings.startsWith(value,s);
	};
}
stx.StringPredicates.endsWith = function(s) {
	return function(value) {
		return stx.Strings.endsWith(value,s);
	};
}
stx.StringPredicates.contains = function(s) {
	return function(value) {
		return stx.Strings.contains(value,s);
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
stx.Promise = $hxClasses["stx.Promise"] = function(cancel) {
	this.done = false;
	this.fut = new stx.Future();
	this.err = stx.Option.None;
	if(cancel != null) this.onError(cancel);
};
stx.Promise.__name__ = ["stx","Promise"];
stx.Promise.success = function(value) {
	var o = new stx.Promise();
	o.right(value);
	return o;
}
stx.Promise.failure = function(value) {
	var o = new stx.Promise();
	o.left(value);
	return o;
}
stx.Promise.fromCallback = function(promise) {
	return function(err,val) {
		if(err != null) promise.left(err); else promise.right(val);
	};
}
stx.Promise.waitFor = function(toJoin) {
	var f0 = false;
	var oc = new stx.Promise(), results = [];
	ArrayLambda.foreach(toJoin,function(x) {
		x.onError(stx.reactive.F1A.lift(function(x1) {
			if(oc.userCancel != null && !f0) f0 = true;
			return x1;
		}));
	});
	stx.Future.waitFor(ArrayLambda.map(toJoin,function(promise) {
		return promise.future();
	})).deliverTo(function(aoc) {
		var failed = false;
		ArrayLambda.foreach(aoc,function(el) {
			if(!failed) {
				if(stx.Eithers.isLeft(el)) {
					failed = true;
					oc.resolve(stx.Either.Left(stx.Options.get(stx.Eithers.left(el))),{ fileName : "Promise.hx", lineNumber : 295, className : "stx.Promise", methodName : "waitFor"});
					return;
				}
				results.push(stx.Options.get(stx.Eithers.right(el)));
			}
		});
		if(!failed) oc.resolve(stx.Either.Right(results),{ fileName : "Promise.hx", lineNumber : 302, className : "stx.Promise", methodName : "waitFor"});
	});
	return oc;
}
stx.Promise.prototype = {
	toCallback: function(cb) {
		if(cb == null) throw new stx.err.NullReferenceError("cb",{ fileName : "Promise.hx", lineNumber : 256, className : "stx.Promise", methodName : "toCallback"});
		this.deliverTo(function(b) {
			cb(null,b);
		});
		this.onError(stx.reactive.F1A.lift(function(x) {
			cb(x,null);
			return x;
		}));
		return this;
	}
	,cancel: function() {
		this.fut.cancel();
	}
	,flatMap: function(f) {
		var nf = new stx.Promise();
		nf.err = this.err;
		this.onError(stx.reactive.F1A.lift(function(x) {
			nf.onCancel(x);
			return x;
		}));
		this.fut.deliverTo(function(either) {
			var $e = (either);
			switch( $e[1] ) {
			case 1:
				var result = $e[2];
				var op = f(result);
				op.onError(stx.reactive.F1A.lift(function(x) {
					nf.onCancel(x);
					return x;
				}));
				op.deliverTo(function(r) {
					nf.resolve(stx.Either.Right(r),{ fileName : "Promise.hx", lineNumber : 210, className : "stx.Promise", methodName : "flatMap"});
				});
				break;
			case 0:
				var msg = $e[2];
				break;
			}
		});
		return nf;
	}
	,map: function(f) {
		var _g = this;
		var nf = new stx.Promise();
		var uc = this.userCancel;
		nf.err = this.err;
		this.onError(stx.reactive.F1A.lift(function(x) {
			nf.onCancel(x);
			return x;
		}));
		this.fut.deliverTo(function(e) {
			var $e = (e);
			switch( $e[1] ) {
			case 1:
				var t = $e[2];
				nf.right(f(t));
				break;
			case 0:
				var msg = $e[2];
				_g.onCancel(msg);
				break;
			}
		});
		return nf;
	}
	,right: function(b) {
		this.resolve(stx.Either.Right(b),{ fileName : "Promise.hx", lineNumber : 158, className : "stx.Promise", methodName : "right"});
		return this;
	}
	,left: function(a) {
		this.resolve(stx.Either.Left(a),{ fileName : "Promise.hx", lineNumber : 151, className : "stx.Promise", methodName : "left"});
		return this;
	}
	,resolve: function(e,pos) {
		this.fut.deliver(e,pos);
		var $e = (e);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			if(!this.isDone()) this.onCancel(v);
			break;
		default:
		}
	}
	,deliverTo: function(cb) {
		var _g = this;
		this.fut.deliverTo(function(e) {
			var $e = (e);
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				cb(v);
				break;
			case 0:
				var v = $e[2];
				_g.onCancel(v);
				break;
			}
		});
		return this;
	}
	,error: function() {
		return this.err;
	}
	,onError: function(cb) {
		if(cb == null) throw new stx.err.NullReferenceError("cb",{ fileName : "Promise.hx", lineNumber : 89, className : "stx.Promise", methodName : "onError"});
		if(this.userCancel == null) this.userCancel = cb; else this.userCancel = stx.reactive.Then.then(this.userCancel,cb);
		var $e = (this.err);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			var $e = (this.err);
			switch( $e[1] ) {
			case 1:
				var v1 = $e[2];
				this.err = stx.Option.Some(v1);
				if(this.userCancel != null) stx.reactive.Viaz.run(this.userCancel,v1);
				break;
			default:
			}
			break;
		default:
		}
		return this;
	}
	,future: function() {
		return this.fut;
	}
	,foreach: function(f) {
		return this.deliverTo(f);
	}
	,onCancel: function(e) {
		if(this.isDone()) return;
		this.err = stx.Option.Some(e);
		if(this.userCancel != null) stx.reactive.Viaz.run(this.userCancel,e);
		this.done = true;
	}
	,isDone: function() {
		return this.fut.isDone() && this.done;
	}
	,toString: function() {
		return "Promise";
	}
	,err: null
	,done: null
	,userCancel: null
	,fut: null
	,__class__: stx.Promise
}
stx.Readers = $hxClasses["stx.Readers"] = function() { }
stx.Readers.__name__ = ["stx","Readers"];
stx.Readers.map = function(reader,f) {
	return function(x) {
		return f(reader(x));
	};
}
stx.Readers.flatMap = function(reader,f) {
	return function(x) {
		return (f(reader(x)))(x);
	};
}
stx.States = $hxClasses["stx.States"] = function() { }
stx.States.__name__ = ["stx","States"];
stx.States.apply = function(state,v) {
	return state(v);
}
stx.States.exec = function(state,s) {
	return stx.Tuple2.second(state(s));
}
stx.States.eval = function(state,s) {
	return stx.Tuple2.first(state(s));
}
stx.States.map = function(state,fn) {
	return stx.Functions1.then(stx.Functions2.p1(stx.States.apply,state),stx.Functions2.p2(stx.Functions3.p3(stx.Tuple2.translate,SCore.unfold
SCore.unfold()),fn));
}
stx.States.mapS = function(state,fn) {
	return function(s) {
		var o = state(s);
		return new stx.Tuple2(o.fst(),fn(o.snd()));
	};
}
stx.States.flatMap = function(state,fn) {
	return stx.Functions1.then(stx.Functions1.then(stx.Functions2.p1(stx.States.apply,state),stx.Functions2.p2(stx.Functions3.p3(stx.Tuple2.translate,SCore.unfold
SCore.unfold()),fn)),function(t) {
		return t.fst()(t.snd());
	});
}
stx.States.getS = function(state) {
	return function(s) {
		var o = state(s);
		return new stx.Tuple2(o.snd(),o.snd());
	};
}
stx.States.putS = function(state,n) {
	return function(s) {
		return new stx.Tuple2(null,n);
	};
}
stx.States.stateOf = function(v) {
	return function(s) {
		return new stx.Tuple2(null,s);
	};
}
stx.States.unit = function(value) {
	return function(s) {
		return new stx.Tuple2(value,s);
	};
}
stx.StateRef = $hxClasses["stx.StateRef"] = function(v) {
	this.value = v;
};
stx.StateRef.__name__ = ["stx","StateRef"];
stx.StateRef.newVar = function(v) {
	return stx.States.unit(new stx.StateRef(v));
}
stx.StateRef.run = function(v) {
	v(new stx._States.WorldState());
}
stx.StateRef.prototype = {
	modify: function(f) {
		var a = this.read();
		var v = stx.States.flatMap(a,stx.Functions1.then(f,$bind(this,this.write)));
		return v;
	}
	,write: function(a) {
		var _g = this;
		return function(s) {
			_g.value = a;
			return new stx.Tuple2(_g,s);
		};
	}
	,read: function() {
		return stx.States.unit(this.value);
	}
	,value: null
	,__class__: stx.StateRef
}
stx.StateRefs = $hxClasses["stx.StateRefs"] = function() { }
stx.StateRefs.__name__ = ["stx","StateRefs"];
stx.StateRefs.modifier = function(f,sr) {
	return sr.modify(f);
}
stx.StateRefs.reader = function(sr) {
	return sr.read();
}
if(!stx._States) stx._States = {}
stx._States.WorldState = $hxClasses["stx._States.WorldState"] = function() {
};
stx._States.WorldState.__name__ = ["stx","_States","WorldState"];
stx._States.WorldState.prototype = {
	__class__: stx._States.WorldState
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
stx.Time = $hxClasses["stx.Time"] = function() {
	this.ready = false;
};
stx.Time.__name__ = ["stx","Time"];
stx.Time.now = function() {
	return new stx.Time().setRaw(haxe.Timer.stamp() * 1000);
}
stx.Time.day = function(m) {
	if(m == null) m = 1;
	return new stx.Time().setRaw(86400000. * m);
}
stx.Time.hour = function(m) {
	if(m == null) m = 1;
	return new stx.Time().setRaw(3600000. * m);
}
stx.Time.minute = function(m) {
	if(m == null) m = 1;
	return new stx.Time().setRaw(60000. * m);
}
stx.Time.second = function(m) {
	if(m == null) m = 1;
	return new stx.Time().setRaw(1000. * m);
}
stx.Time.millisecond = function(m) {
	if(m == null) m = 1;
	return new stx.Time().setRaw(1. * m);
}
stx.Time.prototype = {
	toString: function() {
		return [this.get_days(),":",this.get_hours(),":",this.get_minutes(),":",this.get_seconds(),":",this.get_milliseconds()].join("");
	}
	,get_days: function() {
		if(!this.ready) this.determine();
		return this.days;
	}
	,days: null
	,get_hours: function() {
		if(!this.ready) this.determine();
		return this.hours;
	}
	,hours: null
	,get_minutes: function() {
		if(!this.ready) this.determine();
		return this.minutes;
	}
	,minutes: null
	,get_seconds: function() {
		if(!this.ready) this.determine();
		return this.seconds;
	}
	,seconds: null
	,get_milliseconds: function() {
		if(!this.ready) this.determine();
		return this.milliseconds;
	}
	,milliseconds: null
	,ready: null
	,determine: function() {
		var o = this.raw;
		var days = Math.floor(o / 86400000);
		o -= (0. + days) * 1000 * 60 * 60 * 24;
		var hours = Math.floor(o / 3600000);
		o -= (0. + hours) * 1000 * 60 * 60;
		var minutes = Math.floor(o / 60000);
		o -= (0. + minutes) * 1000 * 60;
		var seconds = Math.floor(o / 1000);
		o -= (0. + seconds) * 1000;
		var milliseconds = Math.floor(o);
		this.ready = true;
		this.days = days;
		this.hours = hours;
		this.minutes = minutes;
		this.seconds = seconds;
		this.milliseconds = milliseconds;
	}
	,mod: function(t) {
		return new stx.Time().setRaw(this.raw % t.raw);
	}
	,div: function(t) {
		return new stx.Time().setRaw(this.raw * t.raw);
	}
	,mul: function(t) {
		return new stx.Time().setRaw(this.raw * t.raw);
	}
	,sub: function(t) {
		return new stx.Time().setRaw(this.raw - t.raw);
	}
	,add: function(t) {
		return new stx.Time().setRaw(this.raw + t.raw);
	}
	,setRaw: function(v) {
		this.raw = v;
		return this;
	}
	,raw: null
	,__class__: stx.Time
	,__properties__: {get_milliseconds:"get_milliseconds",get_seconds:"get_seconds",get_minutes:"get_minutes",get_hours:"get_hours",get_days:"get_days"}
}
stx.Tuples = $hxClasses["stx.Tuples"] = function() { }
stx.Tuples.__name__ = ["stx","Tuples"];
tuple2 = function(_1,_2) {
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
			return ArrayLambda.flatMap(p.elements(),function(v) {
				return js.Boot.__instanceof(v,stx.Product)?ArrayLambda.flatMap(flatn(v),SCore.unfold
SCore.unfold()):[v];
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
					$r = [p.fst(),p.snd(),p.thd(),p.frt(),p.fth()];
					return $r;
				}($this));
				break;
			case 4:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p.fst(),p.snd(),p.thd(),p.frt()];
					return $r;
				}($this));
				break;
			case 3:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p.fst(),p.snd(),p.thd()];
					return $r;
				}($this));
				break;
			case 2:
				$r = (function($this) {
					var $r;
					var p = $this;
					$r = [p.fst(),p.snd()];
					return $r;
				}($this));
				break;
			}
			return $r;
		}(this));
	}
	,get_length: function() {
		return SCore.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 69, className : "stx.AbstractProduct", methodName : "get_length"});
	}
	,get_prefix: function() {
		return SCore.error("Not implemented",{ fileName : "Tuples.hx", lineNumber : 65, className : "stx.AbstractProduct", methodName : "get_prefix"});
	}
	,toString: function() {
		var s = this.get_prefix() + "(" + (stx.ds.plus.Show.getShowFor(this.element(0)))(this.element(0));
		var _g1 = 1, _g = this.get_length();
		while(_g1 < _g) {
			var i = _g1++;
			s += ", " + (stx.ds.plus.Show.getShowFor(this.element(i)))(this.element(i));
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
	this.fst() = _1;
	this.snd() = _2;
	stx.AbstractProduct.call(this,[_1,_2]);
};
stx.Tuple2.__name__ = ["stx","Tuple2"];
stx.Tuple2.entuple = function(t,c) {
	return new stx.Tuple3(t.fst(),t.snd(),c);
}
stx.Tuple2.into = function(t,f) {
	return f(t.fst(),t.snd());
}
stx.Tuple2.first = function(t) {
	return t.fst();
}
stx.Tuple2.second = function(t) {
	return t.snd();
}
stx.Tuple2.translate = function(t,f1,f2) {
	return stx.Entuple.entuple(f1(t.fst()),f2(t.snd()));
}
stx.Tuple2.patch = function(t0,t1) {
	var _1 = t1.fst() == null?t0.fst():t1.fst();
	var _2 = t1.snd() == null?t0.snd():t1.snd();
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
	this.fst() = _1;
	this.snd() = _2;
	this.thd() = _3;
	stx.AbstractProduct.call(this,[_1,_2,_3]);
};
stx.Tuple3.__name__ = ["stx","Tuple3"];
stx.Tuple3.into = function(t,f) {
	return f(t.fst(),t.snd(),t.thd());
}
stx.Tuple3.translate = function(t,f1,f2,f3) {
	return stx.Tuple2.entuple(stx.Entuple.entuple(f1(t.fst()),f2(t.snd())),f3(t.thd()));
}
stx.Tuple3.entuple = function(t,d) {
	return new stx.Tuple4(t.fst(),t.snd(),t.thd(),d);
}
stx.Tuple3.first = function(t) {
	return t.fst();
}
stx.Tuple3.second = function(t) {
	return t.snd();
}
stx.Tuple3.third = function(t) {
	return t.thd();
}
stx.Tuple3.patch = function(t0,t1) {
	var _1 = t1.fst() == null?t0.fst():t1.fst();
	var _2 = t1.snd() == null?t0.snd():t1.snd();
	var _3 = t1.thd() == null?t0.thd():t1.thd();
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
	this.fst() = first;
	this.snd() = second;
	this.thd() = third;
	this.frt() = fourth;
};
stx.Tuple4.__name__ = ["stx","Tuple4"];
stx.Tuple4.into = function(t,f) {
	return f(t.fst(),t.snd(),t.thd(),t.frt());
}
stx.Tuple4.first = function(t) {
	return t.fst();
}
stx.Tuple4.second = function(t) {
	return t.snd();
}
stx.Tuple4.third = function(t) {
	return t.thd();
}
stx.Tuple4.fourth = function(t) {
	return t.frt();
}
stx.Tuple4.patch = function(t0,t1) {
	var _1 = t1.fst() == null?t0.fst():t1.fst();
	var _2 = t1.snd() == null?t0.snd():t1.snd();
	var _3 = t1.thd() == null?t0.thd():t1.thd();
	var _4 = t1.frt() == null?t0.frt():t1.frt();
	return new stx.Tuple4(_1,_2,_3,_4);
}
stx.Tuple4.__super__ = stx.AbstractProduct;
stx.Tuple4.prototype = $extend(stx.AbstractProduct.prototype,{
	entuple: function(_5) {
		return new stx.Tuple5(this.fst(),this.snd(),this.thd(),this.frt(),_5);
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
	this.fst() = first;
	this.snd() = second;
	this.thd() = third;
	this.frt() = fourth;
	this.fth() = fifth;
};
stx.Tuple5.__name__ = ["stx","Tuple5"];
stx.Tuple5.into = function(t,f) {
	return f(t.fst(),t.snd(),t.thd(),t.frt(),t.fth());
}
stx.Tuple5.first = function(t) {
	return t.fst();
}
stx.Tuple5.second = function(t) {
	return t.snd();
}
stx.Tuple5.third = function(t) {
	return t.thd();
}
stx.Tuple5.fourth = function(t) {
	return t.frt();
}
stx.Tuple5.fifth = function(t) {
	return t.fth();
}
stx.Tuple5.patch = function(t0,t1) {
	var _1 = t1.fst() == null?t0.fst():t1.fst();
	var _2 = t1.snd() == null?t0.snd():t1.snd();
	var _3 = t1.thd() == null?t0.thd():t1.thd();
	var _4 = t1.frt() == null?t0.frt():t1.frt();
	var _5 = t1.fth() == null?t0.fth():t1.fth();
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
stx.Util = $hxClasses["stx.Util"] = function() { }
stx.Util.__name__ = ["stx","Util"];
stx.Util.printer = function(value,pos) {
	haxe.Log.trace(value,{ fileName : "Util.hx", lineNumber : 4, className : "stx.Util", methodName : "printer", customParams : [pos]});
	return value;
}
if(!stx.concurrent) stx.concurrent = {}
stx.concurrent.ActorStatus = $hxClasses["stx.concurrent.ActorStatus"] = { __ename__ : ["stx","concurrent","ActorStatus"], __constructs__ : ["Running","Stopped","Failed"] }
stx.concurrent.ActorStatus.Running = ["Running",0];
stx.concurrent.ActorStatus.Running.toString = $estr;
stx.concurrent.ActorStatus.Running.__enum__ = stx.concurrent.ActorStatus;
stx.concurrent.ActorStatus.Stopped = ["Stopped",1];
stx.concurrent.ActorStatus.Stopped.toString = $estr;
stx.concurrent.ActorStatus.Stopped.__enum__ = stx.concurrent.ActorStatus;
stx.concurrent.ActorStatus.Failed = ["Failed",2];
stx.concurrent.ActorStatus.Failed.toString = $estr;
stx.concurrent.ActorStatus.Failed.__enum__ = stx.concurrent.ActorStatus;
stx.concurrent.Actor = $hxClasses["stx.concurrent.Actor"] = function() { }
stx.concurrent.Actor.__name__ = ["stx","concurrent","Actor"];
stx.concurrent.Actor.prototype = {
	send: null
	,load: null
	,stop: null
	,start: null
	,status: null
	,__class__: stx.concurrent.Actor
}
stx.concurrent.ActorFactory = $hxClasses["stx.concurrent.ActorFactory"] = function() { }
stx.concurrent.ActorFactory.__name__ = ["stx","concurrent","ActorFactory"];
stx.concurrent.ActorFactory.prototype = {
	createStateless: null
	,create: null
	,__class__: stx.concurrent.ActorFactory
}
if(!stx.core) stx.core = {}
stx.core.Initializable = $hxClasses["stx.core.Initializable"] = function() { }
stx.core.Initializable.__name__ = ["stx","core","Initializable"];
stx.core.Initializable.prototype = {
	initialized: null
	,initialize: null
	,__class__: stx.core.Initializable
}
if(!stx.ds) stx.ds = {}
stx.ds.BinaryTree = $hxClasses["stx.ds.BinaryTree"] = { __ename__ : ["stx","ds","BinaryTree"], __constructs__ : ["Empty","Node"] }
stx.ds.BinaryTree.Empty = ["Empty",0];
stx.ds.BinaryTree.Empty.toString = $estr;
stx.ds.BinaryTree.Empty.__enum__ = stx.ds.BinaryTree;
stx.ds.BinaryTree.Node = function(el,left,right) { var $x = ["Node",1,el,left,right]; $x.__enum__ = stx.ds.BinaryTree; $x.toString = $estr; return $x; }
stx.ds.BinaryTrees = $hxClasses["stx.ds.BinaryTrees"] = function() { }
stx.ds.BinaryTrees.__name__ = ["stx","ds","BinaryTrees"];
stx.ds.BinaryTrees.tree = function(el,l,r) {
	l = l == null?stx.ds.BinaryTree.Empty:l;
	r = r == null?stx.ds.BinaryTree.Empty:r;
	return stx.ds.BinaryTree.Node(el,l,r);
}
stx.ds.BinaryTrees.inOrder = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = [];
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = stx.Arrays.append(stx.Arrays.add(stx.ds.BinaryTrees.inOrder(l),el),stx.ds.BinaryTrees.inOrder(r));
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.preOrder = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = [];
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = stx.Arrays.append(stx.Arrays.append([el],stx.ds.BinaryTrees.preOrder(l)),stx.ds.BinaryTrees.preOrder(r));
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.postOrder = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = [];
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = stx.Arrays.add(stx.Arrays.append(stx.ds.BinaryTrees.postOrder(l),stx.ds.BinaryTrees.postOrder(r)),el);
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.size = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = 0;
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = 1 + stx.ds.BinaryTrees.size(l) + stx.ds.BinaryTrees.size(r);
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.leafCount = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = 0;
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = l == stx.ds.BinaryTree.Empty && r == stx.ds.BinaryTree.Empty?1:stx.ds.BinaryTrees.leafCount(l) + stx.ds.BinaryTrees.leafCount(r);
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.leaves = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = [];
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = l == stx.ds.BinaryTree.Empty && r == stx.ds.BinaryTree.Empty?[el]:stx.Arrays.append(stx.ds.BinaryTrees.leaves(l),stx.ds.BinaryTrees.leaves(r));
			break;
		}
		return $r;
	}(this));
}
stx.ds.BinaryTrees.height = function(t) {
	return (function($this) {
		var $r;
		var $e = (t);
		switch( $e[1] ) {
		case 0:
			$r = 0;
			break;
		case 1:
			var r = $e[4], l = $e[3], el = $e[2];
			$r = 1 + (Math.max(stx.ds.BinaryTrees.height(l),stx.ds.BinaryTrees.height(r)) | 0);
			break;
		}
		return $r;
	}(this));
}
if(!stx.functional) stx.functional = {}
stx.functional.Foldable = $hxClasses["stx.functional.Foldable"] = function() { }
stx.functional.Foldable.__name__ = ["stx","functional","Foldable"];
stx.functional.Foldable.prototype = {
	foldl: null
	,append: null
	,empty: null
	,__class__: stx.functional.Foldable
}
stx.ds.Collection = $hxClasses["stx.ds.Collection"] = function() { }
stx.ds.Collection.__name__ = ["stx","ds","Collection"];
stx.ds.Collection.__interfaces__ = [stx.functional.Foldable];
stx.ds.Collection.prototype = {
	removeAll: null
	,remove: null
	,addAll: null
	,add: null
	,contains: null
	,size: null
	,__class__: stx.ds.Collection
}
stx.ds.Group = $hxClasses["stx.ds.Group"] = function() {
};
stx.ds.Group.__name__ = ["stx","ds","Group"];
stx.ds.Group.prototype = {
	__class__: stx.ds.Group
}
stx.ds.ArrayGroup = $hxClasses["stx.ds.ArrayGroup"] = function() { }
stx.ds.ArrayGroup.__name__ = ["stx","ds","ArrayGroup"];
stx.ds.ArrayGroup.groupBy = function(arr,grouper) {
	return ArrayLambda.foldl(arr,stx.ds.Map.create(),function(map,e) {
		var key = grouper(e);
		var result = map.getOrElse(key,function() {
			return [];
		});
		result.push(e);
		return map.set(key,result);
	});
}
stx.ds.IterableGroup = $hxClasses["stx.ds.IterableGroup"] = function() { }
stx.ds.IterableGroup.__name__ = ["stx","ds","IterableGroup"];
stx.ds.IterableGroup.groupBy = function(iter,grouper) {
	return stx.ds.ArrayGroup.groupBy(IterableLambda.toArray(iter),grouper);
}
stx.ds.FoldableGroup = $hxClasses["stx.ds.FoldableGroup"] = function() { }
stx.ds.FoldableGroup.__name__ = ["stx","ds","FoldableGroup"];
stx.ds.FoldableGroup.groupBy = function(foldable,grouper) {
	var def = foldable.empty();
	return foldable.foldl(stx.ds.Map.create(),function(map,e) {
		var key = grouper(e);
		var result = map.getOrElseC(key,def);
		return map.set(key,result.add(e));
	});
}
stx.ds.Input = $hxClasses["stx.ds.Input"] = { __ename__ : ["stx","ds","Input"], __constructs__ : ["El","Empty","EOF"] }
stx.ds.Input.El = function(e) { var $x = ["El",0,e]; $x.__enum__ = stx.ds.Input; $x.toString = $estr; return $x; }
stx.ds.Input.Empty = ["Empty",1];
stx.ds.Input.Empty.toString = $estr;
stx.ds.Input.Empty.__enum__ = stx.ds.Input;
stx.ds.Input.EOF = function(exception) { var $x = ["EOF",2,exception]; $x.__enum__ = stx.ds.Input; $x.toString = $estr; return $x; }
stx.ds.IterV = $hxClasses["stx.ds.IterV"] = { __ename__ : ["stx","ds","IterV"], __constructs__ : ["Done","Cont"] }
stx.ds.IterV.Done = function(a,e) { var $x = ["Done",0,a,e]; $x.__enum__ = stx.ds.IterV; $x.toString = $estr; return $x; }
stx.ds.IterV.Cont = function(k) { var $x = ["Cont",1,k]; $x.__enum__ = stx.ds.IterV; $x.toString = $estr; return $x; }
stx.ds.IterVs = $hxClasses["stx.ds.IterVs"] = function() { }
stx.ds.IterVs.__name__ = ["stx","ds","IterVs"];
stx.ds.IterVs.run = function(iter) {
	var $e = (iter);
	switch( $e[1] ) {
	case 0:
		var a = $e[2];
		return a;
	case 1:
		throw "Computation not finished";
		break;
	}
}
stx.ds.IterVs.drop = function(n) {
	var step = null;
	step = function(i) {
		return (function($this) {
			var $r;
			var $e = (i);
			switch( $e[1] ) {
			case 0:
				var e = $e[2];
				$r = stx.ds.IterVs.drop(n - 1);
				break;
			case 1:
				$r = stx.ds.IterV.Cont(step);
				break;
			case 2:
				var e = $e[2];
				$r = stx.ds.IterV.Done(null,stx.ds.Input.EOF(e));
				break;
			}
			return $r;
		}(this));
	};
	return n == 0?stx.ds.IterV.Done(null,stx.ds.Input.Empty):stx.ds.IterV.Cont(step);
}
stx.ds.IterVs.pump = function(s,iter) {
	return s.scanl(iter,function(it,x) {
		return (function($this) {
			var $r;
			var $e = (it);
			switch( $e[1] ) {
			case 0:
				var e = $e[3], a = $e[2];
				$r = stx.ds.IterV.Done(a,e);
				break;
			case 1:
				var k = $e[2];
				$r = k(x);
				break;
			}
			return $r;
		}(this));
	});
}
stx.ds.IterVs.flatMap = function(f1,f2) {
	return (function($this) {
		var $r;
		var $e = (f1);
		switch( $e[1] ) {
		case 0:
			var e = $e[3], x = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (f2(x));
				switch( $e[1] ) {
				case 0:
					var y = $e[2];
					$r = stx.ds.IterV.Done(y,e);
					break;
				case 1:
					var k = $e[2];
					$r = k(e);
					break;
				}
				return $r;
			}($this));
			break;
		case 1:
			var k = $e[2];
			$r = stx.ds.IterV.Cont(stx.Functions1.then(k,stx.Functions2.p2(stx.ds.IterVs.flatMap,f2)));
			break;
		}
		return $r;
	}(this));
}
stx.ds.Examples = $hxClasses["stx.ds.Examples"] = function() { }
stx.ds.Examples.__name__ = ["stx","ds","Examples"];
stx.ds.Examples.enumerate = function() {
	return function(arr,it) {
		var $e = (arr);
		switch( $e[1] ) {
		case 1:
			var $e = (it);
			switch( $e[1] ) {
			case 0:
				return it;
			case 1:
				var k = $e[2];
				return k(stx.ds.Input.EOF());
			}
			return it;
		case 0:
			var rest = $e[3], e = $e[2];
			var $e = (it);
			switch( $e[1] ) {
			case 0:
				return it;
			case 1:
				var k = $e[2];
				return (stx.ds.Examples.enumerate())(rest,k(stx.ds.Input.El(e)));
			}
			break;
		}
	};
}
stx.ds.Examples.counter = function() {
	return (function($this) {
		var $r;
		var step = (function($this) {
			var $r;
			var step1 = null;
			step1 = function(n) {
				return function(inp) {
					return (function($this) {
						var $r;
						var $e = (inp);
						switch( $e[1] ) {
						case 0:
							var x = $e[2];
							$r = stx.ds.IterV.Cont(step1(n + 1));
							break;
						case 1:
							$r = stx.ds.IterV.Cont(step1(n));
							break;
						case 2:
							var e = $e[2];
							$r = stx.ds.IterV.Done(n,stx.ds.Input.EOF(e));
							break;
						}
						return $r;
					}(this));
				};
			};
			$r = step1;
			return $r;
		}($this));
		$r = stx.ds.IterV.Cont(step(0));
		return $r;
	}(this));
}
stx.ds.Main = $hxClasses["stx.ds.Main"] = function() { }
stx.ds.Main.__name__ = ["stx","ds","Main"];
stx.ds.Main.main = function() {
	var list = stx.ds.LList.Cons(5,stx.ds.LList.Cons(7,stx.ds.LList.Cons(6,stx.ds.LList.Nil)));
	var iter = (stx.ds.Examples.enumerate())(list,stx.ds.Examples.counter());
	haxe.Log.trace("Result " + stx.ds.IterVs.run(iter),{ fileName : "Iteratee.hx", lineNumber : 104, className : "stx.ds.Main", methodName : "main"});
}
stx.ds.LList = $hxClasses["stx.ds.LList"] = { __ename__ : ["stx","ds","LList"], __constructs__ : ["Cons","Nil"] }
stx.ds.LList.Cons = function(e,t) { var $x = ["Cons",0,e,t]; $x.__enum__ = stx.ds.LList; $x.toString = $estr; return $x; }
stx.ds.LList.Nil = ["Nil",1];
stx.ds.LList.Nil.toString = $estr;
stx.ds.LList.Nil.__enum__ = stx.ds.LList;
stx.ds.ArrayToList = $hxClasses["stx.ds.ArrayToList"] = function() { }
stx.ds.ArrayToList.__name__ = ["stx","ds","ArrayToList"];
stx.ds.ArrayToList.toList = function(arr) {
	return stx.ds.List.create().addAll(arr);
}
stx.ds.FoldableToList = $hxClasses["stx.ds.FoldableToList"] = function() { }
stx.ds.FoldableToList.__name__ = ["stx","ds","FoldableToList"];
stx.ds.FoldableToList.toList = function(foldable) {
	var dest = stx.ds.List.create();
	return foldable.foldl(dest,function(a,b) {
		return a.add(b);
	});
}
stx.ds.List = $hxClasses["stx.ds.List"] = function(tools) {
	if(tools != null) {
		this._order = tools.order;
		this._equal = tools.equal;
		this._hash = tools.hash;
		this._show = tools.show;
	}
};
stx.ds.List.__name__ = ["stx","ds","List"];
stx.ds.List.__interfaces__ = [stx.ds.Collection];
stx.ds.List.toList = function(i) {
	return stx.ds.List.create().addAll(i);
}
stx.ds.List.nil = function(order,tools) {
	return new stx.ds._List.Nil(tools);
}
stx.ds.List.create = function(tools) {
	return stx.ds.List.nil(null,tools);
}
stx.ds.List.factory = function(tools) {
	return function() {
		return stx.ds.List.create(tools);
	};
}
stx.ds.List.prototype = {
	getTail: function() {
		return SCore.error("List has no head",{ fileName : "List.hx", lineNumber : 432, className : "stx.ds.List", methodName : "getTail"});
	}
	,getLastOption: function() {
		return stx.Option.None;
	}
	,getHeadOption: function() {
		return stx.Option.None;
	}
	,getLast: function() {
		return SCore.error("List has no last element",{ fileName : "List.hx", lineNumber : 420, className : "stx.ds.List", methodName : "getLast"});
	}
	,getHead: function() {
		return SCore.error("List has no head element",{ fileName : "List.hx", lineNumber : 416, className : "stx.ds.List", methodName : "getHead"});
	}
	,size: function() {
		return 0;
	}
	,toString: function() {
		return "List " + stx.ds.plus.ArrayShow.toStringWith(IterableLambda.toArray(this),this.getShow());
	}
	,hashCode: function() {
		var ha = this.getMap();
		return this.foldl(12289,function(a,b) {
			return a * (ha(b) + 12289);
		});
	}
	,compare: function(other) {
		return stx.ds.plus.ArrayOrder.compareWith(IterableLambda.toArray(this),IterableLambda.toArray(other),this.getOrder());
	}
	,equals: function(other) {
		return stx.ds.plus.ArrayEqual.equalsWith(IterableLambda.toArray(this),IterableLambda.toArray(other),this.getEqual());
	}
	,getShow: function() {
		return null == this._show?this.size() == 0?stx.ds.plus.Show.getShowFor(null):this._show = stx.ds.plus.Show.getShowFor(this.getHead()):this._show;
	}
	,getMap: function() {
		return null == this._hash?this.size() == 0?stx.ds.plus.Hasher.getMapFor(null):this._hash = stx.ds.plus.Hasher.getMapFor(this.getHead()):this._hash;
	}
	,getEqual: function() {
		return null == this._equal?this.size() == 0?stx.ds.plus.Equal.getEqualFor(null):this._equal = stx.ds.plus.Equal.getEqualFor(this.getHead()):this._equal;
	}
	,getOrder: function() {
		return null == this._order?this.size() == 0?stx.ds.plus.Order.getOrderFor(null):this._order = stx.ds.plus.Order.getOrderFor(this.getHead()):this._order;
	}
	,_show: null
	,_hash: null
	,_order: null
	,_equal: null
	,withShowFunction: function(show) {
		return stx.ds.List.create({ order : this._order, equal : this._equal, show : show, hash : this._hash}).addAll(this);
	}
	,withMapFunction: function(hash) {
		return stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : hash}).addAll(this);
	}
	,withEqualFunction: function(equal) {
		return stx.ds.List.create({ order : this._order, equal : equal, show : this._show, hash : this._hash}).addAll(this);
	}
	,withOrderFunction: function(order) {
		return stx.ds.List.create({ order : order, equal : this._equal, show : this._show, hash : this._hash}).addAll(this);
	}
	,iterator: function() {
		return $iterator(stx.functional.FoldableExtensions)(this);
	}
	,sort: function() {
		var a = IterableLambda.toArray(this);
		a.sort(this.getOrder());
		var result = stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : this._hash});
		var _g1 = 0, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			result = result.cons(a[a.length - 1 - i]);
		}
		return result;
	}
	,gaps: function(f,equal) {
		return stx.functional.FoldableExtensions.flatMapTo(this.zip(this.drop(1)),stx.ds.List.nil(null,{ order : null, equal : equal, show : null, hash : null}),function(tuple) {
			return f(tuple.fst(),tuple.snd());
		});
	}
	,zip: function(that) {
		var len = stx.Ints.min(this.size(),that.size());
		var iterator1 = this.reverse().drop(stx.Ints.max(0,this.size() - len)).iterator();
		var iterator2 = that.reverse().drop(stx.Ints.max(0,that.size() - len)).iterator();
		var r = stx.ds.List.create();
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			r = r.cons(new stx.Tuple2(iterator1.next(),iterator2.next()));
		}
		return r;
	}
	,reverse: function() {
		return this.foldl(stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : this._hash}),function(a,b) {
			return a.cons(b);
		});
	}
	,filter: function(f) {
		return this.foldr(stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : this._hash}),function(e,list) {
			return f(e)?list.cons(e):list;
		});
	}
	,flatMap: function(f) {
		return this.foldr(stx.ds.List.create(),function(e,list) {
			return list.prependAll(f(e));
		});
	}
	,map: function(f) {
		return this.foldr(stx.ds.List.create(),function(e,list) {
			return list.cons(f(e));
		});
	}
	,take: function(n) {
		return this.reverse().drop(this.size() - n);
	}
	,dropWhile: function(pred) {
		var cur = this;
		var _g1 = 0, _g = this.size();
		while(_g1 < _g) {
			var i = _g1++;
			if(pred(cur.getHead())) return cur;
			cur = cur.getTail();
		}
		return cur;
	}
	,drop: function(n) {
		var cur = this;
		var _g1 = 0, _g = stx.Ints.min(this.size(),n);
		while(_g1 < _g) {
			var i = _g1++;
			cur = cur.getTail();
		}
		return cur;
	}
	,concat: function(l) {
		return this.addAll(l);
	}
	,removeAll: function(i) {
		var r = this;
		var $it0 = $iterator(i)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			r = r.remove(e);
		}
		return r;
	}
	,remove: function(t) {
		var pre = [];
		var post = stx.ds.List.nil(null,{ order : this._order, equal : this._equal, show : this._show, hash : this._hash});
		var cur = this;
		var eq = this.getEqual();
		var _g1 = 0, _g = this.size();
		while(_g1 < _g) {
			var i = _g1++;
			if(eq(t,cur.getHead())) {
				post = cur.getTail();
				break;
			} else {
				pre.push(cur.getHead());
				cur = cur.getTail();
			}
		}
		pre.reverse();
		var result = post;
		var _g = 0;
		while(_g < pre.length) {
			var e = pre[_g];
			++_g;
			result = result.cons(e);
		}
		return result;
	}
	,addAll: function(i) {
		var a = [];
		var $it0 = $iterator(i)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			a.push(e);
		}
		a.reverse();
		var r = stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : this._hash});
		var _g = 0;
		while(_g < a.length) {
			var e = a[_g];
			++_g;
			r = r.cons(e);
		}
		return this.foldr(r,function(b,a1) {
			return a1.cons(b);
		});
	}
	,add: function(t) {
		return this.foldr(stx.ds.List.create({ order : this._order, equal : this._equal, show : this._show, hash : this._hash}).cons(t),function(b,a) {
			return a.cons(b);
		});
	}
	,contains: function(t) {
		var cur = this;
		var eq = this.getEqual();
		var _g1 = 0, _g = this.size();
		while(_g1 < _g) {
			var i = _g1++;
			if(eq(t,cur.getHead())) return true;
			cur = cur.getTail();
		}
		return false;
	}
	,foldr: function(z,f) {
		var a = IterableLambda.toArray(this);
		var acc = z;
		var _g1 = 0, _g = this.size();
		while(_g1 < _g) {
			var i = _g1++;
			var e = a[this.size() - 1 - i];
			acc = f(e,acc);
		}
		return acc;
	}
	,foldl: function(z,f) {
		var acc = z;
		var cur = this;
		var _g1 = 0, _g = this.size();
		while(_g1 < _g) {
			var i = _g1++;
			acc = f(acc,cur.getHead());
			cur = cur.getTail();
		}
		return acc;
	}
	,append: function(b) {
		return this.add(b);
	}
	,prependAllR: function(iterable) {
		var result = this;
		var $it0 = $iterator(iterable)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			result = result.cons(e);
		}
		return result;
	}
	,prependAll: function(iterable) {
		var result = this;
		var array = IterableLambda.toArray(iterable);
		array.reverse();
		var _g = 0;
		while(_g < array.length) {
			var e = array[_g];
			++_g;
			result = result.cons(e);
		}
		return result;
	}
	,prepend: function(head) {
		return this.cons(head);
	}
	,cons: function(head) {
		return new stx.ds._List.Cons({ order : this._order, equal : this._equal, show : this._show, hash : this._hash},head,this);
	}
	,empty: function() {
		return stx.ds.List.nil();
	}
	,show: null
	,hash: null
	,order: null
	,equal: null
	,lastOption: null
	,firstOption: null
	,headOption: null
	,last: null
	,first: null
	,tail: null
	,head: null
	,__class__: stx.ds.List
	,__properties__: {get_head:"getHead",get_tail:"getTail",get_first:"getHead",get_last:"getLast",get_headOption:"getHeadOption",get_firstOption:"getHeadOption",get_lastOption:"getLastOption",get_equal:"getEqual",get_order:"getOrder",get_hash:"getMap",get_show:"getShow"}
}
if(!stx.ds._List) stx.ds._List = {}
stx.ds._List.Cons = $hxClasses["stx.ds._List.Cons"] = function(tools,head,tail) {
	stx.ds.List.call(this,tools);
	this._head = head;
	this._tail = tail;
	this._size = tail.size() + 1;
};
stx.ds._List.Cons.__name__ = ["stx","ds","_List","Cons"];
stx.ds._List.Cons.__super__ = stx.ds.List;
stx.ds._List.Cons.prototype = $extend(stx.ds.List.prototype,{
	size: function() {
		return this._size;
	}
	,getLastOption: function() {
		return stx.Option.Some(this.getLast());
	}
	,getHeadOption: function() {
		return stx.Option.Some(this.getHead());
	}
	,getTail: function() {
		return this._tail;
	}
	,getLast: function() {
		var cur = this;
		var _g1 = 0, _g = this.size() - 1;
		while(_g1 < _g) {
			var i = _g1++;
			cur = cur.getTail();
		}
		return cur.getHead();
	}
	,getHead: function() {
		return this._head;
	}
	,_size: null
	,_tail: null
	,_head: null
	,__class__: stx.ds._List.Cons
});
stx.ds._List.Nil = $hxClasses["stx.ds._List.Nil"] = function(tools) {
	stx.ds.List.call(this,tools);
};
stx.ds._List.Nil.__name__ = ["stx","ds","_List","Nil"];
stx.ds._List.Nil.__super__ = stx.ds.List;
stx.ds._List.Nil.prototype = $extend(stx.ds.List.prototype,{
	__class__: stx.ds._List.Nil
});
stx.functional.PartialFunction1 = $hxClasses["stx.functional.PartialFunction1"] = function() { }
stx.functional.PartialFunction1.__name__ = ["stx","functional","PartialFunction1"];
stx.functional.PartialFunction1.prototype = {
	toFunction: null
	,call: null
	,orAlwaysC: null
	,orAlways: null
	,orElse: null
	,isDefinedAt: null
	,__class__: stx.functional.PartialFunction1
}
stx.ds.Map = $hxClasses["stx.ds.Map"] = function(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow,buckets,size) {
	var self = this;
	this._keyOrder = korder;
	this._keyEqual = kequal;
	this._keyMap = khash;
	this._keyShow = kshow;
	this._valueOrder = vorder;
	this._valueEqual = vequal;
	this._valueMap = vhash;
	this._valueShow = vshow;
	this._size = size;
	this._buckets = buckets;
	this._pf = stx.functional.PartialFunction1ImplExtensions.toPartialFunction([new stx.Tuple2($bind(this,this.containsKey),function(k) {
		return (function($this) {
			var $r;
			var $e = (self.get(k));
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				$r = v;
				break;
			case 0:
				$r = SCore.error("No value for this key",{ fileName : "Map.hx", lineNumber : 88, className : "stx.ds.Map", methodName : "new"});
				break;
			}
			return $r;
		}(this));
	})]);
};
stx.ds.Map.__name__ = ["stx","ds","Map"];
stx.ds.Map.__interfaces__ = [stx.functional.PartialFunction1,stx.ds.Collection];
stx.ds.Map.create = function(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow) {
	return new stx.ds.Map(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow,[[]],0);
}
stx.ds.Map.factory = function(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow) {
	return function() {
		return stx.ds.Map.create(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow);
	};
}
stx.ds.Map.prototype = {
	getValueShow: function() {
		return null == this._valueShow?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Show.getShowFor(null):$this._valueShow = stx.ds.plus.Show.getShowFor(it.next().snd());
			return $r;
		}(this)):this._valueShow;
	}
	,getValueMap: function() {
		return null == this._valueMap?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Hasher.getMapFor(null):$this._valueMap = stx.ds.plus.Hasher.getMapFor(it.next().snd());
			return $r;
		}(this)):this._valueMap;
	}
	,getValueEqual: function() {
		return null == this._valueEqual?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Equal.getEqualFor(null):$this._valueEqual = stx.ds.plus.Equal.getEqualFor(it.next().snd());
			return $r;
		}(this)):this._valueEqual;
	}
	,getValueOrder: function() {
		return null == this._valueOrder?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Order.getOrderFor(null):$this._valueOrder = stx.ds.plus.Order.getOrderFor(it.next().snd());
			return $r;
		}(this)):this._valueOrder;
	}
	,getKeyShow: function() {
		return null == this._keyShow?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Show.getShowFor(null):$this._keyShow = stx.ds.plus.Show.getShowFor(it.next().fst());
			return $r;
		}(this)):this._keyShow;
	}
	,getKeyMap: function() {
		return null == this._keyMap?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Hasher.getMapFor(null):$this._keyMap = stx.ds.plus.Hasher.getMapFor(it.next().fst());
			return $r;
		}(this)):this._keyMap;
	}
	,getKeyEqual: function() {
		return null == this._keyEqual?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Equal.getEqualFor(null):$this._keyEqual = stx.ds.plus.Equal.getEqualFor(it.next().fst());
			return $r;
		}(this)):this._keyEqual;
	}
	,getKeyOrder: function() {
		return null == this._keyOrder?(function($this) {
			var $r;
			var it = $this.iterator();
			$r = !it.hasNext()?stx.ds.plus.Order.getOrderFor(null):$this._keyOrder = stx.ds.plus.Order.getOrderFor(it.next().fst());
			return $r;
		}(this)):this._keyOrder;
	}
	,_valueShow: null
	,_valueMap: null
	,_valueOrder: null
	,_valueEqual: null
	,_keyShow: null
	,_keyMap: null
	,_keyOrder: null
	,_keyEqual: null
	,size: function() {
		return this._size;
	}
	,listFor: function(k) {
		return this._buckets.length == 0?[]:this._buckets[this.bucketFor(k)];
	}
	,bucketFor: function(k) {
		return (this.getKeyMap())(k) % this._buckets.length;
	}
	,rebalance: function() {
		var newSize = Math.round(this.size() / ((stx.ds.Map.MaxLoad + stx.ds.Map.MinLoad) / 2));
		if(newSize > 0) {
			var all = this.entries();
			this._buckets = [];
			var _g = 0;
			while(_g < newSize) {
				var i = _g++;
				this._buckets.push([]);
			}
			var $it0 = $iterator(all)();
			while( $it0.hasNext() ) {
				var e = $it0.next();
				var bucket = this.bucketFor(e.fst());
				this._buckets[bucket].push(e);
			}
		}
	}
	,copyWithMod: function(index) {
		var newTable = [];
		var _g = 0;
		while(_g < index) {
			var i = _g++;
			newTable.push(this._buckets[i]);
		}
		newTable.push([].concat(this._buckets[index]));
		var _g1 = index + 1, _g = this._buckets.length;
		while(_g1 < _g) {
			var i = _g1++;
			newTable.push(this._buckets[i]);
		}
		return new stx.ds.Map(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow,this._valueOrder,this._valueEqual,this._valueMap,this._valueShow,newTable,this.size());
	}
	,removeInternal: function(k,v,ignoreValue) {
		var bucket = this.bucketFor(k);
		var list = this._buckets[bucket];
		var ke = this.getKeyEqual();
		var ve = this.getValueEqual();
		var _g1 = 0, _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var entry = list[i];
			if(ke(entry.fst(),k)) {
				if(ignoreValue || ve(entry.snd(),v)) {
					var newMap = this.copyWithMod(bucket);
					newMap._buckets[bucket] = list.slice(0,i).concat(list.slice(i + 1,list.length));
					newMap._size -= 1;
					if(newMap.load() < stx.ds.Map.MinLoad) newMap.rebalance();
					return newMap;
				} else return this;
			}
		}
		return this;
	}
	,entries: function() {
		var buckets = this._buckets;
		var iterable = { iterator : function() {
			var bucket = 0, element = 0;
			var computeNextValue = function() {
				while(bucket < buckets.length) if(element >= buckets[bucket].length) {
					element = 0;
					++bucket;
				} else return stx.Option.Some(buckets[bucket][element++]);
				return stx.Option.None;
			};
			var nextValue = computeNextValue();
			return { hasNext : function() {
				return !stx.Options.isEmpty(nextValue);
			}, next : function() {
				var value = nextValue;
				nextValue = computeNextValue();
				return stx.Options.get(value);
			}};
		}};
		return iterable;
	}
	,withValueShowFunction: function(show) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow,this._valueOrder,this._valueEqual,this._valueMap,show).addAll(this);
	}
	,withValueMapFunction: function(hash) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow,this._valueOrder,this._valueEqual,hash,this._valueShow).addAll(this);
	}
	,withValueEqualFunction: function(equal) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow,this._valueOrder,equal,this._valueMap,this._valueShow).addAll(this);
	}
	,withValueOrderFunction: function(order) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow,order,this._valueEqual,this._valueMap,this._valueShow).addAll(this);
	}
	,withKeyShowFunction: function(show) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,this._keyMap,show,this._valueOrder,this._valueEqual,this._valueMap,this._valueShow).addAll(this);
	}
	,withKeyMapFunction: function(hash) {
		return stx.ds.Map.create(this._keyOrder,this._keyEqual,hash,this._keyShow,this._valueOrder,this._valueEqual,this._valueMap,this._valueShow).addAll(this);
	}
	,withKeyEqualFunction: function(equal) {
		return stx.ds.Map.create(this._keyOrder,equal,this._keyMap,this._keyShow,this._valueOrder,this._valueEqual,this._valueMap,this._valueShow).addAll(this);
	}
	,withKeyOrderFunction: function(order) {
		return stx.ds.Map.create(order,this._keyEqual,this._keyMap,this._keyShow,this._valueOrder,this._valueEqual,this._valueMap,this._valueShow).addAll(this);
	}
	,load: function() {
		return this._buckets.length == 0?stx.ds.Map.MaxLoad:Math.round(this.size() / this._buckets.length);
	}
	,hashCode: function() {
		var kha = this.getKeyMap();
		var vha = this.getValueMap();
		return this.foldl(786433,function(a,b) {
			return a + (kha(b.fst()) * 49157 + 6151) * vha(b.snd());
		});
	}
	,toString: function() {
		var ksh = this.getKeyShow();
		var vsh = this.getValueShow();
		return "Map " + stx.ds.plus.IterableShow.toString(stx.Iterables.elements(this),function(t) {
			return ksh(t.fst()) + " -> " + vsh(t.snd());
		});
	}
	,equals: function(other) {
		var keys1 = this.keySet();
		var keys2 = other.keySet();
		if(!keys1.equals(keys2)) return false;
		var ve = this.getValueEqual();
		var $it0 = keys1.iterator();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			var v1 = stx.Options.get(this.get(key));
			var v2 = stx.Options.get(other.get(key));
			if(!ve(v1,v2)) return false;
		}
		return true;
	}
	,compare: function(other) {
		var a1 = IterableLambda.toArray(this);
		var a2 = IterableLambda.toArray(other);
		var ko = this.getKeyOrder();
		var vo = this.getValueOrder();
		var sorter = function(t1,t2) {
			var c = ko(t1.fst(),t2.fst());
			return c != 0?c:vo(t1.snd(),t2.snd());
		};
		a1.sort(sorter);
		a2.sort(sorter);
		return stx.ds.plus.ArrayOrder.compare(a1,a2);
	}
	,iterator: function() {
		return $iterator(stx.functional.FoldableExtensions)(this);
	}
	,values: function() {
		var self = this;
		return { iterator : function() {
			var entryIterator = $iterator(self.entries())();
			return { hasNext : $bind(entryIterator,entryIterator.hasNext), next : function() {
				return entryIterator.next().snd();
			}};
		}};
	}
	,keySet: function() {
		return stx.ds.Set.create(this._keyOrder,this._keyEqual,this._keyMap,this._keyShow).addAll(this.keys());
	}
	,keys: function() {
		var self = this;
		return { iterator : function() {
			var entryIterator = $iterator(self.entries())();
			return { hasNext : $bind(entryIterator,entryIterator.hasNext), next : function() {
				return entryIterator.next().fst();
			}};
		}};
	}
	,containsKey: function(k) {
		return (function($this) {
			var $r;
			var $e = ($this.get(k));
			switch( $e[1] ) {
			case 0:
				$r = false;
				break;
			case 1:
				var v = $e[2];
				$r = true;
				break;
			}
			return $r;
		}(this));
	}
	,contains: function(t) {
		var ke = this.getKeyEqual();
		var ve = this.getValueEqual();
		var $it0 = $iterator(this.entries())();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			if(ke(e.fst(),t.fst()) && ve(t.snd(),t.snd())) return true;
		}
		return false;
	}
	,getOrElseC: function(k,c) {
		return (function($this) {
			var $r;
			var $e = ($this.get(k));
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				$r = v;
				break;
			case 0:
				$r = c;
				break;
			}
			return $r;
		}(this));
	}
	,getOrElse: function(k,def) {
		return (function($this) {
			var $r;
			var $e = ($this.get(k));
			switch( $e[1] ) {
			case 1:
				var v = $e[2];
				$r = v;
				break;
			case 0:
				$r = def();
				break;
			}
			return $r;
		}(this));
	}
	,get: function(k) {
		var ke = this.getKeyEqual();
		var _g = 0, _g1 = this.listFor(k);
		while(_g < _g1.length) {
			var e = _g1[_g];
			++_g;
			if(ke(e.fst(),k)) return stx.Option.Some(e.snd());
		}
		return stx.Option.None;
	}
	,removeAllByKey: function(i) {
		var map = this;
		var $it0 = $iterator(i)();
		while( $it0.hasNext() ) {
			var k = $it0.next();
			map = map.removeByKey(k);
		}
		return map;
	}
	,removeByKey: function(k) {
		return this.removeInternal(k,null,true);
	}
	,removeAll: function(i) {
		var map = this;
		var $it0 = $iterator(i)();
		while( $it0.hasNext() ) {
			var t = $it0.next();
			map = map.remove(t);
		}
		return map;
	}
	,remove: function(t) {
		return this.removeInternal(t.fst(),t.snd(),false);
	}
	,addAll: function(i) {
		var map = this;
		var $it0 = $iterator(i)();
		while( $it0.hasNext() ) {
			var t = $it0.next();
			map = map.add(t);
		}
		return map;
	}
	,add: function(t) {
		var k = t.fst();
		var v = t.snd();
		var bucket = this.bucketFor(k);
		var list = this._buckets[bucket];
		if(null == this._keyEqual) this._keyEqual = stx.ds.plus.Equal.getEqualFor(t.fst());
		if(null == this._valueEqual) this._valueEqual = stx.ds.plus.Equal.getEqualFor(t.snd());
		var _g1 = 0, _g = list.length;
		while(_g1 < _g) {
			var i = _g1++;
			var entry = list[i];
			if(this._keyEqual(entry.fst(),k)) {
				if(!this._valueEqual(entry.snd(),v)) {
					var newMap = this.copyWithMod(bucket);
					newMap._buckets[bucket][i] = t;
					return newMap;
				} else return this;
			}
		}
		var newMap = this.copyWithMod(bucket);
		newMap._buckets[bucket].push(t);
		newMap._size += 1;
		if(newMap.load() > stx.ds.Map.MaxLoad) newMap.rebalance();
		return newMap;
	}
	,set: function(k,v) {
		return this.add(new stx.Tuple2(k,v));
	}
	,foldl: function(z,f) {
		var acc = z;
		var $it0 = $iterator(this.entries())();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			acc = f(acc,e);
		}
		return acc;
	}
	,append: function(t) {
		return this.add(t);
	}
	,empty: function() {
		return stx.ds.Map.create();
	}
	,toFunction: function() {
		return $bind(this,this.get);
	}
	,call: function(k) {
		return this._pf.call(k);
	}
	,orAlwaysC: function(v) {
		return this._pf.orAlwaysC(v);
	}
	,orAlways: function(f) {
		return this._pf.orAlways(f);
	}
	,orElse: function(that) {
		return this._pf.orElse(that);
	}
	,isDefinedAt: function(k) {
		return this._pf.isDefinedAt(k);
	}
	,_pf: null
	,_size: null
	,_buckets: null
	,valueShow: null
	,valueMap: null
	,valueOrder: null
	,valueEqual: null
	,keyShow: null
	,keyMap: null
	,keyOrder: null
	,keyEqual: null
	,__class__: stx.ds.Map
	,__properties__: {get_keyEqual:"getKeyEqual",get_keyOrder:"getKeyOrder",get_keyMap:"getKeyMap",get_keyShow:"getKeyShow",get_valueEqual:"getValueEqual",get_valueOrder:"getValueOrder",get_valueMap:"getValueMap",get_valueShow:"getValueShow"}
}
stx.ds.IterableToMap = $hxClasses["stx.ds.IterableToMap"] = function() { }
stx.ds.IterableToMap.__name__ = ["stx","ds","IterableToMap"];
stx.ds.IterableToMap.toMap = function(i) {
	return stx.ds.Map.create().addAll(i);
}
stx.ds.FoldableToMap = $hxClasses["stx.ds.FoldableToMap"] = function() { }
stx.ds.FoldableToMap.__name__ = ["stx","ds","FoldableToMap"];
stx.ds.FoldableToMap.toMap = function(foldable) {
	var dest = stx.ds.Map.create();
	return foldable.foldl(dest,function(a,b) {
		return a.add(b);
	});
}
stx.ds.ArrayToMap = $hxClasses["stx.ds.ArrayToMap"] = function() { }
stx.ds.ArrayToMap.__name__ = ["stx","ds","ArrayToMap"];
stx.ds.ArrayToMap.toMap = function(arr) {
	return stx.ds.Map.create().addAll(arr);
}
stx.ds.MapExtensions = $hxClasses["stx.ds.MapExtensions"] = function() { }
stx.ds.MapExtensions.__name__ = ["stx","ds","MapExtensions"];
stx.ds.MapExtensions.toObject = function(map) {
	return map.foldl({ },function(object,tuple) {
		object[tuple.fst()] = tuple.snd();
		return object;
	});
}
stx.ds.MapExtensions.toMap = function(d) {
	var map = stx.ds.Map.create();
	var _g = 0, _g1 = Reflect.fields(d);
	while(_g < _g1.length) {
		var field = _g1[_g];
		++_g;
		var value = Reflect.field(d,field);
		map = map.set(field,value);
	}
	return map;
}
stx.ds.Range = $hxClasses["stx.ds.Range"] = function(trange) {
	if(trange != null) {
		this.min = trange.min;
		this.max = trange.max;
	} else {
		this.min = stx.ds.Range.MIN;
		this.max = stx.ds.Range.MAX;
	}
};
stx.ds.Range.__name__ = ["stx","ds","Range"];
stx.ds.Range.create = function(min,max) {
	if(min == null) min = stx.ds.Range.MIN;
	if(max == null) max = stx.ds.Range.MAX;
	return new stx.ds.Range({ min : min, max : max});
}
stx.ds.Range.prototype = {
	toString: function() {
		var tname = Type.getClassName(Type.getClass(this));
		return "" + tname + "(min:" + Std.string(this.min) + ",max:" + Std.string(this.max) + ")";
	}
	,delta: function() {
		return this.max - this.min;
	}
	,inside: function(v1) {
		return this.min > v1.min && this.max < v1.max;
	}
	,within: function(n) {
		return n > this.min && n < this.max;
	}
	,overlap: function(v1) {
		return this.max > v1.min && v1.max > this.min;
	}
	,equals: function(v1) {
		return this.min == v1.min && this.max == v1.max;
	}
	,max: null
	,min: null
	,__class__: stx.ds.Range
}
stx.ds.FoldableToSet = $hxClasses["stx.ds.FoldableToSet"] = function() { }
stx.ds.FoldableToSet.__name__ = ["stx","ds","FoldableToSet"];
stx.ds.FoldableToSet.toSet = function(foldable) {
	var dest = stx.ds.Set.create();
	return foldable.foldl(dest,function(a,b) {
		return a.add(b);
	});
}
stx.ds.ArrayToSet = $hxClasses["stx.ds.ArrayToSet"] = function() { }
stx.ds.ArrayToSet.__name__ = ["stx","ds","ArrayToSet"];
stx.ds.ArrayToSet.toSet = function(arr) {
	return stx.ds.Set.create().addAll(arr);
}
stx.ds.Set = $hxClasses["stx.ds.Set"] = function(map) {
	this._map = map;
};
stx.ds.Set.__name__ = ["stx","ds","Set"];
stx.ds.Set.__interfaces__ = [stx.ds.Collection];
stx.ds.Set.toSet = function(i) {
	return stx.ds.Set.create().addAll(i);
}
stx.ds.Set.create = function(order,equal,hash,show) {
	return new stx.ds.Set(stx.ds.Map.create(order,equal,hash,show));
}
stx.ds.Set.factory = function(order,equal,hash,show) {
	return function() {
		return stx.ds.Set.create(order,equal,hash,show);
	};
}
stx.ds.Set.prototype = {
	getShow: function() {
		return this._map.getKeyShow();
	}
	,getMap: function() {
		return this._map.getKeyMap();
	}
	,getEqual: function() {
		return this._map.getKeyEqual();
	}
	,getOrder: function() {
		return this._map.getKeyOrder();
	}
	,size: function() {
		return this._map.size();
	}
	,copyWithMod: function(newMap) {
		return new stx.ds.Set(newMap);
	}
	,withShowFunction: function(show) {
		var m = this._map;
		return stx.ds.Set.create(m._keyOrder,m._keyEqual,m._keyMap,show).addAll(this);
	}
	,withMapFunction: function(hash) {
		var m = this._map;
		return stx.ds.Set.create(m._keyOrder,m._keyEqual,hash,m._keyShow).addAll(this);
	}
	,withEqualFunction: function(equal) {
		var m = this._map;
		return stx.ds.Set.create(m._keyOrder,equal,m._keyMap,m._keyShow).addAll(this);
	}
	,withOrderFunction: function(order) {
		var m = this._map;
		return stx.ds.Set.create(order,m._keyEqual,m._keyMap,m._keyShow).addAll(this);
	}
	,toString: function() {
		return "Set " + stx.ds.plus.ArrayShow.toStringWith(IterableLambda.toArray(this),this.getShow());
	}
	,hashCode: function() {
		var ha = this.getMap();
		return this.foldl(393241,function(a,b) {
			return a * (ha(b) + 6151);
		});
	}
	,compare: function(other) {
		return stx.ds.plus.ArrayOrder.compareWith(IterableLambda.toArray(this),IterableLambda.toArray(other),this.getOrder());
	}
	,equals: function(other) {
		var all = stx.functional.FoldableExtensions.concat(this,other);
		return all.size() == this.size() && all.size() == other.size();
	}
	,iterator: function() {
		return $iterator(stx.functional.FoldableExtensions)(this);
	}
	,removeAll: function(it) {
		var set = this;
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			set = set.remove(e);
		}
		return set;
	}
	,remove: function(t) {
		return this.copyWithMod(this._map.removeByKey(t));
	}
	,addAll: function(it) {
		var set = this;
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			set = set.add(e);
		}
		return set;
	}
	,add: function(t) {
		return this.contains(t)?this:this.copyWithMod(this._map.set(t,t));
	}
	,foldl: function(z,f) {
		var acc = z;
		var $it0 = this._map.iterator();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			acc = f(acc,e.fst());
		}
		return acc;
	}
	,append: function(t) {
		return this.copyWithMod(this._map.set(t,t));
	}
	,empty: function() {
		return stx.ds.Set.create();
	}
	,contains: function(e) {
		return this._map.containsKey(e);
	}
	,_map: null
	,show: null
	,hash: null
	,order: null
	,equal: null
	,__class__: stx.ds.Set
	,__properties__: {get_equal:"getEqual",get_order:"getOrder",get_hash:"getMap",get_show:"getShow"}
}
stx.ds.Zipper = $hxClasses["stx.ds.Zipper"] = function(v,c,p) {
	this.data = v;
	this.path = p;
	this.current = p == null?v:c;
	this.path = this.path == null?[]:this.path;
};
stx.ds.Zipper.__name__ = ["stx","ds","Zipper"];
stx.ds.Zipper.zipper = function(v) {
	return new stx.ds.Zipper(v);
}
stx.ds.Zipper.prototype = {
	get: function() {
		return this.current;
	}
	,up: function() {
		var s = stx.Arrays.take(this.path,this.path.length - 2);
		var p = ArrayLambda.foldl(s,this.data,function(value,func) {
			return func(value);
		});
		return new stx.ds.Zipper(this.data,p,s);
	}
	,flatMap: function() {
	}
	,map: function(f) {
		var o = f(this.current);
		return new stx.ds.Zipper(this.data,o,stx.Arrays.add(this.path,f));
	}
	,root: function() {
		return new stx.ds.Zipper(this.data);
	}
	,current: null
	,path: null
	,data: null
	,__class__: stx.ds.Zipper
}
stx.ds.Zippers = $hxClasses["stx.ds.Zippers"] = function() { }
stx.ds.Zippers.__name__ = ["stx","ds","Zippers"];
stx.ds.Zippers.get = function(z) {
	return z.get();
}
stx.ds.EnumZipper = $hxClasses["stx.ds.EnumZipper"] = function() { }
stx.ds.EnumZipper.__name__ = ["stx","ds","EnumZipper"];
stx.ds.EnumZipper.param = function(z,index) {
	var n = z.current.slice(2)[index];
	var f = function(x) {
		return x.slice(2)[index];
	};
	return z.map(f);
}
stx.ds.ObjectZipper = $hxClasses["stx.ds.ObjectZipper"] = function() { }
stx.ds.ObjectZipper.__name__ = ["stx","ds","ObjectZipper"];
stx.ds.ObjectZipper.field = function(z,field) {
	var f = function(x) {
		return new stx.Tuple2(field,Reflect.field(x,field));
	};
	return z.map(f);
}
stx.ds.ObjectZipper.spawn = function(z) {
	var obj = z.get();
	return ArrayLambda.map(Reflect.fields(obj),(function(_e) {
		return function(field) {
			return Reflect.field(_e,field);
		};
	})(z));
}
stx.ds.MapZipper = $hxClasses["stx.ds.MapZipper"] = function() { }
stx.ds.MapZipper.__name__ = ["stx","ds","MapZipper"];
stx.ds.MapZipper.key = function(z,field) {
	var f = function(x) {
		return new stx.Tuple2(field,x.get(field));
	};
	return z.map(f);
}
stx.ds.MapZipper.spawn = function(z) {
	var obj = z.get();
	return ArrayLambda.map(IterableLambda.toArray(IterableLambda.toIterable(obj.keys())),(function(_e) {
		return function(field) {
			return stx.ds.MapZipper.key(_e,field);
		};
	})(z));
}
stx.ds.ArrayZipper = $hxClasses["stx.ds.ArrayZipper"] = function() { }
stx.ds.ArrayZipper.__name__ = ["stx","ds","ArrayZipper"];
stx.ds.ArrayZipper.index = function(z,index) {
	var f = function(x) {
		return new stx.Tuple2(index,x[index]);
	};
	return z.map(f);
}
stx.ds.ArrayZipper.spawn = function(z) {
	var obj = z.get();
	return ArrayLambda.map(IterableLambda.toArray(IntIterators.until(0,obj.length)),(function(_e) {
		return function(index) {
			return stx.ds.ArrayZipper.index(_e,index);
		};
	})(z));
}
if(!stx.ds.plus) stx.ds.plus = {}
stx.ds.plus.Equal = $hxClasses["stx.ds.plus.Equal"] = function() { }
stx.ds.plus.Equal.__name__ = ["stx","ds","plus","Equal"];
stx.ds.plus.Equal.getEqualFor = function(t) {
	return stx.ds.plus.Equal.getEqualForType(Type["typeof"](t));
}
stx.ds.plus.Equal.getEqualForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.ds.plus.Equal._createEqualImpl(stx.Bools.equals);
			break;
		case 1:
			$r = stx.ds.plus.Equal._createEqualImpl(stx.Ints.equals);
			break;
		case 2:
			$r = stx.ds.plus.Equal._createEqualImpl(stx.Floats.equals);
			break;
		case 8:
			$r = function(a,b) {
				return a == b;
			};
			break;
		case 4:
			$r = stx.ds.plus.Equal._createEqualImpl(function(a,b) {
				var _g = 0, _g1 = Reflect.fields(a);
				while(_g < _g1.length) {
					var key = _g1[_g];
					++_g;
					var va = Reflect.field(a,key);
					if(!(stx.ds.plus.Equal.getEqualFor(va))(va,Reflect.field(b,key))) return false;
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
					$r = stx.ds.plus.Equal._createEqualImpl(stx.Strings.equals);
					break;
				case "Date":
					$r = stx.ds.plus.Equal._createEqualImpl(stx.Dates.equals);
					break;
				case "Array":
					$r = stx.ds.plus.Equal._createEqualImpl(stx.ds.plus.ArrayEqual.equals);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.ds.plus.Equal._createEqualImpl(stx.ds.plus.ProductEqual.equals);
					break;
				default:
					$r = stx.ds.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var fields = stx.ds.plus.Meta._fieldsWithMeta(c,"equalMap");
						$r = stx.ds.plus.Equal._createEqualImpl(function(a,b) {
							var values = ArrayLambda.map(fields,function(v1) {
								return new stx.Tuple2(Reflect.field(a,v1),Reflect.field(b,v1));
							});
							var _g = 0;
							while(_g < values.length) {
								var value = values[_g];
								++_g;
								if(Reflect.isFunction(value.fst())) continue;
								if(!(stx.ds.plus.Equal.getEqualFor(value.fst()))(value.fst(),value.snd())) return false;
							}
							return true;
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"equals")?stx.ds.plus.Equal._createEqualImpl(function(a,b) {
						return a.equals(b);
					}):SCore.error("class " + Type.getClassName(c) + " has no equals method",{ fileName : "Equal.hx", lineNumber : 73, className : "stx.ds.plus.Equal", methodName : "getEqualForType"});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.ds.plus.Equal._createEqualImpl(function(a,b) {
				if(0 != a[1] - b[1]) return false;
				var pa = a.slice(2);
				var pb = b.slice(2);
				var _g1 = 0, _g = pa.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(!(stx.ds.plus.Equal.getEqualFor(pa[i]))(pa[i],pb[i])) return false;
				}
				return true;
			});
			break;
		case 0:
			$r = stx.ds.plus.Equal._createEqualImpl(function(a,b) {
				return SCore.error("at least one of the arguments should be null",{ fileName : "Equal.hx", lineNumber : 89, className : "stx.ds.plus.Equal", methodName : "getEqualForType"});
			});
			break;
		case 5:
			$r = stx.ds.plus.Equal._createEqualImpl(Reflect.compareMethods);
			break;
		}
		return $r;
	}(this));
}
stx.ds.plus.Equal._createEqualImpl = function(impl) {
	return function(a,b) {
		return a == b || a == null && b == null?true:a == null || b == null?false:impl(a,b);
	};
}
stx.ds.plus.ArrayEqual = $hxClasses["stx.ds.plus.ArrayEqual"] = function() { }
stx.ds.plus.ArrayEqual.__name__ = ["stx","ds","plus","ArrayEqual"];
stx.ds.plus.ArrayEqual.equals = function(v1,v2) {
	return stx.ds.plus.ArrayEqual.equalsWith(v1,v2,stx.ds.plus.Equal.getEqualFor(v1[0]));
}
stx.ds.plus.ArrayEqual.equalsWith = function(v1,v2,equal) {
	if(v1.length != v2.length) return false;
	if(v1.length == 0) return true;
	var _g1 = 0, _g = v1.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(!equal(v1[i],v2[i])) return false;
	}
	return true;
}
stx.ds.plus.ProductEqual = $hxClasses["stx.ds.plus.ProductEqual"] = function() { }
stx.ds.plus.ProductEqual.__name__ = ["stx","ds","plus","ProductEqual"];
stx.ds.plus.ProductEqual.getEqualForEqual = function(p,i) {
	return stx.ds.plus.Equal.getEqualFor(p.element(i));
}
stx.ds.plus.ProductEqual.productEquals = function(p,other) {
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		if(!(stx.ds.plus.ProductEqual.getEqualForEqual(p,i))(p.element(i),other.element(i))) return false;
	}
	return true;
}
stx.ds.plus.ProductEqual.equals = function(p,other) {
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		if(!(stx.ds.plus.ProductEqual.getEqualForEqual(p,i))(p.element(i),other.element(i))) return false;
	}
	return true;
}
stx.ds.plus.Hasher = $hxClasses["stx.ds.plus.Hasher"] = function() { }
stx.ds.plus.Hasher.__name__ = ["stx","ds","plus","Hasher"];
stx.ds.plus.Hasher._createMapImpl = function(impl) {
	return function(v) {
		if(null == v) return 0; else return impl(v);
	};
}
stx.ds.plus.Hasher.getMapFor = function(t) {
	return stx.ds.plus.Hasher.getMapForType(Type["typeof"](t));
}
stx.ds.plus.Hasher.getMapForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.BoolHasher.hashCode);
			break;
		case 1:
			$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.IntHasher.hashCode);
			break;
		case 2:
			$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.FloatHasher.hashCode);
			break;
		case 8:
			$r = stx.ds.plus.Hasher._createMapImpl(function(v1) {
				return SCore.error("can't retrieve hascode for TUnknown: " + Std.string(v1),{ fileName : "Hasher.hx", lineNumber : 36, className : "stx.ds.plus.Hasher", methodName : "getMapForType"});
			});
			break;
		case 4:
			$r = stx.ds.plus.Hasher._createMapImpl(function(v1) {
				var s = (stx.ds.plus.Show.getShowFor(v1))(v1);
				return (stx.ds.plus.Hasher.getMapFor(s))(s);
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.StringHasher.hashCode);
					break;
				case "Date":
					$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.DateHasher.hashCode);
					break;
				case "Array":
					$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.ArrayHasher.hashCode);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.ds.plus.Hasher._createMapImpl(stx.ds.plus.ProductHasher.hashCode);
					break;
				default:
					$r = (function($this) {
						var $r;
						var fields = Type.getInstanceFields(c);
						$r = stx.ds.plus.Meta._hasMetaDataClass(c)?(function($this) {
							var $r;
							var fields1 = stx.ds.plus.Meta._fieldsWithMeta(c,"equalMap");
							$r = stx.ds.plus.Hasher._createMapImpl(function(v1) {
								var className = Type.getClassName(c);
								var values = ArrayLambda.filter(ArrayLambda.map(fields1,function(f) {
									return Reflect.field(v1,f);
								}),function(v2) {
									return !Reflect.isFunction(v2);
								});
								return ArrayLambda.foldl(values,9901 * stx.ds.plus.StringHasher.hashCode(className),function(v2,e) {
									return v2 + 333667 * ((stx.ds.plus.Hasher.getMapFor(e))(e) + 197192);
								});
							});
							return $r;
						}($this)):HxOverrides.remove(Type.getInstanceFields(c),"hashCode")?stx.ds.plus.Hasher._createMapImpl(function(v1) {
							return Reflect.field(v1,"hashCode").apply(v1,[]);
						}):SCore.error("class does not have a hashCode method",{ fileName : "Hasher.hx", lineNumber : 64, className : "stx.ds.plus.Hasher", methodName : "getMapForType"});
						return $r;
					}($this));
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.ds.plus.Hasher._createMapImpl(function(v1) {
				var hash = stx.ds.plus.StringHasher.hashCode(v1[0]) * 6151;
				var _g = 0, _g1 = v1.slice(2);
				while(_g < _g1.length) {
					var i = _g1[_g];
					++_g;
					hash += (stx.ds.plus.Hasher.getMapFor(i))(i) * 6151;
				}
				return hash;
			});
			break;
		case 5:
			$r = stx.ds.plus.Hasher._createMapImpl(function(v1) {
				return SCore.error("function can't provide a hash code",{ fileName : "Hasher.hx", lineNumber : 75, className : "stx.ds.plus.Hasher", methodName : "getMapForType"});
			});
			break;
		case 0:
			$r = function(v1) {
				return 0;
			};
			break;
		default:
			$r = function(v1) {
				return -1;
			};
		}
		return $r;
	}(this));
}
stx.ds.plus.ArrayHasher = $hxClasses["stx.ds.plus.ArrayHasher"] = function() { }
stx.ds.plus.ArrayHasher.__name__ = ["stx","ds","plus","ArrayHasher"];
stx.ds.plus.ArrayHasher.hashCode = function(v) {
	return stx.ds.plus.ArrayHasher.hashCodeWith(v,stx.ds.plus.Hasher.getMapFor(v[0]));
}
stx.ds.plus.ArrayHasher.hashCodeWith = function(v,hash) {
	var h = 12289;
	if(v.length == 0) return h;
	var _g1 = 0, _g = v.length;
	while(_g1 < _g) {
		var i = _g1++;
		h += hash(v[i]) * 12289;
	}
	return h;
}
stx.ds.plus.StringHasher = $hxClasses["stx.ds.plus.StringHasher"] = function() { }
stx.ds.plus.StringHasher.__name__ = ["stx","ds","plus","StringHasher"];
stx.ds.plus.StringHasher.hashCode = function(v) {
	var hash = 49157;
	var _g1 = 0, _g = v.length;
	while(_g1 < _g) {
		var i = _g1++;
		hash += (24593 + stx.Strings.cca(v,i)) * 49157;
	}
	return hash;
}
stx.ds.plus.DateHasher = $hxClasses["stx.ds.plus.DateHasher"] = function() { }
stx.ds.plus.DateHasher.__name__ = ["stx","ds","plus","DateHasher"];
stx.ds.plus.DateHasher.hashCode = function(v) {
	return Math.round(v.getTime() * 49157);
}
stx.ds.plus.FloatHasher = $hxClasses["stx.ds.plus.FloatHasher"] = function() { }
stx.ds.plus.FloatHasher.__name__ = ["stx","ds","plus","FloatHasher"];
stx.ds.plus.FloatHasher.hashCode = function(v) {
	return v * 98317 | 0;
}
stx.ds.plus.IntHasher = $hxClasses["stx.ds.plus.IntHasher"] = function() { }
stx.ds.plus.IntHasher.__name__ = ["stx","ds","plus","IntHasher"];
stx.ds.plus.IntHasher.hashCode = function(v) {
	return v * 196613;
}
stx.ds.plus.BoolHasher = $hxClasses["stx.ds.plus.BoolHasher"] = function() { }
stx.ds.plus.BoolHasher.__name__ = ["stx","ds","plus","BoolHasher"];
stx.ds.plus.BoolHasher.hashCode = function(v) {
	return v?786433:393241;
}
stx.ds.plus.ProductHasher = $hxClasses["stx.ds.plus.ProductHasher"] = function() { }
stx.ds.plus.ProductHasher.__name__ = ["stx","ds","plus","ProductHasher"];
stx.ds.plus.ProductHasher.getMap = function(p,i) {
	return stx.ds.plus.Hasher.getMapFor(p.element(i));
}
stx.ds.plus.ProductHasher.hashCode = function(p) {
	var h = 0;
	var _g1 = 0, _g = p.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		h += stx.ds.plus.ProductHasher._baseMapes[p.get_length() - 2][i] * (stx.ds.plus.ProductHasher.getMap(p,i))(p.element(i));
	}
	return h;
}
stx.ds.plus.Meta = $hxClasses["stx.ds.plus.Meta"] = function() { }
stx.ds.plus.Meta.__name__ = ["stx","ds","plus","Meta"];
stx.ds.plus.Meta._hasMetaDataClass = function(c) {
	var m = haxe.rtti.Meta.getType(c);
	return null != m && Reflect.hasField(m,"DataClass");
}
stx.ds.plus.Meta._getMetaDataField = function(c,f) {
	var m = haxe.rtti.Meta.getFields(c);
	if(null == m || !Reflect.hasField(m,f)) return null;
	var fm = Reflect.field(m,f);
	if(!Reflect.hasField(fm,"DataField")) return null;
	return Reflect.field(fm,"DataField").copy().pop();
}
stx.ds.plus.Meta._fieldsWithMeta = function(c,name) {
	var i = 0;
	return ArrayLambda.map(stx.ds.plus.ArrayOrder.sortWith(ArrayLambda.filter(ArrayLambda.map(Type.getInstanceFields(c),function(v) {
		var fieldMeta = stx.ds.plus.Meta._getMetaDataField(c,v);
		var inc = fieldMeta == null || !Reflect.hasField(fieldMeta,name) || Reflect.field(fieldMeta,name);
		return new stx.Tuple3(v,inc,fieldMeta != null && Reflect.hasField(fieldMeta,"index")?Reflect.field(fieldMeta,"index"):i++);
	}),function(v) {
		return v.snd();
	}),function(a,b) {
		var c1 = a.thd() - b.thd();
		if(c1 != 0) return c1;
		return stx.Strings.compare(a.fst(),b.fst());
	}),function(v) {
		return v.fst();
	});
}
stx.ds.plus.Order = $hxClasses["stx.ds.plus.Order"] = function() { }
stx.ds.plus.Order.__name__ = ["stx","ds","plus","Order"];
stx.ds.plus.Order._createOrderImpl = function(impl) {
	return function(a,b) {
		return a == b || a == null && b == null?0:a == null?-1:b == null?1:impl(a,b);
	};
}
stx.ds.plus.Order.getOrderFor = function(t) {
	return stx.ds.plus.Order.getOrderForType(Type["typeof"](t));
}
stx.ds.plus.Order.getOrderForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.ds.plus.Order._createOrderImpl(stx.Bools.compare);
			break;
		case 1:
			$r = stx.ds.plus.Order._createOrderImpl(stx.Ints.compare);
			break;
		case 2:
			$r = stx.ds.plus.Order._createOrderImpl(stx.Floats.compare);
			break;
		case 8:
			$r = function(a,b) {
				return a == b?0:a > b?1:-1;
			};
			break;
		case 4:
			$r = stx.ds.plus.Order._createOrderImpl(function(a,b) {
				var _g = 0, _g1 = Reflect.fields(a);
				while(_g < _g1.length) {
					var key = _g1[_g];
					++_g;
					var va = Reflect.field(a,key);
					var vb = Reflect.field(b,key);
					var v1 = (stx.ds.plus.Order.getOrderFor(va))(va,vb);
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
					$r = stx.ds.plus.Order._createOrderImpl(stx.Strings.compare);
					break;
				case "Date":
					$r = stx.ds.plus.Order._createOrderImpl(stx.Dates.compare);
					break;
				case "Array":
					$r = stx.ds.plus.Order._createOrderImpl(stx.ds.plus.ArrayOrder.compare);
					break;
				case "stx.Tuple2":case "stx.Tuple3":case "stx.Tuple4":case "stx.Tuple5":
					$r = stx.ds.plus.Order._createOrderImpl(stx.ds.plus.ProductOrder.compare);
					break;
				default:
					$r = stx.ds.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var i = 0;
						var fields = stx.ds.plus.ArrayOrder.sortWith(ArrayLambda.filter(ArrayLambda.map(Type.getInstanceFields(c),function(v1) {
							var fieldMeta = stx.ds.plus.Meta._getMetaDataField(c,v1);
							var weight = fieldMeta != null && Reflect.hasField(fieldMeta,"order")?Reflect.field(fieldMeta,"order"):1;
							return new stx.Tuple3(v1,weight,fieldMeta != null && Reflect.hasField(fieldMeta,"index")?Reflect.field(fieldMeta,"index"):i++);
						}),function(v1) {
							return v1.snd() != 0;
						}),function(a,b) {
							var c1 = a.thd() - b.thd();
							if(c1 != 0) return c1;
							return stx.Strings.compare(a.fst(),b.fst());
						});
						$r = stx.ds.plus.Order._createOrderImpl(function(a,b) {
							var values = ArrayLambda.map(ArrayLambda.filter(fields,function(v1) {
								return !Reflect.isFunction(Reflect.field(a,v1.fst()));
							}),function(v1) {
								return new stx.Tuple3(Reflect.field(a,v1.fst()),Reflect.field(b,v1.fst()),v1.snd());
							});
							var _g = 0;
							while(_g < values.length) {
								var value = values[_g];
								++_g;
								var c1 = (stx.ds.plus.Order.getOrderFor(value.fst()))(value.fst(),value.snd()) * value.thd();
								if(c1 != 0) return c1;
							}
							return 0;
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"compare")?stx.ds.plus.Order._createOrderImpl(function(a,b) {
						return a.compare(b);
					}):SCore.error("class " + Type.getClassName(c) + " is not comparable",{ fileName : "Order.hx", lineNumber : 91, className : "stx.ds.plus.Order", methodName : "getOrderForType"});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.ds.plus.Order._createOrderImpl(function(a,b) {
				var v1 = a[1] - b[1];
				if(0 != v1) return v1;
				var pa = a.slice(2);
				var pb = b.slice(2);
				var _g1 = 0, _g = pa.length;
				while(_g1 < _g) {
					var i = _g1++;
					var v2 = (stx.ds.plus.Order.getOrderFor(pa[i]))(pa[i],pb[i]);
					if(v2 != 0) return v2;
				}
				return 0;
			});
			break;
		case 0:
			$r = stx.ds.plus.Order._createOrderImpl(function(a,b) {
				return SCore.error("at least one of the arguments should be null",{ fileName : "Order.hx", lineNumber : 109, className : "stx.ds.plus.Order", methodName : "getOrderForType"});
			});
			break;
		case 5:
			$r = SCore.error("unable to compare on a function",{ fileName : "Order.hx", lineNumber : 111, className : "stx.ds.plus.Order", methodName : "getOrderForType"});
			break;
		}
		return $r;
	}(this));
}
stx.ds.plus.ArrayOrder = $hxClasses["stx.ds.plus.ArrayOrder"] = function() { }
stx.ds.plus.ArrayOrder.__name__ = ["stx","ds","plus","ArrayOrder"];
stx.ds.plus.ArrayOrder.sort = function(v) {
	return stx.ds.plus.ArrayOrder.sortWith(v,stx.ds.plus.Order.getOrderFor(v[0]));
}
stx.ds.plus.ArrayOrder.sortWith = function(v,order) {
	var r = v.slice();
	r.sort(order);
	return r;
}
stx.ds.plus.ArrayOrder.compare = function(v1,v2) {
	return stx.ds.plus.ArrayOrder.compareWith(v1,v2,stx.ds.plus.Order.getOrderFor(v1[0]));
}
stx.ds.plus.ArrayOrder.compareWith = function(v1,v2,order) {
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
stx.ds.plus.ProductOrder = $hxClasses["stx.ds.plus.ProductOrder"] = function() { }
stx.ds.plus.ProductOrder.__name__ = ["stx","ds","plus","ProductOrder"];
stx.ds.plus.ProductOrder.getOrder = function(p,i) {
	return stx.ds.plus.Order.getOrderFor(p.element(i));
}
stx.ds.plus.ProductOrder.compare = function(one,other) {
	var _g1 = 0, _g = one.get_length();
	while(_g1 < _g) {
		var i = _g1++;
		var c = (stx.ds.plus.ProductOrder.getOrder(one,i))(one.element(i),other.element(i));
		if(c != 0) return c;
	}
	return 0;
}
stx.ds.plus.Show = $hxClasses["stx.ds.plus.Show"] = function() { }
stx.ds.plus.Show.__name__ = ["stx","ds","plus","Show"];
stx.ds.plus.Show._createShowImpl = function(impl) {
	return function(v) {
		return null == v?"null":impl(v);
	};
}
stx.ds.plus.Show.getShowFor = function(t) {
	return stx.ds.plus.Show.getShowForType(Type["typeof"](t));
}
stx.ds.plus.Show.getShowForType = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.ds.plus.Show._createShowImpl(stx.ds.plus.BoolShow.toString);
			break;
		case 1:
			$r = stx.ds.plus.Show._createShowImpl(stx.ds.plus.IntShow.toString);
			break;
		case 2:
			$r = stx.ds.plus.Show._createShowImpl(stx.ds.plus.FloatShow.toString);
			break;
		case 8:
			$r = stx.ds.plus.Show._createShowImpl(function(v1) {
				return "<unknown>";
			});
			break;
		case 4:
			$r = stx.ds.plus.Show._createShowImpl(function(v1) {
				var buf = [];
				var _g = 0, _g1 = Reflect.fields(v1);
				while(_g < _g1.length) {
					var k = _g1[_g];
					++_g;
					var i = Reflect.field(v1,k);
					buf.push(k + ":" + (stx.ds.plus.Show.getShowFor(i))(i));
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
					$r = stx.ds.plus.Show._createShowImpl(stx.Strings.toString);
					break;
				case "Array":
					$r = stx.ds.plus.Show._createShowImpl(stx.ds.plus.ArrayShow.toString);
					break;
				default:
					$r = stx.ds.plus.Meta._hasMetaDataClass(c)?(function($this) {
						var $r;
						var fields = stx.ds.plus.Meta._fieldsWithMeta(c,"show");
						$r = stx.ds.plus.Show._createShowImpl(function(v1) {
							var values = ArrayLambda.map(ArrayLambda.filter(ArrayLambda.map(fields,function(f) {
								return Reflect.field(v1,f);
							}),function(v2) {
								return !Reflect.isFunction(v2);
							}),function(v2) {
								return (stx.ds.plus.Show.getShowFor(v2))(v2);
							});
							return stx.ds.plus.IterableShow.mkString(values,null,Type.getClassName(c) + "(",")",", ");
						});
						return $r;
					}($this)):HxOverrides.remove(Type.getInstanceFields(c),"toString")?stx.ds.plus.Show._createShowImpl(function(v1) {
						return Reflect.field(v1,"toString").apply(v1,[]);
					}):stx.ds.plus.Show._createShowImpl(function(v1) {
						return Type.getClassName(Type.getClass(v1));
					});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = stx.ds.plus.Show._createShowImpl(function(v1) {
				var buf = v1[0];
				var params = v1.slice(2);
				if(params.length == 0) return buf; else {
					buf += "(";
					var _g = 0;
					while(_g < params.length) {
						var p = params[_g];
						++_g;
						buf += (stx.ds.plus.Show.getShowFor(p))(p);
					}
					return buf + ")";
				}
			});
			break;
		case 0:
			$r = function(v1) {
				return "null";
			};
			break;
		case 5:
			$r = stx.ds.plus.Show._createShowImpl(function(v1) {
				return "<function>";
			});
			break;
		}
		return $r;
	}(this));
}
stx.ds.plus.ArrayShow = $hxClasses["stx.ds.plus.ArrayShow"] = function() { }
stx.ds.plus.ArrayShow.__name__ = ["stx","ds","plus","ArrayShow"];
stx.ds.plus.ArrayShow.toString = function(v) {
	return stx.ds.plus.ArrayShow.toStringWith(v,stx.ds.plus.Show.getShowFor(v[0]));
}
stx.ds.plus.ArrayShow.toStringWith = function(v,show) {
	return "[" + ArrayLambda.map(v,show).join(", ") + "]";
}
stx.ds.plus.ArrayShow.mkString = function(arr,sep,show) {
	if(sep == null) sep = ", ";
	var isFirst = true;
	return ArrayLambda.foldl(arr,"",function(a,b) {
		var prefix = isFirst?(function($this) {
			var $r;
			isFirst = false;
			$r = "";
			return $r;
		}(this)):sep;
		if(null == show) show = stx.ds.plus.Show.getShowFor(b);
		return a + prefix + show(b);
	});
}
stx.ds.plus.IterableShow = $hxClasses["stx.ds.plus.IterableShow"] = function() { }
stx.ds.plus.IterableShow.__name__ = ["stx","ds","plus","IterableShow"];
stx.ds.plus.IterableShow.toString = function(i,show,prefix,suffix,sep) {
	if(sep == null) sep = ", ";
	if(suffix == null) suffix = ")";
	if(prefix == null) prefix = "(";
	return stx.ds.plus.IterableShow.mkString(i,show,prefix,suffix,sep);
}
stx.ds.plus.IterableShow.mkString = function(i,show,prefix,suffix,sep) {
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
stx.ds.plus.BoolShow = $hxClasses["stx.ds.plus.BoolShow"] = function() { }
stx.ds.plus.BoolShow.__name__ = ["stx","ds","plus","BoolShow"];
stx.ds.plus.BoolShow.toString = function(v) {
	return v?"true":"false";
}
stx.ds.plus.IntShow = $hxClasses["stx.ds.plus.IntShow"] = function() { }
stx.ds.plus.IntShow.__name__ = ["stx","ds","plus","IntShow"];
stx.ds.plus.IntShow.toString = function(v) {
	return "" + v;
}
stx.ds.plus.FloatShow = $hxClasses["stx.ds.plus.FloatShow"] = function() { }
stx.ds.plus.FloatShow.__name__ = ["stx","ds","plus","FloatShow"];
stx.ds.plus.FloatShow.toString = function(v) {
	return "" + v;
}
stx.ds.plus.ProductShow = $hxClasses["stx.ds.plus.ProductShow"] = function() { }
stx.ds.plus.ProductShow.__name__ = ["stx","ds","plus","ProductShow"];
stx.ds.plus.ProductShow.getProductShow = function(p,i) {
	return stx.ds.plus.Show.getShowFor(p.element(i));
}
stx.ds.plus.ProductShow.toString = function(p) {
	var productPrefix = "Tuple" + p.get_length();
	var s = productPrefix + "(" + (stx.ds.plus.ProductShow.getProductShow(p,1))(p.element(1));
	var _g1 = 2, _g = p.get_length() + 1;
	while(_g1 < _g) {
		var i = _g1++;
		s += ", " + (stx.ds.plus.ProductShow.getProductShow(p,i))(p.element(i));
	}
	return s + ")";
}
if(!stx.err) stx.err = {}
stx.Error = $hxClasses["stx.Error"] = function(msg,pos) {
	this.msg = msg;
	this.pos = pos;
};
stx.Error.__name__ = ["stx","error","Error"];
stx.Error.__properties__ = {get_exception:"get_exception"}
stx.Error.exception = null;
stx.Error.get_exception = function() {
	if(stx.Error.exception == null) stx.Error.exception = new stx.Future();
	return stx.Error.exception;
}
stx.Error.toError = function(msg,pos) {
	return new stx.Error(msg,pos);
}
stx.Error.printf = function(a,str) {
	var out = "";
	var reg = new EReg("(\\$\\{[0-9]\\})+","");
	var ms = str;
	var lst = "";
	while(true) try {
		reg.match(ms);
		var match = reg.matched(0);
		out += reg.matchedLeft();
		var index = Std.parseInt(match.charAt(2));
		out += Std.string(a[index]);
		ms = reg.matchedRight();
	} catch( e ) {
		break;
	}
	out += ms;
	return out;
}
stx.Error.prototype = {
	toString: function() {
		return "Error: (" + this.msg + " at " + stx.err.Positions.toString(this.pos) + ")";
	}
	,except: function() {
		stx.Error.get_exception().deliver(this,{ fileName : "Error.hx", lineNumber : 27, className : "stx.Error", methodName : "except"});
		return this;
	}
	,pos: null
	,msg: null
	,__class__: stx.Error
}
stx.err.AbstractMethodError = $hxClasses["stx.err.AbstractMethodError"] = function(pos) {
	stx.Error.call(this,"Called abstract method",pos);
};
stx.err.AbstractMethodError.__name__ = ["stx","error","AbstractMethodError"];
stx.err.AbstractMethodError.__super__ = stx.Error;
stx.err.AbstractMethodError.prototype = $extend(stx.Error.prototype,{
	__class__: stx.err.AbstractMethodError
});
stx.err.AssertionError = $hxClasses["stx.err.AssertionError"] = function(msg,pos) {
	stx.Error.call(this,msg,pos);
};
stx.err.AssertionError.__name__ = ["stx","error","AssertionError"];
stx.err.AssertionError.__super__ = stx.Error;
stx.err.AssertionError.prototype = $extend(stx.Error.prototype,{
	__class__: stx.err.AssertionError
});
stx.err.Positions = $hxClasses["stx.err.Positions"] = function() { }
stx.err.Positions.__name__ = ["stx","error","Positions"];
stx.err.Positions.toString = function(pos) {
	if(pos == null) return "nil";
	var type = pos.className.split(".");
	return type[type.length - 1] + "::" + pos.methodName + "#" + pos.lineNumber;
}
stx.err.Positions.here = function(pos) {
	return pos;
}
stx.err.IllegalOverrideError = $hxClasses["stx.err.IllegalOverrideError"] = function(of,pos) {
	stx.Error.call(this,stx.Error.printf([of],"Attempting illegal override of ${0}"),pos);
};
stx.err.IllegalOverrideError.__name__ = ["stx","error","IllegalOverrideError"];
stx.err.IllegalOverrideError.__super__ = stx.Error;
stx.err.IllegalOverrideError.prototype = $extend(stx.Error.prototype,{
	__class__: stx.err.IllegalOverrideError
});
stx.err.NullReferenceError = $hxClasses["stx.err.NullReferenceError"] = function(fieldname,pos) {
	stx.Error.call(this,stx.Error.printf([fieldname]," \"${0}\" is null"),pos);
};
stx.err.NullReferenceError.__name__ = ["stx","error","NullReferenceError"];
stx.err.NullReferenceError.__super__ = stx.Error;
stx.err.NullReferenceError.prototype = $extend(stx.Error.prototype,{
	__class__: stx.err.NullReferenceError
});
stx.err.OutOfBoundsError = $hxClasses["stx.err.OutOfBoundsError"] = function(pos) {
	stx.Error.call(this,"Index out of bounds at " + Std.string(pos),pos);
};
stx.err.OutOfBoundsError.__name__ = ["stx","error","OutOfBoundsError"];
stx.err.OutOfBoundsError.__super__ = stx.Error;
stx.err.OutOfBoundsError.prototype = $extend(stx.Error.prototype,{
	__class__: stx.err.OutOfBoundsError
});
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
	var factory = stx.Options.getOrElse(binding,stx.Functions2.lazy(SCore.error,"No binding defined for " + Type.getClassName(interf),Stax.here({ fileName : "Injector.hx", lineNumber : 154, className : "stx.framework._Injector.InjectorImpl", methodName : "inject"})));
	return factory();
}
stx.framework._Injector.InjectorImpl.forever = function(f) {
	stx.framework._Injector.InjectorImpl.state.unshift({ defaultBindings : new Map(), globalBindings : new Map(), packageBindings : new Map(), moduleBindings : new Map(), classBindings : new Map()});
	return f(new stx.framework._Injector.InjectorConfigImpl());
}
stx.framework._Injector.InjectorImpl.enter = function(f) {
	stx.framework._Injector.InjectorImpl.state.unshift({ defaultBindings : new Map(), globalBindings : new Map(), packageBindings : new Map(), moduleBindings : new Map(), classBindings : new Map()});
	var result = null;
	try {
		result = f(new stx.framework._Injector.InjectorConfigImpl());
		stx.framework._Injector.InjectorImpl.state.shift();
	} catch( e ) {
		stx.framework._Injector.InjectorImpl.state.shift();
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
			stx.framework._Injector.InjectorImpl.addGlobalBinding(interf,stx.Anys.memoize(f));
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
		stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.state[0]),interf,specific,f);
		break;
	case 1:
		stx.framework._Injector.InjectorImpl.addSpecificBinding(extractor(stx.framework._Injector.InjectorImpl.state[0]),interf,specific,stx.Anys.memoize(f));
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
	var f = stx.Options.flatMap(stx.Options.flatMap(stx.Options.flatMap(stx.Options.toOption(haxe.rtti.Meta.getType(c)),function(m) {
		return stx.Options.toOption(Reflect.hasField(m,"DefaultImplementation")?Reflect.field(m,"DefaultImplementation"):null);
	}),function(p) {
		var cls = null;
		return null == p || null == p[0] || null == (cls = Type.resolveClass(p[0]))?stx.Option.None:stx.Option.Some(new stx.Tuple2(cls,null != p[1]?Type.createEnum(stx.framework.BindingType,p[1],[]):null));
	}),function(p) {
		return (function($this) {
			var $r;
			switch( (stx.framework._Injector.InjectorImpl.bindingTypeDef(p.snd()))[1] ) {
			case 0:
				$r = stx.Options.toOption(stx.framework._Injector.InjectorImpl.factoryFor(p.fst()));
				break;
			case 1:
				$r = stx.Options.toOption(stx.Anys.memoize(stx.framework._Injector.InjectorImpl.factoryFor(p.fst())));
				break;
			}
			return $r;
		}(this));
	});
	stx.framework._Injector.InjectorImpl.addDefaultBinding(c,f);
	return f;
}
stx.framework._Injector.InjectorImpl.getGlobalBinding = function(c) {
	var className = Type.getClassName(c);
	return ArrayLambda.foldl(stx.framework._Injector.InjectorImpl.state,stx.Option.None,function(a,b) {
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
	stx.framework._Injector.InjectorImpl.state[0].globalBindings.set(Type.getClassName(c),f);
}
stx.framework._Injector.InjectorImpl.existsDefaultBinding = function(c) {
	return stx.framework._Injector.InjectorImpl.state[0].defaultBindings.exists(Type.getClassName(c));
}
stx.framework._Injector.InjectorImpl.addDefaultBinding = function(c,f) {
	stx.framework._Injector.InjectorImpl.state[0].defaultBindings.set(Type.getClassName(c),f);
}
stx.framework._Injector.InjectorImpl.getDefaultBinding = function(c) {
	return stx.framework._Injector.InjectorImpl.state[0].defaultBindings.get(Type.getClassName(c));
}
stx.framework._Injector.InjectorImpl.getSpecificBinding = function(extractor,c,specific) {
	var _g = 0, _g1 = stx.framework._Injector.InjectorImpl.state;
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
		h = new Map();
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
stx.functional.FoldableExtensions = $hxClasses["stx.functional.FoldableExtensions"] = function() { }
stx.functional.FoldableExtensions.__name__ = ["stx","functional","FoldableExtensions"];
stx.functional.FoldableExtensions.foldr = function(foldable,z,f) {
	var a = stx.functional.FoldableExtensions.toArray(foldable);
	a.reverse();
	var acc = z;
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		acc = f(e,acc);
	}
	return acc;
}
stx.functional.FoldableExtensions.filter = function(foldable,f) {
	return foldable.foldl(foldable.empty(),function(a,b) {
		return f(b)?a.add(b):a;
	});
}
stx.functional.FoldableExtensions.partition = function(foldable,f) {
	return foldable.foldl(new stx.Tuple2(foldable.empty(),foldable.empty()),function(a,b) {
		return f(b)?new stx.Tuple2(a.fst().add(b),a.snd()):new stx.Tuple2(a.fst(),a.snd().add(b));
	});
}
stx.functional.FoldableExtensions.partitionWhile = function(foldable,f) {
	var partitioning = true;
	return foldable.foldl(new stx.Tuple2(foldable.empty(),foldable.empty()),function(a,b) {
		return partitioning?f(b)?new stx.Tuple2(a.fst().add(b),a.snd()):(function($this) {
			var $r;
			partitioning = false;
			$r = new stx.Tuple2(a.fst(),a.snd().add(b));
			return $r;
		}(this)):new stx.Tuple2(a.fst(),a.snd().add(b));
	});
}
stx.functional.FoldableExtensions.map = function(src,f) {
	return stx.functional.FoldableExtensions.mapTo(src,src.empty(),f);
}
stx.functional.FoldableExtensions.mapTo = function(src,dest,f) {
	return src.foldl(dest,function(a,b) {
		return a.add(f(b));
	});
}
stx.functional.FoldableExtensions.flatMap = function(src,f) {
	return stx.functional.FoldableExtensions.flatMapTo(src,src.empty(),f);
}
stx.functional.FoldableExtensions.flatMapTo = function(src,dest,f) {
	return src.foldl(dest,function(a,b) {
		return f(b).foldl(a,function(a1,b1) {
			return a1.add(b1);
		});
	});
}
stx.functional.FoldableExtensions.take = function(foldable,n) {
	return foldable.foldl(foldable.empty(),function(a,b) {
		return n-- > 0?a.add(b):a;
	});
}
stx.functional.FoldableExtensions.takeWhile = function(foldable,f) {
	var taking = true;
	return foldable.foldl(foldable.empty(),function(a,b) {
		return taking?f(b)?a.add(b):(function($this) {
			var $r;
			taking = false;
			$r = a;
			return $r;
		}(this)):a;
	});
}
stx.functional.FoldableExtensions.drop = function(foldable,n) {
	return foldable.foldl(foldable.empty(),function(a,b) {
		return n-- > 0?a:a.add(b);
	});
}
stx.functional.FoldableExtensions.dropWhile = function(foldable,f) {
	var dropping = true;
	return foldable.foldl(foldable.empty(),function(a,b) {
		return dropping?f(b)?a:(function($this) {
			var $r;
			dropping = false;
			$r = a.add(b);
			return $r;
		}(this)):a.add(b);
	});
}
stx.functional.FoldableExtensions.count = function(foldable,f) {
	return foldable.foldl(0,function(a,b) {
		return a + (f(b)?1:0);
	});
}
stx.functional.FoldableExtensions.countWhile = function(foldable,f) {
	var counting = true;
	return foldable.foldl(0,function(a,b) {
		return !counting?a:f(b)?a + 1:(function($this) {
			var $r;
			counting = false;
			$r = a;
			return $r;
		}(this));
	});
}
stx.functional.FoldableExtensions.scanl = function(foldable,init,f) {
	var a = stx.functional.FoldableExtensions.toArray(foldable);
	var result = foldable.empty().add(init);
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		result = result.add(f(e,init));
	}
	return result;
}
stx.functional.FoldableExtensions.scanr = function(foldable,init,f) {
	var a = stx.functional.FoldableExtensions.toArray(foldable);
	a.reverse();
	var result = foldable.empty().add(init);
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		result = result.add(f(e,init));
	}
	return result;
}
stx.functional.FoldableExtensions.scanl1 = function(foldable,f) {
	var iterator = HxOverrides.iter(stx.functional.FoldableExtensions.toArray(foldable));
	var result = foldable.empty();
	if(!iterator.hasNext()) return result;
	var accum = iterator.next();
	result = result.add(accum);
	while(iterator.hasNext()) result = result.add(f(iterator.next(),accum));
	return result;
}
stx.functional.FoldableExtensions.scanr1 = function(foldable,f) {
	var a = stx.functional.FoldableExtensions.toArray(foldable);
	a.reverse();
	var iterator = HxOverrides.iter(a);
	var result = foldable.empty();
	if(!iterator.hasNext()) return result;
	var accum = iterator.next();
	result = result.add(accum);
	while(iterator.hasNext()) result = result.add(f(iterator.next(),accum));
	return result;
}
stx.functional.FoldableExtensions.elements = function(foldable) {
	return stx.functional.FoldableExtensions.toArray(foldable);
}
stx.functional.FoldableExtensions.concat = function(foldable,rest) {
	return rest.foldl(foldable,function(a,b) {
		return a.add(b);
	});
}
stx.functional.FoldableExtensions.append = function(foldable,e) {
	return foldable.add(e);
}
stx.functional.FoldableExtensions.appendAll = function(foldable,i) {
	var acc = foldable;
	var $it0 = $iterator(i)();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		acc = acc.add(e);
	}
	return acc;
}
stx.functional.FoldableExtensions.iterator = function(foldable) {
	return $iterator(stx.functional.FoldableExtensions.elements(foldable))();
}
stx.functional.FoldableExtensions.isEmpty = function(foldable) {
	return !$iterator(stx.functional.FoldableExtensions)(foldable).hasNext();
}
stx.functional.FoldableExtensions.foreach = function(foldable,f) {
	foldable.foldl(1,function(a,b) {
		f(b);
		return a;
	});
	return foldable;
}
stx.functional.FoldableExtensions.find = function(foldable,f) {
	return foldable.foldl(stx.Option.None,function(a,b) {
		return (function($this) {
			var $r;
			switch( (a)[1] ) {
			case 0:
				$r = stx.Options.filter(stx.Options.toOption(b),f);
				break;
			default:
				$r = a;
			}
			return $r;
		}(this));
	});
}
stx.functional.FoldableExtensions.forAll = function(foldable,f) {
	return foldable.foldl(true,function(a,b) {
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
stx.functional.FoldableExtensions.forAny = function(foldable,f) {
	return foldable.foldl(false,function(a,b) {
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
stx.functional.FoldableExtensions.exists = function(foldable,f) {
	return (function($this) {
		var $r;
		var $e = (stx.functional.FoldableExtensions.find(foldable,f));
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
stx.functional.FoldableExtensions.existsP = function(foldable,ref,f) {
	var result = false;
	var a = stx.functional.FoldableExtensions.toArray(foldable);
	var _g = 0;
	while(_g < a.length) {
		var e = a[_g];
		++_g;
		if(f(e,ref)) result = true;
	}
	return result;
}
stx.functional.FoldableExtensions.contains = function(foldable,member) {
	return stx.functional.FoldableExtensions.exists(foldable,function(e) {
		return e == member;
	});
}
stx.functional.FoldableExtensions.nubBy = function(foldable,f) {
	return foldable.foldl(foldable.empty(),function(a,b) {
		return stx.functional.FoldableExtensions.existsP(a,b,f)?a:a.add(b);
	});
}
stx.functional.FoldableExtensions.nub = function(foldable) {
	var it = $iterator(stx.functional.FoldableExtensions)(foldable);
	var first = it.hasNext()?it.next():null;
	return stx.functional.FoldableExtensions.nubBy(foldable,stx.ds.plus.Equal.getEqualFor(first));
}
stx.functional.FoldableExtensions.intersectBy = function(foldable1,foldable2,f) {
	return foldable1.foldl(foldable1.empty(),function(a,b) {
		return stx.functional.FoldableExtensions.existsP(foldable2,b,f)?a.add(b):a;
	});
}
stx.functional.FoldableExtensions.intersect = function(foldable1,foldable2) {
	var it = $iterator(stx.functional.FoldableExtensions)(foldable1);
	var first = it.hasNext()?it.next():null;
	return stx.functional.FoldableExtensions.intersectBy(foldable1,foldable2,stx.ds.plus.Equal.getEqualFor(first));
}
stx.functional.FoldableExtensions.mkString = function(foldable,sep,show) {
	if(sep == null) sep = ", ";
	var isFirst = true;
	return foldable.foldl("",function(a,b) {
		var prefix = isFirst?(function($this) {
			var $r;
			isFirst = false;
			$r = "";
			return $r;
		}(this)):sep;
		if(null == show) show = stx.ds.plus.Show.getShowFor(b);
		return a + prefix + show(b);
	});
}
stx.functional.FoldableExtensions.toArray = function(foldable) {
	var es = [];
	foldable.foldl(foldable.empty(),function(a,b) {
		es.push(b);
		return a;
	});
	return es;
}
stx.functional.PartialFunction2 = $hxClasses["stx.functional.PartialFunction2"] = function() { }
stx.functional.PartialFunction2.__name__ = ["stx","functional","PartialFunction2"];
stx.functional.PartialFunction2.prototype = {
	toFunction: null
	,call: null
	,orAlwaysC: null
	,orAlways: null
	,orElse: null
	,isDefinedAt: null
	,__class__: stx.functional.PartialFunction2
}
stx.functional.PartialFunction3 = $hxClasses["stx.functional.PartialFunction3"] = function() { }
stx.functional.PartialFunction3.__name__ = ["stx","functional","PartialFunction3"];
stx.functional.PartialFunction3.prototype = {
	toFunction: null
	,call: null
	,orAlwaysC: null
	,orAlways: null
	,orElse: null
	,isDefinedAt: null
	,__class__: stx.functional.PartialFunction3
}
stx.functional.PartialFunction4 = $hxClasses["stx.functional.PartialFunction4"] = function() { }
stx.functional.PartialFunction4.__name__ = ["stx","functional","PartialFunction4"];
stx.functional.PartialFunction4.prototype = {
	toFunction: null
	,call: null
	,orAlwaysC: null
	,orAlways: null
	,orElse: null
	,isDefinedAt: null
	,__class__: stx.functional.PartialFunction4
}
stx.functional.PartialFunction5 = $hxClasses["stx.functional.PartialFunction5"] = function() { }
stx.functional.PartialFunction5.__name__ = ["stx","functional","PartialFunction5"];
stx.functional.PartialFunction5.prototype = {
	toFunction: null
	,call: null
	,orAlwaysC: null
	,orAlways: null
	,orElse: null
	,isDefinedAt: null
	,__class__: stx.functional.PartialFunction5
}
if(!stx.functional._PartialFunctionExtensions) stx.functional._PartialFunctionExtensions = {}
stx.functional._PartialFunctionExtensions.PartialFunction1Impl = $hxClasses["stx.functional._PartialFunctionExtensions.PartialFunction1Impl"] = function(def) {
	this._def = def;
};
stx.functional._PartialFunctionExtensions.PartialFunction1Impl.__name__ = ["stx","functional","_PartialFunctionExtensions","PartialFunction1Impl"];
stx.functional._PartialFunctionExtensions.PartialFunction1Impl.__interfaces__ = [stx.functional.PartialFunction1];
stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create = function(def) {
	return new stx.functional._PartialFunctionExtensions.PartialFunction1Impl(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction1Impl.prototype = {
	toFunction: function() {
		var self = this;
		return function(a) {
			return self.isDefinedAt(a)?stx.Option.Some(self.call(a)):stx.Option.None;
		};
	}
	,call: function(a) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a)) return d.snd()(a);
		}
		return SCore.error("Function undefined at " + Std.string(a),{ fileName : "PartialFunctionExtensions.hx", lineNumber : 67, className : "stx.functional._PartialFunctionExtensions.PartialFunction1Impl", methodName : "call"});
	}
	,orAlwaysC: function(z) {
		return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([stx.Entuple.entuple(function(a) {
			return true;
		},function(a) {
			return z();
		})]));
	}
	,orAlways: function(f) {
		return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([stx.Entuple.entuple(function(a) {
			return true;
		},f)]));
	}
	,orElse: function(that) {
		return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([new stx.Tuple2($bind(that,that.isDefinedAt),$bind(that,that.call))]));
	}
	,isDefinedAt: function(a) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a)) return true;
		}
		return false;
	}
	,_def: null
	,__class__: stx.functional._PartialFunctionExtensions.PartialFunction1Impl
}
stx.functional.PartialFunction1ImplExtensions = $hxClasses["stx.functional.PartialFunction1ImplExtensions"] = function() { }
stx.functional.PartialFunction1ImplExtensions.__name__ = ["stx","functional","PartialFunction1ImplExtensions"];
stx.functional.PartialFunction1ImplExtensions.toPartialFunction = function(def) {
	return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction2Impl = $hxClasses["stx.functional._PartialFunctionExtensions.PartialFunction2Impl"] = function(def) {
	this._def = def;
};
stx.functional._PartialFunctionExtensions.PartialFunction2Impl.__name__ = ["stx","functional","_PartialFunctionExtensions","PartialFunction2Impl"];
stx.functional._PartialFunctionExtensions.PartialFunction2Impl.__interfaces__ = [stx.functional.PartialFunction2];
stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create = function(def) {
	return new stx.functional._PartialFunctionExtensions.PartialFunction2Impl(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction2Impl.prototype = {
	toFunction: function() {
		var self = this;
		return function(a,b) {
			return self.isDefinedAt(a,b)?stx.Option.Some(self.call(a,b)):stx.Option.None;
		};
	}
	,call: function(a,b) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a,b)) return d.snd()(a,b);
		}
		return SCore.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 128, className : "stx.functional._PartialFunctionExtensions.PartialFunction2Impl", methodName : "call"});
	}
	,orAlwaysC: function(z) {
		return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b) {
			return true;
		},function(a,b) {
			return z();
		})]));
	}
	,orAlways: function(f) {
		return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b) {
			return true;
		},f)]));
	}
	,orElse: function(that) {
		return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([new stx.Tuple2($bind(that,that.isDefinedAt),$bind(that,that.call))]));
	}
	,isDefinedAt: function(a,b) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a,b)) return true;
		}
		return false;
	}
	,_def: null
	,__class__: stx.functional._PartialFunctionExtensions.PartialFunction2Impl
}
stx.functional.PartialFunction2ImplExtensions = $hxClasses["stx.functional.PartialFunction2ImplExtensions"] = function() { }
stx.functional.PartialFunction2ImplExtensions.__name__ = ["stx","functional","PartialFunction2ImplExtensions"];
stx.functional.PartialFunction2ImplExtensions.toPartialFunction = function(def) {
	return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction3Impl = $hxClasses["stx.functional._PartialFunctionExtensions.PartialFunction3Impl"] = function(def) {
	this._def = def;
};
stx.functional._PartialFunctionExtensions.PartialFunction3Impl.__name__ = ["stx","functional","_PartialFunctionExtensions","PartialFunction3Impl"];
stx.functional._PartialFunctionExtensions.PartialFunction3Impl.__interfaces__ = [stx.functional.PartialFunction3];
stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create = function(def) {
	return new stx.functional._PartialFunctionExtensions.PartialFunction3Impl(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction3Impl.prototype = {
	toFunction: function() {
		var self = this;
		return function(a,b,c) {
			return self.isDefinedAt(a,b,c)?stx.Option.Some(self.call(a,b,c)):stx.Option.None;
		};
	}
	,call: function(a,b,c) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a,b,c)) return d.snd()(a,b,c);
		}
		return SCore.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 189, className : "stx.functional._PartialFunctionExtensions.PartialFunction3Impl", methodName : "call"});
	}
	,orAlwaysC: function(z) {
		return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c) {
			return true;
		},function(a,b,c) {
			return z();
		})]));
	}
	,orAlways: function(f) {
		return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c) {
			return true;
		},f)]));
	}
	,orElse: function(that) {
		return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([new stx.Tuple2($bind(that,that.isDefinedAt),$bind(that,that.call))]));
	}
	,isDefinedAt: function(a,b,c) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.fst()(a,b,c)) return true;
		}
		return false;
	}
	,_def: null
	,__class__: stx.functional._PartialFunctionExtensions.PartialFunction3Impl
}
stx.functional.PartialFunction3ImplExtensions = $hxClasses["stx.functional.PartialFunction3ImplExtensions"] = function() { }
stx.functional.PartialFunction3ImplExtensions.__name__ = ["stx","functional","PartialFunction3ImplExtensions"];
stx.functional.PartialFunction3ImplExtensions.toPartialFunction = function(def) {
	return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction4Impl = $hxClasses["stx.functional._PartialFunctionExtensions.PartialFunction4Impl"] = function(def) {
	this._def = def;
};
stx.functional._PartialFunctionExtensions.PartialFunction4Impl.__name__ = ["stx","functional","_PartialFunctionExtensions","PartialFunction4Impl"];
stx.functional._PartialFunctionExtensions.PartialFunction4Impl.__interfaces__ = [stx.functional.PartialFunction4];
stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create = function(def) {
	return new stx.functional._PartialFunctionExtensions.PartialFunction4Impl(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction4Impl.prototype = {
	toFunction: function() {
		var self = this;
		return function(a,b,c,d) {
			return self.isDefinedAt(a,b,c,d)?stx.Option.Some(self.call(a,b,c,d)):stx.Option.None;
		};
	}
	,call: function(a,b,c,d) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var def = _g1[_g];
			++_g;
			if(def.fst()(a,b,c,d)) return def.snd()(a,b,c,d);
		}
		return SCore.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ", " + Std.string(d) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 250, className : "stx.functional._PartialFunctionExtensions.PartialFunction4Impl", methodName : "call"});
	}
	,orAlwaysC: function(z) {
		return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c,d) {
			return true;
		},function(a,b,c,d) {
			return z();
		})]));
	}
	,orAlways: function(f) {
		return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c,d) {
			return true;
		},f)]));
	}
	,orElse: function(that) {
		return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([new stx.Tuple2($bind(that,that.isDefinedAt),$bind(that,that.call))]));
	}
	,isDefinedAt: function(a,b,c,d) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var def = _g1[_g];
			++_g;
			if(def.fst()(a,b,c,d)) return true;
		}
		return false;
	}
	,_def: null
	,__class__: stx.functional._PartialFunctionExtensions.PartialFunction4Impl
}
stx.functional.PartialFunction4ImplExtensions = $hxClasses["stx.functional.PartialFunction4ImplExtensions"] = function() { }
stx.functional.PartialFunction4ImplExtensions.__name__ = ["stx","functional","PartialFunction4ImplExtensions"];
stx.functional.PartialFunction4ImplExtensions.toPartialFunction = function(def) {
	return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction5Impl = $hxClasses["stx.functional._PartialFunctionExtensions.PartialFunction5Impl"] = function(def) {
	this._def = def;
};
stx.functional._PartialFunctionExtensions.PartialFunction5Impl.__name__ = ["stx","functional","_PartialFunctionExtensions","PartialFunction5Impl"];
stx.functional._PartialFunctionExtensions.PartialFunction5Impl.__interfaces__ = [stx.functional.PartialFunction5];
stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create = function(def) {
	return new stx.functional._PartialFunctionExtensions.PartialFunction5Impl(def);
}
stx.functional._PartialFunctionExtensions.PartialFunction5Impl.prototype = {
	toFunction: function() {
		var self = this;
		return function(a,b,c,d,e) {
			return self.isDefinedAt(a,b,c,d,e)?stx.Option.Some(self.call(a,b,c,d,e)):stx.Option.None;
		};
	}
	,call: function(a,b,c,d,e) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var def = _g1[_g];
			++_g;
			if(def.fst()(a,b,c,d,e)) return def.snd()(a,b,c,d,e);
		}
		return SCore.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ", " + Std.string(d) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 311, className : "stx.functional._PartialFunctionExtensions.PartialFunction5Impl", methodName : "call"});
	}
	,orAlwaysC: function(z) {
		return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c,d,e) {
			return true;
		},function(a,b,c,d,e) {
			return z();
		})]));
	}
	,orAlways: function(f) {
		return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([stx.Entuple.entuple(function(a,b,c,d,e) {
			return true;
		},f)]));
	}
	,orElse: function(that) {
		return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([new stx.Tuple2($bind(that,that.isDefinedAt),$bind(that,that.call))]));
	}
	,isDefinedAt: function(a,b,c,d,e) {
		var _g = 0, _g1 = this._def;
		while(_g < _g1.length) {
			var def = _g1[_g];
			++_g;
			if(def.fst()(a,b,c,d,e)) return true;
		}
		return false;
	}
	,_def: null
	,__class__: stx.functional._PartialFunctionExtensions.PartialFunction5Impl
}
stx.functional.PartialFunction5ImplExtensions = $hxClasses["stx.functional.PartialFunction5ImplExtensions"] = function() { }
stx.functional.PartialFunction5ImplExtensions.__name__ = ["stx","functional","PartialFunction5ImplExtensions"];
stx.functional.PartialFunction5ImplExtensions.toPartialFunction = function(def) {
	return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(def);
}
if(!stx.io) stx.io = {}
stx.io.Files = $hxClasses["stx.io.Files"] = function() { }
stx.io.Files.__name__ = ["stx","io","Files"];
if(!stx.io.http) stx.io.http = {}
stx.io.http.Http = $hxClasses["stx.io.http.Http"] = function() { }
stx.io.http.Http.__name__ = ["stx","io","http","Http"];
stx.io.http.Http.prototype = {
	custom: null
	,'delete': null
	,put: null
	,post: null
	,get: null
	,__class__: stx.io.http.Http
}
stx.io.http.HttpJValue = $hxClasses["stx.io.http.HttpJValue"] = function() { }
stx.io.http.HttpJValue.__name__ = ["stx","io","http","HttpJValue"];
stx.io.http.HttpJValue.__interfaces__ = [stx.io.http.Http];
stx.io.http.HttpTransformer = $hxClasses["stx.io.http.HttpTransformer"] = function(http,encoder,decoder,mimeType) {
	this.http = http;
	this.encoder = encoder;
	this.decoder = decoder;
	this.mimeType = mimeType;
};
stx.io.http.HttpTransformer.__name__ = ["stx","io","http","HttpTransformer"];
stx.io.http.HttpTransformer.__interfaces__ = [stx.io.http.Http];
stx.io.http.HttpTransformer.prototype = {
	addMimeType: function(map_) {
		return stx.Options.getOrElseC(stx.Options.toOption(map_),stx.ds.Map.create().set("Content-Type",this.mimeType));
	}
	,transformResponse: function(r) {
		return { body : stx.Options.map(r.body,this.decoder), headers : r.headers, code : r.code};
	}
	,custom: function(method,url,data,params,headers) {
		return this.http.custom(method,url,this.encoder(data),params,this.addMimeType(headers)).map($bind(this,this.transformResponse));
	}
	,'delete': function(url,params,headers) {
		return this.http["delete"](url,params,this.addMimeType(headers)).map($bind(this,this.transformResponse));
	}
	,put: function(url,data,params,headers) {
		return this.http.put(url,this.encoder(data),params,this.addMimeType(headers)).map($bind(this,this.transformResponse));
	}
	,post: function(url,data,params,headers) {
		return this.http.post(url,this.encoder(data),params,this.addMimeType(headers)).map($bind(this,this.transformResponse));
	}
	,get: function(url,params,headers) {
		return this.http.get(url,params,this.addMimeType(headers)).map($bind(this,this.transformResponse));
	}
	,mimeType: null
	,decoder: null
	,encoder: null
	,http: null
	,__class__: stx.io.http.HttpTransformer
}
stx.io.http.HttpJValueAsync = $hxClasses["stx.io.http.HttpJValueAsync"] = function() {
	stx.io.http.HttpTransformer.call(this,new stx.io.http.HttpStringAsync(),stx.io.json.Json.encode,stx.io.json.Json.decode,"application/json");
};
stx.io.http.HttpJValueAsync.__name__ = ["stx","io","http","HttpJValueAsync"];
stx.io.http.HttpJValueAsync.__interfaces__ = [stx.io.http.HttpJValue];
stx.io.http.HttpJValueAsync.__super__ = stx.io.http.HttpTransformer;
stx.io.http.HttpJValueAsync.prototype = $extend(stx.io.http.HttpTransformer.prototype,{
	__class__: stx.io.http.HttpJValueAsync
});
stx.io.http.HttpJValueJsonp = $hxClasses["stx.io.http.HttpJValueJsonp"] = function(callbackParameterName) {
	if(callbackParameterName == null) callbackParameterName = "callback";
	this.callbackParameterName = callbackParameterName;
};
stx.io.http.HttpJValueJsonp.__name__ = ["stx","io","http","HttpJValueJsonp"];
stx.io.http.HttpJValueJsonp.__interfaces__ = [stx.io.http.HttpJValue];
stx.io.http.HttpJValueJsonp.prototype = {
	custom: function(request,url,data,params,headers) {
		return SCore.error("JSONP does not support custom request: " + request,{ fileName : "HttpJValue.hx", lineNumber : 142, className : "stx.io.http.HttpJValueJsonp", methodName : "custom"});
	}
	,'delete': function(url,params,headers) {
		return SCore.error("JSONP does not support DELETE",{ fileName : "HttpJValue.hx", lineNumber : 138, className : "stx.io.http.HttpJValueJsonp", methodName : "delete"});
	}
	,put: function(url,data,params,headers) {
		return SCore.error("JSONP does not support PUT",{ fileName : "HttpJValue.hx", lineNumber : 134, className : "stx.io.http.HttpJValueJsonp", methodName : "put"});
	}
	,post: function(url,data,params,headers) {
		return SCore.error("JSONP does not support POST",{ fileName : "HttpJValue.hx", lineNumber : 130, className : "stx.io.http.HttpJValueJsonp", methodName : "post"});
	}
	,get: function(url_,params_,headers) {
		var future = new stx.Future();
		var requestId = Math.round(stx.io.http.HttpJValueJsonp.RequestMod * ++stx.io.http.HttpJValueJsonp.RequestCount);
		var callbackName = "stx_jsonp_callback_" + requestId;
		var callbackFullName = "stx.io.http.HttpJValueJsonp.Responders." + callbackName;
		var params = stx.Options.getOrElseC(stx.Options.toOption(params_),stx.ds.Map.create()).set(this.callbackParameterName,callbackFullName);
		var url = stx.net.UrlExtensions.addQueryParameters(url_,params);
		var doCleanup = function() {
			var script = stx.js.Env.document.getElementById(callbackName);
			if(script != null) stx.js.Env.document.getElementsByTagName("HEAD")[0].removeChild(script);
			Reflect.deleteField(stx.io.http.HttpJValueJsonp.Responders,callbackName);
		};
		future.ifCanceled(doCleanup);
		stx.io.http.HttpJValueJsonp.Responders[callbackName] = function(data) {
			doCleanup();
			var code;
			var response;
			try {
				response = stx.Option.Some(stx.io.json.Json.fromObject(data));
				code = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.OK));
			} catch( e ) {
				response = stx.Option.None;
				code = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.NoContent));
			}
			future.deliver({ body : response, headers : stx.ds.Map.create(), code : code},{ fileName : "HttpJValue.hx", lineNumber : 111, className : "stx.io.http.HttpJValueJsonp", methodName : "get"});
		};
		var script = stx.js.Env.document.createElement("SCRIPT");
		script.setAttribute("type","text/javascript");
		script.setAttribute("src",url);
		script.setAttribute("id",callbackName);
		stx.js.Env.document.getElementsByTagName("HEAD")[0].appendChild(script);
		return future;
	}
	,callbackParameterName: null
	,__class__: stx.io.http.HttpJValueJsonp
}
stx.io.http.HttpString = $hxClasses["stx.io.http.HttpString"] = function() { }
stx.io.http.HttpString.__name__ = ["stx","io","http","HttpString"];
stx.io.http.HttpString.__interfaces__ = [stx.io.http.Http];
stx.io.http.HttpStringAsync = $hxClasses["stx.io.http.HttpStringAsync"] = function() {
};
stx.io.http.HttpStringAsync.__name__ = ["stx","io","http","HttpStringAsync"];
stx.io.http.HttpStringAsync.__interfaces__ = [stx.io.http.HttpString];
stx.io.http.HttpStringAsync.prototype = {
	makeHeader: function(_headers,contentType) {
		return stx.Options.getOrElseC(stx.Options.toOption(_headers),stx.ds.Map.create().set("Content-Type",contentType));
	}
	,custom: function(method,_url,data,_params,_headers) {
		var url = _params != null?stx.net.UrlExtensions.addQueryParameters(_url,stx.Options.getOrElseC(stx.Options.toOption(_params),stx.ds.Map.create())):_url;
		var future = new stx.Future();
		var request = stx.js.dom.Quirks.createXMLHttpRequest();
		future.ifCanceled(function() {
			try {
				request.abort();
			} catch( e ) {
			}
		});
		request.onreadystatechange = function() {
			var toBody = function(text) {
				return text == null || text.length == 0?stx.Option.None:stx.Option.Some(text);
			};
			if(request.readyState == stx.js.XmlHttpRequestState.DONE) {
				var responseHeaders = request.getAllResponseHeaders() == null?"":request.getAllResponseHeaders();
				future.deliver({ body : toBody(request.responseText), headers : stx.net.HttpHeaderExtensions.toHttpHeaders(responseHeaders), code : stx.net.HttpResponseCodeExtensions.toHttpResponseCode(request.status)},{ fileName : "HttpString.hx", lineNumber : 84, className : "stx.io.http.HttpStringAsync", methodName : "custom"});
			}
		};
		try {
			request.open(method,url,true);
		} catch( e ) {
			future.cancel();
		}
		stx.Options.map(stx.Options.toOption(_headers),function(headers) {
			stx.functional.FoldableExtensions.foreach(headers,function(header) {
				request.setRequestHeader(header.fst(),header.snd());
			});
		});
		request.send(data);
		return future;
	}
	,'delete': function(url,params,headers) {
		return this.custom("DELETE",url,null,params,headers);
	}
	,put: function(url,data,params,headers) {
		return this.custom("PUT",url,data,params,this.makeHeader(headers,"application/x-www-form-urlencoded"));
	}
	,post: function(url,data,params,headers) {
		return this.custom("POST",url,data,params,this.makeHeader(headers,"application/x-www-form-urlencoded"));
	}
	,get: function(url,params,headers) {
		return this.custom("GET",url,null,params,headers);
	}
	,__class__: stx.io.http.HttpStringAsync
}
stx.io.http.HttpXml = $hxClasses["stx.io.http.HttpXml"] = function() { }
stx.io.http.HttpXml.__name__ = ["stx","io","http","HttpXml"];
stx.io.http.HttpXml.__interfaces__ = [stx.io.http.Http];
if(!stx.io.json) stx.io.json = {}
stx.io.json.CollectionsJValue = $hxClasses["stx.io.json.CollectionsJValue"] = function() {
};
stx.io.json.CollectionsJValue.__name__ = ["stx","io","json","CollectionsJValue"];
stx.io.json.CollectionsJValue.prototype = {
	__class__: stx.io.json.CollectionsJValue
}
stx.io.json.SetJValue = $hxClasses["stx.io.json.SetJValue"] = function() { }
stx.io.json.SetJValue.__name__ = ["stx","io","json","SetJValue"];
stx.io.json.SetJValue.decompose = function(v) {
	return stx.io.json.ArrayJValue.decompose(IterableLambda.toArray(v));
}
stx.io.json.SetJValue.extract = function(v,e,order,equal,hash,show) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = stx.ds.Set.create(order,equal,hash,show).addAll(ArrayLambda.map(v1,e));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 40, className : "stx.io.json.SetJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.ListJValue = $hxClasses["stx.io.json.ListJValue"] = function() { }
stx.io.json.ListJValue.__name__ = ["stx","io","json","ListJValue"];
stx.io.json.ListJValue.decompose = function(l) {
	return stx.io.json.ArrayJValue.decompose(IterableLambda.toArray(l));
}
stx.io.json.ListJValue.extract = function(v,e,tool) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = stx.ds.List.create(tool).addAll(ArrayLambda.map(v1,e));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 53, className : "stx.io.json.ListJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.MapJValue = $hxClasses["stx.io.json.MapJValue"] = function() { }
stx.io.json.MapJValue.__name__ = ["stx","io","json","MapJValue"];
stx.io.json.MapJValue.decompose = function(v) {
	return stx.io.json.ArrayJValue.decompose(IterableLambda.toArray(v));
}
stx.io.json.MapJValue.extract = function(v,ke,ve,korder,kequal,khash,kshow,vorder,vequal,vhash,vshow) {
	var te = function(abc) {
		return stx.io.json.Tuple2JValue.extract(abc,ke,ve);
	};
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = stx.ds.Map.create(korder,kequal,khash,kshow,vorder,vequal,vhash,vshow).addAll(ArrayLambda.map(v1,te));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "CollectionsJValue.hx", lineNumber : 68, className : "stx.io.json.MapJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
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
stx.io.json.JValueExtensions = $hxClasses["stx.io.json.JValueExtensions"] = function() { }
stx.io.json.JValueExtensions.__name__ = ["stx","io","json","JValueExtensions"];
stx.io.json.JValueExtensions.decompose = function(v) {
	return v;
}
stx.io.json.JValueExtensions.extract = function(c,v) {
	return v;
}
stx.io.json.JValueExtensions.fold = function(v,initial,f) {
	var cur = initial;
	stx.io.json.JValueExtensions.map(v,function(j) {
		cur = f(cur,j);
		return j;
	});
	return cur;
}
stx.io.json.JValueExtensions.path = function(v,s) {
	var ss = s.split("/"), c = v;
	var $it0 = HxOverrides.iter(ss);
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(x.length > 0) c = stx.io.json.JValueExtensions.get(c,x);
	}
	return c;
}
stx.io.json.JValueExtensions.map = function(v,f) {
	var $e = (v);
	switch( $e[1] ) {
	case 4:
		var xs = $e[2];
		return f(stx.io.json.JValue.JArray(ArrayLambda.map(xs,function(x) {
			return stx.io.json.JValueExtensions.map(x,f);
		})));
	case 6:
		var v1 = $e[3], k = $e[2];
		return f(stx.io.json.JValue.JField(k,stx.io.json.JValueExtensions.map(v1,f)));
	case 5:
		var fs = $e[2];
		return f(stx.io.json.JValue.JObject(ArrayLambda.map(fs,function(field) {
			return stx.io.json.JValueExtensions.map(field,f);
		})));
	default:
		return f(v);
	}
}
stx.io.json.JValueExtensions.getOption = function(v,k) {
	var $e = (v);
	switch( $e[1] ) {
	case 5:
		var xs = $e[2];
		var hash = stx.io.json.JValueExtensions.extractMap(v);
		return hash.exists(k)?stx.Option.Some(hash.get(k)):stx.Option.None;
	default:
		return stx.Option.None;
	}
}
stx.io.json.JValueExtensions.get = function(v,k) {
	return (function($this) {
		var $r;
		var $e = (stx.io.json.JValueExtensions.getOption(v,k));
		switch( $e[1] ) {
		case 1:
			var v1 = $e[2];
			$r = v1;
			break;
		case 0:
			$r = SCore.error("Expected to find field " + k + " in " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 80, className : "stx.io.json.JValueExtensions", methodName : "get"});
			break;
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.getOrElse = function(v,k,def) {
	return (function($this) {
		var $r;
		var $e = (stx.io.json.JValueExtensions.getOption(v,k));
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
stx.io.json.JValueExtensions.extractString = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			var s = $e[2];
			$r = s;
			break;
		default:
			$r = SCore.error("Expected JString but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 93, className : "stx.io.json.JValueExtensions", methodName : "extractString"});
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.extractNumber = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 2:
			var n = $e[2];
			$r = n;
			break;
		default:
			$r = SCore.error("Expected JNumber but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 100, className : "stx.io.json.JValueExtensions", methodName : "extractNumber"});
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.extractBool = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 1:
			var b = $e[2];
			$r = b;
			break;
		default:
			$r = SCore.error("Expected JBool but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 107, className : "stx.io.json.JValueExtensions", methodName : "extractBool"});
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.extractKey = function(v) {
	return stx.io.json.JValueExtensions.extractField(v).fst();
}
stx.io.json.JValueExtensions.extractValue = function(v) {
	return stx.io.json.JValueExtensions.extractField(v).snd();
}
stx.io.json.JValueExtensions.extractField = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 6:
			var v1 = $e[3], k = $e[2];
			$r = new stx.Tuple2(k,v1);
			break;
		default:
			$r = SCore.error("Expected JField but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 119, className : "stx.io.json.JValueExtensions", methodName : "extractField"});
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.extractMap = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 5:
			var xs = $e[2];
			$r = (function($this) {
				var $r;
				var hash = new Map();
				{
					var _g = 0;
					while(_g < xs.length) {
						var x = xs[_g];
						++_g;
						var field = stx.io.json.JValueExtensions.extractField(x);
						hash.set(field.fst(),field.snd());
					}
				}
				$r = hash;
				return $r;
			}($this));
			break;
		default:
			$r = SCore.error("Expected JObject but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 135, className : "stx.io.json.JValueExtensions", methodName : "extractMap"});
		}
		return $r;
	}(this));
}
stx.io.json.JValueExtensions.extractFields = function(v) {
	return ArrayLambda.flatMap(stx.io.json.JValueExtensions.extractArray(v),function(j) {
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
stx.io.json.JValueExtensions.extractArray = function(v) {
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
			$r = SCore.error("Expected JArray or JObject but found: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 153, className : "stx.io.json.JValueExtensions", methodName : "extractArray"});
		}
		return $r;
	}(this));
}
stx.io.json.OptionJValue = $hxClasses["stx.io.json.OptionJValue"] = function() { }
stx.io.json.OptionJValue.__name__ = ["stx","io","json","OptionJValue"];
stx.io.json.OptionJValue.decompose = function(v) {
	return stx.Options.getOrElse(stx.Options.map(v,function(v1) {
		return (stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](v1)))(v1);
	}),stx.Anys.toThunk(stx.io.json.JValue.JNull));
}
stx.io.json.OptionJValue.extract = function(c,v,e) {
	return (function($this) {
		var $r;
		switch( (v)[1] ) {
		case 0:
			$r = stx.Option.None;
			break;
		default:
			$r = stx.Option.Some(e(v));
		}
		return $r;
	}(this));
}
stx.io.json.AbstractProductJValue = $hxClasses["stx.io.json.AbstractProductJValue"] = function() { }
stx.io.json.AbstractProductJValue.__name__ = ["stx","io","json","AbstractProductJValue"];
stx.io.json.AbstractProductJValue.productDecompose = function(t) {
	return stx.io.json.JValue.JArray(ArrayLambda.map(t.elements(),function(t1) {
		return (stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](t1)))(t1);
	}));
}
stx.io.json.Tuple2JValue = $hxClasses["stx.io.json.Tuple2JValue"] = function() { }
stx.io.json.Tuple2JValue.__name__ = ["stx","io","json","Tuple2JValue"];
stx.io.json.Tuple2JValue.extract = function(v,e1,e2) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = new stx.Tuple2(e1(v1[0]),e2(v1[1]));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 186, className : "stx.io.json.Tuple2JValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.Tuple2JValue.decompose = function(t) {
	return stx.io.json.AbstractProductJValue.productDecompose(t);
}
stx.io.json.Tuple3JValue = $hxClasses["stx.io.json.Tuple3JValue"] = function() { }
stx.io.json.Tuple3JValue.__name__ = ["stx","io","json","Tuple3JValue"];
stx.io.json.Tuple3JValue.decompose = function(t) {
	return stx.io.json.AbstractProductJValue.productDecompose(t);
}
stx.io.json.Tuple3JValue.extract = function(v,e1,e2,e3) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = new stx.Tuple3(e1(v1[0]),e2(v1[1]),e3(v1[2]));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 201, className : "stx.io.json.Tuple3JValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.Tuple4JValue = $hxClasses["stx.io.json.Tuple4JValue"] = function() { }
stx.io.json.Tuple4JValue.__name__ = ["stx","io","json","Tuple4JValue"];
stx.io.json.Tuple4JValue.decompose = function(t) {
	return stx.io.json.AbstractProductJValue.productDecompose(t);
}
stx.io.json.Tuple4JValue.extract = function(v,e1,e2,e3,e4) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = new stx.Tuple4(e1(v1[0]),e2(v1[1]),e3(v1[2]),e4(v1[3]));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 213, className : "stx.io.json.Tuple4JValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.Tuple5JValue = $hxClasses["stx.io.json.Tuple5JValue"] = function() { }
stx.io.json.Tuple5JValue.__name__ = ["stx","io","json","Tuple5JValue"];
stx.io.json.Tuple5JValue.decompose = function(t) {
	return stx.io.json.AbstractProductJValue.productDecompose(t);
}
stx.io.json.Tuple5JValue.extract = function(v,e1,e2,e3,e4,e5) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = new stx.Tuple5(e1(v1[0]),e2(v1[1]),e3(v1[2]),e4(v1[3]),e5(v1[4]));
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "JValueExtensions.hx", lineNumber : 225, className : "stx.io.json.Tuple5JValue", methodName : "extract"});
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
		return ArrayLambda.map(xs,function(x) {
			return stx.io.json.Json.toObject(x);
		});
	case 5:
		var fs = $e[2];
		return ArrayLambda.foldl(fs,{ },function(o,e) {
			var field = stx.io.json.JValueExtensions.extractField(e);
			o[field.fst()] = stx.io.json.Json.toObject(field.snd());
			return o;
		});
	case 6:
		var v1 = $e[3], k = $e[2];
		return SCore.error("Cannot convert JField to object",{ fileName : "Json.hx", lineNumber : 47, className : "stx.io.json.Json", methodName : "toObject"});
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
		if(js.Boot.__instanceof(d,String)) return stx.io.json.JValue.JString(d); else if(js.Boot.__instanceof(d,Map)) return stx.io.json.JValue.JObject(d.keys.toArray().map(function(k) {
			return stx.io.json.JValue.JField(k,d.get(k));
		})); else if(js.Boot.__instanceof(d,Array)) return stx.io.json.JValue.JArray(ArrayLambda.map(js.Boot.__cast(d , Array),stx.io.json.Json.fromObject)); else return SCore.error("Unknown object type: " + Std.string(d),{ fileName : "Json.hx", lineNumber : 57, className : "stx.io.json.Json", methodName : "fromObject"});
		break;
	case 7:
		var e = $e[2];
		return SCore.error("Json.fromObject does not support enum conversions.",{ fileName : "Json.hx", lineNumber : 59, className : "stx.io.json.Json", methodName : "fromObject"});
	case 5:
		return SCore.error("Json.fromObject does not support function conversions.",{ fileName : "Json.hx", lineNumber : 60, className : "stx.io.json.Json", methodName : "fromObject"});
	case 0:
		return stx.io.json.JValue.JNull;
	case 3:
		return stx.io.json.JValue.JBool(d);
	case 1:
		return stx.io.json.JValue.JNumber(d);
	case 2:
		return stx.io.json.JValue.JNumber(d);
	case 4:
		return stx.io.json.JValue.JObject(ArrayLambda.map(Reflect.fields(d),function(f) {
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
		return "[" + ArrayLambda.map(xs,stx.io.json.Json.encode).join(",") + "]";
	case 5:
		var fs = $e[2];
		return "{" + ArrayLambda.map(fs,function(f) {
			var field = stx.io.json.JValueExtensions.extractField(f);
			return stx.io.json.Json.encode(stx.io.json.JValue.JString(field.fst())) + ":" + stx.io.json.Json.encode(field.snd());
		}).join(",") + "}";
	case 6:
		var v1 = $e[3], k = $e[2];
		return SCore.error("Cannot encode JField",{ fileName : "Json.hx", lineNumber : 84, className : "stx.io.json.Json", methodName : "encode"});
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
			if(state == 1 && value != null) stx.io.json.JValueExtensions.extractArray(last).push(value); else if(state == 3 && name != null && value != null) {
				stx.io.json.JValueExtensions.extractArray(last).push(stx.io.json.JValue.JField(name,value));
				state = 2;
			}
			value = null;
			break;
		case 10:
			if(state == 2) {
				name = stx.io.json.JValueExtensions.extractString(value);
				state = 3;
			} else throw "Non-sequitur colon on line " + line + " (character " + i + ", state " + state + ")";
			break;
		case 5:
			if(state <= 1) throw "Unmatched closing brace on line " + line + " (character " + i + ")";
			if(name != null && value != null) stx.io.json.JValueExtensions.extractArray(last).push(stx.io.json.JValue.JField(name,value));
			value = current.pop();
			state = states.pop();
			name = names.pop();
			if(current.length > 0) last = current[current.length - 1];
			break;
		case 9:
			if(state != 1) throw "Unmatched closing square bracket on line " + line + " (character " + i + ")";
			if(value != null) stx.io.json.JValueExtensions.extractArray(last).push(value);
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
				if(s1 == "n") return "\n"; else if(s1 == "r") return "\r"; else if(s1 == "b") return String.fromCharCode(8); else if(s1 == "f") return String.fromCharCode(12); else if(s1 == "t") return "\t"; else if(s1 == "\\") return "\\"; else if(s1 == "\"") return "\""; else if(s1 == "/") return "/"; else return String.fromCharCode(Std.parseInt("0x" + HxOverrides.substr(s1,1,null)));
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
stx.io.json.PrimitivesJValue = $hxClasses["stx.io.json.PrimitivesJValue"] = function() { }
stx.io.json.PrimitivesJValue.__name__ = ["stx","io","json","PrimitivesJValue"];
stx.io.json.StringJValue = $hxClasses["stx.io.json.StringJValue"] = function() { }
stx.io.json.StringJValue.__name__ = ["stx","io","json","StringJValue"];
stx.io.json.StringJValue.decompose = function(v) {
	return stx.io.json.JValue.JString(v);
}
stx.io.json.StringJValue.extract = function(c,val) {
	return (function($this) {
		var $r;
		var $e = (val);
		switch( $e[1] ) {
		case 2:
			var v = $e[2];
			$r = stx.ds.plus.FloatShow.toString(v);
			break;
		case 1:
			var v = $e[2];
			$r = stx.ds.plus.BoolShow.toString(v);
			break;
		case 3:
			var v = $e[2];
			$r = v;
			break;
		default:
			$r = SCore.error("Expected String but found: " + Std.string(val),{ fileName : "PrimitivesJValue.hx", lineNumber : 36, className : "stx.io.json.StringJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.BoolJValue = $hxClasses["stx.io.json.BoolJValue"] = function() { }
stx.io.json.BoolJValue.__name__ = ["stx","io","json","BoolJValue"];
stx.io.json.BoolJValue.decompose = function(v) {
	return stx.io.json.JValue.JBool(v);
}
stx.io.json.BoolJValue.extract = function(c,v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 1:
			var v1 = $e[2];
			$r = v1;
			break;
		case 2:
			var v1 = $e[2];
			$r = v1 == 0.0?false:true;
			break;
		case 3:
			var v1 = $e[2];
			$r = stx.Strings.toBool(v1);
			break;
		default:
			$r = SCore.error("Expected Bool but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 50, className : "stx.io.json.BoolJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.IntJValue = $hxClasses["stx.io.json.IntJValue"] = function() { }
stx.io.json.IntJValue.__name__ = ["stx","io","json","IntJValue"];
stx.io.json.IntJValue.decompose = function(v) {
	return stx.io.json.JValue.JNumber(v);
}
stx.io.json.IntJValue.extract = function(c,v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 2:
			var v1 = $e[2];
			$r = stx.Floats["int"](v1);
			break;
		case 3:
			var v1 = $e[2];
			$r = stx.Strings["int"](v1);
			break;
		default:
			$r = SCore.error("Expected Int but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 63, className : "stx.io.json.IntJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.FloatJValue = $hxClasses["stx.io.json.FloatJValue"] = function() { }
stx.io.json.FloatJValue.__name__ = ["stx","io","json","FloatJValue"];
stx.io.json.FloatJValue.decompose = function(v) {
	return stx.io.json.JValue.JNumber(v);
}
stx.io.json.FloatJValue.extract = function(c,v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 2:
			var v1 = $e[2];
			$r = v1;
			break;
		case 3:
			var v1 = $e[2];
			$r = stx.Strings.toFloat(v1);
			break;
		default:
			$r = SCore.error("Expected Float but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 76, className : "stx.io.json.FloatJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.DateJValue = $hxClasses["stx.io.json.DateJValue"] = function() { }
stx.io.json.DateJValue.__name__ = ["stx","io","json","DateJValue"];
stx.io.json.DateJValue.decompose = function(v) {
	return stx.io.json.JValue.JNumber(v.getTime());
}
stx.io.json.DateJValue.extract = function(c,v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 2:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var d = new Date();
				d.setTime(v1);
				$r = d;
				return $r;
			}($this));
			break;
		case 3:
			var v1 = $e[2];
			$r = (function($this) {
				var $r;
				var d = new Date();
				d.setTime(stx.Strings.toFloat(v1));
				$r = d;
				return $r;
			}($this));
			break;
		default:
			$r = SCore.error("Expected Number but found: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 89, className : "stx.io.json.DateJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.ObjectJValue = $hxClasses["stx.io.json.ObjectJValue"] = function() { }
stx.io.json.ObjectJValue.__name__ = ["stx","io","json","ObjectJValue"];
stx.io.json.ObjectJValue.decompose = function(d) {
	return stx.io.json.JValue.JObject(ArrayLambda.map(Reflect.fields(d),function(f) {
		var val = Reflect.field(d,f);
		return stx.io.json.JValue.JField(f,(stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](val)))(val));
	}));
}
stx.io.json.ObjectJValue.extract = function(v) {
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
		return ArrayLambda.map(xs,function(x) {
			return stx.io.json.ObjectJValue.extract(x);
		});
	case 5:
		var fs = $e[2];
		return ArrayLambda.foldl(fs,{ },function(o,e) {
			var field = stx.io.json.JValueExtensions.extractField(e);
			o[field.fst()] = stx.io.json.ObjectJValue.extract(field.snd());
			return o;
		});
	case 6:
		var v1 = $e[3], k = $e[2];
		return SCore.error("Cannot convert JField to object",{ fileName : "PrimitivesJValue.hx", lineNumber : 120, className : "stx.io.json.ObjectJValue", methodName : "extract"});
	}
}
stx.io.json.ArrayJValue = $hxClasses["stx.io.json.ArrayJValue"] = function() { }
stx.io.json.ArrayJValue.__name__ = ["stx","io","json","ArrayJValue"];
stx.io.json.ArrayJValue.decompose = function(v) {
	return ArrayLambda.size(v) != 0?(function($this) {
		var $r;
		var d = stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](v[0]));
		$r = stx.io.json.JValue.JArray(ArrayLambda.map(v,d));
		return $r;
	}(this)):stx.io.json.JValue.JArray([]);
}
stx.io.json.ArrayJValue.extract = function(c,v,e) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 4:
			var v1 = $e[2];
			$r = ArrayLambda.map(v1,e);
			break;
		default:
			$r = SCore.error("Expected Array but was: " + Std.string(v),{ fileName : "PrimitivesJValue.hx", lineNumber : 138, className : "stx.io.json.ArrayJValue", methodName : "extract"});
		}
		return $r;
	}(this));
}
stx.io.json.ExtractorHelpers = $hxClasses["stx.io.json.ExtractorHelpers"] = function() { }
stx.io.json.ExtractorHelpers.__name__ = ["stx","io","json","ExtractorHelpers"];
stx.io.json.ExtractorHelpers.extractFieldValue = function(j,n,e,def) {
	var fieldValue = stx.io.json.JValueExtensions.getOrElse(j,n,stx.Anys.toThunk(def));
	try {
		return e(fieldValue);
	} catch( err ) {
		return e(def);
	}
}
stx.io.json.MapOps = $hxClasses["stx.io.json.MapOps"] = function() { }
stx.io.json.MapOps.__name__ = ["stx","io","json","MapOps"];
stx.io.json.MapOps.stringKeyDecompose = function(v) {
	var it = v.iterator();
	if(it.hasNext()) {
		var dv = stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](it.next().snd()));
		return stx.io.json.JValue.JObject(ArrayLambda.map(IterableLambda.toArray(v),function(t) {
			return stx.io.json.JValue.JField(t.fst(),dv(t.snd()));
		}));
	} else return stx.io.json.JValue.JObject([]);
}
stx.io.json.MapOps.stringKeyExtract = function(v,ve,vorder,vequal,vhash,vshow) {
	var extract0 = function(v1) {
		return stx.ds.Map.create(stx.Strings.compare,stx.Strings.equals,stx.ds.plus.StringHasher.hashCode,stx.Strings.toString,vorder,vequal,vhash,vshow).addAll(ArrayLambda.map(v1,function(j) {
			return (function($this) {
				var $r;
				var $e = (j);
				switch( $e[1] ) {
				case 6:
					var v2 = $e[3], k = $e[2];
					$r = new stx.Tuple2(k,ve(v2));
					break;
				default:
					$r = SCore.error("Expected field but was: " + Std.string(v1),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 76, className : "stx.io.json.MapOps", methodName : "stringKeyExtract"});
				}
				return $r;
			}(this));
		}));
	};
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 5:
			var v1 = $e[2];
			$r = extract0(v1);
			break;
		case 4:
			var v1 = $e[2];
			$r = extract0(v1);
			break;
		default:
			$r = SCore.error("Expected either Array or Object but was: " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 85, className : "stx.io.json.MapOps", methodName : "stringKeyExtract"});
		}
		return $r;
	}(this));
}
stx.io.json.TranscodeJValue = $hxClasses["stx.io.json.TranscodeJValue"] = function() { }
stx.io.json.TranscodeJValue.__name__ = ["stx","io","json","TranscodeJValue"];
stx.io.json.TranscodeJValue._createDecomposeImpl = function(impl) {
	return function(v) {
		return null == v?stx.io.json.JValue.JNull:impl(v);
	};
}
stx.io.json.TranscodeJValue.getDecomposerFor = function(v) {
	return (function($this) {
		var $r;
		var $e = (v);
		switch( $e[1] ) {
		case 3:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.BoolJValue.decompose);
			break;
		case 1:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.IntJValue.decompose);
			break;
		case 2:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.FloatJValue.decompose);
			break;
		case 8:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v1) {
				return SCore.error("Can't decompose TUnknown: " + v1,{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 111, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
			});
			break;
		case 4:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ObjectJValue.decompose);
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getClassName(c)) {
				case "String":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.StringJValue.decompose);
					break;
				case "Date":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.DateJValue.decompose);
					break;
				case "Array":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ArrayJValue.decompose);
					break;
				case "stx.ds.List":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.ListJValue.decompose);
					break;
				case "stx.ds.Map":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.MapJValue.decompose);
					break;
				case "stx.ds.Set":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.SetJValue.decompose);
					break;
				case "stx.Tuple2":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple2JValue.decompose);
					break;
				case "stx.Tuple3":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple3JValue.decompose);
					break;
				case "stx.Tuple4":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple4JValue.decompose);
					break;
				case "stx.Tuple5":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.Tuple5JValue.decompose);
					break;
				default:
					$r = SCore.error("Decompose function cannot be created. " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 138, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
				}
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getEnumName(e)) {
				case "Option":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.OptionJValue.decompose);
					break;
				case "stx.io.json.JValue":
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(stx.io.json.JValueExtensions.decompose);
					break;
				default:
					$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v1) {
						var name = stx.io.json.StringJValue.decompose(Type.getEnumName(e));
						var constructor = stx.io.json.StringJValue.decompose(v1[0]);
						var parameters = stx.io.json.JValue.JArray(ArrayLambda.map(v1.slice(2),function(v2) {
							return (stx.io.json.TranscodeJValue.getDecomposerFor(Type["typeof"](v2)))(v2);
						}));
						return stx.io.json.JValue.JArray([name,constructor,parameters]);
					});
				}
				return $r;
			}($this));
			break;
		case 5:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v1) {
				SCore.error("Can't decompose function.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 153, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
				return stx.io.json.JValue.JNull;
			});
			break;
		case 0:
			$r = function(v1) {
				return stx.io.json.JValue.JNull;
			};
			break;
		default:
			$r = stx.io.json.TranscodeJValue._createDecomposeImpl(function(v1) {
				SCore.error("Can't decompose unknown type.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 157, className : "stx.io.json.TranscodeJValue", methodName : "getDecomposerFor"});
				return stx.io.json.JValue.JNull;
			});
		}
		return $r;
	}(this));
}
stx.io.json.TranscodeJValue._createExtractorImpl = function(impl) {
	return function(v) {
		if(null == v) return null; else return impl(v);
	};
}
stx.io.json.TranscodeJValue.getExtractorFor = function(valueType,args) {
	return (function($this) {
		var $r;
		var $e = (valueType);
		switch( $e[1] ) {
		case 3:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				return stx.io.json.BoolJValue.extract(Bool,v);
			});
			break;
		case 1:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				return stx.io.json.IntJValue.extract(Int,v);
			});
			break;
		case 2:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				return stx.io.json.FloatJValue.extract(Float,v);
			});
			break;
		case 8:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				return SCore.error("Can't extract TUnknown: " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 172, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
			});
			break;
		case 4:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				return stx.io.json.ObjectJValue.extract(v);
			});
			break;
		case 6:
			var c = $e[2];
			$r = (function($this) {
				var $r;
				var t = c;
				var cname = Type.getClassName(c);
				$r = (function($this) {
					var $r;
					switch(cname) {
					case "String":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.StringJValue.extract(String,v);
						});
						break;
					case "Date":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.DateJValue.extract(Date,v);
						});
						break;
					case "Array":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.ArrayJValue.extract(Array,v,args[0]);
						});
						break;
					case "stx.ds.List":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.ListJValue.extract(v,args[0],args[1]);
						});
						break;
					case "stx.ds.Map":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.MapJValue.extract(v,args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
						});
						break;
					case "stx.ds.Set":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.SetJValue.extract(v,args[0],args[1]);
						});
						break;
					case "stx.Tuple2":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.Tuple2JValue.extract(v,args[0],args[1]);
						});
						break;
					case "stx.Tuple3":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.Tuple3JValue.extract(v,args[0],args[1],args[2]);
						});
						break;
					case "stx.Tuple4":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.Tuple4JValue.extract(v,args[0],args[1],args[2],args[3]);
						});
						break;
					case "stx.Tuple5":
						$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
							return stx.io.json.Tuple5JValue.extract(v,args[0],args[1],args[2],args[3],args[4]);
						});
						break;
					default:
						$r = SCore.error("Extract function cannot be created. 'extract' method is missing. Type: " + Std.string(valueType),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 200, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
					}
					return $r;
				}($this));
				return $r;
			}($this));
			break;
		case 7:
			var e = $e[2];
			$r = (function($this) {
				var $r;
				switch(Type.getEnumName(e)) {
				case "Option":
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
						return stx.io.json.OptionJValue.extract(stx.Option,v,args[0]);
					});
					break;
				case "stx.io.json.JValue":
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
						return stx.io.json.JValueExtensions.extract(stx.io.json.JValue,v);
					});
					break;
				default:
					$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
						var $e = (v);
						switch( $e[1] ) {
						case 4:
							var arr = $e[2];
							var name = stx.io.json.StringJValue.extract(String,arr[0]);
							var constructor = stx.io.json.StringJValue.extract(String,arr[1]);
							var parameters = (function($this) {
								var $r;
								var $e = (arr[2]);
								switch( $e[1] ) {
								case 4:
									var a = $e[2];
									$r = (function($this) {
										var $r;
										if(args == null) args = [];
										$r = ArrayLambda.map(stx.Arrays.zip(a,args),function(t) {
											return t.snd()(t.fst());
										});
										return $r;
									}($this));
									break;
								default:
									$r = SCore.error("Expected JArray but was: " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 216, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
								}
								return $r;
							}(this));
							return Type.createEnum(Type.resolveEnum(name),constructor,parameters);
						default:
							SCore.error("Expected JArray but was: " + Std.string(v),{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 220, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
							return null;
						}
					});
				}
				return $r;
			}($this));
			break;
		case 5:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				SCore.error("Can't extract function.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 225, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
				return stx.io.json.JValue.JNull;
			});
			break;
		case 0:
			$r = function(v) {
				return null;
			};
			break;
		default:
			$r = stx.io.json.TranscodeJValue._createExtractorImpl(function(v) {
				SCore.error("Can't extract unknown type.",{ fileName : "TranscodeJValueExtensions.hx", lineNumber : 229, className : "stx.io.json.TranscodeJValue", methodName : "getExtractorFor"});
				return stx.io.json.JValue.JNull;
			});
		}
		return $r;
	}(this));
}
if(!stx.js) stx.js = {}
stx.js.DOMTokenList = $hxClasses["stx.js.DOMTokenList"] = function() { }
stx.js.DOMTokenList.__name__ = ["stx","js","DOMTokenList"];
stx.js.DOMTokenList.prototype = {
	stringifier: null
	,toggle: null
	,remove: null
	,add: null
	,contains: null
	,item: null
	,length: null
	,__class__: stx.js.DOMTokenList
}
stx.js.DOMSettableTokenList = $hxClasses["stx.js.DOMSettableTokenList"] = function() { }
stx.js.DOMSettableTokenList.__name__ = ["stx","js","DOMSettableTokenList"];
stx.js.DOMSettableTokenList.prototype = {
	stringifier: null
	,toggle: null
	,remove: null
	,add: null
	,contains: null
	,item: null
	,length: null
	,value: null
	,__class__: stx.js.DOMSettableTokenList
}
stx.js.DOMStringList = $hxClasses["stx.js.DOMStringList"] = function() { }
stx.js.DOMStringList.__name__ = ["stx","js","DOMStringList"];
stx.js.DOMStringList.prototype = {
	length: null
	,contains: null
	,item: null
	,__class__: stx.js.DOMStringList
}
stx.js.NameList = $hxClasses["stx.js.NameList"] = function() { }
stx.js.NameList.__name__ = ["stx","js","NameList"];
stx.js.NameList.prototype = {
	length: null
	,containsNS: null
	,contains: null
	,getNamespaceURI: null
	,getName: null
	,__class__: stx.js.NameList
}
stx.js.NamedNodeMap = $hxClasses["stx.js.NamedNodeMap"] = function() { }
stx.js.NamedNodeMap.__name__ = ["stx","js","NamedNodeMap"];
stx.js.NamedNodeMap.prototype = {
	length: null
	,removeNamedItemNS: null
	,setNamedItemNS: null
	,getNamedItemNS: null
	,item: null
	,removeNamedItem: null
	,setNamedItem: null
	,getNamedItem: null
	,__class__: stx.js.NamedNodeMap
}
stx.js.TimedTrackCueList = $hxClasses["stx.js.TimedTrackCueList"] = function() { }
stx.js.TimedTrackCueList.__name__ = ["stx","js","TimedTrackCueList"];
stx.js.TimedTrackCueList.prototype = {
	getCueById: null
	,getter: null
	,length: null
	,__class__: stx.js.TimedTrackCueList
}
stx.js.Selection = $hxClasses["stx.js.Selection"] = function() { }
stx.js.Selection.__name__ = ["stx","js","Selection"];
stx.js.Selection.prototype = {
	stringifier: null
	,removeAllRanges: null
	,removeRange: null
	,addRange: null
	,getRangeAt: null
	,deleteFromDocument: null
	,selectAllChildren: null
	,collapseToEnd: null
	,collapseToStart: null
	,collapse: null
	,rangeCount: null
	,isCollapsed: null
	,focusOffset: null
	,focusNode: null
	,anchorOffset: null
	,anchorNode: null
	,__class__: stx.js.Selection
}
stx.js.MessagePortArray = $hxClasses["stx.js.MessagePortArray"] = function() { }
stx.js.MessagePortArray.__name__ = ["stx","js","MessagePortArray"];
stx.js.MessagePort = $hxClasses["stx.js.MessagePort"] = function() { }
stx.js.MessagePort.__name__ = ["stx","js","MessagePort"];
stx.js.MessagePort.prototype = {
	onMessage: null
	,close: null
	,start: null
	,postMessage: null
	,__class__: stx.js.MessagePort
}
stx.js.MediaList = $hxClasses["stx.js.MediaList"] = function() { }
stx.js.MediaList.__name__ = ["stx","js","MediaList"];
stx.js.MediaList.prototype = {
	appendMedium: null
	,deleteMedium: null
	,item: null
	,length: null
	,mediaText: null
	,__class__: stx.js.MediaList
}
stx.js.Env = $hxClasses["stx.js.Env"] = function() { }
stx.js.Env.__name__ = ["stx","js","Env"];
stx.js.Env.eq = function(a,b) {
	return (function(a, b) { return a === b; })(a,b);
}
stx.js.Env.alert = function(a) {
	alert(Std.string(a));
}
stx.js.Env.decodeURI = function(uri) {
	return decodeURI(uri);
}
stx.js.Env.decodeURIComponent = function(uriComponent) {
	return decodeURIComponent(uriComponent);
}
stx.js.Env.encodeURI = function(uri) {
	return encodeURI(uri);
}
stx.js.Env.encodeURIComponent = function(uriComponent) {
	return encodeURIComponent(uriComponent);
}
stx.js.Env.escape = function(string) {
	return escape(string);
}
stx.js.Env.unescape = function(string) {
	return unescape(string);
}
stx.js.Env.eval = function(string) {
	return eval(string);
}
stx.js.Env.isFinite = function(number) {
	return isFinite(number);
}
stx.js.Env.isNaN = function(number) {
	return isNaN(number);
}
stx.js.Env.isDefined = function(d) {
	return stx.js.Env.typeOf(d) != "undefined";
}
stx.js.Env.isDefinedGlobal = function(s) {
	return (function(s){return typeof window[s] != "undefined";})(s);
}
stx.js.Env.typeOf = function(d) {
	return typeof d;
}
stx.js.Env.getElementsByClass = function(className,tag,elm) {
	var getFunc = 
      /*
        Developed by Robert Nyman, http://www.robertnyman.com
        Code/licensing: http://code.google.com/p/getelementsbyclassname/
      */  
      function (className, tag, elm){
        if (document.getElementsByClassName) {
          getElementsByClassName = function (className, tag, elm) {
            elm = elm || document;
            var elements = elm.getElementsByClassName(className),
              nodeName = (tag)? new RegExp("\b" + tag + "\b", "i") : null,
              returnElements = [],
              current;
            for(var i=0, il=elements.length; i<il; i+=1){
              current = elements[i];
              if(!nodeName || nodeName.test(current.nodeName)) {
                returnElements.push(current);
              }
            }
            return returnElements;
          };
        }
        else if (document.evaluate) { 
          getElementsByClassName = function (className, tag, elm) {
            tag = tag || "*";
            elm = elm || document;
            var space = " ";
            var classes = className.split(" "),
              classesToCheck = "",
              xhtmlNamespace = "http://www.w3.org/1999/xhtml",
              namespaceResolver = (document.documentElement.namespaceURI === xhtmlNamespace)? xhtmlNamespace : null,
              returnElements = [],
              elements,
              node;
            for(var j=0, jl=classes.length; j<jl; j+=1){
              classesToCheck += "[contains(concat(space, @class, space), (space + classes[j] + space))]";
            }
            try  {
              elements = document.evaluate(".//" + tag + classesToCheck, elm, namespaceResolver, 0, null);
            }
            catch (e) {
              elements = document.evaluate(".//" + tag + classesToCheck, elm, null, 0, null);
            }
            while ((node = elements.iterateNext())) {
              returnElements.push(node);
            }
            return returnElements;
          };
        }
        else if (document.getElementsByTagName("*")) { 
          getElementsByClassName = function(className, tag, elm) {
            var result = new Array;
            var tag = tag || "*";
            var elm = elm || document;
            
            var elements = elm.getElementsByTagName(tag);
               
            for(var i=0;i<elements.length;i++){
              var pattern = new RegExp(className, "i");
              
              if(pattern.test(elements[i].className)){
                 result.push(elements[i]);
              }
            }
            
            return result;
          };
        }
        else {
          getElementsByClassName = function (className, tag, elm) {
            tag = tag || "*";
            elm = elm || document;
            var classes = className.split(" "),
              classesToCheck = [],
              elements = (tag === "*" && elm.all)? elm.all : elm.getElementsByTagName(tag),
              current,
              returnElements = [],
              match;
            for(var k=0, kl=classes.length; k<kl; k+=1){
              classesToCheck.push(new RegExp("(^|\s)" + classes[k] + "(\s|$)"));
            }
            for(var l=0, ll=elements.length; l<ll; l+=1){
              current = elements[l];
              match = false;
              for(var m=0, ml=classesToCheck.length; m<ml; m+=1){
                match = classesToCheck[m].test(current.className);
                if (!match) {
                  break;
                }
              }
              if (match) {
                returnElements.push(current);
              }
            }
            return returnElements;
          };
        }
        return getElementsByClassName(className, tag, elm);
      };
    
    ;
	return getFunc(className,tag,elm);
}
stx.js.Env.setCookie = function(name,value,expires,path,domain,secure) {
	var now = new Date();
	var secure1 = secure == true?"secure":"";
	var myCookie = stx.js.Env.asCookiePair(name,value,false) + stx.js.Env.getCookieExpiration(expires) + stx.js.Env.asCookiePair("path",path,true,"/") + stx.js.Env.asCookiePair("domain",domain,true) + secure1;
	stx.js.Env.document.cookie = myCookie;
}
stx.js.Env.getCookie = function(name) {
	var cookieArray = stx.js.Env.getCookies();
	var result = null;
	var _g1 = 0, _g = cookieArray.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(StringTools.startsWith(cookieArray[i],name)) result = cookieArray[i].split("=")[1];
	}
	return result;
}
stx.js.Env.getCookies = function() {
	return stx.js.Env.document.cookie.split(";");
}
stx.js.Env.getCookieExpiration = function(expires) {
	return expires != null?(function($this) {
		var $r;
		var result = (function($this) {
			var $r;
			var d = new Date();
			d.setTime(new Date().getTime() + expires * 1000 * 60 * 60 * 24);
			$r = d;
			return $r;
		}($this));
		$r = ";expires=" + Std.string(result.toGMTString());
		return $r;
	}(this)):"";
}
stx.js.Env.asCookiePair = function(n,v,withSemi,ifNull) {
	if(withSemi == null) withSemi = true;
	var suffix = withSemi?";":"";
	return v != null?suffix + n + "=" + v:ifNull != null?suffix + n + "=" + ifNull:"";
}
stx.js.XmlHttpRequestState = $hxClasses["stx.js.XmlHttpRequestState"] = function() { }
stx.js.XmlHttpRequestState.__name__ = ["stx","js","XmlHttpRequestState"];
stx.js.ExceptionCode = $hxClasses["stx.js.ExceptionCode"] = function() { }
stx.js.ExceptionCode.__name__ = ["stx","js","ExceptionCode"];
stx.js.NodeType = $hxClasses["stx.js.NodeType"] = function() { }
stx.js.NodeType.__name__ = ["stx","js","NodeType"];
stx.js.DocumentPosition = $hxClasses["stx.js.DocumentPosition"] = function() { }
stx.js.DocumentPosition.__name__ = ["stx","js","DocumentPosition"];
stx.js.DerivationMethod = $hxClasses["stx.js.DerivationMethod"] = function() { }
stx.js.DerivationMethod.__name__ = ["stx","js","DerivationMethod"];
stx.js.OperationType = $hxClasses["stx.js.OperationType"] = function() { }
stx.js.OperationType.__name__ = ["stx","js","OperationType"];
stx.js.ErrorState = $hxClasses["stx.js.ErrorState"] = function() { }
stx.js.ErrorState.__name__ = ["stx","js","ErrorState"];
stx.js.ReadyState = $hxClasses["stx.js.ReadyState"] = function() { }
stx.js.ReadyState.__name__ = ["stx","js","ReadyState"];
stx.js.EventExceptionCode = $hxClasses["stx.js.EventExceptionCode"] = function() { }
stx.js.EventExceptionCode.__name__ = ["stx","js","EventExceptionCode"];
stx.js.DeltaModeCode = $hxClasses["stx.js.DeltaModeCode"] = function() { }
stx.js.DeltaModeCode.__name__ = ["stx","js","DeltaModeCode"];
stx.js.InputModeCode = $hxClasses["stx.js.InputModeCode"] = function() { }
stx.js.InputModeCode.__name__ = ["stx","js","InputModeCode"];
stx.js.KeyLocationCode = $hxClasses["stx.js.KeyLocationCode"] = function() { }
stx.js.KeyLocationCode.__name__ = ["stx","js","KeyLocationCode"];
stx.js.PhaseType = $hxClasses["stx.js.PhaseType"] = function() { }
stx.js.PhaseType.__name__ = ["stx","js","PhaseType"];
stx.js.AttrChangeType = $hxClasses["stx.js.AttrChangeType"] = function() { }
stx.js.AttrChangeType.__name__ = ["stx","js","AttrChangeType"];
stx.js.AcceptNodeConstants = $hxClasses["stx.js.AcceptNodeConstants"] = function() { }
stx.js.AcceptNodeConstants.__name__ = ["stx","js","AcceptNodeConstants"];
stx.js.WhatToShowConstants = $hxClasses["stx.js.WhatToShowConstants"] = function() { }
stx.js.WhatToShowConstants.__name__ = ["stx","js","WhatToShowConstants"];
stx.js.RangeExceptionCode = $hxClasses["stx.js.RangeExceptionCode"] = function() { }
stx.js.RangeExceptionCode.__name__ = ["stx","js","RangeExceptionCode"];
stx.js.CompareHow = $hxClasses["stx.js.CompareHow"] = function() { }
stx.js.CompareHow.__name__ = ["stx","js","CompareHow"];
stx.js.RuleType = $hxClasses["stx.js.RuleType"] = function() { }
stx.js.RuleType.__name__ = ["stx","js","RuleType"];
stx.js.CSSValueType = $hxClasses["stx.js.CSSValueType"] = function() { }
stx.js.CSSValueType.__name__ = ["stx","js","CSSValueType"];
stx.js.PrimitiveType = $hxClasses["stx.js.PrimitiveType"] = function() { }
stx.js.PrimitiveType.__name__ = ["stx","js","PrimitiveType"];
stx.js.UpdateStatus = $hxClasses["stx.js.UpdateStatus"] = function() { }
stx.js.UpdateStatus.__name__ = ["stx","js","UpdateStatus"];
stx.js.ErrorSeverity = $hxClasses["stx.js.ErrorSeverity"] = function() { }
stx.js.ErrorSeverity.__name__ = ["stx","js","ErrorSeverity"];
if(!stx.js.detect) stx.js.detect = {}
stx.js.detect.BrowserSupport = $hxClasses["stx.js.detect.BrowserSupport"] = function() { }
stx.js.detect.BrowserSupport.__name__ = ["stx","js","detect","BrowserSupport"];
stx.js.detect.BrowserSupport.cssTransformationSupported = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("cssTransformationSupported",function(v) {
		var isSupported = stx.Option.None;
		var docEl = stx.js.Env.document.documentElement;
		if(docEl != null) {
			var s = docEl.style;
			isSupported = stx.Option.Some(stx.js.Env.isDefined(s.WebkitTransform) || stx.js.Env.isDefined(s.MozTransform));
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.elementTagnameUppercased = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("elementTagnameUppercased",function(v) {
		var isUppercased = stx.Option.None;
		var docEl = stx.js.Env.document.documentElement;
		if(docEl != null) isUppercased = stx.Option.Some("HTML" == docEl.nodeName);
		return isUppercased;
	});
}
stx.js.detect.BrowserSupport.querySelectorIgnoresCapitalizedValuesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("querySelectorIgnoresCapitalizedValuesBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && stx.js.Env.document.compatMode == "BackCompat") {
			var el = stx.js.Env.document.createElement("div");
			var el2 = stx.js.Env.document.createElement("span");
			if(el != null && el2 != null && el.querySelector != null) {
				el2.className = "Test";
				el.appendChild(el2);
				result = stx.Option.Some(el.querySelector(".Test") != null);
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isEventSrcelementPresent = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isEventSrcelementPresent",function(v) {
		var isSupported = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var i = stx.js.Env.document.createElement("input");
			var root = stx.js.Env.document.documentElement;
			if(i != null && i.style != null && $bind(i,i.click) != null && root != null && $bind(root,root.appendChild) != null && $bind(root,root.removeChild) != null) {
				i.type = "checkbox";
				i.style.display = "none";
				i.onclick = function(e) {
					if(stx.js.Env.typeOf(e) == "object") isSupported = stx.Option.Some(stx.js.Env.isDefined(e.srcElement)); else isSupported = stx.Option.Some(false);
				};
				root.appendChild(i);
				i.click();
				root.removeChild(i);
				i.onclick = null;
				i = null;
			}
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.isNativeHasAttributePresent = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isNativeHasAttributePresent",function(v) {
		var isSupported = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var i = stx.js.Env.document.createElement("iframe");
			var root = stx.js.Env.document.documentElement;
			var frames = stx.js.Env.window.frames;
			if(root != null && $bind(root,root.appendChild) != null && $bind(root,root.removeChild) != null) {
				i.style.display = "none";
				root.appendChild(i);
				try {
					var frame = frames[frames.length - 1];
					if(frame != null) {
						var doc = frame.document;
						if(doc != null && $bind(doc,doc.write) != null) {
							doc.write("<html><head><title></title></head><body></body></html>");
							if(doc.documentElement != null) isSupported = stx.Option.Some(stx.js.Env.isDefined(($_=doc.documentElement,$bind($_,$_.hasAttribute)))); else isSupported = stx.Option.Some(false);
							root.removeChild(i);
							i = null;
						}
					}
				} catch( e ) {
					isSupported = stx.Option.Some(false);
				}
			}
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.isContextMenuEventSupported = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isContextMenuEventSupported",function(v) {
		var isPresent = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("p");
			if(el != null && $bind(el,el.setAttribute) != null) {
				el.setAttribute("oncontextmenu","");
				isPresent = stx.Option.Some(stx.js.Env.isDefined(el.oncontextmenu));
			}
		}
		return isPresent;
	});
}
stx.js.detect.BrowserSupport.computedStyleReturnsValuesForStaticlyPositionedElements = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("computedStyleReturnsValuesForStaticlyPositionedElements",function(v) {
		var result = stx.Option.None;
		var view = stx.js.Env.document.defaultView;
		if(view != null && $bind(view,view.getComputedStyle) != null) {
			var docEl = stx.js.Env.document.documentElement;
			var position = null;
			var positionPriority = null;
			var style = view.getComputedStyle(docEl,null);
			if(style.position != "static") {
				position = style.position;
				var docElStyle = docEl.style;
				docElStyle.position = "";
			}
			var computedStyle = view.getComputedStyle(docEl,null);
			result = stx.Option.Some(computedStyle.left != "auto");
			if(position != null) {
				var docElStyle = docEl.style;
				docElStyle.position = position;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isRgbaSupported = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isRgbaSupported",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var value = "rgba(1,1,1,0.5)";
			var el = stx.js.Env.document.createElement("p");
			var re = /^rgba/;
			if(el != null && el.style != null && stx.js.Env.typeOf(re.test) == "function") try {
				el.style.color = value;
				result = stx.Option.Some(re.test(el.style.color));
			} catch( e ) {
				result = stx.Option.Some(false);
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isCssBorderRadiusSupported = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isCssBorderRadiusSupported",function(v) {
		var result = stx.Option.None;
		var docEl = stx.js.Env.document.documentElement;
		if(docEl != null) {
			var s = docEl.style;
			result = stx.Option.Some(stx.js.Env.typeOf(s.borderRadius) == "string" || stx.js.Env.typeOf(s.MozBorderRadius) == "string" || stx.js.Env.typeOf(s.WebkitBorderRadius) == "string" || stx.js.Env.typeOf(s.KhtmlBorderRadius) == "string");
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.elemenChildrenReturnsElementNodes = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("elemenChildrenReturnsElementNodes",function(v) {
		var isSupported = stx.Option.None;
		var docEl = stx.js.Env.document.documentElement;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && stx.js.Env.isDefined(docEl.children)) {
			var el = stx.js.Env.document.createElement("div");
			el.innerHTML = "<div><p>a</p></div>b<!-- x -->";
			isSupported = stx.Option.Some(el.children && el.children.length == 1 && el.children[0] && el.children[0].tagName && el.children[0].tagName.toUpperCase() == "DIV");
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.isCanvasSupported = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isCanvasSupported",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var elCanvas = stx.js.Env.document.createElement("canvas");
			result = stx.Option.Some(!!(elCanvas != null && (elCanvas.getContext != null && elCanvas.getContext("2d") != null)));
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.positionFixed = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("positionFixed",function(v) {
		var isSupported = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && el.style != null) {
				el.style.position = "fixed";
				el.style.top = "-10px";
				var root = stx.js.Env.document.body;
				if(root != null) {
					root.appendChild(el);
					isSupported = stx.Option.Some(el.offsetTop == -10);
					root.removeChild(el);
				}
			}
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.isCssEnabled = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isCssEnabled",function(v) {
		var isSupported = stx.Option.None;
		var body = stx.js.Env.document.body;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && body != null && $bind(body,body.appendChild) != null && $bind(body,body.removeChild) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && el.style != null) {
				el.style.display = "none";
				body.appendChild(el);
				isSupported = stx.Option.Some(el.offsetWidth == 0);
				body.removeChild(el);
			}
		}
		return isSupported;
	});
}
stx.js.detect.BrowserSupport.isQuirksMode = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isQuirksMode",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && el.style != null) {
				var style = el.style;
				style.width = "1";
			}
			var style = el.style;
			result = stx.Option.Some(style.width == "1px");
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isContainsBuggy = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isContainsBuggy",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el1 = stx.js.Env.document.createElement("div"), el2 = stx.js.Env.document.createElement("div");
			if(el1 != null && el2 != null && stx.js.Env.isDefined(el1.contains)) result = stx.Option.Some(el1.contains(el2));
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isActivexEnabled = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("isActivexEnabled",function(v) {
		var result = stx.Option.Some(false);
		if(window.ActiveXObject) {
			var xmlVersions = ["Microsoft.XMLHTTP","Msxml2.XMLHTTP.3.0","Msxml2.XMLHTTP.4.0","Msxml2.XMLHTTP.5.0","Msxml2.XMLHTTP.6.0"];
			var _g = 0;
			while(_g < xmlVersions.length) {
				var value = xmlVersions[_g];
				++_g;
				try {
					if(new ActiveXObject(value) != null) result = stx.Option.Some(true);
				} catch( ex ) {
				}
			}
			result = stx.Option.Some(stx.Options.getOrElseC(result,false));
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.typeofNodelistIsFunctionBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("typeofNodelistIsFunctionBug",function(v) {
		var result = stx.Option.None;
		if(stx.js.Env.document.forms != null) result = stx.Option.Some(stx.js.Env.typeOf(stx.js.Env.document.forms) == "function");
		return result;
	});
}
stx.js.detect.BrowserSupport.getElementsByTagNameReturnsCommentNodesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("getElementsByTagNameReturnsCommentNodesBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && $bind(el,el.getElementsByTagName) != null) {
				el.innerHTML = "<span>a</span><!--b-->";
				var all = el.getElementsByTagName("*");
				if(all.length != null) {
					var lastNode = el.getElementsByTagName("*")[1];
					result = stx.Option.Some(!!(lastNode != null && lastNode.nodeType == 8));
				}
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.setAttributeIgnoresNameAttributeBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("setAttributeIgnoresNameAttributeBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var elForm = stx.js.Env.document.createElement("form");
			var elInput = stx.js.Env.document.createElement("input");
			var root = stx.js.Env.document.documentElement;
			if(elForm != null && elInput != null && $bind(elInput,elInput.setAttribute) != null && $bind(elForm,elForm.appendChild) != null && root != null && $bind(root,root.appendChild) != null && $bind(root,root.removeChild) != null) {
				elInput.setAttribute("name","test");
				elForm.appendChild(elInput);
				root.appendChild(elForm);
				if(elForm.elements != null) result = stx.Option.Some(stx.js.Env.typeOf(elForm.elements.test) == "undefined"); else result = stx.Option.Some(true);
				root.removeChild(elForm);
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.elementPropertiesAreAttributesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("elementPropertiesAreAttributesBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && $bind(el,el.getAttribute) != null) {
				el.__foo = 'bar';
				result = stx.Option.Some(el.getAttribute("__foo") == "bar");
				el = null;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isRegexpWhitespaceCharacterClassBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isRegexpWhitespaceCharacterClassBug",function(v) {
		var result = stx.Option.None;
		var str = '\u0009\u000A\u000B\u000C\u000D\u0020\u00A0\u1680\u180E\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000\u2028\u2029';
		result = stx.Option.Some(!/^\s+$/.test(str));
		return result;
	});
}
stx.js.detect.BrowserSupport.isStringPrototypeSplitRegexpBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isStringPrototypeSplitRegexpBug",function(v) {
		var s = "a_b";
		return stx.Option.Some(s.split(/(_)/).length != 3);
	});
}
stx.js.detect.BrowserSupport.preElementsIgnoreNewLinesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("preElementsIgnoreNewLinesBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && ($_=stx.js.Env.document,$bind($_,$_.createTextNode)) != null) {
			var el = stx.js.Env.document.createElement("pre");
			var txt = stx.js.Env.document.createTextNode("xx");
			var root = stx.js.Env.document.documentElement;
			if(el != null && $bind(el,el.appendChild) != null && txt != null && root != null && $bind(root,root.appendChild) != null && $bind(root,root.removeChild) != null) {
				el.appendChild(txt);
				root.appendChild(el);
				var initialHeight = el.offsetHeight;
				el.firstChild.nodeValue = "x\nx";
				var isIgnored = el.offsetHeight == initialHeight;
				root.removeChild(el);
				el = txt = null;
				result = stx.Option.Some(isIgnored);
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.selectElementInnerHtmlBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("selectElementInnerHtmlBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("select");
			if(el != null) {
				el.innerHTML = "<option value=\"test\">test</option>";
				if(el.options != null && el.options[0] != null) result = stx.Option.Some(el.options[0].nodeName.toUpperCase() != "OPTION");
				el = null;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.tableElementInnerHtmlBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("tableElementInnerHtmlBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) try {
			var el = stx.js.Env.document.createElement("table");
			if(el != null && el.tBodies != null) {
				el.innerHTML = "<tbody><tr><td>test</td></tr></tbody>";
				result = stx.Option.Some(stx.js.Env.typeOf(el.tBodies[0]) == "undefined");
				el = null;
			}
		} catch( e ) {
			result = stx.Option.Some(true);
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.scriptElementRejectsTextNodeAppendingBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("scriptElementRejectsTextNodeAppendingBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && ($_=stx.js.Env.document,$bind($_,$_.createTextNode)) != null) {
			var s = stx.js.Env.document.createElement("script");
			if(s != null && $bind(s,s.appendChild) != null) {
				try {
					s.appendChild(stx.js.Env.document.createTextNode(""));
					result = stx.Option.Some(s.firstChild == null || s.firstChild != null && s.firstChild.nodeType != 3);
				} catch( e ) {
					result = stx.Option.Some(true);
				}
				s = null;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.documentGetElementByIdConfusesIdsWithNamesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("documentGetElementByIdConfusesIdsWithNamesBug",function(v) {
		var result = stx.Option.Some(false);
		if(($_=stx.js.Env.document,$bind($_,$_.getElementsByTagName)) != null && ($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var num = new Date().getTime();
			var name = "__test_" + num;
			var head = stx.js.Env.document.getElementsByTagName("head")[0];
			var el;
			try {
				el = stx.js.Env.document.createElement("<input name=\"" + name + "\">");
			} catch( e ) {
				el = stx.js.Env.document.createElement("input");
				el.name = name;
			}
			if($bind(head,head.appendChild) != null && $bind(head,head.removeChild) != null) {
				head.appendChild(el);
				var testElement = stx.js.Env.document.getElementById(name);
				result = stx.Option.Some(!!(testElement != null && testElement.nodeName.toUpperCase() == "INPUT"));
				head.removeChild(el);
				el = null;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.documentGetElementByIdIgnoresCaseBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("documentGetElementByIdIgnoresCaseBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && ($_=stx.js.Env.document,$bind($_,$_.getElementsByTagName)) != null && ($_=stx.js.Env.document,$bind($_,$_.getElementById)) != null) {
			var el = stx.js.Env.document.createElement("script");
			var head = stx.js.Env.document.getElementsByTagName("head")[0];
			if(el != null && head != null && $bind(head,head.appendChild) != null && $bind(head,head.removeChild) != null) {
				el.type = "text/javascript";
				el.id = "A";
				head.appendChild(el);
				result = stx.Option.Some(!!(stx.js.Env.document.getElementById("a") != null));
				head.removeChild(el);
				el = null;
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.offsetValuesForStaticElementsInsidePositionedOnesBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("offsetValuesForStaticElementsInsidePositionedOnesBug",function(v) {
		var result = stx.Option.None;
		var body = stx.js.Env.document.body;
		if(body != null && $bind(body,body.insertBefore) != null && ($_=stx.js.Env.document,$bind($_,$_.createElement)) != null && ($_=stx.js.Env.document,$bind($_,$_.getElementById)) != null) {
			var id = "x" + HxOverrides.substr(Math.random() + "",2,null);
			var clearance = "margin:0;padding:0;border:0;visibility:hidden;";
			var payload = "<div style=\"position:absolute;top:10px;" + clearance + "\">" + "<div style=\"position:relative;top:10px;" + clearance + "\">" + "<div style=\"height:10px;font-size:1px;" + clearance + "\"></div>" + "<div id=\"" + id + "\">x</div>" + "</div>" + "</div>";
			var wrapper = stx.js.Env.document.createElement("div");
			if(wrapper != null) {
				wrapper.innerHTML = payload;
				body.insertBefore(wrapper,body.firstChild);
				var el = stx.js.Env.document.getElementById(id);
				if(el != null && el.style != null) {
					if(el.offsetTop != 10) {
						el.style.position = "relative";
						if(el.offsetTop == 10) result = stx.Option.Some(true);
					} else result = stx.Option.Some(false);
				}
				body.removeChild(wrapper);
			}
			wrapper = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isDocumentGetElementsByNameBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isDocumentGetElementsByNameBug",function(v) {
		var result = stx.Option.None;
		var docEl = stx.js.Env.document.documentElement;
		if(docEl != null && $bind(docEl,docEl.appendChild) != null && $bind(docEl,docEl.removeChild) != null && ($_=stx.js.Env.document,$bind($_,$_.getElementsByName)) != null && ($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null) {
				var uid = "x" + HxOverrides.substr(Math.random() + "",2,null);
				el.id = uid;
				docEl.appendChild(el);
				result = stx.Option.Some(stx.js.Env.document.getElementsByName(uid)[0] == el);
				docEl.removeChild(el);
			}
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isOverflowStyleBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isOverflowStyleBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			el.innerHTML = "<p style=\"overflow: visible;\">x</p>";
			var firstChild = el.firstChild;
			if(firstChild != null && firstChild.style != null) {
				var style = firstChild.style;
				style.overflow = "hidden";
				result = stx.Option.Some(style.overflow != "hidden");
			}
			el = null;
			firstChild = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.isQuerySelectorAllBug = function() {
	return stx.js.detect.BrowserSupport.testBugAndMemorize("isQuerySelectorAllBug",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("div");
			if(el != null && el.querySelectorAll != null) {
				el.innerHTML = "<object><param name=\"\"></object>";
				result = stx.Option.Some(el.querySelectorAll("param").length != 1);
			}
			el = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5Audio = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Audio",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("audio");
			result = stx.Option.Some(!!el.canPlayType);
			el = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5AudioInMP3Format = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5AudioInMP3Format",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("audio","audio/mpeg;");
	});
}
stx.js.detect.BrowserSupport.html5AudioInVorbisFormat = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5AudioInVorbisFormat",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("audio","audio/ogg; codecs=\"vorbis\"");
	});
}
stx.js.detect.BrowserSupport.html5AudioInWavFormat = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5AudioInWavFormat",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("audio","audio/wav; codecs=\"1\"");
	});
}
stx.js.detect.BrowserSupport.html5AudioInAACFormat = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5AudioInAACFormat",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("audio","audio/mp4; codecs=\"mp4a.40.2\"");
	});
}
stx.js.detect.BrowserSupport.canPlayType = function(element,format) {
	var result = stx.Option.None;
	if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
		var a = stx.js.Env.document.createElement(element);
		result = stx.Option.Some(!!(a.canPlayType && a.canPlayType(format).replace("no","") != ""));
		a = null;
	}
	return result;
}
stx.js.detect.BrowserSupport.html5Canvas = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Canvas",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var a = stx.js.Env.document.createElement("canvas");
			result = stx.Option.Some(!!a.getContext);
			a = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5CanvasTextAPI = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5CanvasTextAPI",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var c = stx.js.Env.document.createElement("canvas");
			result = stx.Option.Some(c.getContext && stx.js.Env.typeOf(c.getContext("2d").fillText) == "function");
			c = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5Command = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Command",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("command","type");
	});
}
stx.js.detect.BrowserSupport.html5Datalist = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Datalist",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("datalist","options");
	});
}
stx.js.detect.BrowserSupport.html5Details = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Details",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("details","open");
	});
}
stx.js.detect.BrowserSupport.html5Device = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Device",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("device","type");
	});
}
stx.js.detect.BrowserSupport.html5FormConstraintValidation = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5FormConstraintValidation",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("form","noValidate");
	});
}
stx.js.detect.BrowserSupport.html5IframeSandbox = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5IframeSandbox",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("iframe","sandbox");
	});
}
stx.js.detect.BrowserSupport.html5IframeSrcdoc = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5IframeSrcdoc",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("iframe","srcdoc");
	});
}
stx.js.detect.BrowserSupport.html5InputAutofocus = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputAutofocus",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("input","autofocus");
	});
}
stx.js.detect.BrowserSupport.html5InputPlaceholder = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputPlaceholder",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("input","placeholder");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeColor = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeColor",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("color");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeEmail = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeEmail",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("email");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeNumber = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeNumber",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("range");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeRange = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeRange",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("color");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeSearch = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeSearch",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("search");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeTel = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeTel",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("tel");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeUrl = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeUrl",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("url");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeDate = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeDate",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("date");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeTime = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeTime",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("time");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeDatetime = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeDatetime",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("datetime");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeDatetimeLocal = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeDatetimeLocal",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("datetime-local");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeWeek = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeWeek",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("week");
	});
}
stx.js.detect.BrowserSupport.html5InputTypeMonth = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5InputTypeMonth",function(v) {
		return stx.js.detect.BrowserSupport.checIputTypeProperty("month");
	});
}
stx.js.detect.BrowserSupport.html5Meter = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Meter",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("meter","value");
	});
}
stx.js.detect.BrowserSupport.html5Output = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Output",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("output","value");
	});
}
stx.js.detect.BrowserSupport.html5Progress = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Progress",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("value","progress");
	});
}
stx.js.detect.BrowserSupport.html5Time = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Time",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("time","valueAsDate");
	});
}
stx.js.detect.BrowserSupport.html5Video = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5Video",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var el = stx.js.Env.document.createElement("video");
			result = stx.Option.Some(!!el.canPlayType);
			el = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5VideoCaptions = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5VideoCaptions",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("track","track");
	});
}
stx.js.detect.BrowserSupport.html5VideoPoster = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5VideoPoster",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("track","poster");
	});
}
stx.js.detect.BrowserSupport.checIfExist = function(elementName,property) {
	var result = stx.Option.None;
	if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
		var c = stx.js.Env.document.createElement(elementName);
		result = stx.Option.Some(stx.js.Env.typeOf(c[property]) != "undefined");
		c = null;
	}
	return result;
}
stx.js.detect.BrowserSupport.checIputTypeProperty = function(type) {
	var result = stx.Option.None;
	if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
		var i = stx.js.Env.document.createElement("input");
		i.setAttribute("type",type);
		result = stx.Option.Some(i.type != "text");
		i = null;
	}
	return result;
}
stx.js.detect.BrowserSupport.html5VidouInWebMFormat = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5VidouInWebMFormat",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("video","video/webm; codecs=\"vp8, vorbis\"");
	});
}
stx.js.detect.BrowserSupport.html5VidouInH264Format = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5VidouInH264Format",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("video","video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"");
	});
}
stx.js.detect.BrowserSupport.html5VidouInTheoraFormat = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5VidouInTheoraFormat",function(v) {
		return stx.js.detect.BrowserSupport.canPlayType("video","video/ogg; codecs=\"theora, vorbis\"");
	});
}
stx.js.detect.BrowserSupport.html5ContentEditable = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5ContentEditable",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("span","isContentEditable");
	});
}
stx.js.detect.BrowserSupport.html5CrossDocumentMessaging = function() {
	return stx.js.Env.isDefined(($_=stx.js.Env.window,$bind($_,$_.postMessage)));
}
stx.js.detect.BrowserSupport.html5DragAndDrop = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5DragAndDrop",function(v) {
		return stx.js.detect.BrowserSupport.checIfExist("span","draggable");
	});
}
stx.js.detect.BrowserSupport.html5FileApi = function() {
	try {
		return stx.js.Env.isDefined(FileReader);
	} catch( e ) {
		return false;
	}
}
stx.js.detect.BrowserSupport.html5Geolocation = function() {
	return stx.js.Env.isDefined(stx.js.Env.navigator.geolocation);
}
stx.js.detect.BrowserSupport.html5History = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.history) && stx.js.Env.isDefined(($_=stx.js.Env.window.history,$bind($_,$_.pushState))) && stx.js.Env.isDefined(stx.js.Env.window.history.popState);
}
stx.js.detect.BrowserSupport.html5LocalStorage = function() {
	return stx.js.Env.typeOf(stx.js.Env.window.localStorage) != "undefined" && stx.js.Env.window.localStorage != null;
}
stx.js.detect.BrowserSupport.html5Microdata = function() {
	return stx.js.Env.isDefined(stx.js.Env.document.getItems);
}
stx.js.detect.BrowserSupport.html5OfflineWebApplications = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.applicationCache);
}
stx.js.detect.BrowserSupport.html5ServerSentEvents = function() {
	try {
		return stx.js.Env.isDefined(EventSource);
	} catch( e ) {
		return false;
	}
}
stx.js.detect.BrowserSupport.html5SessionStorage = function() {
	try {
		return stx.js.Env.typeOf(stx.js.Env.window.sessionStorage) != "undefined" && stx.js.Env.window.sessionStorage != null;
	} catch( e ) {
		return false;
	}
}
stx.js.detect.BrowserSupport.html5SVG = function() {
	return ($_=stx.js.Env.document,$bind($_,$_.createElementNS)) != null && stx.js.Env.document.createElementNS("http://www.w3.org/2000/svg","svg").createSVGRect != null;
}
stx.js.detect.BrowserSupport.html5SVGInTextHtml = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("html5SVGInTextHtml",function(v) {
		var result = stx.Option.None;
		if(($_=stx.js.Env.document,$bind($_,$_.createElement)) != null) {
			var e = stx.js.Env.document.createElement("div");
			e.innerHTML = "<svg></svg>";
			result = stx.Option.Some(!!(stx.js.Env.window.SVGSVGElement != null && js.Boot.__instanceof(e.firstChild,stx.js.Env.window.SVGSVGElement)));
			e = null;
		}
		return result;
	});
}
stx.js.detect.BrowserSupport.html5WebSimpleDB = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.indexedDB);
}
stx.js.detect.BrowserSupport.html5WebSocket = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.WebSocket);
}
stx.js.detect.BrowserSupport.html5WebSQLDatabase = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.openDatabase);
}
stx.js.detect.BrowserSupport.html5WebWorkers = function() {
	return stx.js.Env.isDefined(stx.js.Env.window.Worker);
}
stx.js.detect.BrowserSupport.html5Widgets = function() {
	try {
		return stx.js.Env.isDefined(widget);
	} catch( e ) {
		return false;
	}
}
stx.js.detect.BrowserSupport.html5Undo = function() {
	try {
		return stx.js.Env.isDefined(UndoManager);
	} catch( e ) {
		return false;
	}
}
stx.js.detect.BrowserSupport.boxModel = function() {
	return stx.js.detect.BrowserSupport.testSupportInBody("<div style=\"padding: 0; margin: 0; padding-left: 1px; width: 1px;\"></div>","div",function(e) {
		return e.offsetWidth == 2;
	});
}
stx.js.detect.BrowserSupport.getAttributeStyle = function() {
	return stx.js.detect.BrowserSupport.testSupport("<a style=\"color: black;\"></a>","a",function(e) {
		var styleAttribute = e.getAttribute("style");
		if(stx.js.Env.typeOf(styleAttribute) == "string") return stx.Strings.contains(styleAttribute,"black"); else if(stx.js.Env.typeOf(styleAttribute) == "object") {
			var cssText = styleAttribute.cssText;
			return stx.Strings.contains(cssText,"black");
		} else return false;
	});
}
stx.js.detect.BrowserSupport.opacity = function() {
	return stx.js.detect.BrowserSupport.testSupport("<div></div>","div",function(e) {
		var filter = e.style.filter;
		e.opacity = 0.5;
		return e.opacity == 0.5 || filter == null;
	});
}
stx.js.detect.BrowserSupport.cssFloat = function() {
	return stx.js.detect.BrowserSupport.testSupport("<div style=\"float:left\"></div>","div",function(e) {
		return e.style.cssFloat != null;
	});
}
stx.js.detect.BrowserSupport.checkboxValueDefaultsToOn = function() {
	return stx.js.detect.BrowserSupport.testSupport("<input type=\"checkbox\"/>","input",function(e) {
		var value = e.value;
		return stx.Options.getOrElseC(stx.Options.map(stx.Options.toOption(value),function(s) {
			return new EReg("on","i").match(s);
		}),false);
	});
}
stx.js.detect.BrowserSupport.defaultSelectedHasSelectProperty = function() {
	return stx.js.detect.BrowserSupport.testSupport("<select><option></select>","option",function(e) {
		return e.selected != null;
	});
}
stx.js.detect.BrowserSupport.removedNodeHasNullParentNode = function() {
	return stx.js.detect.BrowserSupport.testSupport("<div></div>","div",function(e) {
		return e.removeChild(e.appendChild(stx.js.Env.document.createElement("div"))).parentNode == null;
	});
}
stx.js.detect.BrowserSupport.getComputedStyle = function() {
	return stx.js.Env.document.defaultView != null && ($_=stx.js.Env.document.defaultView,$bind($_,$_.getComputedStyle)) != null;
}
stx.js.detect.BrowserSupport.offsetDoesNotIncludeMarginInBodyOffset = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("offsetDoesNotIncludeMarginInBodyOffset",function(v) {
		if(stx.js.Env.document != null && stx.js.Env.document.body != null) return stx.Anys.into(stx.js.Env.document.body,function(body) {
			var bodyMarginTop = stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getComputedCssProperty(body,"margin-top"),function(s) {
				return stx.Strings["int"](s,0);
			}),0);
			return stx.Option.Some(body.offsetTop != bodyMarginTop);
		});
		return stx.Option.None;
	});
}
stx.js.detect.BrowserSupport.spuriousTbodyInsertedBug = function() {
	return stx.js.detect.BrowserSupport.testBug("<table></table>","tbody",function(e) {
		return true;
	},false);
}
stx.js.detect.BrowserSupport.whitespaceDroppedWithInnerHTMLBug = function() {
	return stx.js.detect.BrowserSupport.testBug("      <div></div>","div",function(e) {
		return e.previousSibling == null || e.previousSibling.nodeType != stx.js.NodeType.TEXT_NODE;
	});
}
stx.js.detect.BrowserSupport.linksDroppedWithInnerHTMLBug = function() {
	return stx.js.detect.BrowserSupport.testBug("<link/>","link",function(e) {
		return false;
	});
}
stx.js.detect.BrowserSupport.hrefIsNormalizedBug = function() {
	return stx.js.detect.BrowserSupport.testBug("<a href=\"/a\" style=\"color: black;\"></a>","a",function(e) {
		return e.getAttribute("href") != "/a";
	});
}
stx.js.detect.BrowserSupport.offsetDoesNotAddBorder = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("offsetDoesNotAddBorder",function(v) {
		if(stx.js.Env.document != null && stx.js.Env.document.body != null) {
			var container = stx.Anys.withEffect(stx.js.Env.document.createElement("div"),function(container1) {
				stx.Objects.extendWith(container1.style,{ position : "absolute", top : 0, left : 0, margin : 0, border : 0, width : "1px", height : "1px", visibility : "hidden"});
				container1.innerHTML = "<div style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;'><div></div></div>";
			});
			return stx.Option.Some(stx.Anys.into(stx.js.Env.document.body,function(body) {
				body.insertBefore(container,body.firstChild);
				var checkDiv = container.firstChild.firstChild;
				return stx.Anys.withEffect(checkDiv.offsetTop != 5,function(_) {
					body.removeChild(container);
				});
			}));
		}
		return stx.Option.None;
	});
}
stx.js.detect.BrowserSupport.offsetAddsBorderForTableAndCells = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("offsetAddsBorderForTableAndCells",function(v) {
		if(stx.js.Env.document != null && stx.js.Env.document.body != null) {
			var container = stx.Anys.withEffect(stx.js.Env.document.createElement("div"),function(container1) {
				stx.Objects.extendWith(container1.style,{ position : "absolute", top : 0, left : 0, margin : 0, border : 0, width : "1px", height : "1px", visibility : "hidden"});
				container1.innerHTML = "<table style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;' cellpadding='0' cellspacing='0'><tr><td></td></tr></table>";
			});
			return stx.Option.Some(stx.Anys.into(stx.js.Env.document.body,function(body) {
				body.insertBefore(container,body.firstChild);
				var td = container.getElementsByTagName("td")[0];
				return stx.Anys.withEffect(td.offsetTop == 5,function(_) {
					body.removeChild(container);
				});
			}));
		}
		return stx.Option.None;
	});
}
stx.js.detect.BrowserSupport.offsetSubtractsBorderForOverflowNotVisible = function() {
	return stx.js.detect.BrowserSupport.testFeatureAndMemorize("offsetSubtractsBorderForOverflowNotVisible",function(v) {
		if(stx.js.Env.document != null && stx.js.Env.document.body != null) {
			var container = stx.Anys.withEffect(stx.js.Env.document.createElement("div"),function(container1) {
				stx.Objects.extendWith(container1.style,{ position : "absolute", top : 0, left : 0, margin : 0, border : 0, width : "1px", height : "1px", visibility : "hidden"});
				container1.innerHTML = "<div style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;'><div></div></div>";
			});
			return stx.Option.Some(stx.Anys.into(stx.js.Env.document.body,function(body) {
				body.insertBefore(container,body.firstChild);
				var innerDiv = container.firstChild;
				stx.Objects.extendWith(innerDiv.style,{ overflow : "hidden", position : "relative"});
				var checkDiv = innerDiv.firstChild;
				return stx.Anys.withEffect(checkDiv.offsetTop == -5,function(_) {
					body.removeChild(container);
				});
			}));
		}
		return stx.Option.None;
	});
}
stx.js.detect.BrowserSupport.testSupport = function(contents,tagName,f,def) {
	if(def == null) def = false;
	return stx.js.detect.BrowserSupport.test(contents,tagName,f,true,def);
}
stx.js.detect.BrowserSupport.testSupportInBody = function(contents,tagName,f,def) {
	if(def == null) def = false;
	return stx.js.detect.BrowserSupport.testInBody(contents,tagName,f,true,def);
}
stx.js.detect.BrowserSupport.testBug = function(contents,tagName,f,def) {
	if(def == null) def = true;
	return stx.js.detect.BrowserSupport.test(contents,tagName,f,false,def);
}
stx.js.detect.BrowserSupport.testBugInBody = function(contents,tagName,f,def) {
	if(def == null) def = true;
	return stx.js.detect.BrowserSupport.testInBody(contents,tagName,f,false,def);
}
stx.js.detect.BrowserSupport.test = function(contents,tagName,f,def1,def2) {
	return stx.js.detect.BrowserSupport.testAndMemorize("testInBody" + contents + tagName,def1,function(v) {
		return stx.js.Env.document == null?stx.Option.None:(function($this) {
			var $r;
			var div = stx.js.Env.document.createElement("div");
			div.style.display = "none";
			div.innerHTML = contents;
			$r = stx.Option.Some(stx.Options.getOrElseC(stx.Options.map(stx.Arrays.firstOption(stx.js.dom.DomCollectionExtensions.toArray(div.getElementsByTagName(tagName))),f),def2));
			return $r;
		}(this));
	});
}
stx.js.detect.BrowserSupport.testInBody = function(contents,tagName,f,def1,def2) {
	return stx.js.detect.BrowserSupport.testAndMemorize("testInBody" + contents + tagName,def1,function(v) {
		return stx.js.Env.document == null || stx.js.Env.document.body == null?stx.Option.None:(function($this) {
			var $r;
			var div = stx.js.Env.document.createElement("div");
			div.innerHTML = contents;
			stx.js.Env.document.body.insertBefore(div,stx.js.Env.document.body.firstChild);
			$r = stx.Option.Some(stx.Anys.withEffect(stx.Options.getOrElseC(stx.Options.map(stx.Arrays.firstOption(stx.js.dom.DomCollectionExtensions.toArray(div.getElementsByTagName(tagName))),f),def2),function(_) {
				stx.js.Env.document.body.removeChild(div);
				div.style.display = "none";
			}));
			return $r;
		}(this));
	});
}
stx.js.detect.BrowserSupport.testFeatureAndMemorize = function(key,testFunction) {
	return stx.js.detect.BrowserSupport.testAndMemorize(key,true,testFunction);
}
stx.js.detect.BrowserSupport.testBugAndMemorize = function(key,testFunction) {
	return stx.js.detect.BrowserSupport.testAndMemorize(key,false,testFunction);
}
stx.js.detect.BrowserSupport.testAndMemorize = function(key,defaultValue,testFunction) {
	return stx.Options.getOrElse(stx.js.detect.BrowserSupport.memorized.get(key),function() {
		var result = testFunction.call();
		stx.Options.foreach(result,function(v) {
			stx.js.detect.BrowserSupport.memorized = stx.js.detect.BrowserSupport.memorized.set(key,v);
		});
		return stx.Options.getOrElseC(result,defaultValue);
	});
}
stx.js.detect.EnvironmentType = $hxClasses["stx.js.detect.EnvironmentType"] = { __ename__ : ["stx","js","detect","EnvironmentType"], __constructs__ : ["UnknownServer","NodeJs","IE","Firefox","Safari","Chrome","Unknown","Opera"] }
stx.js.detect.EnvironmentType.UnknownServer = ["UnknownServer",0];
stx.js.detect.EnvironmentType.UnknownServer.toString = $estr;
stx.js.detect.EnvironmentType.UnknownServer.__enum__ = stx.js.detect.EnvironmentType;
stx.js.detect.EnvironmentType.NodeJs = ["NodeJs",1];
stx.js.detect.EnvironmentType.NodeJs.toString = $estr;
stx.js.detect.EnvironmentType.NodeJs.__enum__ = stx.js.detect.EnvironmentType;
stx.js.detect.EnvironmentType.IE = function(version) { var $x = ["IE",2,version]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.EnvironmentType.Firefox = function(version) { var $x = ["Firefox",3,version]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.EnvironmentType.Safari = function(version) { var $x = ["Safari",4,version]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.EnvironmentType.Chrome = function(version) { var $x = ["Chrome",5,version]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.EnvironmentType.Unknown = function(what) { var $x = ["Unknown",6,what]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.EnvironmentType.Opera = function(version) { var $x = ["Opera",7,version]; $x.__enum__ = stx.js.detect.EnvironmentType; $x.toString = $estr; return $x; }
stx.js.detect.OSType = $hxClasses["stx.js.detect.OSType"] = { __ename__ : ["stx","js","detect","OSType"], __constructs__ : ["Windows","MacMobile","Android","Mac","Linux","Unknown"] }
stx.js.detect.OSType.Windows = ["Windows",0];
stx.js.detect.OSType.Windows.toString = $estr;
stx.js.detect.OSType.Windows.__enum__ = stx.js.detect.OSType;
stx.js.detect.OSType.MacMobile = ["MacMobile",1];
stx.js.detect.OSType.MacMobile.toString = $estr;
stx.js.detect.OSType.MacMobile.__enum__ = stx.js.detect.OSType;
stx.js.detect.OSType.Android = ["Android",2];
stx.js.detect.OSType.Android.toString = $estr;
stx.js.detect.OSType.Android.__enum__ = stx.js.detect.OSType;
stx.js.detect.OSType.Mac = ["Mac",3];
stx.js.detect.OSType.Mac.toString = $estr;
stx.js.detect.OSType.Mac.__enum__ = stx.js.detect.OSType;
stx.js.detect.OSType.Linux = ["Linux",4];
stx.js.detect.OSType.Linux.toString = $estr;
stx.js.detect.OSType.Linux.__enum__ = stx.js.detect.OSType;
stx.js.detect.OSType.Unknown = function(userAgent) { var $x = ["Unknown",5,userAgent]; $x.__enum__ = stx.js.detect.OSType; $x.toString = $estr; return $x; }
stx.js.detect.Host = $hxClasses["stx.js.detect.Host"] = function() { }
stx.js.detect.Host.__name__ = ["stx","js","detect","Host"];
stx.js.detect.Host.detectEnvironment = function() {
	if(stx.js.Env.navigator == null) return stx.js.detect.EnvironmentType.UnknownServer; else if(process != null) return stx.js.detect.EnvironmentType.NodeJs;
	var userAgent = stx.js.Env.navigator.userAgent;
	return stx.js.detect.Host.OperaPattern.match(userAgent)?stx.js.detect.EnvironmentType.Opera(stx.js.detect.Host.OperaPattern.matched(1)):stx.js.detect.Host.ChromePattern.match(userAgent)?stx.js.detect.EnvironmentType.Chrome(stx.js.detect.Host.ChromePattern.matched(1)):stx.js.detect.Host.SafariPattern.match(userAgent)?stx.js.detect.EnvironmentType.Safari(stx.js.detect.Host.SafariPattern.matched(1)):stx.js.detect.Host.FirefoxPattern.match(userAgent)?stx.js.detect.EnvironmentType.Firefox(stx.js.detect.Host.FirefoxPattern.matched(1)):stx.js.detect.Host.IEPattern.match(userAgent)?stx.js.detect.EnvironmentType.IE(stx.js.detect.Host.IEPattern.matched(1)):stx.js.detect.EnvironmentType.Unknown(userAgent);
}
stx.js.detect.Host.detectOS = function() {
	if(stx.js.Env.navigator == null) return stx.js.detect.OSType.Unknown("unknown");
	var userAgent = stx.js.Env.navigator.userAgent;
	return stx.js.detect.Host.WindowsPattern.match(userAgent)?stx.js.detect.OSType.Windows:stx.js.detect.Host.MacMobilePattern.match(userAgent)?stx.js.detect.OSType.MacMobile:stx.js.detect.Host.AndroidPattern.match(userAgent)?stx.js.detect.OSType.Android:stx.js.detect.Host.MacPattern.match(userAgent)?stx.js.detect.OSType.Mac:stx.js.detect.Host.LinuxPattern.match(userAgent)?stx.js.detect.OSType.Linux:stx.js.detect.OSType.Unknown(userAgent);
}
if(!stx.js.dom) stx.js.dom = {}
stx.js.dom.DomCollectionExtensions = $hxClasses["stx.js.dom.DomCollectionExtensions"] = function() { }
stx.js.dom.DomCollectionExtensions.__name__ = ["stx","js","dom","DomCollectionExtensions"];
stx.js.dom.DomCollectionExtensions.toArray = function(c) {
	var a = [];
	var _g1 = 0, _g = c.length;
	while(_g1 < _g) {
		var i = _g1++;
		a.push(c[i]);
	}
	return a;
}
stx.js.dom.HTMLDocumentExtensions = $hxClasses["stx.js.dom.HTMLDocumentExtensions"] = function() { }
stx.js.dom.HTMLDocumentExtensions.__name__ = ["stx","js","dom","HTMLDocumentExtensions"];
stx.js.dom.HTMLDocumentExtensions.newElement = function(document,eType,atts,style) {
	if(style == null) style = "";
	var element = document.createElement(eType);
	if(atts != null) {
		var _g1 = 0, _g = atts.length;
		while(_g1 < _g) {
			var i = _g1++;
			element.setAttribute(atts[i].fst(),atts[i].snd());
		}
	}
	if(style != null) element.style.cssText = style;
	return element;
}
stx.js.dom.HTMLDocumentExtensions.newImage = function(doc) {
	return doc.createElement("IMG");
}
stx.js.dom.HTMLDocumentExtensions.newDiv = function(doc) {
	return doc.createElement("DIV");
}
stx.js.dom.HTMLDocumentExtensions.newIframe = function(doc,width,height) {
	var iframe = doc.createElement("IFRAME");
	stx.Options.map(stx.Options.zip(stx.Options.toOption(width),stx.Options.toOption(height)),function(t) {
		iframe.setAttribute("width",stx.Floats.toString(width));
		iframe.setAttribute("height",stx.Floats.toString(height));
	});
	return iframe;
}
stx.js.dom.HTMLDocumentExtensions.newIframeWindow = function(doc,width,height) {
	var iframe = stx.js.dom.HTMLDocumentExtensions.newIframe(doc,width,height);
	iframe.setAttribute("frameBorder","0");
	iframe.setAttribute("marginWidth","0");
	iframe.setAttribute("marginHeight","0");
	iframe.setAttribute("vspace","0");
	iframe.setAttribute("hspace","0");
	iframe.setAttribute("scrolling","no");
	iframe.setAttribute("noResize","noResize");
	iframe.setAttribute("allowTransparency","true");
	iframe.style.margin = "0";
	iframe.style.padding = "0";
	iframe.style.border = "none";
	iframe.style.borderLeftStyle = "none";
	iframe.style.borderRightStyle = "none";
	iframe.style.borderTopStyle = "none";
	iframe.style.borderBottomStyle = "none";
	iframe.style.backgroundColor = "transparent";
	return iframe;
}
stx.js.dom.HTMLDocumentExtensions.newIframeInvisible = function(doc) {
	return stx.js.dom.HTMLDocumentExtensions.newIframeWindow(doc,0,0);
}
stx.js.dom.HTMLDocumentExtensions.getId = function(doc,s) {
	return doc.getElementById(s);
}
stx.js.dom.HTMLDocumentExtensions.getIds = function(doc,a) {
	var result = [];
	var _g1 = 0, _g = a.length;
	while(_g1 < _g) {
		var i = _g1++;
		result.push(stx.js.dom.HTMLDocumentExtensions.getId(doc,a[i]));
	}
	return result;
}
stx.js.dom.HTMLDocumentExtensions.getTags = function(doc,s) {
	return stx.Options.getOrElseC(stx.Options.toOption(doc.getElementsByTagName(s)),[]);
}
stx.js.dom.HTMLDocumentExtensions.getClasses = function(doc,s) {
	return stx.Options.getOrElseC(stx.Options.toOption(stx.js.Env.getElementsByClass(s)),[]);
}
stx.js.dom.HTMLElementExtensions = $hxClasses["stx.js.dom.HTMLElementExtensions"] = function() { }
stx.js.dom.HTMLElementExtensions.__name__ = ["stx","js","dom","HTMLElementExtensions"];
stx.js.dom.HTMLElementExtensions.hasClass = function(e,name) {
	return stx.Arrays.exists(e.getAttribute("class").split(" "),function(e1) {
		return e1 == name;
	});
}
stx.js.dom.HTMLElementExtensions.removeElement = function(e) {
	var parent = e.parentNode;
	if(parent != null) parent.removeChild(e);
}
stx.js.dom.HTMLElementExtensions.getTags = function(e,tagName) {
	return stx.js.dom.DomCollectionExtensions.toArray(e.getElementsByTagName(tagName));
}
stx.js.dom.HTMLElementExtensions.append = function(e,child) {
	e.appendChild(child);
	return e;
}
stx.js.dom.HTMLElementExtensions.setAttr = function(e,attGet,attSet) {
	e.setAttribute(attGet,attSet);
	return e;
}
stx.js.dom.HTMLElementExtensions.getAttr = function(e,attGet) {
	return e.getAttribute(attGet);
}
stx.js.dom.HTMLElementExtensions.setClass = function(e,className) {
	e.className = className;
	return e;
}
stx.js.dom.HTMLElementExtensions.asIframe = function(e) {
	return stx.Options.get(e.nodeName == "IFRAME"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asScript = function(e) {
	return stx.Options.get(e.nodeName == "SCRIPT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asDiv = function(e) {
	return stx.Options.get(e.nodeName == "DIV"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asForm = function(e) {
	return stx.Options.get(e.nodeName == "FORM"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asBody = function(e) {
	return stx.Options.get(e.nodeName == "BODY"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asStyle = function(e) {
	return stx.Options.get(e.nodeName == "STYLE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asText = function(e) {
	return stx.Options.get(e.nodeName == "TEXT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asVideo = function(e) {
	return stx.Options.get(e.nodeName == "VIDEO"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asAudio = function(e) {
	return stx.Options.get(e.nodeName == "AUDIO"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asHead = function(e) {
	return stx.Options.get(e.nodeName == "HEAD"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asLink = function(e) {
	return stx.Options.get(e.nodeName == "LINK"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTitle = function(e) {
	return stx.Options.get(e.nodeName == "TITLE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asMeta = function(e) {
	return stx.Options.get(e.nodeName == "META"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asBase = function(e) {
	return stx.Options.get(e.nodeName == "BASE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asIsIndex = function(e) {
	return stx.Options.get(e.nodeName == "ISINDEX"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asSelect = function(e) {
	return stx.Options.get(e.nodeName == "SELECT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asCanvas = function(e) {
	return stx.Options.get(e.nodeName == "CANVAS"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asOptGroup = function(e) {
	return stx.Options.get(e.nodeName == "OPTGROUP"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asOption = function(e) {
	return stx.Options.get(e.nodeName == "OPTION"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asInput = function(e) {
	return stx.Options.get(e.nodeName == "INPUT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTextArea = function(e) {
	return stx.Options.get(e.nodeName == "TEXTAREA"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asButton = function(e) {
	return stx.Options.get(e.nodeName == "BUTTON"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asLabel = function(e) {
	return stx.Options.get(e.nodeName == "LABEL"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asFieldSet = function(e) {
	return stx.Options.get(e.nodeName == "FIELDSET"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asLegend = function(e) {
	return stx.Options.get(e.nodeName == "LEGEND"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asUList = function(e) {
	return stx.Options.get(e.nodeName == "UL"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asOList = function(e) {
	return stx.Options.get(e.nodeName == "OL"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asDList = function(e) {
	return stx.Options.get(e.nodeName == "DL"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asDir = function(e) {
	return stx.Options.get(e.nodeName == "DIR"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asMenu = function(e) {
	return stx.Options.get(e.nodeName == "MENU"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asLI = function(e) {
	return stx.Options.get(e.nodeName == "LI"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asP = function(e) {
	return stx.Options.get(e.nodeName == "P"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asH = function(e) {
	return stx.Options.get(e.nodeName == "H"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asQuote = function(e) {
	return stx.Options.get(e.nodeName == "QUOTE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asPre = function(e) {
	return stx.Options.get(e.nodeName == "PRE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asBR = function(e) {
	return stx.Options.get(e.nodeName == "BR"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asBaseFont = function(e) {
	return stx.Options.get(e.nodeName == "BASEFONT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asFont = function(e) {
	return stx.Options.get(e.nodeName == "FONT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asHR = function(e) {
	return stx.Options.get(e.nodeName == "HR"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asMod = function(e) {
	return stx.Options.get(e.nodeName == "MOD"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asA = function(e) {
	return stx.Options.get(e.nodeName == "A"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asImage = function(e) {
	return stx.Options.get(e.nodeName == "IMG"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asObject = function(e) {
	return stx.Options.get(e.nodeName == "OBJECT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asParam = function(e) {
	return stx.Options.get(e.nodeName == "PARAM"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asApplet = function(e) {
	return stx.Options.get(e.nodeName == "APPLET"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asMap = function(e) {
	return stx.Options.get(e.nodeName == "MAP"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asArea = function(e) {
	return stx.Options.get(e.nodeName == "AREA"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTable = function(e) {
	return stx.Options.get(e.nodeName == "TABLE"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asCaption = function(e) {
	return stx.Options.get(e.nodeName == "CAPTION"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTD = function(e) {
	return stx.Options.get(e.nodeName == "TD"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTHead = function(e) {
	return stx.Options.get(e.nodeName == "THEAD"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTBody = function(e) {
	return stx.Options.get(e.nodeName == "TBODY"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTFoot = function(e) {
	return stx.Options.get(e.nodeName == "TFOOT"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asTR = function(e) {
	return stx.Options.get(e.nodeName == "TR"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asFrameSet = function(e) {
	return stx.Options.get(e.nodeName == "FRAMESET"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asFrame = function(e) {
	return stx.Options.get(e.nodeName == "FRAME"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asIFrame = function(e) {
	return stx.Options.get(e.nodeName == "IFRAME"?stx.Option.Some(e):stx.Option.None);
}
stx.js.dom.HTMLElementExtensions.asIframeOption = function(e) {
	return e.nodeName == "IFRAME"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asScriptOption = function(e) {
	return e.nodeName == "SCRIPT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asDivOption = function(e) {
	return e.nodeName == "DIV"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asFormOption = function(e) {
	return e.nodeName == "FORM"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asBodyOption = function(e) {
	return e.nodeName == "BODY"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asStyleOption = function(e) {
	return e.nodeName == "STYLE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTextOption = function(e) {
	return e.nodeName == "TEXT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asVideoOption = function(e) {
	return e.nodeName == "VIDEO"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asAudioOption = function(e) {
	return e.nodeName == "AUDIO"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asHeadOption = function(e) {
	return e.nodeName == "HEAD"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asLinkOption = function(e) {
	return e.nodeName == "LINK"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTitleOption = function(e) {
	return e.nodeName == "TITLE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asMetaOption = function(e) {
	return e.nodeName == "META"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asBaseOption = function(e) {
	return e.nodeName == "BASE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asIsIndexOption = function(e) {
	return e.nodeName == "ISINDEX"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asSelectOption = function(e) {
	return e.nodeName == "SELECT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asCanvasOption = function(e) {
	return e.nodeName == "CANVAS"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asOptGroupOption = function(e) {
	return e.nodeName == "OPTGROUP"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asOptionOption = function(e) {
	return e.nodeName == "OPTION"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asInputOption = function(e) {
	return e.nodeName == "INPUT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTextAreaOption = function(e) {
	return e.nodeName == "TEXTAREA"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asButtonOption = function(e) {
	return e.nodeName == "BUTTON"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asLabelOption = function(e) {
	return e.nodeName == "LABEL"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asFieldSetOption = function(e) {
	return e.nodeName == "FIELDSET"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asLegendOption = function(e) {
	return e.nodeName == "LEGEND"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asUListOption = function(e) {
	return e.nodeName == "UL"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asOListOption = function(e) {
	return e.nodeName == "OL"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asDListOption = function(e) {
	return e.nodeName == "DL"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asDirOption = function(e) {
	return e.nodeName == "DIR"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asMenuOption = function(e) {
	return e.nodeName == "MENU"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asLIOption = function(e) {
	return e.nodeName == "LI"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asPOption = function(e) {
	return e.nodeName == "P"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asHOption = function(e) {
	return e.nodeName == "H"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asQuoteOption = function(e) {
	return e.nodeName == "QUOTE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asPreOption = function(e) {
	return e.nodeName == "PRE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asBROption = function(e) {
	return e.nodeName == "BR"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asBaseFontOption = function(e) {
	return e.nodeName == "BASEFONT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asFontOption = function(e) {
	return e.nodeName == "FONT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asHROption = function(e) {
	return e.nodeName == "HR"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asModOption = function(e) {
	return e.nodeName == "MOD"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asAOption = function(e) {
	return e.nodeName == "A"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asImageOption = function(e) {
	return e.nodeName == "IMG"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asObjectOption = function(e) {
	return e.nodeName == "OBJECT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asParamOption = function(e) {
	return e.nodeName == "PARAM"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asAppletOption = function(e) {
	return e.nodeName == "APPLET"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asMapOption = function(e) {
	return e.nodeName == "MAP"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asAreaOption = function(e) {
	return e.nodeName == "AREA"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTableOption = function(e) {
	return e.nodeName == "TABLE"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asCaptionOption = function(e) {
	return e.nodeName == "CAPTION"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTDOption = function(e) {
	return e.nodeName == "TD"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTHeadOption = function(e) {
	return e.nodeName == "THEAD"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTBodyOption = function(e) {
	return e.nodeName == "TBODY"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTFootOption = function(e) {
	return e.nodeName == "TFOOT"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asTROption = function(e) {
	return e.nodeName == "TR"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asFrameSetOption = function(e) {
	return e.nodeName == "FRAMESET"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asFrameOption = function(e) {
	return e.nodeName == "FRAME"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLElementExtensions.asIFrameOption = function(e) {
	return e.nodeName == "IFRAME"?stx.Option.Some(e):stx.Option.None;
}
stx.js.dom.HTMLEventExtensions = $hxClasses["stx.js.dom.HTMLEventExtensions"] = function() { }
stx.js.dom.HTMLEventExtensions.__name__ = ["stx","js","dom","HTMLEventExtensions"];
stx.js.dom.HTMLEventExtensions.cancelBubbling = function(e) {
	var cancelBubble = e.cancelBubble;
	if(cancelBubble != null) e.cancelBubble = true; else e.stopPropagation();
}
stx.js.dom.HTMLEventExtensions.getRelatedTarget = function(event) {
	var ms = event.toElement;
	var net = event.relatedTarget;
	return ms != null?ms:net != null?net:null;
}
stx.js.dom.Quirks = $hxClasses["stx.js.dom.Quirks"] = function() { }
stx.js.dom.Quirks.__name__ = ["stx","js","dom","Quirks"];
stx.js.dom.Quirks.createXMLHttpRequest = function() {
	return window.XMLHttpRequest?new XMLHttpRequest():window.ActiveXObject?(function($this) {
		var $r;
		try {
			$r = new ActiveXObject("Msxml2.XMLHTTP");
		} catch( e ) {
			$r = (function($this) {
				var $r;
				try {
					$r = new ActiveXObject("Microsoft.XMLHTTP");
				} catch( e1 ) {
					$r = (function($this) {
						var $r;
						throw "Unable to create XMLHttpRequest object.";
						$r = null;
						return $r;
					}($this));
				}
				return $r;
			}($this));
		}
		return $r;
	}(this)):(function($this) {
		var $r;
		throw "Unable to create XMLHttpRequest object.";
		$r = null;
		return $r;
	}(this));
}
stx.js.dom.Quirks.getIframeDocument = function(iframe) {
	if(iframe.contentDocument != null) return iframe.contentDocument; else if(iframe.contentWindow != null) return iframe.contentWindow.document; else if(iframe.document != null) return iframe.document; else {
		throw "Cannot find iframe content document for " + Std.string(iframe);
		return null;
	}
}
stx.js.dom.Quirks.getIframeWindow = function(iframe) {
	if(iframe.contentWindow != null) return iframe.contentWindow; else if(iframe.contentDocument != null && iframe.contentDocument.defaultView != null) return iframe.contentDocument.defaultView; else if(iframe.document != null && iframe.document.window != null) return iframe.document.window; else {
		throw "Cannot find iframe content document for " + Std.string(iframe);
		return null;
	}
}
stx.js.dom.Quirks.addEventListener = function(target,type,listener,useCapture) {
	if(target.addEventListener != null) target.addEventListener(type,listener,useCapture); else if(target.attachEvent != null) target.attachEvent("on" + type,listener);
}
stx.js.dom.Quirks.removeEventListener = function(target,type,listener,useCapture) {
	if(target.addEventListener != null) target.removeEventListener(type,listener,useCapture); else if(target.detachEvent != null) target.detachEvent("on" + type,listener);
}
stx.js.dom.Quirks.getOverrideStyle = function(doc,el,pseudo) {
	if($bind(doc,doc.getOverrideStyle) != null && doc.getOverrideStyle(el,pseudo) != null) return doc.getOverrideStyle(el,pseudo); else if(el.runtimeStyle != null) return el.runtimeStyle; else return { };
}
stx.js.dom.Quirks.deleteCssRule = function(doc,rule) {
	var deleteFromSheet = function(sheet) {
		var index = stx.Arrays.indexOf(stx.js.dom.DomCollectionExtensions.toArray(stx.js.dom.Quirks.getCssRules(sheet)),rule);
		if(index > 0) {
			if($bind(sheet,sheet.deleteRule) != null) {
				sheet.deleteRule(index);
				return true;
			} else if(sheet.removeRule != null) {
				sheet.removeRule(index);
				return true;
			}
		}
		return false;
	};
	if(rule.parentStyleSheet != null) deleteFromSheet(rule.parentStyleSheet); else {
		var stylesheets = doc.styleSheets;
		var _g1 = 0, _g = stylesheets.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(deleteFromSheet(stylesheets[i])) break;
		}
	}
	return rule;
}
stx.js.dom.Quirks.addOverridingCssRule = function(el,style) {
	if(style == null) style = "";
	var doc = el.ownerDocument;
	var id = stx.Options.getOrElse(stx.Options.filter(stx.Options.toOption(el.getAttribute("id")),function(id1) {
		return id1 != "";
	}),function() {
		return stx.Anys.withEffect("id-" + stx.util.Guid.generate(),function(guid) {
			el.setAttribute("id",guid);
		});
	});
	stx.js.dom.Quirks.addCssStylesheet(doc,"");
	var lastStyleSheet = doc.styleSheets[doc.styleSheets.length - 1];
	return stx.js.dom.Quirks.insertCssRule(lastStyleSheet,"#" + id + " {" + style + "}");
}
stx.js.dom.Quirks.addCssStylesheet = function(doc,content) {
	var head = stx.Options.getOrElse(stx.Options.toOption(doc.getElementsByTagName("HEAD")[0]),function() {
		return stx.Anys.withEffect(doc.createElement("HEAD"),function(newHead) {
			doc.documentElement.appendChild(newHead);
		});
	});
	var style = doc.createElement("STYLE");
	style.setAttribute("type","text/css");
	try {
		if(style.innerText != null) style.innerText = content; else if(style.innerHTML != null) style.innerHTML = content;
		head.appendChild(style);
	} catch( e ) {
		head.appendChild(style);
		doc.styleSheets[doc.styleSheets.length - 1].cssText = content;
	}
	return doc.styleSheets[doc.styleSheets.length - 1];
}
stx.js.dom.Quirks.getCssRules = function(sheet) {
	return sheet.cssRules != null?sheet.cssRules:sheet.rules;
}
stx.js.dom.Quirks.insertCssRule = function(sheet,rule,index_) {
	if($bind(sheet,sheet.insertRule) != null) {
		var rules = stx.js.dom.Quirks.getCssRules(sheet);
		var index = index_ == null?rules.length:index_;
		sheet.insertRule(rule,index);
		return rules[index];
	} else if(sheet.addRule != null) {
		var addRule = sheet.addRule;
		var Pattern = new EReg("^([^{]+)\\{([^}]*)\\}$","");
		if(Pattern.match(rule)) {
			var index = index_ == null?-1:index_;
			addRule(stx.Strings.trim(Pattern.matched(1)),stx.Strings.trim(Pattern.matched(2)),index);
			var rules = stx.js.dom.Quirks.getCssRules(sheet);
			var newIndex = index == -1?rules.length - 1:index;
			return rules[newIndex];
		}
	}
	return SCore.error("Invalid rule: " + rule,{ fileName : "Quirks.hx", lineNumber : 268, className : "stx.js.dom.Quirks", methodName : "insertCssRule"});
}
stx.js.dom.Quirks.getActualCssPropertyName = function(name) {
	if(stx.js.dom.Quirks.FloatPattern.match(name)) return stx.js.detect.BrowserSupport.cssFloat()?"cssFloat":"styleFloat";
	return name;
}
stx.js.dom.Quirks.getComputedCssProperty = function(elem,name) {
	return stx.Anys.into(stx.js.detect.BrowserSupport.getComputedStyle()?stx.Options.getOrElseC(stx.Options.orElse(stx.Options.flatMap(stx.Options.flatMap(stx.Options.toOption(elem.ownerDocument.defaultView),function(defaultView) {
		return stx.Options.toOption(defaultView.getComputedStyle(elem,null));
	}),function(computedStyle) {
		return stx.Options.filter(stx.Options.toOption(computedStyle.getPropertyValue(name)),function(style) {
			return style != "";
		});
	}),function() {
		return name == "opacity"?stx.Option.Some("1"):stx.Option.None;
	}),""):elem.currentStyle != null?name == "opacity" && !stx.js.detect.BrowserSupport.opacity()?stx.js.dom.Quirks.OpacityPattern.match(elem.currentStyle.filter)?stx.Floats.toString(stx.Strings.toFloat(stx.js.dom.Quirks.OpacityPattern.matched(1)) / 100.0):"1":(function($this) {
		var $r;
		var style = elem.currentStyle[name];
		$r = stx.js.dom.Quirks.NumberPattern.match(style) && !stx.js.dom.Quirks.NumberPixelPattern.match(style)?(function($this) {
			var $r;
			var oldLeft = elem.style.left;
			var oldRtLeft = elem.runtimeStyle.left;
			elem.runtimeStyle.left = elem.currentStyle.left;
			elem.style.left = name == "font-size"?"1em":style;
			$r = stx.Anys.withEffect(elem.style.pixelLeft + "px",function(t) {
				elem.style.left = oldLeft;
				elem.runtimeStyle.left = oldRtLeft;
			});
			return $r;
		}($this)):style;
		return $r;
	}(this)):"",function(computedStyle) {
		return computedStyle == ""?stx.Option.None:stx.Options.toOption(computedStyle);
	});
}
stx.js.dom.Quirks.getCssProperty = function(elem,name) {
	return stx.Options.orElse(stx.Options.flatMap(stx.Options.toOption(elem.style),function(style) {
		return stx.Objects.getAny(style,stx.js.dom.Quirks.getActualCssPropertyName(name));
	}),function() {
		return stx.js.dom.Quirks.getComputedCssProperty(elem,name);
	});
}
stx.js.dom.Quirks.getCssPropertyIfSet = function(elem,name) {
	return stx.Options.filter(stx.js.dom.Quirks.getCssProperty(elem,name),function(style) {
		return style != "";
	});
}
stx.js.dom.Quirks.getViewportSize = function(win_) {
	var win = stx.Options.getOrElseC(stx.Options.toOption(win_),stx.js.Env.window);
	var doc = win.document;
	return stx.js.Env.window.innerWidth != null?{ dx : win.innerWidth, dy : win.innerHeight}:doc.documentElement != null && (doc.documentElement.clientWidth != null && doc.documentElement.clientWidth != 0)?{ dx : doc.documentElement.clientWidth, dy : doc.documentElement.clientHeight}:{ dx : doc.body.clientWidth, dy : doc.body.clientHeight};
}
stx.js.dom.Quirks.getPageScroll = function(win_) {
	var win = stx.Options.getOrElseC(stx.Options.toOption(win_),stx.js.Env.window);
	var doc = win.document;
	var xScroll = 0;
	var yScroll = 0;
	if(stx.js.Env.window.pageYOffset != null) {
		yScroll = win.pageYOffset;
		xScroll = win.pageXOffset;
	} else if(doc.documentElement != null && doc.documentElement.scrollTop != null) {
		yScroll = doc.documentElement.scrollTop;
		xScroll = doc.documentElement.scrollLeft;
	} else if(stx.js.Env.document.body != null) {
		yScroll = doc.body.scrollTop;
		xScroll = doc.body.scrollLeft;
	}
	return { x : xScroll, y : yScroll};
}
stx.js.dom.Quirks.hasAttribute = function(e,attr) {
	if($bind(e,e.hasAttribute) != null) return e.hasAttribute(attr); else {
		var value = e.getAttribute(attr);
		return stx.js.Env.eq(value,null) || stx.js.Env.eq(value,"")?false:true;
	}
}
stx.js.dom.Quirks.getBodyOffset = function(doc) {
	return stx.Options.map(stx.Options.flatMap(stx.Options.toOption(stx.js.Env.document),function(document) {
		return stx.Options.toOption(document.body);
	}),function(body) {
		var top = body.offsetTop;
		var left = body.offsetLeft;
		if(stx.js.detect.BrowserSupport.offsetDoesNotIncludeMarginInBodyOffset()) {
			top += stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getComputedCssProperty(body,"margin-top"),function(s) {
				return stx.Strings["int"](s,0);
			}),0);
			left += stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getComputedCssProperty(body,"margin-left"),function(s) {
				return stx.Strings["int"](s,0);
			}),0);
		}
		return { x : left, y : top};
	});
}
stx.js.dom.Quirks.setOffset = function(elem,offset) {
	if(elem == null || elem.ownerDocument == null) return elem; else {
		var position = stx.js.dom.Quirks.getComputedCssProperty(elem,"position");
		stx.Options.foreach(position,function(v) {
			if(v == "static") elem.style.position = "relative";
		});
		var curOffset = stx.Options.getOrElseC(stx.js.dom.Quirks.getOffset(elem),{ x : 0, y : 0});
		var curTop = stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getComputedCssProperty(elem,"top"),function(s) {
			return stx.Strings["int"](s,0);
		}),0);
		var curLeft = stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getComputedCssProperty(elem,"left"),function(s) {
			return stx.Strings["int"](s,0);
		}),0);
		elem.style.top = stx.Floats.toString(offset.y - curOffset.y + curTop) + "px";
		elem.style.left = stx.Floats.toString(offset.x - curOffset.x + curLeft) + "px";
		return elem;
	}
}
stx.js.dom.Quirks.addClass = function(element,value) {
	if(!stx.js.dom.Quirks.hasClass(element,value)) element.className += (element.className != null && element.className != ""?" ":"") + value;
}
stx.js.dom.Quirks.removeClass = function(element,value) {
	var result = new EReg("(^|\\s)" + value + "(\\s|$)","g").replace(element.className,"$2");
	element.className = new EReg("/^\\s|\\s$/","").replace(result,"");
}
stx.js.dom.Quirks.hasClass = function(element,value) {
	var r = new EReg("(^|\\s)" + value + "(\\s|$)","");
	return element.className != null?r.match(element.className):false;
}
stx.js.dom.Quirks.setWidth = function(elem,width) {
	return stx.js.dom.Quirks.setCssProperty(elem,"width",stx.Floats.toString(width) + "px");
}
stx.js.dom.Quirks.setHeight = function(elem,hight) {
	return stx.js.dom.Quirks.setCssProperty(elem,"height",stx.Floats.toString(hight) + "px");
}
stx.js.dom.Quirks.setCssProperty = function(elem,name,value) {
	if(elem == null || elem.nodeType == 3 || elem.nodeType == 8) return elem; else if((name == "width" || name == "height") && stx.Strings.toFloat(value) < 0) return elem; else {
		var style = elem.style;
		if(name == "opacity" && !stx.js.detect.BrowserSupport.opacity()) {
			style.zoom = 1;
			var opacity = "alpha(opacity=" + stx.Strings.toFloat(value) * 100 + ")";
			var filter = style.filter != null?stx.Options.getOrElseC(stx.js.dom.Quirks.getComputedCssProperty(elem,"filter"),""):"";
			var newFilter = stx.js.dom.Quirks.AlphaPattern.match(filter)?stx.js.dom.Quirks.AlphaPattern.replace(filter,opacity):opacity;
			style.filter = newFilter;
		} else {
			var propertyName = stx.Strings.toCamelCase(stx.js.dom.Quirks.getActualCssPropertyName(name));
			elem.style[propertyName] = value;
		}
		return elem;
	}
}
stx.js.dom.Quirks.getInnerHeight = function(elem) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetHeight",stx.js.dom.Quirks.cssHeight,"padding");
}
stx.js.dom.Quirks.getOuterHeight = function(elem,includeMargin) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetHeight",stx.js.dom.Quirks.cssHeight,includeMargin?"margin":"border");
}
stx.js.dom.Quirks.getInnerWidth = function(elem) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetWidth",stx.js.dom.Quirks.cssWidth,"padding");
}
stx.js.dom.Quirks.getOuterWidth = function(elem,includeMargin) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetWidth",stx.js.dom.Quirks.cssWidth,includeMargin?"margin":"border");
}
stx.js.dom.Quirks.getHeight = function(elem) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetHeight",stx.js.dom.Quirks.cssHeight,"");
}
stx.js.dom.Quirks.getWidth = function(elem) {
	return stx.js.dom.Quirks.getWidthOrHeight(elem,"offsetWidth",stx.js.dom.Quirks.cssWidth,"");
}
stx.js.dom.Quirks.getWidthOrHeight = function(elem,offsetValueExtract,which,extra) {
	if(elem == null || elem.ownerDocument == null) return stx.Option.None; else {
		var val = 0;
		if(elem.offsetWidth != 0) val = stx.js.dom.Quirks.getWH(elem,offsetValueExtract,which,extra); else val = stx.js.dom.Quirks.swap(elem,stx.js.dom.Quirks.cssShow,function(value) {
			return stx.js.dom.Quirks.getWH(elem,offsetValueExtract,which,extra);
		});
		return stx.Option.Some(stx.Floats["int"](Math.max(0,Math.round(val))));
	}
}
stx.js.dom.Quirks.swap = function(elem,values,functionCallback) {
	var elemStyle = stx.js.dom.Quirks.setAndStore(elem,values);
	var result = functionCallback.call(elem);
	stx.js.dom.Quirks.setAndStore(elem,elemStyle);
	return result;
}
stx.js.dom.Quirks.setAndStore = function(elem,styles) {
	var values = stx.ds.Map.create();
	var $it0 = styles.iterator();
	while( $it0.hasNext() ) {
		var k = $it0.next();
		values = values.set(k.fst(),elem.style[k.fst()]);
		elem.style[k.fst()] = k.snd();
	}
	return values;
}
stx.js.dom.Quirks.getWH = function(elem,offsetValueExtract,which,extra) {
	var val = elem[offsetValueExtract];
	if(extra != "border") ArrayLambda.foreach(which,function(v) {
		if(extra != "") val -= stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getCssPropertyIfSet(elem,"padding-" + v),function(s) {
			return stx.Strings["int"](s,0);
		}),0);
		if(extra == "margin") val += stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getCssPropertyIfSet(elem,"margin-" + v),function(s) {
			return stx.Strings["int"](s,0);
		}),0); else val -= stx.Options.getOrElseC(stx.Options.map(stx.js.dom.Quirks.getCssPropertyIfSet(elem,"border-" + v + "-width"),function(s) {
			return stx.Strings["int"](s,0);
		}),0);
	});
	return val;
}
stx.js.dom.Quirks.getOffset = function(elem) {
	if(elem == null || elem.ownerDocument == null) return stx.Option.None; else if(elem == elem.ownerDocument.body) return stx.js.dom.Quirks.getBodyOffset(elem.ownerDocument); else if(stx.js.Env.document.documentElement != null && ($_=stx.js.Env.document.documentElement,$bind($_,$_.getBoundingClientRect)) != null) {
		var box = elem.getBoundingClientRect();
		var doc = elem.ownerDocument;
		var body = doc.body;
		var docElem = doc.documentElement;
		var clientTop = stx.Arrays.first(ArrayLambda.filter([docElem.clientTop,body.clientTop,0],stx.Predicates.isNotNull()));
		var clientLeft = stx.Arrays.first(ArrayLambda.filter([docElem.clientLeft,body.clientLeft,0],stx.Predicates.isNotNull()));
		var top = box.top + stx.Arrays.first(ArrayLambda.filter([stx.js.Env.window.pageYOffset,stx.js.detect.BrowserSupport.boxModel()?docElem.scrollTop:null,body.scrollTop],stx.Predicates.isNotNull())) - clientTop;
		var left = box.left + stx.Arrays.first(ArrayLambda.filter([stx.js.Env.window.pageXOffset,stx.js.detect.BrowserSupport.boxModel()?docElem.scrollLeft:null,body.scrollLeft],stx.Predicates.isNotNull())) - clientLeft;
		return stx.Option.Some({ x : left, y : top});
	} else {
		var getStyle = function(elem1) {
			var defaultView = elem1.ownerDocument.defaultView;
			return defaultView != null?defaultView.getComputedStyle(elem1,null):elem1.currentStyle;
		};
		var offsetParent = elem.offsetParent;
		var prevOffsetParent = elem;
		var doc = elem.ownerDocument;
		var docElem = doc.documentElement;
		var body = doc.body;
		var defaultView = doc.defaultView;
		var prevComputedStyle = getStyle(elem);
		var top = elem.offsetTop;
		var left = elem.offsetLeft;
		while((elem = elem.parentNode) != null && elem != body && elem != docElem) {
			if(stx.js.detect.BrowserSupport.positionFixed() && prevComputedStyle.position == "fixed") break;
			var computedStyle = getStyle(elem);
			top -= elem.scrollTop;
			left -= elem.scrollLeft;
			if(elem == offsetParent) {
				top += elem.offsetTop;
				left += elem.offsetLeft;
				if(stx.js.detect.BrowserSupport.offsetDoesNotAddBorder() && !(stx.js.detect.BrowserSupport.offsetAddsBorderForTableAndCells() && new EReg("^t(able|d|h)$","i").match(elem.nodeName))) {
					top += computedStyle.borderTopWidth["int"](0);
					left += computedStyle.borderLeftWidth["int"](0);
				}
				prevOffsetParent = offsetParent;
				offsetParent = elem.offsetParent;
			}
			if(stx.js.detect.BrowserSupport.offsetSubtractsBorderForOverflowNotVisible() && computedStyle.overflow != "visible") {
				top += computedStyle.borderTopWidth["int"](0);
				left += computedStyle.borderLeftWidth["int"](0);
			}
			prevComputedStyle = computedStyle;
		}
		if(prevComputedStyle.position == "relative" || prevComputedStyle.position == "static") {
			top += body.offsetTop;
			left += body.offsetLeft;
		}
		if(stx.js.detect.BrowserSupport.positionFixed() && prevComputedStyle.position == "fixed") {
			top += stx.Floats["int"](Math.max(docElem.scrollTop,body.scrollTop));
			left += stx.Floats["int"](Math.max(docElem.scrollLeft,body.scrollLeft));
		}
		return stx.Option.Some({ x : left, y : top});
	}
}
stx.js.dom.Quirks.getPosition = function(elem) {
	if(elem == null || elem.ownerDocument == null) return stx.Option.None;
	var offsetParent = stx.js.dom.Quirks.offsetParent(elem);
	var offset = stx.Options.getOrElseC(stx.js.dom.Quirks.getOffset(elem),{ x : 0, y : 0});
	var parentOffset = stx.js.dom.Quirks.RootPattern.match(offsetParent.nodeName)?{ x : 0, y : 0}:stx.Options.getOrElseC(stx.js.dom.Quirks.getOffset(offsetParent),{ x : 0, y : 0});
	offset.x -= stx.Strings["int"](stx.Options.getOrElseC(stx.js.dom.Quirks.getCssPropertyIfSet(elem,"marginTop"),"0"));
	offset.y -= stx.Strings["int"](stx.Options.getOrElseC(stx.js.dom.Quirks.getCssPropertyIfSet(elem,"marginLeft"),"0"));
	parentOffset.x += stx.Strings["int"](stx.Options.getOrElseC(stx.js.dom.Quirks.getCssPropertyIfSet(offsetParent,"borderTopWidth"),"0"));
	parentOffset.y += stx.Strings["int"](stx.Options.getOrElseC(stx.js.dom.Quirks.getCssPropertyIfSet(offsetParent,"borderLeftWidth"),"0"));
	return stx.Option.Some({ x : offset.x - parentOffset.x, y : offset.y - parentOffset.y});
}
stx.js.dom.Quirks.offsetParent = function(elem) {
	var offsetParent = elem.offsetParent != null?elem.offsetParent:stx.js.Env.document.body;
	while(offsetParent != null && (!stx.js.dom.Quirks.RootPattern.match(offsetParent.nodeName) && stx.Options.getOrElseC(stx.js.dom.Quirks.getCssProperty(offsetParent,"position"),"") == "static")) offsetParent = offsetParent.offsetParent;
	return offsetParent;
}
if(!stx.js.io) stx.js.io = {}
stx.js.io.IFrameIO = $hxClasses["stx.js.io.IFrameIO"] = function() { }
stx.js.io.IFrameIO.__name__ = ["stx","js","io","IFrameIO"];
stx.js.io.IFrameIO.prototype = {
	request: null
	,send: null
	,receiveRequests: null
	,receiveWhile: null
	,receive: null
	,__class__: stx.js.io.IFrameIO
}
stx.js.io.AbstractIFrameIO = $hxClasses["stx.js.io.AbstractIFrameIO"] = function() {
	this.requestCounter = 0;
};
stx.js.io.AbstractIFrameIO.__name__ = ["stx","js","io","AbstractIFrameIO"];
stx.js.io.AbstractIFrameIO.__interfaces__ = [stx.js.io.IFrameIO];
stx.js.io.AbstractIFrameIO.prototype = {
	request: function(requestData,targetUrl,targetWindow) {
		var requestId = ++this.requestCounter;
		var future = new stx.Future();
		this.receiveWhile(function(message) {
			return message.__responseId != null && message.__responseId == requestId?(function($this) {
				var $r;
				future.deliver(message.__data,{ fileName : "IFrameIO.hx", lineNumber : 163, className : "stx.js.io.AbstractIFrameIO", methodName : "request"});
				$r = false;
				return $r;
			}(this)):true;
		},targetUrl,targetWindow);
		this.send({ __requestId : requestId, __data : requestData},targetUrl,targetWindow);
		return future;
	}
	,send: function(data,targetUrl,targetWindow) {
		return SCore.error("Not implemented",{ fileName : "IFrameIO.hx", lineNumber : 153, className : "stx.js.io.AbstractIFrameIO", methodName : "send"});
	}
	,receiveRequests: function(f,url,window) {
		var self = this;
		return this.receive(function(message) {
			if(message.__requestId != null && message.__data != null) f(message.__data).deliverTo(function(responseData) {
				self.send({ __responseId : message.__requestId, __data : responseData},url,window);
			});
		},url,window);
	}
	,receiveWhile: function(f,originUrl,originWindow) {
		return SCore.error("Not implemented",{ fileName : "IFrameIO.hx", lineNumber : 134, className : "stx.js.io.AbstractIFrameIO", methodName : "receiveWhile"});
	}
	,receive: function(f,originUrl,originWindow) {
		return SCore.error("Not implemented",{ fileName : "IFrameIO.hx", lineNumber : 130, className : "stx.js.io.AbstractIFrameIO", methodName : "receive"});
	}
	,requestCounter: null
	,__class__: stx.js.io.AbstractIFrameIO
}
stx.js.io.IFrameIOAutoDetect = $hxClasses["stx.js.io.IFrameIOAutoDetect"] = function(w) {
	this.bindTarget = stx.Options.getOrElseC(stx.Options.toOption(w),stx.js.Env.window);
	this.underlying = ($_=this.bindTarget,$bind($_,$_.postMessage)) != null?js.Boot.__cast(new stx.js.io.IFrameIOPostMessage(this.bindTarget) , stx.js.io.IFrameIO):js.Boot.__cast(new stx.js.io.IFrameIOPollingMaptag(this.bindTarget) , stx.js.io.IFrameIO);
};
stx.js.io.IFrameIOAutoDetect.__name__ = ["stx","js","io","IFrameIOAutoDetect"];
stx.js.io.IFrameIOAutoDetect.__interfaces__ = [stx.js.io.IFrameIO];
stx.js.io.IFrameIOAutoDetect.prototype = {
	request: function(data,targetUrl,targetWindow) {
		return this.underlying.request(data,targetUrl,targetWindow);
	}
	,send: function(data,targetUrl,targetWindow) {
		this.underlying.send(data,targetUrl,targetWindow);
		return this;
	}
	,receiveRequests: function(f,url,window) {
		this.underlying.receiveRequests(f,url,window);
		return this;
	}
	,receiveWhile: function(f,originUrl,originWindow) {
		this.underlying.receiveWhile(f,originUrl,originWindow);
		return this;
	}
	,receive: function(f,originUrl,originWindow) {
		this.underlying.receive(f,originUrl,originWindow);
		return this;
	}
	,underlying: null
	,bindTarget: null
	,__class__: stx.js.io.IFrameIOAutoDetect
}
stx.js.io.IFrameIOPostMessage = $hxClasses["stx.js.io.IFrameIOPostMessage"] = function(w) {
	stx.js.io.AbstractIFrameIO.call(this);
	this.bindTarget = w;
};
stx.js.io.IFrameIOPostMessage.__name__ = ["stx","js","io","IFrameIOPostMessage"];
stx.js.io.IFrameIOPostMessage.__interfaces__ = [stx.js.io.IFrameIO];
stx.js.io.IFrameIOPostMessage.normalizeOpt = function(url) {
	return stx.Options.map(stx.net.UrlExtensions.toParsedUrl(url),function(p) {
		return stx.net.UrlExtensions.toUrl(stx.net.UrlExtensions.withoutSearch(stx.net.UrlExtensions.withoutPathname(stx.net.UrlExtensions.withoutMap(p))));
	});
}
stx.js.io.IFrameIOPostMessage.normalize = function(url) {
	return stx.Options.getOrElseC(stx.js.io.IFrameIOPostMessage.normalizeOpt(url),url);
}
stx.js.io.IFrameIOPostMessage.getUrlFor = function(w,url_) {
	return stx.Strings.startsWith(url_,"about:")?(function($this) {
		var $r;
		var allWindows = [w].concat(IterableLambda.toArray(SCore.unfold(w,function(w1) {
			var parentWindow = w1.parent;
			return w1 == parentWindow?stx.Option.None:stx.Option.Some(stx.Entuple.entuple(parentWindow,parentWindow));
		})));
		$r = stx.Arrays.first(ArrayLambda.flatMap(allWindows,function(w1) {
			try {
				return stx.Options.toArray(stx.js.io.IFrameIOPostMessage.normalizeOpt(w1.location.href));
			} catch( e ) {
				return [];
			}
		}));
		return $r;
	}(this)):stx.js.io.IFrameIOPostMessage.normalize(url_);
}
stx.js.io.IFrameIOPostMessage.__super__ = stx.js.io.AbstractIFrameIO;
stx.js.io.IFrameIOPostMessage.prototype = $extend(stx.js.io.AbstractIFrameIO.prototype,{
	send: function(data,targetUrl_,targetWindow) {
		var targetUrl = stx.js.io.IFrameIOPostMessage.getUrlFor(targetWindow,targetUrl_);
		if(stx.Strings.startsWith(targetUrl,"file:")) targetUrl = "*";
		try {
			targetWindow.postMessage(stx.io.json.Json.encodeObject(data),targetUrl);
		} catch( e ) {
			haxe.Log.trace(stx.Log.fatal("Error while posting message to " + targetUrl + " (originally " + targetUrl_ + "): " + Std.string(e.message)),{ fileName : "IFrameIO.hx", lineNumber : 265, className : "stx.js.io.IFrameIOPostMessage", methodName : "send"});
		}
		return this;
	}
	,receiveWhile: function(f,originUrl_,originWindow) {
		var originUrl = stx.js.io.IFrameIOPostMessage.getUrlFor(originWindow,originUrl_);
		var listener = null;
		var self = this;
		listener = function(event) {
			if(event.origin == originUrl || event.origin == "null") {
				var data = stx.io.json.Json.decodeObject(event.data);
				if(!f(data)) stx.js.dom.Quirks.removeEventListener(self.bindTarget,"message",listener,false);
			} else stx.Log.warning("Received data but from wrong domain: expected: " + originUrl + ", but found: " + event.origin);
		};
		stx.js.dom.Quirks.addEventListener(this.bindTarget,"message",listener,false);
		return this;
	}
	,receive: function(f,originUrl,originWindow) {
		return this.receiveWhile(function(d) {
			return stx.Anys.withEffect(true,function(_) {
				f(d);
			});
		},originUrl,originWindow);
	}
	,bindTarget: null
	,__class__: stx.js.io.IFrameIOPostMessage
});
stx.js.io.IFrameIOPollingMaptag = $hxClasses["stx.js.io.IFrameIOPollingMaptag"] = function(w) {
	stx.js.io.AbstractIFrameIO.call(this);
	this.bindTarget = w;
	this.executor = stx.framework.Injector.inject(stx.time.ScheduledExecutor,{ fileName : "IFrameIO.hx", lineNumber : 320, className : "stx.js.io.IFrameIOPollingMaptag", methodName : "new"});
	this.fragmentsToSend = stx.js.io.IFrameIOPollingMaptag.newFragmentsList();
	this.fragmentsReceived = stx.ds.Map.create();
	this.receivers = new Map();
	this.originUrlToWindow = new Map();
	this.senderFuture = stx.Option.None;
	this.receiverFuture = stx.Option.None;
};
stx.js.io.IFrameIOPollingMaptag.__name__ = ["stx","js","io","IFrameIOPollingMaptag"];
stx.js.io.IFrameIOPollingMaptag.__interfaces__ = [stx.js.io.IFrameIO];
stx.js.io.IFrameIOPollingMaptag.normalizeOpt = function(url) {
	return stx.Options.map(stx.net.UrlExtensions.toParsedUrl(url),function(p) {
		return stx.net.UrlExtensions.toUrl(stx.net.UrlExtensions.withoutMap(p));
	});
}
stx.js.io.IFrameIOPollingMaptag.normalize = function(url) {
	return stx.Options.getOrElseC(stx.js.io.IFrameIOPollingMaptag.normalizeOpt(url),url);
}
stx.js.io.IFrameIOPollingMaptag.messageKeyFrom = function(o) {
	return new stx.js.io.MessageKey(stx.Strings["int"](o.messageId),o.from,o.to,stx.Strings["int"](o.fragmentCount));
}
stx.js.io.IFrameIOPollingMaptag.__super__ = stx.js.io.AbstractIFrameIO;
stx.js.io.IFrameIOPollingMaptag.prototype = $extend(stx.js.io.AbstractIFrameIO.prototype,{
	stopReceiver: function() {
		stx.Options.map(this.receiverFuture,function(r) {
			r.cancel();
			return stx.Unit.Unit;
		});
		this.receiverFuture = stx.Option.None;
	}
	,startReceiver: function() {
		if(stx.Options.isEmpty(this.receiverFuture)) this.receiverFuture = stx.Option.Some(this.executor.forever($bind(this,this.receiver),10));
	}
	,stopSender: function() {
		stx.Options.map(this.senderFuture,function(s) {
			s.cancel();
			return stx.Unit.Unit;
		});
		this.senderFuture = stx.Option.None;
	}
	,startSender: function() {
		if(stx.Options.isEmpty(this.senderFuture)) this.senderFuture = stx.Option.Some(this.executor.forever($bind(this,this.sender),20));
	}
	,fragmentsReceivedFor: function(messageKey) {
		if(!this.fragmentsReceived.containsKey(messageKey)) this.fragmentsReceived = this.fragmentsReceived.set(messageKey,[]);
		return stx.Options.get(this.fragmentsReceived.get(messageKey));
	}
	,findMissingFragments: function() {
		return IterableLambda.foldl(this.fragmentsReceived.values(),stx.ds.List.nil(),function(allMissing,fragments) {
			var firstFrag = fragments[0];
			fragments.sort(function(a,b) {
				return stx.Strings["int"](a.fragmentId) - stx.Strings["int"](b.fragmentId);
			});
			return stx.ds.ArrayToList.toList(fragments).gaps(function(a,b) {
				var lastId = stx.Strings["int"](a.fragmentId);
				var curId = stx.Strings["int"](b.fragmentId);
				return stx.ds.List.toList(IterableLambda.map(IntIterators.until(lastId + 1,curId),function(missingId) {
					var request = { type : "request", from : firstFrag.to, to : firstFrag.from, messageId : firstFrag.messageId, fragmentCount : firstFrag.fragmentCount, fragmentId : stx.Floats.toString(missingId)};
					return request;
				}));
			});
		});
	}
	,analyzeReceivedFragments: function(messageKey,fragments) {
		if(fragments.length >= messageKey.fragmentCount) {
			fragments.sort(function(a,b) {
				return stx.Strings["int"](a.fragmentId) - stx.Strings["int"](b.fragmentId);
			});
			var fullData = ArrayLambda.foldl(fragments,"",function(a,b) {
				return a + b.data;
			});
			var message = stx.io.json.Json.decodeObject(fullData);
			var domain = this.extractDomain(fragments[0].from);
			if(this.receivers.exists(domain)) ArrayLambda.foreach(this.receivers.get(domain),function(r) {
				r(message);
			});
			this.fragmentsReceived.removeByKey(messageKey);
		}
	}
	,extractDomain: function(url) {
		return (function($this) {
			var $r;
			var $e = (stx.net.UrlExtensions.toParsedUrl(url));
			switch( $e[1] ) {
			case 1:
				var parsed = $e[2];
				$r = parsed.hostname + parsed.pathname;
				break;
			case 0:
				$r = url;
				break;
			}
			return $r;
		}(this));
	}
	,receiver: function() {
		var hash = this.bindTarget.location.hash;
		if(hash.length > 2) {
			var query = "?" + HxOverrides.substr(hash,2,null);
			var unknown = stx.ds.MapExtensions.toObject(stx.net.UrlExtensions.toQueryParameters(query));
			if(unknown.type == "delivery") {
				var packet = unknown;
				var messageKey = stx.js.io.IFrameIOPollingMaptag.messageKeyFrom(packet);
				var fragments = this.fragmentsReceivedFor(messageKey);
				var alreadyReceived = ArrayLambda.foldl(fragments,false,function(b,f) {
					return b || f.fragmentId == packet.fragmentId;
				});
				if(!alreadyReceived) {
					fragments.push(packet);
					this.analyzeReceivedFragments(messageKey,fragments);
				}
			} else if(unknown.type == "request") {
				var packet = unknown;
				var messageKey = stx.js.io.IFrameIOPollingMaptag.messageKeyFrom(packet);
			} else if(unknown.type == "receipt") {
				var packet = unknown;
				var messageKey = stx.js.io.IFrameIOPollingMaptag.messageKeyFrom(packet);
			}
			this.bindTarget.location.hash = "#&";
		} else {
			var self = this;
			var fragmentRequests = this.findMissingFragments();
			if(fragmentRequests.size() > 0) {
				var encoded = stx.functional.FoldableExtensions.flatMapTo(fragmentRequests,stx.ds.List.nil(),function(request) {
					var win = self.originUrlToWindow.get(request.to);
					return win != null?stx.ds.List.nil().cons(stx.Entuple.entuple(win,request)):stx.ds.List.nil();
				});
				this.fragmentsToSend = this.fragmentsToSend.concat(encoded);
			}
		}
	}
	,sender: function() {
		var $e = (this.fragmentsToSend.getHeadOption());
		switch( $e[1] ) {
		case 0:
			this.stopSender();
			break;
		case 1:
			var tuple = $e[2];
			this.fragmentsToSend = this.fragmentsToSend.drop(1);
			var win = tuple.fst();
			var frag = tuple.snd();
			win.location.href = frag.to + "#&" + HxOverrides.substr(stx.net.UrlExtensions.toQueryString(stx.ds.MapExtensions.toMap(frag)),1,null);
			break;
		}
	}
	,stop: function() {
		this.stopSender();
		this.stopReceiver();
		return this;
	}
	,send: function(data,to_,iframe) {
		var from = stx.js.io.IFrameIOPollingMaptag.normalize(this.bindTarget.location.href);
		var to = stx.js.io.IFrameIOPollingMaptag.normalize(to_);
		var maxFragSize = 1500 - to.length;
		var fragmentId = 1;
		var fragments = stx.ds.ArrayToList.toList(stx.Strings.chunk(stx.io.json.Json.encodeObject(data),maxFragSize));
		var encoded = stx.functional.FoldableExtensions.mapTo(fragments,stx.js.io.IFrameIOPollingMaptag.newFragmentsList(),function(chunk) {
			return stx.Entuple.entuple(iframe,{ type : "delivery", from : from, to : to, messageId : stx.Floats.toString(stx.js.io.IFrameIOPollingMaptag.lastMessageId), fragmentId : stx.Floats.toString(fragmentId++), fragmentCount : stx.Floats.toString(fragments.size()), data : chunk});
		});
		this.fragmentsToSend = this.fragmentsToSend.concat(encoded);
		++stx.js.io.IFrameIOPollingMaptag.lastMessageId;
		this.startSender();
		return this;
	}
	,receiveWhile: function(f,originUrl,originWindow) {
		var self = this;
		var domain = this.extractDomain(originUrl);
		var r = this.receivers.exists(domain)?this.receivers.get(domain):stx.Anys.withEffect([],function(r1) {
			self.receivers.set(domain,r1);
		});
		var wrapper = null;
		wrapper = function(d) {
			if(!f(d)) HxOverrides.remove(r,wrapper);
		};
		r.push(wrapper);
		this.originUrlToWindow.set(originUrl,originWindow);
		this.startReceiver();
		return this;
	}
	,receive: function(f,originUrl,originWindow) {
		return this.receiveWhile(function(d) {
			return stx.Anys.withEffect(true,function(_) {
				f(d);
			});
		},originUrl,originWindow);
	}
	,receiverFuture: null
	,senderFuture: null
	,bindTarget: null
	,originUrlToWindow: null
	,receivers: null
	,fragmentsReceived: null
	,fragmentsToSend: null
	,executor: null
	,__class__: stx.js.io.IFrameIOPollingMaptag
});
stx.js.io.MessageKey = $hxClasses["stx.js.io.MessageKey"] = function(messageId,from,to,fragmentCount) {
	this.messageId = messageId;
	this.from = from;
	this.to = to;
	this.fragmentCount = fragmentCount;
};
stx.js.io.MessageKey.__name__ = ["stx","js","io","MessageKey"];
stx.js.io.MessageKey.prototype = {
	equals: function(other) {
		return this.messageId == other.messageId && this.from == other.from && this.to == other.to && this.fragmentCount == other.fragmentCount;
	}
	,hashCode: function() {
		return stx.ds.plus.FloatHasher.hashCode(this.messageId) * stx.ds.plus.StringHasher.hashCode(this.from) * stx.ds.plus.StringHasher.hashCode(this.to) * stx.ds.plus.FloatHasher.hashCode(this.fragmentCount);
	}
	,fragmentCount: null
	,to: null
	,from: null
	,messageId: null
	,__class__: stx.js.io.MessageKey
}
if(!stx.js.text) stx.js.text = {}
if(!stx.js.text.html) stx.js.text.html = {}
stx.js.text.html.HTMLParser = $hxClasses["stx.js.text.html.HTMLParser"] = function() { }
stx.js.text.html.HTMLParser.__name__ = ["stx","js","text","html","HTMLParser"];
stx.js.text.html.HTMLParser.parseIntoElements = function(s) {
	var d = js.Lib.document, container = d.createElement("div"), convert_script = function(node_as_text) {
		var r = new EReg("^<script ([^>]+)>",""), new_script_node = d.createElement("script");
		if(r.match(node_as_text)) new EReg("(\\w+)=([\"'])([^\\1]*)\\1","").customReplace(r.matched(1),function(matches) {
			new_script_node.setAttribute(matches.matched(1),matches.matched(3));
			return "";
		});
		var r2 = new EReg("^<script[^>]*>(.*)</script>",""), can_have_children = new_script_node.canHaveChildren;
		if(r2.match(node_as_text)) {
			if(can_have_children == null || can_have_children) new_script_node.appendChild(d.createTextNode(r2.matched(1))); else new_script_node.text = r2.matched(1);
		}
		return new_script_node;
	}, parsed = stx.js.text.html.HTMLParser.parse(s);
	container.innerHTML = parsed[0];
	return Lambda.array(Lambda.map({ iterator : function() {
		return new IntIterator(0,container.childNodes.length);
	}},function(i) {
		return container.childNodes[i];
	})).concat(Lambda.array(Lambda.map(parsed.slice(1),convert_script)));
}
stx.js.text.html.HTMLParser.parse = function(s) {
	var min = function(x,y) {
		return x < y?x:y;
	}, max = function(x,y) {
		return x > y?x:y;
	}, next = function(s1,search,mark,previous) {
		return previous > mark?previous:(mark = s1.indexOf(search,mark)) == -1?s1.length:mark;
	}, end_of_string = function(start,s1) {
		var mark = start + 1, back_mark = start, quote_mark = start, quote = s1.charAt(start);
		while((quote_mark = next(s1,quote,mark,quote_mark)) > (back_mark = next(s1,"\\",mark,back_mark))) mark = back_mark + 2;
		return quote_mark;
	}, end_of_line_comment = function(start,s1) {
		return next(s1,"\n",start,start);
	}, end_of_block_comment = function(start,s1) {
		return next(s1,"*/",start + 2,start + 2);
	}, end_of_cdata = function(start,s1) {
		return next(s1,"]]>",start,start);
	}, end_of_comment = function(start,s1) {
		return next(s1,"-->",start + 4,start + 4);
	}, end_of_script = function(start,s1,l) {
		var mark = start, line_comment_mark = start, block_comment_mark = start, single_string_mark = start, double_string_mark = start, cdata_mark = start, close_script_mark = start;
		while((close_script_mark = next(l,"</script>",mark,close_script_mark)) % s1.length > (mark = min(min(min(single_string_mark = next(s1,"'",mark,single_string_mark),double_string_mark = next(s1,"\"",mark,double_string_mark)),cdata_mark = next(s1,"<![CDATA[",mark,cdata_mark)),min(line_comment_mark = next(s1,"//",mark,line_comment_mark),block_comment_mark = next(s1,"/*",mark,block_comment_mark))))) mark = (mark == single_string_mark || mark == double_string_mark?end_of_string:mark == line_comment_mark?end_of_line_comment:mark == block_comment_mark?end_of_block_comment:end_of_cdata)(mark,s1) + 1;
		return close_script_mark + 9;
	}, next_script = function(start,s1,l) {
		var mark = start, cdata_mark = start, comment_mark = start, script_mark = start;
		while((script_mark = next(l,"<script",mark,script_mark)) % s1.length > (mark = min(cdata_mark = next(s1,"<![CDATA[",mark,cdata_mark),comment_mark = next(s1,"<!--",mark,comment_mark)))) mark = (mark == cdata_mark?end_of_cdata:end_of_comment)(mark,s1);
		return script_mark;
	}, mark = 0, last_mark = 0, scripts = [], rest = [], lowercase = s.toLowerCase();
	while((mark = next_script(mark,s,lowercase)) < s.length) {
		rest.push(HxOverrides.substr(s,last_mark,mark - last_mark));
		scripts.push(HxOverrides.substr(s,mark,-(mark - (mark = end_of_script(s.indexOf(">",mark),s,lowercase)))));
		last_mark = mark;
	}
	rest.push(HxOverrides.substr(s,last_mark,null));
	return [rest.join("")].concat(scripts);
}
if(!stx.macro) stx.macro = {}
stx.macro.Lenses = $hxClasses["stx.macro.Lenses"] = function() { }
stx.macro.Lenses.__name__ = ["stx","macro","Lenses"];
stx.macro.LensesFor = $hxClasses["stx.macro.LensesFor"] = function() { }
stx.macro.LensesFor.__name__ = ["stx","macro","LensesFor"];
stx.macro.Stx = $hxClasses["stx.macro.Stx"] = function() { }
stx.macro.Stx.__name__ = ["stx","macro","Stx"];
if(!stx.math) stx.math = {}
if(!stx.math.geom) stx.math.geom = {}
stx.math.geom.Point2dIntExtensions = $hxClasses["stx.math.geom.Point2dIntExtensions"] = function() { }
stx.math.geom.Point2dIntExtensions.__name__ = ["stx","math","geom","Point2dIntExtensions"];
stx.math.geom.Point2dIntExtensions.minus = function(p1,p2) {
	return { dx : p1.x - p2.x, dy : p1.y - p2.y};
}
stx.math.geom.Point2dIntExtensions.plus = function(p,v) {
	return { x : p.x + v.dx, y : p.y + v.dy};
}
stx.math.geom.Point2dIntExtensions.map = function(p,f,g) {
	return { x : f(p.x), y : g(p.y)};
}
stx.math.geom.Point2dIntExtensions.toVector = function(p) {
	return { dx : p.x, dy : p.y};
}
stx.math.geom.Point2dIntExtensions.toFloat = function(p) {
	return { x : stx.Ints.toFloat(p.x), y : stx.Ints.toFloat(p.y)};
}
stx.math.geom.Point2dIntExtensions.toTuple = function(p) {
	return stx.Entuple.entuple(p.x,p.y);
}
stx.math.geom.Point2dFloatExtensions = $hxClasses["stx.math.geom.Point2dFloatExtensions"] = function() { }
stx.math.geom.Point2dFloatExtensions.__name__ = ["stx","math","geom","Point2dFloatExtensions"];
stx.math.geom.Point2dFloatExtensions.minus = function(p1,p2) {
	return { dx : p1.x - p2.x, dy : p1.y - p2.y};
}
stx.math.geom.Point2dFloatExtensions.plus = function(p,v) {
	return { x : p.x + v.dx, y : p.y + v.dy};
}
stx.math.geom.Point2dFloatExtensions.map = function(p,f,g) {
	return { x : f(p.x), y : g(p.y)};
}
stx.math.geom.Point2dFloatExtensions.toVector = function(p) {
	return { dx : p.x, dy : p.y};
}
stx.math.geom.Point2dFloatExtensions.toInt = function(p) {
	return { x : stx.Floats.round(p.x,null), y : stx.Floats.round(p.y,null)};
}
stx.math.geom.Point2dFloatExtensions.toTuple = function(p) {
	return stx.Entuple.entuple(p.x,p.y);
}
stx.math.geom.Vector2dIntExtensions = $hxClasses["stx.math.geom.Vector2dIntExtensions"] = function() { }
stx.math.geom.Vector2dIntExtensions.__name__ = ["stx","math","geom","Vector2dIntExtensions"];
stx.math.geom.Vector2dIntExtensions.minus = function(v1,v2) {
	return { dx : v1.dx - v2.dx, dy : v1.dy - v2.dy};
}
stx.math.geom.Vector2dIntExtensions.plus = function(v1,v2) {
	return { dx : v1.dx + v2.dx, dy : v1.dy + v2.dy};
}
stx.math.geom.Vector2dIntExtensions.times = function(v,factor) {
	return { dx : v.dx * factor, dy : v.dy * factor};
}
stx.math.geom.Vector2dIntExtensions.dot = function(v1,v2) {
	return v1.dx * v2.dx + v1.dy * v2.dy;
}
stx.math.geom.Vector2dIntExtensions.map = function(v,f,g) {
	return { dx : f(v.dx), dy : g(v.dy)};
}
stx.math.geom.Vector2dIntExtensions.toPoint = function(v) {
	return { x : v.dx, y : v.dy};
}
stx.math.geom.Vector2dIntExtensions.toFloat = function(v) {
	return { dx : stx.Ints.toFloat(v.dx), dy : stx.Ints.toFloat(v.dy)};
}
stx.math.geom.Vector2dIntExtensions.toTuple = function(v) {
	return stx.Entuple.entuple(v.dx,v.dy);
}
stx.math.geom.Vector2dFloatExtensions = $hxClasses["stx.math.geom.Vector2dFloatExtensions"] = function() { }
stx.math.geom.Vector2dFloatExtensions.__name__ = ["stx","math","geom","Vector2dFloatExtensions"];
stx.math.geom.Vector2dFloatExtensions.minus = function(v1,v2) {
	return { dx : v1.dx - v2.dx, dy : v1.dy - v2.dy};
}
stx.math.geom.Vector2dFloatExtensions.plus = function(v1,v2) {
	return { dx : v1.dx + v2.dx, dy : v1.dy + v2.dy};
}
stx.math.geom.Vector2dFloatExtensions.times = function(v,factor) {
	return { dx : v.dx * factor, dy : v.dy * factor};
}
stx.math.geom.Vector2dFloatExtensions.dot = function(v1,v2) {
	return v1.dx * v2.dx + v1.dy * v2.dy;
}
stx.math.geom.Vector2dFloatExtensions.map = function(v,f,g) {
	return { dx : f(v.dx), dy : g(v.dy)};
}
stx.math.geom.Vector2dFloatExtensions.toPoint = function(v) {
	return { x : v.dx, y : v.dy};
}
stx.math.geom.Vector2dFloatExtensions.toInt = function(v) {
	return { dx : stx.Floats.round(v.dx,null), dy : stx.Floats.round(v.dy,null)};
}
stx.math.geom.Vector2dFloatExtensions.toTuple = function(v) {
	return stx.Entuple.entuple(v.dx,v.dy);
}
if(!stx.math.tween) stx.math.tween = {}
stx.math.tween.Easings = $hxClasses["stx.math.tween.Easings"] = function() { }
stx.math.tween.Easings.__name__ = ["stx","math","tween","Easings"];
stx.math.tween.Easings.Linear = function(t) {
	return t;
}
stx.math.tween.Easings.Quadratic = function(t) {
	return t * t;
}
stx.math.tween.Easings.Cubic = function(t) {
	return t * t * t;
}
stx.math.tween.Easings.Quartic = function(t) {
	var squared = t * t;
	return squared * squared;
}
stx.math.tween.Easings.Quintic = function(t) {
	var squared = t * t;
	return squared * squared * t;
}
stx.math.tween.Tween = $hxClasses["stx.math.tween.Tween"] = function() { }
stx.math.tween.Tween.__name__ = ["stx","math","tween","Tween"];
stx.math.tween.Tween.linear = function(state1,state2,def) {
	if(def == null) def = 0.0;
	var combinedFields = stx.ds.ArrayToSet.toSet(Reflect.fields(state1)).addAll(Reflect.fields(state2));
	var data = stx.ds.FoldableToMap.toMap(stx.functional.FoldableExtensions.map(combinedFields,function(name) {
		var start = stx.Options.getOrElseC(stx.Options.toOption(Reflect.field(state1,name)),def);
		var end = stx.Options.getOrElseC(stx.Options.toOption(Reflect.field(state2,name)),def);
		return stx.Entuple.entuple(name,{ start : start, delta : end - start});
	}));
	return function(t) {
		return data.foldl({ },function(r,tuple) {
			var name = tuple.fst();
			var start = tuple.snd().start;
			var delta = tuple.snd().delta;
			r[name] = start + t * delta;
			return r;
		});
	};
}
stx.math.tween.TweenerExtensions = $hxClasses["stx.math.tween.TweenerExtensions"] = function() { }
stx.math.tween.TweenerExtensions.__name__ = ["stx","math","tween","TweenerExtensions"];
stx.math.tween.TweenerExtensions.startWith = function(tweener,easing) {
	return function(t) {
		return tweener(easing(t));
	};
}
stx.math.tween.TweenerExtensions.endWith = function(tweener,easing) {
	return stx.math.tween.TweenerExtensions.startWith(tweener,function(t) {
		return 1.0 - easing(1.0 - t);
	});
}
stx.math.tween.TweenerExtensions.animate = function(tweener,duration,frequency_,cb) {
	if(frequency_ == null) frequency_ = 0;
	var executor = stx.framework.Injector.inject(stx.time.ScheduledExecutor,{ fileName : "TweenExtensions.hx", lineNumber : 53, className : "stx.math.tween.TweenerExtensions", methodName : "animate"});
	var frequency = frequency_ > 0?frequency_:stx.math.tween.TweenerExtensions.DefaultFrequency;
	return executor.repeat(frequency,function(millis) {
		var t = millis / duration;
		cb(tweener(t));
		return millis + frequency;
	},frequency,stx.Floats.ceil(duration / frequency,null));
}
if(!stx.net) stx.net = {}
stx.net.HttpHeaderExtensions = $hxClasses["stx.net.HttpHeaderExtensions"] = function() { }
stx.net.HttpHeaderExtensions.__name__ = ["stx","net","HttpHeaderExtensions"];
stx.net.HttpHeaderExtensions.toHttpHeader = function(str) {
	return stx.net.HttpHeaderExtensions.HeaderPattern.match(str)?stx.Option.Some(stx.Entuple.entuple(stx.Strings.trim(stx.net.HttpHeaderExtensions.HeaderPattern.matched(1)),stx.Strings.trim(stx.net.HttpHeaderExtensions.HeaderPattern.matched(2)))):stx.Option.None;
}
stx.net.HttpHeaderExtensions.toHttpHeaders = function(str) {
	return stx.ds.Map.create().addAll(ArrayLambda.flatMap(stx.net.HttpHeaderExtensions.HeaderLinesPattern.split(str),function(line) {
		return stx.Options.toArray(stx.net.HttpHeaderExtensions.toHttpHeader(stx.Strings.trim(line)));
	}));
}
stx.net.HttpInformational = $hxClasses["stx.net.HttpInformational"] = { __ename__ : ["stx","net","HttpInformational"], __constructs__ : ["Continue","SwitchingProtocols","Processing"] }
stx.net.HttpInformational.Continue = ["Continue",0];
stx.net.HttpInformational.Continue.toString = $estr;
stx.net.HttpInformational.Continue.__enum__ = stx.net.HttpInformational;
stx.net.HttpInformational.SwitchingProtocols = ["SwitchingProtocols",1];
stx.net.HttpInformational.SwitchingProtocols.toString = $estr;
stx.net.HttpInformational.SwitchingProtocols.__enum__ = stx.net.HttpInformational;
stx.net.HttpInformational.Processing = ["Processing",2];
stx.net.HttpInformational.Processing.toString = $estr;
stx.net.HttpInformational.Processing.__enum__ = stx.net.HttpInformational;
stx.net.HttpSuccess = $hxClasses["stx.net.HttpSuccess"] = { __ename__ : ["stx","net","HttpSuccess"], __constructs__ : ["OK","Created","Accepted","Non","NoContent","ResetContent","PartialContent","Multi"] }
stx.net.HttpSuccess.OK = ["OK",0];
stx.net.HttpSuccess.OK.toString = $estr;
stx.net.HttpSuccess.OK.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.Created = ["Created",1];
stx.net.HttpSuccess.Created.toString = $estr;
stx.net.HttpSuccess.Created.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.Accepted = ["Accepted",2];
stx.net.HttpSuccess.Accepted.toString = $estr;
stx.net.HttpSuccess.Accepted.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.Non = ["Non",3];
stx.net.HttpSuccess.Non.toString = $estr;
stx.net.HttpSuccess.Non.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.NoContent = ["NoContent",4];
stx.net.HttpSuccess.NoContent.toString = $estr;
stx.net.HttpSuccess.NoContent.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.ResetContent = ["ResetContent",5];
stx.net.HttpSuccess.ResetContent.toString = $estr;
stx.net.HttpSuccess.ResetContent.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.PartialContent = ["PartialContent",6];
stx.net.HttpSuccess.PartialContent.toString = $estr;
stx.net.HttpSuccess.PartialContent.__enum__ = stx.net.HttpSuccess;
stx.net.HttpSuccess.Multi = ["Multi",7];
stx.net.HttpSuccess.Multi.toString = $estr;
stx.net.HttpSuccess.Multi.__enum__ = stx.net.HttpSuccess;
stx.net.HttpRedirection = $hxClasses["stx.net.HttpRedirection"] = { __ename__ : ["stx","net","HttpRedirection"], __constructs__ : ["MultipleChoices","MovedPermanently","Found","SeeOther","NotModified","UseProxy","TemporaryRedirect"] }
stx.net.HttpRedirection.MultipleChoices = ["MultipleChoices",0];
stx.net.HttpRedirection.MultipleChoices.toString = $estr;
stx.net.HttpRedirection.MultipleChoices.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.MovedPermanently = ["MovedPermanently",1];
stx.net.HttpRedirection.MovedPermanently.toString = $estr;
stx.net.HttpRedirection.MovedPermanently.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.Found = ["Found",2];
stx.net.HttpRedirection.Found.toString = $estr;
stx.net.HttpRedirection.Found.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.SeeOther = ["SeeOther",3];
stx.net.HttpRedirection.SeeOther.toString = $estr;
stx.net.HttpRedirection.SeeOther.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.NotModified = ["NotModified",4];
stx.net.HttpRedirection.NotModified.toString = $estr;
stx.net.HttpRedirection.NotModified.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.UseProxy = ["UseProxy",5];
stx.net.HttpRedirection.UseProxy.toString = $estr;
stx.net.HttpRedirection.UseProxy.__enum__ = stx.net.HttpRedirection;
stx.net.HttpRedirection.TemporaryRedirect = ["TemporaryRedirect",6];
stx.net.HttpRedirection.TemporaryRedirect.toString = $estr;
stx.net.HttpRedirection.TemporaryRedirect.__enum__ = stx.net.HttpRedirection;
stx.net.HttpClientError = $hxClasses["stx.net.HttpClientError"] = { __ename__ : ["stx","net","HttpClientError"], __constructs__ : ["BadRequest","Unauthorized","PaymentRequired","Forbidden","NotFound","MethodNotAllowed","NotAcceptable","ProxyAuthenticationRequired","RequestTimeout","Conflict","Gone","LengthRequired","PreconditionFailed","RequestEntityTooLarge","Request","UnsupportedMediaType","RequestedRangeNotSatisfiable","ExpectationFailed","TooManyConnections","UnprocessableEntity","Locked","FailedDependency","UnorderedCollection","UpgradeRequired","RetryWith"] }
stx.net.HttpClientError.BadRequest = ["BadRequest",0];
stx.net.HttpClientError.BadRequest.toString = $estr;
stx.net.HttpClientError.BadRequest.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Unauthorized = ["Unauthorized",1];
stx.net.HttpClientError.Unauthorized.toString = $estr;
stx.net.HttpClientError.Unauthorized.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.PaymentRequired = ["PaymentRequired",2];
stx.net.HttpClientError.PaymentRequired.toString = $estr;
stx.net.HttpClientError.PaymentRequired.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Forbidden = ["Forbidden",3];
stx.net.HttpClientError.Forbidden.toString = $estr;
stx.net.HttpClientError.Forbidden.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.NotFound = ["NotFound",4];
stx.net.HttpClientError.NotFound.toString = $estr;
stx.net.HttpClientError.NotFound.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.MethodNotAllowed = ["MethodNotAllowed",5];
stx.net.HttpClientError.MethodNotAllowed.toString = $estr;
stx.net.HttpClientError.MethodNotAllowed.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.NotAcceptable = ["NotAcceptable",6];
stx.net.HttpClientError.NotAcceptable.toString = $estr;
stx.net.HttpClientError.NotAcceptable.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.ProxyAuthenticationRequired = ["ProxyAuthenticationRequired",7];
stx.net.HttpClientError.ProxyAuthenticationRequired.toString = $estr;
stx.net.HttpClientError.ProxyAuthenticationRequired.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.RequestTimeout = ["RequestTimeout",8];
stx.net.HttpClientError.RequestTimeout.toString = $estr;
stx.net.HttpClientError.RequestTimeout.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Conflict = ["Conflict",9];
stx.net.HttpClientError.Conflict.toString = $estr;
stx.net.HttpClientError.Conflict.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Gone = ["Gone",10];
stx.net.HttpClientError.Gone.toString = $estr;
stx.net.HttpClientError.Gone.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.LengthRequired = ["LengthRequired",11];
stx.net.HttpClientError.LengthRequired.toString = $estr;
stx.net.HttpClientError.LengthRequired.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.PreconditionFailed = ["PreconditionFailed",12];
stx.net.HttpClientError.PreconditionFailed.toString = $estr;
stx.net.HttpClientError.PreconditionFailed.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.RequestEntityTooLarge = ["RequestEntityTooLarge",13];
stx.net.HttpClientError.RequestEntityTooLarge.toString = $estr;
stx.net.HttpClientError.RequestEntityTooLarge.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Request = ["Request",14];
stx.net.HttpClientError.Request.toString = $estr;
stx.net.HttpClientError.Request.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.UnsupportedMediaType = ["UnsupportedMediaType",15];
stx.net.HttpClientError.UnsupportedMediaType.toString = $estr;
stx.net.HttpClientError.UnsupportedMediaType.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.RequestedRangeNotSatisfiable = ["RequestedRangeNotSatisfiable",16];
stx.net.HttpClientError.RequestedRangeNotSatisfiable.toString = $estr;
stx.net.HttpClientError.RequestedRangeNotSatisfiable.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.ExpectationFailed = ["ExpectationFailed",17];
stx.net.HttpClientError.ExpectationFailed.toString = $estr;
stx.net.HttpClientError.ExpectationFailed.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.TooManyConnections = ["TooManyConnections",18];
stx.net.HttpClientError.TooManyConnections.toString = $estr;
stx.net.HttpClientError.TooManyConnections.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.UnprocessableEntity = ["UnprocessableEntity",19];
stx.net.HttpClientError.UnprocessableEntity.toString = $estr;
stx.net.HttpClientError.UnprocessableEntity.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.Locked = ["Locked",20];
stx.net.HttpClientError.Locked.toString = $estr;
stx.net.HttpClientError.Locked.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.FailedDependency = ["FailedDependency",21];
stx.net.HttpClientError.FailedDependency.toString = $estr;
stx.net.HttpClientError.FailedDependency.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.UnorderedCollection = ["UnorderedCollection",22];
stx.net.HttpClientError.UnorderedCollection.toString = $estr;
stx.net.HttpClientError.UnorderedCollection.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.UpgradeRequired = ["UpgradeRequired",23];
stx.net.HttpClientError.UpgradeRequired.toString = $estr;
stx.net.HttpClientError.UpgradeRequired.__enum__ = stx.net.HttpClientError;
stx.net.HttpClientError.RetryWith = ["RetryWith",24];
stx.net.HttpClientError.RetryWith.toString = $estr;
stx.net.HttpClientError.RetryWith.__enum__ = stx.net.HttpClientError;
stx.net.HttpServerError = $hxClasses["stx.net.HttpServerError"] = { __ename__ : ["stx","net","HttpServerError"], __constructs__ : ["InternalServerError","NotImplemented","BadGateway","ServiceUnavailable","GatewayTimeout","HTTPVersionNotSupported","VariantAlsoNegotiates","InsufficientStorage","BandwidthLimitExceeded","NotExtended","UserAccessDenied"] }
stx.net.HttpServerError.InternalServerError = ["InternalServerError",0];
stx.net.HttpServerError.InternalServerError.toString = $estr;
stx.net.HttpServerError.InternalServerError.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.NotImplemented = ["NotImplemented",1];
stx.net.HttpServerError.NotImplemented.toString = $estr;
stx.net.HttpServerError.NotImplemented.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.BadGateway = ["BadGateway",2];
stx.net.HttpServerError.BadGateway.toString = $estr;
stx.net.HttpServerError.BadGateway.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.ServiceUnavailable = ["ServiceUnavailable",3];
stx.net.HttpServerError.ServiceUnavailable.toString = $estr;
stx.net.HttpServerError.ServiceUnavailable.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.GatewayTimeout = ["GatewayTimeout",4];
stx.net.HttpServerError.GatewayTimeout.toString = $estr;
stx.net.HttpServerError.GatewayTimeout.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.HTTPVersionNotSupported = ["HTTPVersionNotSupported",5];
stx.net.HttpServerError.HTTPVersionNotSupported.toString = $estr;
stx.net.HttpServerError.HTTPVersionNotSupported.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.VariantAlsoNegotiates = ["VariantAlsoNegotiates",6];
stx.net.HttpServerError.VariantAlsoNegotiates.toString = $estr;
stx.net.HttpServerError.VariantAlsoNegotiates.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.InsufficientStorage = ["InsufficientStorage",7];
stx.net.HttpServerError.InsufficientStorage.toString = $estr;
stx.net.HttpServerError.InsufficientStorage.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.BandwidthLimitExceeded = ["BandwidthLimitExceeded",8];
stx.net.HttpServerError.BandwidthLimitExceeded.toString = $estr;
stx.net.HttpServerError.BandwidthLimitExceeded.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.NotExtended = ["NotExtended",9];
stx.net.HttpServerError.NotExtended.toString = $estr;
stx.net.HttpServerError.NotExtended.__enum__ = stx.net.HttpServerError;
stx.net.HttpServerError.UserAccessDenied = ["UserAccessDenied",10];
stx.net.HttpServerError.UserAccessDenied.toString = $estr;
stx.net.HttpServerError.UserAccessDenied.__enum__ = stx.net.HttpServerError;
stx.net.HttpNormal = $hxClasses["stx.net.HttpNormal"] = { __ename__ : ["stx","net","HttpNormal"], __constructs__ : ["Informational","Success","Redirection"] }
stx.net.HttpNormal.Informational = function(v) { var $x = ["Informational",0,v]; $x.__enum__ = stx.net.HttpNormal; $x.toString = $estr; return $x; }
stx.net.HttpNormal.Success = function(v) { var $x = ["Success",1,v]; $x.__enum__ = stx.net.HttpNormal; $x.toString = $estr; return $x; }
stx.net.HttpNormal.Redirection = function(v) { var $x = ["Redirection",2,v]; $x.__enum__ = stx.net.HttpNormal; $x.toString = $estr; return $x; }
stx.net.HttpError = $hxClasses["stx.net.HttpError"] = { __ename__ : ["stx","net","HttpError"], __constructs__ : ["Client","Server"] }
stx.net.HttpError.Client = function(v) { var $x = ["Client",0,v]; $x.__enum__ = stx.net.HttpError; $x.toString = $estr; return $x; }
stx.net.HttpError.Server = function(v) { var $x = ["Server",1,v]; $x.__enum__ = stx.net.HttpError; $x.toString = $estr; return $x; }
stx.net.HttpResponseCode = $hxClasses["stx.net.HttpResponseCode"] = { __ename__ : ["stx","net","HttpResponseCode"], __constructs__ : ["Normal","Error"] }
stx.net.HttpResponseCode.Normal = function(v) { var $x = ["Normal",0,v]; $x.__enum__ = stx.net.HttpResponseCode; $x.toString = $estr; return $x; }
stx.net.HttpResponseCode.Error = function(v) { var $x = ["Error",1,v]; $x.__enum__ = stx.net.HttpResponseCode; $x.toString = $estr; return $x; }
stx.net.HttpResponseCodeExtensions = $hxClasses["stx.net.HttpResponseCodeExtensions"] = function() { }
stx.net.HttpResponseCodeExtensions.__name__ = ["stx","net","HttpResponseCodeExtensions"];
stx.net.HttpResponseCodeExtensions.toHttpResponseCode = function(code) {
	return (function($this) {
		var $r;
		switch(code) {
		case 100:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.Continue));
			break;
		case 101:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.SwitchingProtocols));
			break;
		case 102:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.Processing));
			break;
		case 200:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.OK));
			break;
		case 201:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Created));
			break;
		case 202:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Accepted));
			break;
		case 203:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Non));
			break;
		case 204:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.NoContent));
			break;
		case 205:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.ResetContent));
			break;
		case 206:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.PartialContent));
			break;
		case 207:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Multi));
			break;
		case 300:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.MultipleChoices));
			break;
		case 301:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.MovedPermanently));
			break;
		case 302:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.Found));
			break;
		case 303:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.SeeOther));
			break;
		case 304:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.NotModified));
			break;
		case 305:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.UseProxy));
			break;
		case 307:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.TemporaryRedirect));
			break;
		case 400:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.BadRequest));
			break;
		case 401:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Unauthorized));
			break;
		case 402:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.PaymentRequired));
			break;
		case 403:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Forbidden));
			break;
		case 404:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.NotFound));
			break;
		case 405:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.MethodNotAllowed));
			break;
		case 406:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.NotAcceptable));
			break;
		case 407:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.ProxyAuthenticationRequired));
			break;
		case 408:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestTimeout));
			break;
		case 409:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Conflict));
			break;
		case 410:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Gone));
			break;
		case 411:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.LengthRequired));
			break;
		case 412:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.PreconditionFailed));
			break;
		case 413:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestEntityTooLarge));
			break;
		case 414:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Request));
			break;
		case 415:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnsupportedMediaType));
			break;
		case 416:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestedRangeNotSatisfiable));
			break;
		case 417:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.ExpectationFailed));
			break;
		case 421:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.TooManyConnections));
			break;
		case 422:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnprocessableEntity));
			break;
		case 423:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Locked));
			break;
		case 424:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.FailedDependency));
			break;
		case 425:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnorderedCollection));
			break;
		case 426:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UpgradeRequired));
			break;
		case 449:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RetryWith));
			break;
		case 500:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.InternalServerError));
			break;
		case 501:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.NotImplemented));
			break;
		case 502:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.BadGateway));
			break;
		case 503:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.ServiceUnavailable));
			break;
		case 504:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.GatewayTimeout));
			break;
		case 505:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.HTTPVersionNotSupported));
			break;
		case 506:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.VariantAlsoNegotiates));
			break;
		case 507:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.InsufficientStorage));
			break;
		case 509:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.BandwidthLimitExceeded));
			break;
		case 510:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.NotExtended));
			break;
		case 530:
			$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.UserAccessDenied));
			break;
		default:
			$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.OK));
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isNormal = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = true;
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isInformational = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 0:
					var v1 = $e[2];
					$r = true;
					break;
				default:
					$r = false;
				}
				return $r;
			}($this));
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isSuccess = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 1:
					var v1 = $e[2];
					$r = true;
					break;
				default:
					$r = false;
				}
				return $r;
			}($this));
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isRedirection = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 2:
					var v1 = $e[2];
					$r = true;
					break;
				default:
					$r = false;
				}
				return $r;
			}($this));
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isError = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			$r = true;
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isClientError = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 0:
					var v1 = $e[2];
					$r = true;
					break;
				default:
					$r = false;
				}
				return $r;
			}($this));
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.isServerError = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 1:
					var v1 = $e[2];
					$r = true;
					break;
				default:
					$r = false;
				}
				return $r;
			}($this));
			break;
		default:
			$r = false;
		}
		return $r;
	}(this));
}
stx.net.HttpResponseCodeExtensions.toStatusCode = function(response) {
	return (function($this) {
		var $r;
		var $e = (response);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 0:
					var v1 = $e[2];
					$r = (function($this) {
						var $r;
						switch( (v1)[1] ) {
						case 0:
							$r = 100;
							break;
						case 1:
							$r = 101;
							break;
						case 2:
							$r = 102;
							break;
						}
						return $r;
					}($this));
					break;
				case 1:
					var v1 = $e[2];
					$r = (function($this) {
						var $r;
						switch( (v1)[1] ) {
						case 0:
							$r = 200;
							break;
						case 1:
							$r = 201;
							break;
						case 2:
							$r = 202;
							break;
						case 3:
							$r = 203;
							break;
						case 4:
							$r = 204;
							break;
						case 5:
							$r = 205;
							break;
						case 6:
							$r = 206;
							break;
						case 7:
							$r = 207;
							break;
						}
						return $r;
					}($this));
					break;
				case 2:
					var v1 = $e[2];
					$r = (function($this) {
						var $r;
						switch( (v1)[1] ) {
						case 0:
							$r = 300;
							break;
						case 1:
							$r = 301;
							break;
						case 2:
							$r = 302;
							break;
						case 3:
							$r = 303;
							break;
						case 4:
							$r = 304;
							break;
						case 5:
							$r = 305;
							break;
						case 6:
							$r = 307;
							break;
						}
						return $r;
					}($this));
					break;
				}
				return $r;
			}($this));
			break;
		case 1:
			var v = $e[2];
			$r = (function($this) {
				var $r;
				var $e = (v);
				switch( $e[1] ) {
				case 0:
					var v1 = $e[2];
					$r = (function($this) {
						var $r;
						switch( (v1)[1] ) {
						case 0:
							$r = 400;
							break;
						case 1:
							$r = 401;
							break;
						case 2:
							$r = 402;
							break;
						case 3:
							$r = 403;
							break;
						case 4:
							$r = 404;
							break;
						case 5:
							$r = 405;
							break;
						case 6:
							$r = 406;
							break;
						case 7:
							$r = 407;
							break;
						case 8:
							$r = 408;
							break;
						case 9:
							$r = 409;
							break;
						case 10:
							$r = 410;
							break;
						case 11:
							$r = 411;
							break;
						case 12:
							$r = 412;
							break;
						case 13:
							$r = 413;
							break;
						case 14:
							$r = 414;
							break;
						case 15:
							$r = 415;
							break;
						case 16:
							$r = 416;
							break;
						case 17:
							$r = 417;
							break;
						case 18:
							$r = 421;
							break;
						case 19:
							$r = 422;
							break;
						case 20:
							$r = 423;
							break;
						case 21:
							$r = 424;
							break;
						case 22:
							$r = 425;
							break;
						case 23:
							$r = 426;
							break;
						case 24:
							$r = 449;
							break;
						}
						return $r;
					}($this));
					break;
				case 1:
					var v1 = $e[2];
					$r = (function($this) {
						var $r;
						switch( (v1)[1] ) {
						case 0:
							$r = 500;
							break;
						case 1:
							$r = 501;
							break;
						case 2:
							$r = 502;
							break;
						case 3:
							$r = 503;
							break;
						case 4:
							$r = 504;
							break;
						case 5:
							$r = 505;
							break;
						case 6:
							$r = 506;
							break;
						case 7:
							$r = 507;
							break;
						case 8:
							$r = 509;
							break;
						case 9:
							$r = 510;
							break;
						case 10:
							$r = 530;
							break;
						}
						return $r;
					}($this));
					break;
				}
				return $r;
			}($this));
			break;
		}
		return $r;
	}(this));
}
stx.net.UrlExtensions = $hxClasses["stx.net.UrlExtensions"] = function() { }
stx.net.UrlExtensions.__name__ = ["stx","net","UrlExtensions"];
stx.net.UrlExtensions.toParsedUrl = function(s) {
	var nonNull = function(s1) {
		return s1 == null?"":s1;
	};
	return stx.net.UrlExtensions.UrlPattern.match(s)?stx.Option.Some(stx.net.UrlExtensions.formUrl(nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Protocol)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Hostname)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Port)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Pathname)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Search)),nonNull(stx.net.UrlExtensions.UrlPattern.matched(stx.net.UrlExtensions.Map)))):stx.Option.None;
}
stx.net.UrlExtensions.toUrl = function(parsed) {
	return parsed.href;
}
stx.net.UrlExtensions.withProtocol = function(parsed,protocol) {
	return stx.net.UrlExtensions.formUrl(protocol,parsed.hostname,parsed.port,parsed.pathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withHostname = function(parsed,hostname) {
	return stx.net.UrlExtensions.formUrl(parsed.protocol,hostname,parsed.port,parsed.pathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withPort = function(parsed,port) {
	return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,port,parsed.pathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withPathname = function(parsed,pathname) {
	return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,pathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withSearch = function(parsed,search) {
	return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,parsed.pathname,search,parsed.hash);
}
stx.net.UrlExtensions.withSubdomains = function(parsed,subdomains) {
	var Pattern = new EReg("([^.]+\\.[^.]+)$","");
	var replaceSubdomains = function(oldHostname,subdomains1) {
		return Pattern.match(oldHostname)?(function($this) {
			var $r;
			var prefix = subdomains1 + (stx.Strings.endsWith(subdomains1,".") || subdomains1.length == 0?"":".");
			$r = prefix + Pattern.matched(1);
			return $r;
		}(this)):oldHostname;
	};
	return stx.net.UrlExtensions.formUrl(parsed.protocol,replaceSubdomains(parsed.hostname,subdomains),parsed.port,parsed.pathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withMap = function(parsed,hash) {
	return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,parsed.pathname,parsed.search,hash);
}
stx.net.UrlExtensions.withFile = function(parsed,file) {
	var filePattern = new EReg("[/]([^/]*)$","i");
	var newPathname = filePattern.replace(parsed.pathname,"/" + file);
	return stx.net.UrlExtensions.formUrl(parsed.protocol,parsed.hostname,parsed.port,newPathname,parsed.search,parsed.hash);
}
stx.net.UrlExtensions.withoutProtocol = function(parsed) {
	return stx.net.UrlExtensions.withProtocol(parsed,"");
}
stx.net.UrlExtensions.withoutHostname = function(parsed) {
	return stx.net.UrlExtensions.withHostname(parsed,"");
}
stx.net.UrlExtensions.withoutPort = function(parsed) {
	return stx.net.UrlExtensions.withPort(parsed,"");
}
stx.net.UrlExtensions.withoutPathname = function(parsed) {
	return stx.net.UrlExtensions.withPathname(parsed,"");
}
stx.net.UrlExtensions.withoutSearch = function(parsed) {
	return stx.net.UrlExtensions.withSearch(parsed,"");
}
stx.net.UrlExtensions.withoutSubdomains = function(parsed) {
	return stx.net.UrlExtensions.withSubdomains(parsed,"");
}
stx.net.UrlExtensions.withoutMap = function(parsed) {
	return stx.net.UrlExtensions.withMap(parsed,"");
}
stx.net.UrlExtensions.withoutFile = function(parsed) {
	return stx.net.UrlExtensions.withFile(parsed,"");
}
stx.net.UrlExtensions.addQueryParameters = function(url,params) {
	var tqs = stx.net.UrlExtensions.toQueryString(params);
	return (function($this) {
		var $r;
		var $e = (stx.net.UrlExtensions.toParsedUrl(url));
		switch( $e[1] ) {
		case 0:
			$r = url + tqs;
			break;
		case 1:
			var parsed = $e[2];
			$r = parsed.search.length == 0?url + tqs:parsed.search.length == 1?url + HxOverrides.substr(tqs,1,null):url + "&" + HxOverrides.substr(tqs,1,null);
			break;
		}
		return $r;
	}(this));
}
stx.net.UrlExtensions.extractQueryParameters = function(url) {
	return stx.net.UrlExtensions.toQueryParameters(stx.net.UrlExtensions.extractSearch(url));
}
stx.net.UrlExtensions.extractSearch = function(url) {
	return stx.net.UrlExtensions.extractField(url,"search");
}
stx.net.UrlExtensions.extractProtocol = function(url) {
	return stx.net.UrlExtensions.extractField(url,"protocol");
}
stx.net.UrlExtensions.extractMap = function(url) {
	return stx.net.UrlExtensions.extractField(url,"hash");
}
stx.net.UrlExtensions.extractPathname = function(url) {
	return stx.net.UrlExtensions.extractField(url,"pathname");
}
stx.net.UrlExtensions.extractHostname = function(url) {
	return stx.net.UrlExtensions.extractField(url,"hostname");
}
stx.net.UrlExtensions.extractHost = function(url) {
	return stx.net.UrlExtensions.extractField(url,"host");
}
stx.net.UrlExtensions.extractPort = function(url) {
	return stx.Strings["int"](stx.net.UrlExtensions.extractField(url,"port"));
}
stx.net.UrlExtensions.toQueryParameters = function(query) {
	return !stx.Strings.startsWith(query,"?")?stx.ds.Map.create():ArrayLambda.foldl(ArrayLambda.flatMap(HxOverrides.substr(query,1,null).split("&"),function(kv) {
		var a = ArrayLambda.map(kv.split("="),function(s) {
			return stx.Strings.urlDecode(s);
		});
		return a.length == 0?[]:a.length == 1?[stx.Entuple.entuple(a[0],"")]:[stx.Entuple.entuple(a[0],a[1])];
	}),stx.ds.Map.create(),function(m,t) {
		return m.add(t);
	});
}
stx.net.UrlExtensions.toQueryString = function(query) {
	return query.foldl("?",function(url,tuple) {
		var fieldName = tuple.fst();
		var fieldValue = tuple.snd();
		var rest = StringTools.urlEncode(fieldName) + "=" + StringTools.urlEncode(fieldValue);
		return url + (url == "?"?rest:"&" + rest);
	});
}
stx.net.UrlExtensions.formUrl = function(protocol,hostname,port,pathname,search,hash) {
	var host = hostname + (port == ""?"":":" + port);
	var $final = host + pathname + search + hash;
	return { hash : hash, host : host, hostname : hostname, href : protocol.length > 0?protocol + "//" + $final:$final, pathname : pathname, port : port, protocol : protocol, search : search};
}
stx.net.UrlExtensions.extractField = function(url,field) {
	return stx.Options.getOrElseC(stx.Options.map(stx.net.UrlExtensions.toParsedUrl(url),function(parsed) {
		return Reflect.field(parsed,field);
	}),"");
}
if(!stx.reactive) stx.reactive = {}
stx.reactive.Arrow = $hxClasses["stx.reactive.Arrow"] = function() { }
stx.reactive.Arrow.__name__ = ["stx","reactive","Arrow"];
stx.reactive.Arrow.prototype = {
	withInput: null
	,__class__: stx.reactive.Arrow
}
stx.reactive.Viaz = $hxClasses["stx.reactive.Viaz"] = function() {
};
stx.reactive.Viaz.__name__ = ["stx","reactive","Viaz"];
stx.reactive.Viaz.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Viaz.constant = function(v) {
	return new stx.reactive.FunctionArrow(function(x) {
		return v;
	});
}
stx.reactive.Viaz.identity = function() {
	return stx.reactive.F1A.lift(function(x) {
		return x;
	});
}
stx.reactive.Viaz.fan = function(a) {
	return stx.reactive.Then.then(a,stx.reactive.F1A.lift(function(x) {
		return new stx.Tuple2(x,x);
	}));
}
stx.reactive.Viaz["as"] = function(a,type) {
	return stx.reactive.Then.then(a,stx.reactive.F1A.lift(function(x) {
		return x;
	}));
}
stx.reactive.Viaz.runCPS = function(a,i,cont) {
	return a.withInput(i,cont);
}
stx.reactive.Viaz.runCont = function(a,i) {
	return function(cont) {
		a.withInput(i,cont);
	};
}
stx.reactive.Viaz.trace = function(a) {
	var m = function(x) {
		haxe.Log.trace(x,{ fileName : "Arrows.hx", lineNumber : 53, className : "stx.reactive.Viaz", methodName : "trace"});
		return x;
	};
	return new stx.reactive.Then(a,new stx.reactive.FunctionArrow(m));
}
stx.reactive.Viaz.run = function(a,i,cont) {
	stx.reactive.Viaz.runCPS(a,i,cont == null?function(x) {
	}:cont);
}
stx.reactive.Viaz.runner = function(a,i) {
	stx.reactive.Viaz.run(a,i);
}
stx.reactive.Viaz.apply = function() {
	return new stx.reactive.ArrowApply();
}
stx.reactive.Viaz.prototype = {
	withInput: function(i,cont) {
	}
	,__class__: stx.reactive.Viaz
}
stx.reactive.Stack = $hxClasses["stx.reactive.Stack"] = function() {
	this.data = [];
};
stx.reactive.Stack.__name__ = ["stx","reactive","Stack"];
stx.reactive.Stack.prototype = {
	next: function(x,f,g) {
	}
	,data: null
	,__class__: stx.reactive.Stack
}
stx.reactive.Arrows = $hxClasses["stx.reactive.Arrows"] = function() { }
stx.reactive.Arrows.__name__ = ["stx","reactive","Arrows"];
stx.reactive.Arrows.trampoline = function(f) {
	return function(x) {
		haxe.Timer.delay(function() {
			f(x);
		},10);
	};
}
stx.reactive.Then = $hxClasses["stx.reactive.Then"] = function(a,b) {
	this.a = a;
	this.b = b;
};
stx.reactive.Then.__name__ = ["stx","reactive","Then"];
stx.reactive.Then.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Then.then = function(before,after) {
	return new stx.reactive.Then(before,after);
}
stx.reactive.Then.join = function(joinl,joinr) {
	return new stx.reactive.Then(joinl,stx.reactive.Split.split(stx.reactive.Viaz.identity(),joinr));
}
stx.reactive.Then.bind = function(bindl,bindr) {
	return new stx.reactive.Then(stx.reactive.Split.split(stx.reactive.Viaz.identity(),bindl),bindr);
}
stx.reactive.Then.prototype = {
	withInput: function(i,cont) {
		var _g = this;
		stx.test.Assert.notNull(cont,null,{ fileName : "Arrows.hx", lineNumber : 99, className : "stx.reactive.Then", methodName : "withInput"});
		var m = function(reta) {
			_g.b.withInput(reta,cont);
		};
		this.a.withInput(i,m);
	}
	,b: null
	,a: null
	,__class__: stx.reactive.Then
}
stx.reactive.FunctionArrow = $hxClasses["stx.reactive.FunctionArrow"] = function(m) {
	this.f = m;
};
stx.reactive.FunctionArrow.__name__ = ["stx","reactive","FunctionArrow"];
stx.reactive.FunctionArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.FunctionArrow.prototype = {
	withInput: function(i,cont) {
		cont(this.f(i));
	}
	,f: null
	,__class__: stx.reactive.FunctionArrow
}
stx.reactive.RepeatV = $hxClasses["stx.reactive.RepeatV"] = { __ename__ : ["stx","reactive","RepeatV"], __constructs__ : ["Repeat","Done"] }
stx.reactive.RepeatV.Repeat = function(x) { var $x = ["Repeat",0,x]; $x.__enum__ = stx.reactive.RepeatV; $x.toString = $estr; return $x; }
stx.reactive.RepeatV.Done = function(x) { var $x = ["Done",1,x]; $x.__enum__ = stx.reactive.RepeatV; $x.toString = $estr; return $x; }
stx.reactive.RepeatArrow = $hxClasses["stx.reactive.RepeatArrow"] = function(a) {
	this.a = a;
};
stx.reactive.RepeatArrow.__name__ = ["stx","reactive","RepeatArrow"];
stx.reactive.RepeatArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.RepeatArrow.repeat = function(a) {
	return new stx.reactive.RepeatArrow(a);
}
stx.reactive.RepeatArrow.prototype = {
	withInput: function(i,cont) {
		var thiz = this;
		var withRes = (function($this) {
			var $r;
			var withRes1 = null;
			withRes1 = function(res) {
				var $e = (res);
				switch( $e[1] ) {
				case 0:
					var rv = $e[2];
					thiz.a.withInput(rv,stx.reactive.Arrows.trampoline(withRes1));
					break;
				case 1:
					var dv = $e[2];
					cont(dv);
					break;
				}
			};
			$r = withRes1;
			return $r;
		}(this));
		this.a.withInput(i,withRes);
	}
	,a: null
	,__class__: stx.reactive.RepeatArrow
}
stx.reactive.MapArrow = $hxClasses["stx.reactive.MapArrow"] = function(fn) {
	this.a = fn;
};
stx.reactive.MapArrow.__name__ = ["stx","reactive","MapArrow"];
stx.reactive.MapArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.MapArrow.mapper = function(a) {
	return new stx.reactive.MapArrow(a);
}
stx.reactive.MapArrow.prototype = {
	withInput: function(i,cont) {
		haxe.Log.trace(i,{ fileName : "Arrows.hx", lineNumber : 150, className : "stx.reactive.MapArrow", methodName : "withInput"});
		var iter = $iterator(i)();
		var o = [];
		var index = 0;
		return new stx.reactive.RepeatArrow(stx.reactive.Then.then(stx.reactive.Then.then(stx.reactive.F1A.lift(function(iter1) {
			return iter1.hasNext()?stx.Option.Some(iter1.next()):stx.Option.None;
		}),stx.reactive.OptionArrow.option(this.a)),stx.reactive.F1A.lift(function(x) {
			return (function($this) {
				var $r;
				var $e = (x);
				switch( $e[1] ) {
				case 0:
					$r = stx.reactive.RepeatV.Done(o);
					break;
				case 1:
					var v = $e[2];
					$r = (function($this) {
						var $r;
						o.push(v);
						$r = stx.reactive.RepeatV.Repeat(iter);
						return $r;
					}($this));
					break;
				}
				return $r;
			}(this));
		}))).withInput(iter,cont);
	}
	,a: null
	,__class__: stx.reactive.MapArrow
}
stx.reactive.OptionArrow = $hxClasses["stx.reactive.OptionArrow"] = function(a) {
	this.a = a;
};
stx.reactive.OptionArrow.__name__ = ["stx","reactive","OptionArrow"];
stx.reactive.OptionArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.OptionArrow.option = function(a) {
	return new stx.reactive.OptionArrow(a);
}
stx.reactive.OptionArrow.prototype = {
	withInput: function(i,cont) {
		var $e = (i);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			stx.reactive.Viaz.apply().withInput(stx.Entuple.entuple(this.a,v),stx.Functions1.then(stx.Option.Some,cont));
			break;
		case 0:
			cont(stx.Option.None);
			break;
		}
	}
	,a: null
	,__class__: stx.reactive.OptionArrow
}
stx.reactive.DelayArrow = $hxClasses["stx.reactive.DelayArrow"] = function(a,delay) {
	this.a = a;
	this.t = delay;
};
stx.reactive.DelayArrow.__name__ = ["stx","reactive","DelayArrow"];
stx.reactive.DelayArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.DelayArrow.delay = function(a,delay) {
	return new stx.reactive.DelayArrow(a,delay);
}
stx.reactive.DelayArrow.prototype = {
	withInput: function(i,cont) {
		var _g = this;
		var f = function() {
			stx.reactive.Viaz.runCPS(_g.a,i,cont);
		};
		haxe.Timer.delay(f,this.t);
	}
	,t: null
	,a: null
	,__class__: stx.reactive.DelayArrow
}
stx.reactive.EventArrow = $hxClasses["stx.reactive.EventArrow"] = function(name) {
	this.name = name;
};
stx.reactive.EventArrow.__name__ = ["stx","reactive","EventArrow"];
stx.reactive.EventArrow.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.EventArrow.event = function(evt) {
	return new stx.reactive.EventArrow(evt);
}
stx.reactive.EventArrow.prototype = {
	withInput: function(i,cont) {
		var _g = this;
		haxe.Log.trace("added: " + this.name,{ fileName : "Arrows.hx", lineNumber : 216, className : "stx.reactive.EventArrow", methodName : "withInput"});
		var canceller = null;
		var handler = function(evt) {
			haxe.Log.trace("called: " + _g.name,{ fileName : "Arrows.hx", lineNumber : 220, className : "stx.reactive.EventArrow", methodName : "withInput"});
			canceller();
			cont(evt);
		};
		i.addEventListener(this.name,handler);
		canceller = function() {
			i.removeEventListener(_g.name,handler);
		};
	}
	,name: null
	,__class__: stx.reactive.EventArrow
}
stx.reactive.Pair = $hxClasses["stx.reactive.Pair"] = function(l,r) {
	this.l = l;
	this.r = r;
};
stx.reactive.Pair.__name__ = ["stx","reactive","Pair"];
stx.reactive.Pair.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Pair.pair = function(pair_,_pair) {
	return new stx.reactive.Pair(pair_,_pair);
}
stx.reactive.Pair.first = function(first) {
	return new stx.reactive.Pair(first,stx.reactive.Viaz.identity());
}
stx.reactive.Pair.second = function(second) {
	return new stx.reactive.Pair(stx.reactive.Viaz.identity(),second);
}
stx.reactive.Pair.prototype = {
	withInput: function(i,cont) {
		stx.test.Assert.notNull(cont,null,{ fileName : "Arrows.hx", lineNumber : 240, className : "stx.reactive.Pair", methodName : "withInput"});
		var ol = null;
		var or = null;
		var merge = function(l,r) {
			cont(new stx.Tuple2(l,r));
		};
		var check = function() {
			if(ol != null && or != null) merge(stx.Options.get(ol),stx.Options.get(or));
		};
		var hl = function(v) {
			ol = v == null?stx.Option.None:stx.Option.Some(v);
			check();
		};
		var hr = function(v) {
			or = v == null?stx.Option.None:stx.Option.Some(v);
			check();
		};
		this.l.withInput(i.fst(),hl);
		this.r.withInput(i.snd(),hr);
	}
	,r: null
	,l: null
	,__class__: stx.reactive.Pair
}
stx.reactive.Cleave = $hxClasses["stx.reactive.Cleave"] = function(a) {
	this.a = a;
};
stx.reactive.Cleave.__name__ = ["stx","reactive","Cleave"];
stx.reactive.Cleave.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Cleave.cleave = function(a) {
	return new stx.reactive.Cleave(a);
}
stx.reactive.Cleave.prototype = {
	withInput: function(i,cont) {
		this.a.withInput(i,function(o) {
			cont(new stx.Tuple2(o,o));
		});
	}
	,a: null
	,__class__: stx.reactive.Cleave
}
stx.reactive.Merge = $hxClasses["stx.reactive.Merge"] = function(a,b) {
	this.a = a;
	this.b = b;
};
stx.reactive.Merge.__name__ = ["stx","reactive","Merge"];
stx.reactive.Merge.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Merge.merge = function(a,b) {
	return new stx.reactive.Merge(a,b);
}
stx.reactive.Merge.prototype = {
	withInput: function(i,cont) {
		return stx.reactive.Then.then(this.a,this.b).withInput(i,cont);
	}
	,b: null
	,a: null
	,__class__: stx.reactive.Merge
}
stx.reactive.Split = $hxClasses["stx.reactive.Split"] = function(l,r) {
	this.a = new stx.reactive.Pair(l,r);
};
stx.reactive.Split.__name__ = ["stx","reactive","Split"];
stx.reactive.Split.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Split.split = function(split_,_split) {
	return new stx.reactive.Split(split_,_split);
}
stx.reactive.Split.prototype = {
	withInput: function(i,cont) {
		this.a.withInput(new stx.Tuple2(i,i),cont);
	}
	,a: null
	,__class__: stx.reactive.Split
}
stx.reactive.Or = $hxClasses["stx.reactive.Or"] = function(l,r) {
	this.a = l;
	this.b = r;
};
stx.reactive.Or.__name__ = ["stx","reactive","Or"];
stx.reactive.Or.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.Or.or = function(or_,_or) {
	return new stx.reactive.Or(or_,_or);
}
stx.reactive.Or.prototype = {
	withInput: function(i,cont) {
		var $e = (i);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			this.a.withInput(v,cont);
			break;
		case 1:
			var v = $e[2];
			this.b.withInput(v,cont);
			break;
		}
	}
	,b: null
	,a: null
	,__class__: stx.reactive.Or
}
stx.reactive.LeftChoice = $hxClasses["stx.reactive.LeftChoice"] = function(a) {
	this.a = a;
};
stx.reactive.LeftChoice.__name__ = ["stx","reactive","LeftChoice"];
stx.reactive.LeftChoice.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.LeftChoice.left = function(arr) {
	return new stx.reactive.LeftChoice(arr);
}
stx.reactive.LeftChoice.prototype = {
	withInput: function(i,cont) {
		var $e = (i);
		switch( $e[1] ) {
		case 0:
			var v = $e[2];
			new stx.reactive.ArrowApply().withInput(new stx.Tuple2(this.a,v),function(x) {
				cont(stx.Either.Left(x));
			});
			break;
		case 1:
			var v = $e[2];
			cont(stx.Either.Right(v));
			break;
		}
	}
	,a: null
	,__class__: stx.reactive.LeftChoice
}
stx.reactive.RightChoice = $hxClasses["stx.reactive.RightChoice"] = function(a) {
	this.a = a;
};
stx.reactive.RightChoice.__name__ = ["stx","reactive","RightChoice"];
stx.reactive.RightChoice.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.RightChoice.right = function(arr) {
	return new stx.reactive.RightChoice(arr);
}
stx.reactive.RightChoice.prototype = {
	withInput: function(i,cont) {
		var $e = (i);
		switch( $e[1] ) {
		case 1:
			var v = $e[2];
			new stx.reactive.ArrowApply().withInput(new stx.Tuple2(this.a,v),function(x) {
				cont(stx.Either.Right(x));
			});
			break;
		case 0:
			var v = $e[2];
			cont(stx.Either.Left(v));
			break;
		}
	}
	,a: null
	,__class__: stx.reactive.RightChoice
}
stx.reactive.ArrowApply = $hxClasses["stx.reactive.ArrowApply"] = function() {
};
stx.reactive.ArrowApply.__name__ = ["stx","reactive","ArrowApply"];
stx.reactive.ArrowApply.__interfaces__ = [stx.reactive.Arrow];
stx.reactive.ArrowApply.prototype = {
	withInput: function(i,cont) {
		i.fst().withInput(i.snd(),function(x) {
			cont(x);
		});
	}
	,__class__: stx.reactive.ArrowApply
}
stx.reactive.F0A = $hxClasses["stx.reactive.F0A"] = function() { }
stx.reactive.F0A.__name__ = ["stx","reactive","F0A"];
stx.reactive.F0A.lift = function(t) {
	return stx.reactive.F1A.lift(function(v) {
		return t();
	});
}
stx.reactive.F1A = $hxClasses["stx.reactive.F1A"] = function() { }
stx.reactive.F1A.__name__ = ["stx","reactive","F1A"];
stx.reactive.F1A.lift = function(f) {
	return new stx.reactive.FunctionArrow(f);
}
stx.reactive.F1A.thenA = function(f,a) {
	return stx.reactive.Then.then(stx.reactive.F1A.lift(f),a);
}
stx.reactive.F1F = $hxClasses["stx.reactive.F1F"] = function() { }
stx.reactive.F1F.__name__ = ["stx","reactive","F1F"];
stx.reactive.F1F.thenF = function(f1,f2) {
	var a1 = stx.reactive.F1A.lift(f1);
	var a2 = stx.reactive.F1A.lift(f2);
	return stx.reactive.Then.then(a1,a2);
}
stx.reactive.A1F = $hxClasses["stx.reactive.A1F"] = function() { }
stx.reactive.A1F.__name__ = ["stx","reactive","A1F"];
stx.reactive.A1F.thenF = function(a,f) {
	var a2 = stx.reactive.F1A.lift(f);
	return stx.reactive.Then.then(a,a2);
}
stx.reactive.F2A = $hxClasses["stx.reactive.F2A"] = function() { }
stx.reactive.F2A.__name__ = ["stx","reactive","F2A"];
stx.reactive.F2A.lift = function(f) {
	return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple2.into)))(f));
}
stx.reactive.F2A.run = function(arr,a,b) {
	stx.reactive.Viaz.run(arr,stx.Entuple.entuple(a,b));
}
stx.reactive.F3A = $hxClasses["stx.reactive.F3A"] = function() { }
stx.reactive.F3A.__name__ = ["stx","reactive","F3A"];
stx.reactive.F3A.lift = function(f) {
	return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple3.into)))(f));
}
stx.reactive.F3A.run = function(arr,a,b,c) {
	stx.reactive.Viaz.run(arr,stx.Tuple2.entuple(stx.Entuple.entuple(a,b),c));
}
stx.reactive.F4A = $hxClasses["stx.reactive.F4A"] = function() { }
stx.reactive.F4A.__name__ = ["stx","reactive","F4A"];
stx.reactive.F4A.lift = function(f) {
	return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple4.into)))(f));
}
stx.reactive.F4A.run = function(arr,a,b,c,d) {
	stx.reactive.Viaz.run(arr,stx.Tuple3.entuple(stx.Tuple2.entuple(stx.Entuple.entuple(a,b),c),d));
}
stx.reactive.F5A = $hxClasses["stx.reactive.F5A"] = function() { }
stx.reactive.F5A.__name__ = ["stx","reactive","F5A"];
stx.reactive.F5A.lift = function(f) {
	return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple5.into)))(f));
}
stx.reactive.F5A.run = function(arr,a,b,c,d,e) {
	stx.reactive.Viaz.run(arr,stx.Tuple3.entuple(stx.Tuple2.entuple(stx.Entuple.entuple(a,b),c),d).entuple(e));
}
stx.reactive.Collections = $hxClasses["stx.reactive.Collections"] = function() {
};
stx.reactive.Collections.__name__ = ["stx","reactive","Collections"];
stx.reactive.Collections.toStream = function(collection,time) {
	return stx.reactive.Collections.toStreamS(collection,stx.reactive.Signals.constant(time));
}
stx.reactive.Collections.toStreamS = function(collection,time) {
	var startTime = -1.0;
	var accum = 0;
	var iterator = $iterator(collection)();
	if(!iterator.hasNext()) return stx.reactive.Streams.zero();
	var stream = stx.reactive.Streams.identity();
	var pulser = null;
	var timer = null;
	var createTimer = function() {
		var nowTime = stx.reactive.External.now();
		if(startTime < 0.0) startTime = nowTime;
		var delta = time.valueNow();
		var endTime = startTime + accum + delta;
		var timeToWait = endTime - nowTime;
		accum += delta;
		return timeToWait < 0?(function($this) {
			var $r;
			pulser();
			$r = null;
			return $r;
		}(this)):(function($this) {
			var $r;
			var t = stx.reactive.External.setTimeout(pulser,timeToWait | 0);
			$r = t;
			return $r;
		}(this));
	};
	pulser = function() {
		var next = iterator.next();
		stream.sendEvent(next);
		if(timer != null) stx.reactive.External.cancelTimeout(timer);
		if(iterator.hasNext()) timer = createTimer();
	};
	timer = createTimer();
	return stream;
}
stx.reactive.Collections.prototype = {
	__class__: stx.reactive.Collections
}
stx.reactive.External = $hxClasses["stx.reactive.External"] = function() { }
stx.reactive.External.__name__ = ["stx","reactive","External"];
stx.reactive.External.setTimeout = function(f,time) {
	return haxe.Timer.delay(f,time);
}
stx.reactive.External.cancelTimeout = function(timer) {
	(js.Boot.__cast(timer , haxe.Timer)).stop();
}
stx.reactive.External.now = function() {
	return new Date().getTime();
}
stx.reactive.Propagation = $hxClasses["stx.reactive.Propagation"] = { __ename__ : ["stx","reactive","Propagation"], __constructs__ : ["propagate","doNotPropagate"] }
stx.reactive.Propagation.propagate = function(value) { var $x = ["propagate",0,value]; $x.__enum__ = stx.reactive.Propagation; $x.toString = $estr; return $x; }
stx.reactive.Propagation.doNotPropagate = ["doNotPropagate",1];
stx.reactive.Propagation.doNotPropagate.toString = $estr;
stx.reactive.Propagation.doNotPropagate.__enum__ = stx.reactive.Propagation;
stx.reactive.Pulse = $hxClasses["stx.reactive.Pulse"] = function(stamp,value) {
	this.stamp = stamp;
	this.value = value;
	var elements = [];
	elements.push(stamp);
	elements.push(value);
};
stx.reactive.Pulse.__name__ = ["stx","reactive","Pulse"];
stx.reactive.Pulse.prototype = {
	withValue: function(newValue) {
		return new stx.reactive.Pulse(this.stamp,newValue);
	}
	,map: function(f) {
		return this.withValue(f(this.value));
	}
	,value: null
	,stamp: null
	,__class__: stx.reactive.Pulse
}
stx.reactive.Stamp = $hxClasses["stx.reactive.Stamp"] = function() { }
stx.reactive.Stamp.__name__ = ["stx","reactive","Stamp"];
stx.reactive.Stamp.lastStamp = function() {
	return stx.reactive.Stamp._stamp;
}
stx.reactive.Stamp.nextStamp = function() {
	return ++stx.reactive.Stamp._stamp;
}
stx.reactive.Rank = $hxClasses["stx.reactive.Rank"] = function() { }
stx.reactive.Rank.__name__ = ["stx","reactive","Rank"];
stx.reactive.Rank.lastRank = function() {
	return stx.reactive.Rank._rank;
}
stx.reactive.Rank.nextRank = function() {
	return ++stx.reactive.Rank._rank;
}
if(!stx.reactive._Reactive) stx.reactive._Reactive = {}
stx.reactive._Reactive.PriorityQueue = $hxClasses["stx.reactive._Reactive.PriorityQueue"] = function() {
	this.val = [];
};
stx.reactive._Reactive.PriorityQueue.__name__ = ["stx","reactive","_Reactive","PriorityQueue"];
stx.reactive._Reactive.PriorityQueue.prototype = {
	pop: function() {
		if(this.val.length == 1) return this.val.pop();
		var ret = this.val.shift();
		this.val.unshift(this.val.pop());
		var kvpos = 0;
		var kv = this.val[0];
		while(true) {
			var leftChild = kvpos * 2 + 1 < this.val.length?this.val[kvpos * 2 + 1].k:kv.k + 1;
			var rightChild = kvpos * 2 + 2 < this.val.length?this.val[kvpos * 2 + 2].k:kv.k + 1;
			if(leftChild > kv.k && rightChild > kv.k) break; else if(leftChild < rightChild) {
				this.val[kvpos] = this.val[kvpos * 2 + 1];
				this.val[kvpos * 2 + 1] = kv;
				kvpos = kvpos * 2 + 1;
			} else {
				this.val[kvpos] = this.val[kvpos * 2 + 2];
				this.val[kvpos * 2 + 2] = kv;
				kvpos = kvpos * 2 + 2;
			}
		}
		return ret;
	}
	,isEmpty: function() {
		return this.val.length == 0;
	}
	,insert: function(kv) {
		this.val.push(kv);
		var kvpos = this.val.length - 1;
		while(kvpos > 0 && kv.k < this.val[Math.floor((kvpos - 1) / 2)].k) {
			var oldpos = kvpos;
			kvpos = Math.floor((kvpos - 1) / 2);
			this.val[oldpos] = this.val[kvpos];
			this.val[kvpos] = kv;
		}
	}
	,length: function() {
		return this.val.length;
	}
	,val: null
	,__class__: stx.reactive._Reactive.PriorityQueue
}
stx.reactive.Stream = $hxClasses["stx.reactive.Stream"] = function(updater,sources) {
	this._updater = updater;
	this._sendsTo = [];
	this._weak = false;
	this._rank = stx.reactive.Rank.nextRank();
	this._cleanups = [];
	if(sources != null) {
		var _g = 0;
		while(_g < sources.length) {
			var source = sources[_g];
			++_g;
			source.attachListener(this);
		}
	}
};
stx.reactive.Stream.__name__ = ["stx","reactive","Stream"];
stx.reactive.Stream.prototype = {
	getWeaklyHeld: function() {
		return this._weak;
	}
	,setWeaklyHeld: function(held) {
		if(this._weak != held) {
			this._weak = held;
			if(!held) {
				var _g = 0, _g1 = this._cleanups;
				while(_g < _g1.length) {
					var cleanup = _g1[_g];
					++_g;
					cleanup();
				}
				this._cleanups = [];
			}
		}
		return this._weak;
	}
	,propagatePulse: function(pulse) {
		var queue = new stx.reactive._Reactive.PriorityQueue();
		var self = js.Boot.__cast(this , stx.reactive.Stream);
		queue.insert({ k : this._rank, v : { stream : self, pulse : pulse}});
		while(queue.length() > 0) {
			var qv = queue.pop();
			var stream = qv.v.stream;
			var pulse1 = qv.v.pulse;
			var propagation = stream._updater(pulse1);
			var $e = (propagation);
			switch( $e[1] ) {
			case 0:
				var nextPulse = $e[2];
				var weaklyHeld = true;
				var _g = 0, _g1 = stream._sendsTo;
				while(_g < _g1.length) {
					var recipient = _g1[_g];
					++_g;
					weaklyHeld = weaklyHeld && recipient.getWeaklyHeld();
					queue.insert({ k : recipient._rank, v : { stream : js.Boot.__cast(recipient , stx.reactive.Stream), pulse : nextPulse}});
				}
				if(stream._sendsTo.length > 0 && weaklyHeld) stream.setWeaklyHeld(true);
				break;
			case 1:
				break;
			}
		}
	}
	,unique: function(eq) {
		return this.uniqueSteps().uniqueEvents(eq);
	}
	,uniqueEvents: function(eq) {
		if(eq == null) eq = function(e1,e2) {
			return e1 == e2;
		};
		var lastEvent = null;
		return stx.reactive.Streams.create(function(pulse) {
			return lastEvent == null || !eq(pulse.value,lastEvent)?(function($this) {
				var $r;
				lastEvent = pulse.value;
				$r = stx.reactive.Propagation.propagate(pulse);
				return $r;
			}(this)):stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,uniqueSteps: function() {
		var lastStamp = -1;
		return stx.reactive.Streams.create(function(pulse) {
			return pulse.stamp != lastStamp?(function($this) {
				var $r;
				lastStamp = pulse.stamp;
				$r = stx.reactive.Propagation.propagate(pulse);
				return $r;
			}(this)):stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,merge: function(that) {
		return stx.reactive.Streams.create(function(p) {
			return stx.reactive.Propagation.propagate(p);
		},[this,that]);
	}
	,groupBy: function(eq) {
		var prev = null;
		var cur = [];
		return stx.reactive.Streams.create(function(pulse) {
			var ret = stx.reactive.Propagation.doNotPropagate;
			if(prev != null) {
				if(!eq(prev,pulse.value)) {
					var iter = cur;
					ret = stx.reactive.Propagation.propagate(pulse.withValue(iter));
					cur = [];
					cur.push(pulse.value);
					prev = null;
				} else cur.push(pulse.value);
			} else cur.push(pulse.value);
			prev = pulse.value;
			return ret;
		},[this]);
	}
	,group: function() {
		return this.groupBy(function(e1,e2) {
			return e1 == e2;
		});
	}
	,zip5: function($as,bs,cs,ds) {
		var streams = [];
		streams.push(this);
		streams.push($as);
		streams.push(bs);
		streams.push(cs);
		streams.push(ds);
		return stx.reactive.Streams.zipN(streams).map(function(i) {
			return new stx.Tuple5(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2),stx.Iterables.at(i,3),stx.Iterables.at(i,4));
		});
	}
	,zip4: function($as,bs,cs) {
		var streams = [];
		streams.push(this);
		streams.push($as);
		streams.push(bs);
		streams.push(cs);
		return stx.reactive.Streams.zipN(streams).map(function(i) {
			return new stx.Tuple4(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2),stx.Iterables.at(i,3));
		});
	}
	,zip3: function($as,bs) {
		var streams = [];
		streams.push(this);
		streams.push($as);
		streams.push(bs);
		return stx.reactive.Streams.zipN(streams).map(function(i) {
			return new stx.Tuple3(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2));
		});
	}
	,zip: function($as) {
		return this.zipWith($as,tuple2);
	}
	,zipWith: function($as,f) {
		var testStamp = -1;
		var value1 = null;
		stx.reactive.Streams.create(function(pulse) {
			testStamp = pulse.stamp;
			value1 = pulse.value;
			return stx.reactive.Propagation.doNotPropagate;
		},[this]);
		return stx.reactive.Streams.create(function(pulse) {
			return testStamp == pulse.stamp?stx.reactive.Propagation.propagate(pulse.withValue(f(value1,pulse.value))):stx.reactive.Propagation.doNotPropagate;
		},[$as]);
	}
	,filterWhile: function(pred) {
		var checking = true;
		var self = this;
		return stx.reactive.Streams.create(function(pulse) {
			return checking?pred(pulse.value)?stx.reactive.Propagation.propagate(pulse):(function($this) {
				var $r;
				checking = false;
				self.setWeaklyHeld(true);
				$r = stx.reactive.Propagation.doNotPropagate;
				return $r;
			}(this)):stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,filter: function(pred) {
		return stx.reactive.Streams.create(function(pulse) {
			return pred(pulse.value)?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,partitionWhile: function(pred) {
		var trueStream = this.takeWhile(pred);
		var falseStream = this.dropWhile(pred);
		return new stx.Tuple2(trueStream,falseStream);
	}
	,partition: function(pred) {
		var trueStream = stx.reactive.Streams.create(function(pulse) {
			return pred(pulse.value)?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate;
		},[this]);
		var falseStream = stx.reactive.Streams.create(function(pulse) {
			return !pred(pulse.value)?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate;
		},[this]);
		return new stx.Tuple2(trueStream,falseStream);
	}
	,dropWhile: function(pred) {
		var checking = true;
		return stx.reactive.Streams.create(function(pulse) {
			return checking?pred(pulse.value)?stx.reactive.Propagation.doNotPropagate:(function($this) {
				var $r;
				checking = false;
				$r = stx.reactive.Propagation.propagate(pulse);
				return $r;
			}(this)):stx.reactive.Propagation.propagate(pulse);
		},[this]);
	}
	,drop: function(n) {
		var count = n;
		return stx.reactive.Streams.create(function(pulse) {
			return count > 0?(function($this) {
				var $r;
				--count;
				$r = stx.reactive.Propagation.doNotPropagate;
				return $r;
			}(this)):stx.reactive.Propagation.propagate(pulse);
		},[this]);
	}
	,shiftWith: function(elements) {
		var queue = IterableLambda.toArray(elements);
		var n = queue.length;
		return stx.reactive.Streams.create(function(pulse) {
			queue.push(pulse.value);
			return queue.length <= n?stx.reactive.Propagation.doNotPropagate:stx.reactive.Propagation.propagate(pulse.withValue(queue.shift()));
		},[this]);
	}
	,shiftWhile: function(pred) {
		var queue = [];
		var checking = true;
		return stx.reactive.Streams.create(function(pulse) {
			queue.push(pulse.value);
			return checking?pred(pulse.value)?stx.reactive.Propagation.doNotPropagate:(function($this) {
				var $r;
				checking = false;
				$r = stx.reactive.Propagation.propagate(pulse.withValue(queue.shift()));
				return $r;
			}(this)):stx.reactive.Propagation.propagate(pulse.withValue(queue.shift()));
		},[this]);
	}
	,shift: function(n) {
		var queue = [];
		return stx.reactive.Streams.create(function(pulse) {
			queue.push(pulse.value);
			return queue.length <= n?stx.reactive.Propagation.doNotPropagate:stx.reactive.Propagation.propagate(pulse.withValue(queue.shift()));
		},[this]);
	}
	,takeWhile: function(filter) {
		var stillChecking = true;
		var self = this;
		return stx.reactive.Streams.create(function(pulse) {
			return stillChecking?filter(pulse.value)?stx.reactive.Propagation.propagate(pulse):(function($this) {
				var $r;
				stillChecking = false;
				self.setWeaklyHeld(true);
				$r = stx.reactive.Propagation.doNotPropagate;
				return $r;
			}(this)):stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,take: function(n) {
		var count = n;
		var self = this;
		return stx.reactive.Streams.create(function(pulse) {
			return count > 0?(function($this) {
				var $r;
				--count;
				$r = stx.reactive.Propagation.propagate(pulse);
				return $r;
			}(this)):(function($this) {
				var $r;
				self.setWeaklyHeld(true);
				$r = stx.reactive.Propagation.doNotPropagate;
				return $r;
			}(this));
		},[this]);
	}
	,scanlP: function(folder) {
		var acc = null;
		return this.map(function(n) {
			var next;
			if(acc != null) next = folder(acc,n); else next = n;
			acc = next;
			return next;
		});
	}
	,scanl: function(initial,folder) {
		var acc = initial;
		return this.map(function(n) {
			var next = folder(acc,n);
			acc = next;
			return next;
		});
	}
	,flatMap: function(mapper) {
		return this.bind(mapper);
	}
	,map: function(mapper) {
		return stx.reactive.Streams.create(function(pulse) {
			return stx.reactive.Propagation.propagate(pulse.map(mapper));
		},[this]);
	}
	,filterRepeatsBy: function(optStart,eq) {
		var hadFirst = optStart == null?false:true;
		var prev = optStart;
		return this.filter(function(v) {
			return !hadFirst || !eq(prev,v)?(function($this) {
				var $r;
				hadFirst = true;
				prev = v;
				$r = true;
				return $r;
			}(this)):false;
		});
	}
	,filterRepeats: function(optStart) {
		return this.filterRepeatsBy(optStart,function(v1,v2) {
			return (stx.ds.plus.Equal.getEqualFor(v1))(v1,v2);
		});
	}
	,snapshot: function(value) {
		return this.map(function(t) {
			return value.valueNow();
		});
	}
	,blindS: function(time) {
		var lastSent = stx.reactive.External.now() - time.valueNow() - 1;
		return stx.reactive.Streams.create(function(p) {
			var curTime = stx.reactive.External.now();
			if(curTime - lastSent > time.valueNow()) {
				lastSent = curTime;
				return stx.reactive.Propagation.propagate(p);
			} else return stx.reactive.Propagation.doNotPropagate;
		},[this]);
	}
	,blind: function(time) {
		return this.blindS(stx.reactive.Signals.constant(time));
	}
	,startsWith: function(init) {
		return new stx.reactive.Signal(this,init,function(pulse) {
			return stx.reactive.Propagation.propagate(pulse);
		});
	}
	,calmS: function(time) {
		var out = stx.reactive.Streams.identity();
		var towards = null;
		stx.reactive.Streams.create(function(pulse) {
			if(towards != null) stx.reactive.External.cancelTimeout(towards);
			towards = stx.reactive.External.setTimeout(function() {
				towards = null;
				out.sendEvent(pulse.value);
			},time.valueNow());
			return stx.reactive.Propagation.doNotPropagate;
		},[this]);
		return out;
	}
	,calm: function(time) {
		return this.calmS(stx.reactive.Signals.constant(time));
	}
	,delayS: function(time) {
		var self = this;
		var receiverEE = stx.reactive.Streams.identity();
		var link = { from : self, towards : self.delay(time.valueNow())};
		var switcherE = stx.reactive.Streams.create(function(pulse) {
			link.from.removeListener(link.towards);
			link = { from : self, towards : self.delay(pulse.value)};
			receiverEE.sendEvent(link.towards);
			return stx.reactive.Propagation.doNotPropagate;
		},[time._underlying]);
		var resE = stx.reactive.StreamStream.flatten(receiverEE);
		switcherE.sendEvent(time.valueNow());
		return resE;
	}
	,delay: function(time) {
		var resE = stx.reactive.Streams.identity();
		stx.reactive.Streams.create(function(pulse) {
			resE.sendLaterIn(pulse.value,time);
			return stx.reactive.Propagation.doNotPropagate;
		},[this]);
		return resE;
	}
	,sendLater: function(value) {
		return this.sendLaterIn(value,0);
	}
	,sendLaterIn: function(value,millis) {
		var self = this;
		stx.reactive.External.setTimeout(function() {
			self.sendEvent(value);
		},millis);
		return this;
	}
	,sendEventTyped: function(value) {
		this.propagatePulse(new stx.reactive.Pulse(stx.reactive.Stamp.nextStamp(),value));
		return this;
	}
	,sendEvent: function(value) {
		this.propagatePulse(new stx.reactive.Pulse(stx.reactive.Stamp.nextStamp(),value));
		return this;
	}
	,bind: function(k) {
		var m = this;
		var prevE = null;
		var outE = stx.reactive.Streams.identity();
		var inE = stx.reactive.Streams.create(function(pulse) {
			var first = prevE == null;
			if(prevE != null) prevE.removeListener(outE,true);
			prevE = k(pulse.value);
			prevE.attachListener(outE);
			return stx.reactive.Propagation.doNotPropagate;
		},[m]);
		return outE;
	}
	,constant: function(value) {
		return this.map(function(v) {
			return value;
		});
	}
	,toArray: function() {
		var array = [];
		this.each(function(e) {
			array.push(e);
		});
		return array;
	}
	,each: function(f) {
		return this.foreach(f);
	}
	,foreach: function(f) {
		stx.reactive.Streams.create(function(pulse) {
			f(pulse.value);
			return stx.reactive.Propagation.doNotPropagate;
		},[this]);
		return this;
	}
	,whenFinishedDo: function(f) {
		if(this.getWeaklyHeld()) f(); else this._cleanups.push(f);
	}
	,removeListener: function(dependent,isWeakReference) {
		if(isWeakReference == null) isWeakReference = false;
		var foundSending = false;
		var _g1 = 0, _g = this._sendsTo.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(this._sendsTo[i] == dependent) {
				this._sendsTo.splice(i,1);
				foundSending = true;
				break;
			}
		}
		if(isWeakReference && this._sendsTo.length == 0) this.setWeaklyHeld(true);
		return foundSending;
	}
	,attachListener: function(dependent) {
		this._sendsTo.push(dependent);
		if(this._rank > dependent._rank) {
			var lowest = stx.reactive.Rank.lastRank() + 1;
			var q = [dependent];
			while(q.length > 0) {
				var cur = q.splice(0,1)[0];
				cur._rank = stx.reactive.Rank.nextRank();
				q = q.concat(cur._sendsTo);
			}
		}
	}
	,_cleanups: null
	,weaklyHeld: null
	,_weak: null
	,_updater: null
	,_sendsTo: null
	,_rank: null
	,__class__: stx.reactive.Stream
	,__properties__: {set_weaklyHeld:"setWeaklyHeld",get_weaklyHeld:"getWeaklyHeld"}
}
stx.reactive.Signal = $hxClasses["stx.reactive.Signal"] = function(stream,init,updater) {
	this._last = init;
	this._underlyingRaw = stream;
	this._updater = updater;
	var self = this;
	this._underlying = stx.reactive.Streams.create(function(pulse) {
		return (function($this) {
			var $r;
			var $e = (updater(pulse));
			switch( $e[1] ) {
			case 0:
				var newPulse = $e[2];
				$r = (function($this) {
					var $r;
					self._last = newPulse.value;
					$r = stx.reactive.Propagation.propagate(newPulse);
					return $r;
				}($this));
				break;
			case 1:
				$r = stx.reactive.Propagation.doNotPropagate;
				break;
			}
			return $r;
		}(this));
	},[stream.uniqueSteps()]);
};
stx.reactive.Signal.__name__ = ["stx","reactive","Signal"];
stx.reactive.Signal.prototype = {
	sendSignalTyped: function(value) {
		this._underlying.sendEventTyped(value);
	}
	,sendSignal: function(value) {
		this._underlying.sendEvent(value);
	}
	,nowAndWhenChanges: function(f) {
		this._underlying.foreach(f);
		f(this.valueNow());
	}
	,whenChanges: function(f) {
		this._underlying.foreach(f);
	}
	,changes: function() {
		return this._underlying;
	}
	,mapC: function(f) {
		return f(this._underlying).startsWith(this.valueNow());
	}
	,valueNow: function() {
		return this._last;
	}
	,delayS: function(time) {
		return this.mapC(function(s) {
			return s.delayS(time);
		});
	}
	,delay: function(time) {
		return this.mapC(function(s) {
			return s.delay(time);
		});
	}
	,blindS: function(time) {
		return this.mapC(function(s) {
			return s.blindS(time);
		});
	}
	,blind: function(time) {
		return this.mapC(function(s) {
			return s.blind(time);
		});
	}
	,calmS: function(time) {
		return this.mapC(function(s) {
			return s.calmS(time);
		});
	}
	,calm: function(time) {
		return this.mapC(function(s) {
			return s.calm(time);
		});
	}
	,zipN: function(signals) {
		var signals1 = stx.Iterables.cons(signals,this);
		return stx.reactive.Signals.zipN(signals1);
	}
	,zip5: function(b2,b3,b4,b5) {
		var self = this;
		var createTuple = function() {
			return new stx.Tuple5(self.valueNow(),b2.valueNow(),b3.valueNow(),b4.valueNow(),b5.valueNow());
		};
		var arr = [this,b2,b3,b4,b5];
		return stx.reactive.Streams.create(function(pulse) {
			return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
		},ArrayLambda.map(arr,function(b) {
			return js.Boot.__cast(b._underlying , stx.reactive.Stream);
		})).startsWith(createTuple());
	}
	,zip4: function(b2,b3,b4) {
		var self = this;
		var createTuple = function() {
			return new stx.Tuple4(self.valueNow(),b2.valueNow(),b3.valueNow(),b4.valueNow());
		};
		var arr = [this,b2,b3,b4];
		return stx.reactive.Streams.create(function(pulse) {
			return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
		},ArrayLambda.map(arr,function(b) {
			return js.Boot.__cast(b._underlying , stx.reactive.Stream);
		})).startsWith(createTuple());
	}
	,zip3: function(b2,b3) {
		var self = this;
		var createTuple = function() {
			return new stx.Tuple3(self.valueNow(),b2.valueNow(),b3.valueNow());
		};
		var arr = [this,b2,b3];
		return stx.reactive.Streams.create(function(pulse) {
			return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
		},ArrayLambda.map(arr,function(b) {
			return js.Boot.__cast(b._underlying , stx.reactive.Stream);
		})).startsWith(createTuple());
	}
	,zip: function(b2) {
		return this.zipWith(b2,tuple2);
	}
	,zipWith: function(b2,f) {
		var self = this;
		var applyF = function() {
			return f(self.valueNow(),b2.valueNow());
		};
		var pulse = function(pulse1) {
			return stx.reactive.Propagation.propagate(pulse1.withValue(applyF()));
		};
		var arr = [this,b2];
		var out = ArrayLambda.map(arr,function(b) {
			return js.Boot.__cast(b._underlying , stx.reactive.Stream);
		});
		return stx.reactive.Streams.create(pulse,out).startsWith(applyF());
	}
	,liftS: function(f) {
		return this._underlying.map(function(a) {
			return (f.valueNow())(a);
		}).startsWith((f.valueNow())(this.valueNow()));
	}
	,lift: function(f) {
		return this._underlying.map(f).startsWith(f(this.valueNow()));
	}
	,mapS: function(f) {
		return this.liftS(f);
	}
	,map: function(f) {
		return this.lift(f);
	}
	,_last: null
	,_updater: null
	,_underlying: null
	,_underlyingRaw: null
	,__class__: stx.reactive.Signal
}
stx.reactive.SignalBool = $hxClasses["stx.reactive.SignalBool"] = function() {
};
stx.reactive.SignalBool.__name__ = ["stx","reactive","SignalBool"];
stx.reactive.SignalBool.not = function(signal) {
	return stx.reactive.StreamBool.not(signal._underlying).startsWith(!signal.valueNow());
}
stx.reactive.SignalBool.ifTrue = function(condition,thenS,elseS) {
	return condition.map(function(b) {
		return b?thenS.valueNow():elseS.valueNow();
	});
}
stx.reactive.SignalBool.and = function(signals) {
	return stx.reactive.Signals.zipN(signals).map(function(i) {
		return stx.Iterables.and(i);
	});
}
stx.reactive.SignalBool.or = function(signals) {
	return stx.reactive.Signals.zipN(signals).map(function(i) {
		return stx.Iterables.or(i);
	});
}
stx.reactive.SignalBool.prototype = {
	__class__: stx.reactive.SignalBool
}
stx.reactive.SignalCollection = $hxClasses["stx.reactive.SignalCollection"] = function() {
};
stx.reactive.SignalCollection.__name__ = ["stx","reactive","SignalCollection"];
stx.reactive.SignalCollection.concatS = function(b1,b2) {
	return b1.zip(b2).map(function(c) {
		return stx.functional.FoldableExtensions.concat(c.fst(),c.snd());
	});
}
stx.reactive.SignalCollection.join = function(b,$char) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.mkString(c,$char);
	});
}
stx.reactive.SignalCollection.size = function(b) {
	return b.map(function(c) {
		return c.size();
	});
}
stx.reactive.SignalCollection.zipS = function(b1,b2) {
	return b1.zip(b2).map(function(c) {
		return c.fst().zip(c.snd());
	});
}
stx.reactive.SignalCollection.append = function(b,element) {
	return b.map(function(c) {
		return c.add(element);
	});
}
stx.reactive.SignalCollection.count = function(b,predicate) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.count(c,predicate);
	});
}
stx.reactive.SignalCollection.all = function(b,tester) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.forAll(c,tester);
	});
}
stx.reactive.SignalCollection.any = function(b,tester) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.forAny(c,tester);
	});
}
stx.reactive.SignalCollection.foreach = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foreach(c,f);
	});
}
stx.reactive.SignalCollection.each = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foreach(c,f);
	});
}
stx.reactive.SignalCollection.map = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.map(c,f);
	});
}
stx.reactive.SignalCollection.mapTo = function(b,t,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.mapTo(c,t,f);
	});
}
stx.reactive.SignalCollection.partition = function(b,filter) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.partition(c,filter);
	});
}
stx.reactive.SignalCollection.filter = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.filter(c,f);
	});
}
stx.reactive.SignalCollection.flatMap = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.flatMap(c,f);
	});
}
stx.reactive.SignalCollection.toArray = function(b) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.toArray(c);
	});
}
stx.reactive.SignalCollection.foldr = function(b,initial,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foldr(c,initial,f);
	});
}
stx.reactive.SignalCollection.foldl = function(b,initial,f) {
	return b.map(function(c) {
		return c.foldl(initial,f);
	});
}
stx.reactive.SignalCollection.prototype = {
	__class__: stx.reactive.SignalCollection
}
stx.reactive.SignalCollectionExtensions = $hxClasses["stx.reactive.SignalCollectionExtensions"] = function() {
};
stx.reactive.SignalCollectionExtensions.__name__ = ["stx","reactive","SignalCollectionExtensions"];
stx.reactive.SignalCollectionExtensions.concatS = function(b1,b2) {
	return b1.zip(b2).map(function(c) {
		return stx.functional.FoldableExtensions.concat(c.fst(),c.snd());
	});
}
stx.reactive.SignalCollectionExtensions.join = function(b,$char) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.mkString(c,$char);
	});
}
stx.reactive.SignalCollectionExtensions.size = function(b) {
	return b.map(function(c) {
		return c.size();
	});
}
stx.reactive.SignalCollectionExtensions.zipS = function(b1,b2) {
	return b1.zip(b2).map(function(c) {
		return c.fst().zip(c.snd());
	});
}
stx.reactive.SignalCollectionExtensions.append = function(b,element) {
	return b.map(function(c) {
		return c.add(element);
	});
}
stx.reactive.SignalCollectionExtensions.count = function(b,predicate) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.count(c,predicate);
	});
}
stx.reactive.SignalCollectionExtensions.all = function(b,tester) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.forAll(c,tester);
	});
}
stx.reactive.SignalCollectionExtensions.any = function(b,tester) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.forAny(c,tester);
	});
}
stx.reactive.SignalCollectionExtensions.foreach = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foreach(c,f);
	});
}
stx.reactive.SignalCollectionExtensions.each = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foreach(c,f);
	});
}
stx.reactive.SignalCollectionExtensions.map = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.map(c,f);
	});
}
stx.reactive.SignalCollectionExtensions.mapTo = function(b,t,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.mapTo(c,t,f);
	});
}
stx.reactive.SignalCollectionExtensions.partition = function(b,filter) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.partition(c,filter);
	});
}
stx.reactive.SignalCollectionExtensions.filter = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.filter(c,f);
	});
}
stx.reactive.SignalCollectionExtensions.flatMap = function(b,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.flatMap(c,f);
	});
}
stx.reactive.SignalCollectionExtensions.toArray = function(b) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.toArray(c);
	});
}
stx.reactive.SignalCollectionExtensions.foldr = function(b,initial,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.foldr(c,initial,f);
	});
}
stx.reactive.SignalCollectionExtensions.foldl = function(b,initial,f) {
	return b.map(function(c) {
		return c.foldl(initial,f);
	});
}
stx.reactive.SignalCollectionExtensions.scanl = function(b,initial,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.scanl(c,initial,f);
	});
}
stx.reactive.SignalCollectionExtensions.scanr = function(b,initial,f) {
	return b.map(function(c) {
		return stx.functional.FoldableExtensions.scanr(c,initial,f);
	});
}
stx.reactive.SignalCollectionExtensions.prototype = {
	__class__: stx.reactive.SignalCollectionExtensions
}
stx.reactive.SignalFloat = $hxClasses["stx.reactive.SignalFloat"] = function() {
};
stx.reactive.SignalFloat.__name__ = ["stx","reactive","SignalFloat"];
stx.reactive.SignalFloat.plus = function(b,value) {
	return stx.reactive.SignalFloat.plusS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.plusS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() + t.snd();
	});
}
stx.reactive.SignalFloat.minusS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() - t.snd();
	});
}
stx.reactive.SignalFloat.minus = function(b,value) {
	return stx.reactive.SignalFloat.minusS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.timesS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() * t.snd();
	});
}
stx.reactive.SignalFloat.times = function(b,value) {
	return stx.reactive.SignalFloat.timesS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.dividedByS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() / t.snd();
	});
}
stx.reactive.SignalFloat.dividedBy = function(b,value) {
	return stx.reactive.SignalFloat.dividedByS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.abs = function(b) {
	return b.map(function(e) {
		return Math.abs(e);
	});
}
stx.reactive.SignalFloat.negate = function(b) {
	return b.map(function(e) {
		return -e;
	});
}
stx.reactive.SignalFloat.floor = function(b) {
	return b.map(function(e) {
		return Math.floor(e);
	});
}
stx.reactive.SignalFloat.ceil = function(b) {
	return b.map(function(e) {
		return Math.ceil(e);
	});
}
stx.reactive.SignalFloat.round = function(b) {
	return b.map(function(e) {
		return Math.round(e);
	});
}
stx.reactive.SignalFloat.acos = function(b) {
	return b.map(function(e) {
		return Math.acos(e);
	});
}
stx.reactive.SignalFloat.asin = function(b) {
	return b.map(function(e) {
		return Math.asin(e);
	});
}
stx.reactive.SignalFloat.atan = function(b) {
	return b.map(function(e) {
		return Math.atan(e);
	});
}
stx.reactive.SignalFloat.atan2B = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return Math.atan2(t.fst(),t.snd());
	});
}
stx.reactive.SignalFloat.atan2 = function(b,value) {
	return stx.reactive.SignalFloat.atan2B(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.cos = function(b) {
	return b.map(function(e) {
		return Math.cos(e);
	});
}
stx.reactive.SignalFloat.exp = function(b) {
	return b.map(function(e) {
		return Math.exp(e);
	});
}
stx.reactive.SignalFloat.log = function(b) {
	return b.map(function(e) {
		return Math.log(e);
	});
}
stx.reactive.SignalFloat.maxS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return Math.max(t.fst(),t.snd());
	});
}
stx.reactive.SignalFloat.max = function(b,value) {
	return stx.reactive.SignalFloat.maxS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.minS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return Math.min(t.fst(),t.snd());
	});
}
stx.reactive.SignalFloat.min = function(b,value) {
	return stx.reactive.SignalFloat.minS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.powS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return Math.pow(t.fst(),t.snd());
	});
}
stx.reactive.SignalFloat.pow = function(b,value) {
	return stx.reactive.SignalFloat.powS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalFloat.sin = function(b) {
	return b.map(function(e) {
		return Math.sin(e);
	});
}
stx.reactive.SignalFloat.sqrt = function(b) {
	return b.map(function(e) {
		return Math.sqrt(e);
	});
}
stx.reactive.SignalFloat.tan = function(b) {
	return b.map(function(e) {
		return Math.tan(e);
	});
}
stx.reactive.SignalFloat.prototype = {
	__class__: stx.reactive.SignalFloat
}
stx.reactive.SignalInt = $hxClasses["stx.reactive.SignalInt"] = function() {
};
stx.reactive.SignalInt.__name__ = ["stx","reactive","SignalInt"];
stx.reactive.SignalInt.plus = function(b,value) {
	return stx.reactive.SignalInt.plusS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalInt.plusS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() + t.snd();
	});
}
stx.reactive.SignalInt.minusS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() - t.snd();
	});
}
stx.reactive.SignalInt.minus = function(b,value) {
	return stx.reactive.SignalInt.minusS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalInt.timesS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() * t.snd();
	});
}
stx.reactive.SignalInt.times = function(b,value) {
	return stx.reactive.SignalInt.timesS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalInt.modS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() % t.snd();
	});
}
stx.reactive.SignalInt.mod = function(b,value) {
	return stx.reactive.SignalInt.modS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalInt.dividedByS = function(b1,b2) {
	return b1.zip(b2).map(function(t) {
		return t.fst() / t.snd() | 0;
	});
}
stx.reactive.SignalInt.dividedBy = function(b,value) {
	return stx.reactive.SignalInt.dividedByS(b,stx.reactive.Signals.constant(value));
}
stx.reactive.SignalInt.abs = function(b) {
	return b.map(function(e) {
		return Math.abs(e) | 0;
	});
}
stx.reactive.SignalInt.negate = function(b) {
	return b.map(function(e) {
		return -e;
	});
}
stx.reactive.SignalInt.toFloat = function(b) {
	return b.map(function(e) {
		return e;
	});
}
stx.reactive.SignalInt.prototype = {
	__class__: stx.reactive.SignalInt
}
stx.reactive.SignalSignal = $hxClasses["stx.reactive.SignalSignal"] = function() {
};
stx.reactive.SignalSignal.__name__ = ["stx","reactive","SignalSignal"];
stx.reactive.SignalSignal.switchS = function(signal) {
	return stx.reactive.SignalSignal.flatten(signal);
}
stx.reactive.SignalSignal.join = function(signal) {
	return stx.reactive.SignalSignal.flatten(signal);
}
stx.reactive.SignalSignal.flatten = function(signal) {
	var init = signal.valueNow();
	var prevSourceE = null;
	var receiverE = stx.reactive.Streams.identity();
	var makerE = stx.reactive.Streams.create(function(p) {
		if(prevSourceE != null) prevSourceE.removeListener(receiverE);
		prevSourceE = p.value._underlying;
		prevSourceE.attachListener(receiverE);
		receiverE.sendEvent(p.value.valueNow());
		return stx.reactive.Propagation.doNotPropagate;
	},[signal._underlying]);
	makerE.sendEvent(init);
	return receiverE.startsWith(init.valueNow());
}
stx.reactive.SignalSignal.prototype = {
	__class__: stx.reactive.SignalSignal
}
stx.reactive.Signals = $hxClasses["stx.reactive.Signals"] = function() {
};
stx.reactive.Signals.__name__ = ["stx","reactive","Signals"];
stx.reactive.Signals.constant = function(value) {
	return stx.reactive.Streams.identity().startsWith(value);
}
stx.reactive.Signals.cond = function(conditions,elseS) {
	return (function($this) {
		var $r;
		var $e = (stx.Iterables.headOption(conditions));
		switch( $e[1] ) {
		case 0:
			$r = elseS;
			break;
		case 1:
			var h = $e[2];
			$r = stx.reactive.SignalBool.ifTrue(h.fst(),h.snd(),stx.reactive.Signals.cond(stx.Iterables.tail(conditions),elseS));
			break;
		}
		return $r;
	}(this));
}
stx.reactive.Signals.zipN = function(signals) {
	var zipValueNow = function() {
		return IterableLambda.map(signals,function(b) {
			return b.valueNow();
		});
	};
	return stx.reactive.Streams.create(function(pulse) {
		return stx.reactive.Propagation.propagate(pulse.withValue(zipValueNow()));
	},IterableLambda.map(signals,function(b) {
		return b._underlying;
	})).startsWith(zipValueNow());
}
stx.reactive.Signals.sample = function(time) {
	return stx.reactive.Streams.timer(time).startsWith(stx.reactive.External.now() | 0);
}
stx.reactive.Signals.sampleS = function(time) {
	return stx.reactive.Streams.timerS(time).startsWith(stx.reactive.External.now() | 0);
}
stx.reactive.Signals.toSignal = function(s,init) {
	return new stx.reactive.Signal(s,init,function(pulse) {
		return stx.reactive.Propagation.propagate(pulse);
	});
}
stx.reactive.Signals.prototype = {
	__class__: stx.reactive.Signals
}
stx.reactive.StreamBool = $hxClasses["stx.reactive.StreamBool"] = function() {
};
stx.reactive.StreamBool.__name__ = ["stx","reactive","StreamBool"];
stx.reactive.StreamBool.not = function(stream) {
	return stream.map(function(v) {
		return !v;
	});
}
stx.reactive.StreamBool.ifTrue = function(stream,thenE,elseE) {
	var testStamp = -1;
	var testValue = false;
	stx.reactive.Streams.create(function(pulse) {
		testStamp = pulse.stamp;
		testValue = pulse.value;
		return stx.reactive.Propagation.doNotPropagate;
	},[stream]);
	return stx.reactive.Streams.merge([stx.reactive.Streams.create(function(pulse) {
		return testValue && testStamp == pulse.stamp?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate;
	},[thenE]),stx.reactive.Streams.create(function(pulse) {
		return !testValue && testStamp == pulse.stamp?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate;
	},[elseE])]);
}
stx.reactive.StreamBool.and = function(streams) {
	var rev = stx.Iterables.reversed(streams);
	var count = IterableLambda.size(streams);
	var iterator = $iterator(rev)();
	var acc = iterator.hasNext()?iterator.next():stx.reactive.Streams.one(true);
	while(iterator.hasNext()) {
		var next = iterator.next();
		acc = stx.reactive.StreamBool.ifTrue(next,acc,next.constant(false));
	}
	return acc;
}
stx.reactive.StreamBool.or = function(streams) {
	var rev = stx.Iterables.reversed(streams);
	var count = IterableLambda.size(streams);
	var iterator = $iterator(rev)();
	var acc = iterator.hasNext()?iterator.next():stx.reactive.Streams.one(false);
	while(iterator.hasNext()) {
		var next = iterator.next();
		acc = stx.reactive.StreamBool.ifTrue(next,next,acc);
	}
	return acc;
}
stx.reactive.StreamBool.prototype = {
	__class__: stx.reactive.StreamBool
}
stx.reactive.StreamStream = $hxClasses["stx.reactive.StreamStream"] = function() {
};
stx.reactive.StreamStream.__name__ = ["stx","reactive","StreamStream"];
stx.reactive.StreamStream.switchE = function(streams) {
	return stx.reactive.StreamStream.flatten(streams);
}
stx.reactive.StreamStream.join = function(stream) {
	return stx.reactive.StreamStream.flatten(stream);
}
stx.reactive.StreamStream.flatten = function(stream) {
	return stream.bind(function(stream1) {
		return stream1;
	});
}
stx.reactive.StreamStream.prototype = {
	__class__: stx.reactive.StreamStream
}
stx.reactive.Streams = $hxClasses["stx.reactive.Streams"] = function() {
};
stx.reactive.Streams.__name__ = ["stx","reactive","Streams"];
stx.reactive.Streams.create = function(updater,sources) {
	var sourceEvents = sources == null?null:IterableLambda.toArray(sources);
	return new stx.reactive.Stream(updater,sourceEvents);
}
stx.reactive.Streams.identity = function(sources) {
	var sourceArray = sources == null?null:IterableLambda.toArray(sources);
	return new stx.reactive.Stream(function(pulse) {
		return stx.reactive.Propagation.propagate(pulse);
	},sourceArray);
}
stx.reactive.Streams.zero = function() {
	return stx.reactive.Streams.create(function(pulse) {
		throw "zeroE : received a value; zeroE should not receive a value; the value was " + Std.string(pulse.value);
		return stx.reactive.Propagation.doNotPropagate;
	});
}
stx.reactive.Streams.toStream = function(f) {
	var s = stx.reactive.Streams.create(function(pulse) {
		return stx.reactive.Propagation.propagate(pulse.value);
	});
	f.foreach(function(v) {
		s.sendEvent(v);
	});
	return s;
}
stx.reactive.Streams.one = function(val) {
	var sent = false;
	var stream = stx.reactive.Streams.create(function(pulse) {
		if(sent) throw "Streams.one: received an extra value";
		sent = false;
		return stx.reactive.Propagation.propagate(pulse);
	});
	stream.sendLater(val);
	return stream;
}
stx.reactive.Streams.merge = function(streams) {
	return IterableLambda.size(streams) == 0?stx.reactive.Streams.zero():stx.reactive.Streams.identity(streams);
}
stx.reactive.Streams.constant = function(value,sources) {
	return stx.reactive.Streams.create(function(pulse) {
		return stx.reactive.Propagation.propagate(pulse.withValue(value));
	},sources);
}
stx.reactive.Streams.receiver = function() {
	return stx.reactive.Streams.identity();
}
stx.reactive.Streams.cond = function(conditions) {
	return (function($this) {
		var $r;
		var $e = (stx.Iterables.headOption(conditions));
		switch( $e[1] ) {
		case 0:
			$r = stx.reactive.Streams.zero();
			break;
		case 1:
			var h = $e[2];
			$r = stx.reactive.StreamBool.ifTrue(h.fst(),h.snd(),stx.reactive.Streams.cond(stx.Iterables.tail(conditions)));
			break;
		}
		return $r;
	}(this));
}
stx.reactive.Streams.timer = function(time) {
	return stx.reactive.Streams.timerS(stx.reactive.Signals.constant(time));
}
stx.reactive.Streams.timerS = function(time) {
	var stream = stx.reactive.Streams.identity();
	var pulser = null;
	var timer = null;
	var createTimer = function() {
		return stx.reactive.External.setTimeout(pulser,time.valueNow());
	};
	pulser = function() {
		stream.sendEvent(stx.reactive.External.now());
		if(timer != null) stx.reactive.External.cancelTimeout(timer);
		if(!stream.getWeaklyHeld()) timer = createTimer();
	};
	timer = createTimer();
	return stream;
}
stx.reactive.Streams.zipN = function(streams) {
	var stamps = IterableLambda.toArray(IterableLambda.map(streams,function(s) {
		return -1;
	}));
	var values = IterableLambda.toArray(IterableLambda.map(streams,function(s) {
		return null;
	}));
	var output = stx.reactive.Streams.identity();
	var _g1 = 0, _g = IterableLambda.size(streams);
	while(_g1 < _g) {
		var index = [_g1++];
		var stream = stx.Iterables.at(streams,index[0]);
		output = output.merge(stx.reactive.Streams.create((function(index) {
			return function(pulse) {
				stamps[index[0]] = pulse.stamp;
				values[index[0]] = pulse.value;
				return stx.reactive.Propagation.propagate(pulse);
			};
		})(index),[stream]));
	}
	return stx.reactive.Streams.create(function(pulse) {
		var stampsEqual = IterableLambda.size(stx.Iterables.nub(stamps)) == 1;
		return stampsEqual?(function($this) {
			var $r;
			var iter = ArrayLambda.snapshot(values);
			$r = stx.reactive.Propagation.propagate(pulse.withValue(iter));
			return $r;
		}(this)):stx.reactive.Propagation.doNotPropagate;
	},[output]).uniqueSteps();
}
stx.reactive.Streams.randomS = function(time) {
	return stx.reactive.Streams.timerS(time).map(function(e) {
		return Math.random();
	});
}
stx.reactive.Streams.random = function(time) {
	return stx.reactive.Streams.randomS(stx.reactive.Signals.constant(time));
}
stx.reactive.Streams.prototype = {
	__class__: stx.reactive.Streams
}
if(!stx.rtti) stx.rtti = {}
stx.rtti.RTypes = $hxClasses["stx.rtti.RTypes"] = function() { }
stx.rtti.RTypes.__name__ = ["stx","rtti","RTypes"];
stx.rtti.RTypes.typetree = function(type) {
	var rtti = Reflect.field(type,"__rtti");
	var x = Xml.parse(rtti).firstElement();
	return new haxe.rtti.XmlParser().processElement(x);
}
stx.rtti.RTypes.fields = function(type) {
	return (function($this) {
		var $r;
		var $e = (stx.rtti.RTypes.typetree(type));
		switch( $e[1] ) {
		case 1:
			var c = $e[2];
			$r = c.fields;
			break;
		default:
			$r = null;
		}
		return $r;
	}(this));
}
stx.rtti.RTypes.ancestors = function(v,a) {
	var arr = a == null?[]:a;
	arr.push(v);
	var scp = v.superClass;
	if(scp == null) return arr;
	var superclass = Type.resolveClass(scp.path);
	if(superclass != null) return stx.rtti.RTypes.ancestors(stx.Enums.params(stx.rtti.RTypes.typetree(superclass))[0],arr);
	return arr;
}
if(!stx.test) stx.test = {}
stx.test.Assert = $hxClasses["stx.test.Assert"] = function() { }
stx.test.Assert.__name__ = ["stx","test","Assert"];
stx.test.Assert.results = null;
stx.test.Assert.that = function(obj,cond,msg,pos) {
	var $e = (cond(obj));
	switch( $e[1] ) {
	case 0:
		var result = $e[2];
		stx.test.Assert.isTrue(false,"Expected: " + result.assertion + ", Found: x = " + stx.test.Assert.q(obj),pos);
		break;
	case 1:
		stx.test.Assert.isTrue(true,null,pos);
		break;
	}
}
stx.test.Assert.isTrue = function(cond,msg,pos) {
	if(null == msg) msg = "expected true";
	if(stx.test.Assert.results == null) {
		if(cond) {
		} else throw new stx.err.AssertionError(msg,{ fileName : "Assert.hx", lineNumber : 77, className : "stx.test.Assert", methodName : "isTrue"});
	} else if(cond) stx.test.Assert.results.add(stx.test.Assertation.Success(pos)); else stx.test.Assert.results.add(stx.test.Assertation.Failure(msg,pos));
	return cond;
}
stx.test.Assert.isFalse = function(value,msg,pos) {
	if(null == msg) msg = "expected false";
	return stx.test.Assert.isTrue(value == false,msg,pos);
}
stx.test.Assert.isNull = function(value,msg,pos) {
	if(msg == null) msg = "expected null but was " + stx.test.Assert.q(value);
	return stx.test.Assert.isTrue(value == null,msg,pos);
}
stx.test.Assert.notNull = function(value,msg,pos) {
	if(null == msg) msg = "expected false";
	return stx.test.Assert.isTrue(value != null,msg,pos);
}
stx.test.Assert["is"] = function(value,type,msg,pos) {
	if(msg == null) msg = "expected type " + stx.test.Assert.typeToString(type) + " but was " + stx.test.Assert.typeToString(value);
	return stx.test.Assert.isTrue(js.Boot.__instanceof(value,type),msg,pos);
}
stx.test.Assert.notEquals = function(expected,value,msg,pos) {
	if(msg == null) msg = "expected " + stx.test.Assert.q(expected) + " and testa value " + stx.test.Assert.q(value) + " should be different";
	return stx.test.Assert.isFalse(expected == value,msg,pos);
}
stx.test.Assert.equals = function(expected,value,equal,msg,pos) {
	if(equal == null) equal = stx.ds.plus.Equal.getEqualFor(expected);
	if(msg == null) msg = "expected " + stx.test.Assert.q(expected) + " but was " + stx.test.Assert.q(value);
	return stx.test.Assert.isTrue(equal(expected,value),msg,pos);
}
stx.test.Assert.matches = function(pattern,value,msg,pos) {
	if(msg == null) msg = "the value " + stx.test.Assert.q(value) + "does not match the provided pattern";
	return stx.test.Assert.isTrue(pattern.match(value),msg,pos);
}
stx.test.Assert.floatEquals = function(expected,value,approx,msg,pos) {
	if(msg == null) msg = "expected " + expected + " but was " + value;
	if(Math.isNaN(expected)) {
		if(Math.isNaN(value)) return stx.test.Assert.isTrue(true,msg,pos); else return stx.test.Assert.isTrue(false,msg,pos);
	} else if(Math.isNaN(value)) return stx.test.Assert.isTrue(false,msg,pos);
	if(null == approx) approx = 1e-5;
	return stx.test.Assert.isTrue(Math.abs(value - expected) < approx,msg,pos);
}
stx.test.Assert.getTypeName = function(v) {
	var $e = (Type["typeof"](v));
	switch( $e[1] ) {
	case 0:
		return null;
	case 1:
		return "Int";
	case 2:
		return "Float";
	case 3:
		return "Bool";
	case 5:
		return "function";
	case 6:
		var c = $e[2];
		return Type.getClassName(c);
	case 7:
		var e = $e[2];
		return Type.getEnumName(e);
	case 4:
		return "Object";
	case 8:
		return "Unknown";
	}
}
stx.test.Assert.isIterable = function(v,isAnonym) {
	var fields = isAnonym?Reflect.fields(v):Type.getInstanceFields(Type.getClass(v));
	if(!Lambda.has(fields,"iterator")) return false;
	return Reflect.isFunction(Reflect.field(v,"iterator"));
}
stx.test.Assert.isIterator = function(v,isAnonym) {
	var fields = isAnonym?Reflect.fields(v):Type.getInstanceFields(Type.getClass(v));
	if(!Lambda.has(fields,"next") || !Lambda.has(fields,"hasNext")) return false;
	return Reflect.isFunction(Reflect.field(v,"next")) && Reflect.isFunction(Reflect.field(v,"hasNext"));
}
stx.test.Assert.sameAs = function(expected,value,status) {
	var texpected = stx.test.Assert.getTypeName(expected);
	var tvalue = stx.test.Assert.getTypeName(value);
	var isanonym = texpected == "Object";
	if(texpected != tvalue) {
		status.error = "expected type " + texpected + " but it is " + tvalue + (status.path == ""?"":" for field " + status.path);
		return false;
	}
	var $e = (Type["typeof"](expected));
	switch( $e[1] ) {
	case 0:
	case 1:
	case 2:
	case 3:
		if(expected != value) {
			status.error = "expected " + Std.string(expected) + " but it is " + Std.string(value) + (status.path == ""?"":" for field " + status.path);
			return false;
		}
		return true;
	case 5:
		if(!Reflect.compareMethods(expected,value)) {
			status.error = "expected same function reference" + (status.path == ""?"":" for field " + status.path);
			return false;
		}
		return true;
	case 6:
		var c = $e[2];
		var cexpected = Type.getClassName(c);
		var cvalue = Type.getClassName(Type.getClass(value));
		if(cexpected != cvalue) {
			status.error = "expected instance of " + cexpected + " but it is " + cvalue + (status.path == ""?"":" for field " + status.path);
			return false;
		}
		if(js.Boot.__instanceof(expected,Array)) {
			if(status.recursive || status.path == "") {
				if(expected.length != value.length) {
					status.error = "expected " + Std.string(expected.length) + " elements but they were " + Std.string(value.length) + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g1 = 0, _g = expected.length;
				while(_g1 < _g) {
					var i = _g1++;
					status.path = path == ""?"array[" + i + "]":path + "[" + i + "]";
					if(!stx.test.Assert.sameAs(expected[i],value[i],status)) {
						status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
						return false;
					}
				}
			}
			return true;
		}
		if(js.Boot.__instanceof(expected,Date)) {
			if(expected.getTime() != value.getTime()) {
				status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
				return false;
			}
			return true;
		}
		if(js.Boot.__instanceof(expected,haxe.io.Bytes)) {
			if(status.recursive || status.path == "") {
				var ebytes = expected;
				var vbytes = value;
				if(ebytes.length != vbytes.length) return false;
				var _g1 = 0, _g = ebytes.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(ebytes.b[i] != vbytes.b[i]) {
						status.error = "expected byte " + ebytes.b[i] + " but wss " + ebytes.b[i] + (status.path == ""?"":" for field " + status.path);
						return false;
					}
				}
			}
			return true;
		}
		if(js.Boot.__instanceof(expected,Map) || js.Boot.__instanceof(expected,IntMap)) {
			if(status.recursive || status.path == "") {
				var keys = Lambda.array({ iterator : function() {
					return expected.keys();
				}});
				var vkeys = Lambda.array({ iterator : function() {
					return value.keys();
				}});
				if(keys.length != vkeys.length) {
					status.error = "expected " + keys.length + " keys but they were " + vkeys.length + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g = 0;
				while(_g < keys.length) {
					var key = keys[_g];
					++_g;
					status.path = path == ""?"hash[" + key + "]":path + "[" + key + "]";
					if(!stx.test.Assert.sameAs(expected.get(key),value.get(key),status)) {
						status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
						return false;
					}
				}
			}
			return true;
		}
		if(stx.test.Assert.isIterator(expected,false)) {
			if(status.recursive || status.path == "") {
				var evalues = Lambda.array({ iterator : function() {
					return expected;
				}});
				var vvalues = Lambda.array({ iterator : function() {
					return value;
				}});
				if(evalues.length != vvalues.length) {
					status.error = "expected " + evalues.length + " values in Iterator but they were " + vvalues.length + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g1 = 0, _g = evalues.length;
				while(_g1 < _g) {
					var i = _g1++;
					status.path = path == ""?"iterator[" + i + "]":path + "[" + i + "]";
					if(!stx.test.Assert.sameAs(evalues[i],vvalues[i],status)) {
						status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
						return false;
					}
				}
			}
			return true;
		}
		if(stx.test.Assert.isIterable(expected,false)) {
			if(status.recursive || status.path == "") {
				var evalues = Lambda.array(expected);
				var vvalues = Lambda.array(value);
				if(evalues.length != vvalues.length) {
					status.error = "expected " + evalues.length + " values in Iterable but they were " + vvalues.length + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g1 = 0, _g = evalues.length;
				while(_g1 < _g) {
					var i = _g1++;
					status.path = path == ""?"iterable[" + i + "]":path + "[" + i + "]";
					if(!stx.test.Assert.sameAs(evalues[i],vvalues[i],status)) return false;
				}
			}
			return true;
		}
		if(status.recursive || status.path == "") {
			var fields = Type.getInstanceFields(Type.getClass(expected));
			var path = status.path;
			var _g = 0;
			while(_g < fields.length) {
				var field = fields[_g];
				++_g;
				status.path = path == ""?field:path + "." + field;
				var e = Reflect.field(expected,field);
				if(Reflect.isFunction(e)) continue;
				var v = Reflect.field(value,field);
				if(!stx.test.Assert.sameAs(e,v,status)) return false;
			}
		}
		return true;
	case 7:
		var e = $e[2];
		var eexpected = Type.getEnumName(e);
		var evalue = Type.getEnumName(Type.getEnum(value));
		if(eexpected != evalue) {
			status.error = "expected enumeration of " + eexpected + " but it is " + evalue + (status.path == ""?"":" for field " + status.path);
			return false;
		}
		if(status.recursive || status.path == "") {
			if(expected[1] != value[1]) {
				status.error = "expected " + stx.test.Assert.q(expected[0]) + " but is " + stx.test.Assert.q(value[0]) + (status.path == ""?"":" for field " + status.path);
				return false;
			}
			var eparams = expected.slice(2);
			var vparams = value.slice(2);
			var path = status.path;
			var _g1 = 0, _g = eparams.length;
			while(_g1 < _g) {
				var i = _g1++;
				status.path = path == ""?"enum[" + i + "]":path + "[" + i + "]";
				if(!stx.test.Assert.sameAs(eparams[i],vparams[i],status)) {
					status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
					return false;
				}
			}
		}
		return true;
	case 4:
		if(status.recursive || status.path == "") {
			var fields = Reflect.fields(expected);
			var path = status.path;
			var _g = 0;
			while(_g < fields.length) {
				var field = fields[_g];
				++_g;
				status.path = path == ""?field:path + "." + field;
				if(!Reflect.hasField(value,field)) {
					status.error = "expected field " + status.path + " does not exist in " + Std.string(value);
					return false;
				}
				var e = Reflect.field(expected,field);
				if(Reflect.isFunction(e)) continue;
				var v = Reflect.field(value,field);
				if(!stx.test.Assert.sameAs(e,v,status)) return false;
			}
		}
		if(stx.test.Assert.isIterator(expected,true)) {
			if(!stx.test.Assert.isIterator(value,true)) {
				status.error = "expected Iterable but it is not " + (status.path == ""?"":" for field " + status.path);
				return false;
			}
			if(status.recursive || status.path == "") {
				var evalues = Lambda.array({ iterator : function() {
					return expected;
				}});
				var vvalues = Lambda.array({ iterator : function() {
					return value;
				}});
				if(evalues.length != vvalues.length) {
					status.error = "expected " + evalues.length + " values in Iterator but they were " + vvalues.length + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g1 = 0, _g = evalues.length;
				while(_g1 < _g) {
					var i = _g1++;
					status.path = path == ""?"iterator[" + i + "]":path + "[" + i + "]";
					if(!stx.test.Assert.sameAs(evalues[i],vvalues[i],status)) {
						status.error = "expected " + stx.test.Assert.q(expected) + " but it is " + stx.test.Assert.q(value) + (status.path == ""?"":" for field " + status.path);
						return false;
					}
				}
			}
			return true;
		}
		if(stx.test.Assert.isIterable(expected,true)) {
			if(!stx.test.Assert.isIterable(value,true)) {
				status.error = "expected Iterator but it is not " + (status.path == ""?"":" for field " + status.path);
				return false;
			}
			if(status.recursive || status.path == "") {
				var evalues = Lambda.array(expected);
				var vvalues = Lambda.array(value);
				if(evalues.length != vvalues.length) {
					status.error = "expected " + evalues.length + " values in Iterable but they were " + vvalues.length + (status.path == ""?"":" for field " + status.path);
					return false;
				}
				var path = status.path;
				var _g1 = 0, _g = evalues.length;
				while(_g1 < _g) {
					var i = _g1++;
					status.path = path == ""?"iterable[" + i + "]":path + "[" + i + "]";
					if(!stx.test.Assert.sameAs(evalues[i],vvalues[i],status)) return false;
				}
			}
			return true;
		}
		return true;
	case 8:
		return (function($this) {
			var $r;
			throw "Unable to compare  two unknown types";
			return $r;
		}(this));
	}
	return (function($this) {
		var $r;
		throw "Unable to compare values: " + stx.test.Assert.q(expected) + " and " + stx.test.Assert.q(value);
		return $r;
	}(this));
}
stx.test.Assert.q = function(v) {
	if(null == v) return "null"; else if(js.Boot.__instanceof(v,String)) return "\"" + StringTools.replace(v,"\"","\\\"") + "\""; else return "" + Std.string(v);
}
stx.test.Assert.looksLike = function(expected,value,recursive,msg,pos) {
	if(null == recursive) recursive = true;
	var status = { recursive : recursive, path : "", error : null};
	if(stx.test.Assert.sameAs(expected,value,status)) return stx.test.Assert.isTrue(true,msg,pos); else {
		stx.test.Assert.fail(msg == null?status.error:msg,pos);
		return false;
	}
}
stx.test.Assert.throwsException = function(method,type,msg,pos) {
	if(type == null) type = String;
	try {
		method();
		var name = Type.getClassName(type);
		if(name == null) name = "" + Std.string(type);
		stx.test.Assert.fail("exception of type " + name + " not raised",pos);
		return false;
	} catch( ex ) {
		var name = Type.getClassName(type);
		if(name == null) name = "" + Std.string(type);
		return stx.test.Assert.isTrue(js.Boot.__instanceof(ex,type),"expected throw of type " + name + " but was " + Std.string(ex),pos);
	}
}
stx.test.Assert.equalsOneOf = function(value,possibilities,msg,pos) {
	if(Lambda.has(possibilities,value)) return stx.test.Assert.isTrue(true,msg,pos); else {
		stx.test.Assert.fail(msg == null?"value " + stx.test.Assert.q(value) + " not found in the expected possibilities " + Std.string(possibilities):msg,pos);
		return false;
	}
}
stx.test.Assert.contains = function(values,match,msg,pos) {
	if(Lambda.has(values,match)) return stx.test.Assert.isTrue(true,msg,pos); else {
		stx.test.Assert.fail(msg == null?"values " + Std.string(values) + " do not contain " + Std.string(match):msg,pos);
		return false;
	}
}
stx.test.Assert.notContains = function(values,match,msg,pos) {
	if(!Lambda.has(values,match)) return stx.test.Assert.isTrue(true,msg,pos); else {
		stx.test.Assert.fail(msg == null?"values " + Std.string(values) + " do contain " + Std.string(match):msg,pos);
		return false;
	}
}
stx.test.Assert.stringContains = function(match,value,msg,pos) {
	if(value != null && value.indexOf(match) >= 0) return stx.test.Assert.isTrue(true,msg,pos); else {
		stx.test.Assert.fail(msg == null?"value " + stx.test.Assert.q(value) + " does not contain " + stx.test.Assert.q(match):msg,pos);
		return false;
	}
}
stx.test.Assert.stringSequence = function(sequence,value,msg,pos) {
	if(null == value) {
		stx.test.Assert.fail(msg == null?"null argument value":msg,pos);
		return false;
	}
	var p = 0;
	var _g = 0;
	while(_g < sequence.length) {
		var s = sequence[_g];
		++_g;
		var p2 = value.indexOf(s,p);
		if(p2 < 0) {
			if(msg == null) {
				msg = "expected '" + s + "' after ";
				if(p > 0) {
					var cut = HxOverrides.substr(value,0,p);
					if(cut.length > 30) cut = "..." + HxOverrides.substr(cut,-27,null);
					msg += " '" + cut + "'";
				} else msg += " begin";
			}
			stx.test.Assert.fail(msg,pos);
			return false;
		}
		p = p2 + s.length;
	}
	return stx.test.Assert.isTrue(true,msg,pos);
}
stx.test.Assert.fail = function(msg,pos) {
	if(msg == null) msg = "failure expected";
	return stx.test.Assert.isTrue(false,msg,pos);
}
stx.test.Assert.warn = function(msg) {
	stx.test.Assert.results.add(stx.test.Assertation.Warning(msg));
}
stx.test.Assert.createAsync = function(f,timeout) {
	return function() {
	};
}
stx.test.Assert.delivered = function(future,assertions,timeout) {
	var f = stx.test.Assert.createAsync(function() {
		if(future.isCanceled()) stx.test.Assert.fail("expected delivery of future " + stx.test.Assert.q(future) + ", but it was canceled",{ fileName : "Assert.hx", lineNumber : 701, className : "stx.test.Assert", methodName : "delivered"}); else assertions(stx.Options.get(future.value()));
	},timeout);
	future.deliverTo(function(value) {
		f();
	});
	future.ifCanceled(f);
}
stx.test.Assert.canceled = function(future,assertions,timeout) {
	future.ifCanceled(stx.test.Assert.createAsync(assertions,timeout));
}
stx.test.Assert.notDelivered = function(future,timeout,pos) {
	var f = stx.test.Assert.createAsync(function() {
		if(future.isDelivered()) stx.test.Assert.fail("Did not expect delivery of: " + Std.string(stx.Options.get(future.value())),pos); else stx.test.Assert.isTrue(true,null,{ fileName : "Assert.hx", lineNumber : 728, className : "stx.test.Assert", methodName : "notDelivered"});
	},timeout + 10);
	haxe.Timer.delay(f,timeout);
	future.deliverTo(function(value) {
		f();
	});
}
stx.test.Assert.createEvent = function(f,timeout) {
	return function(e) {
	};
}
stx.test.Assert.typeToString = function(t) {
	try {
		var _t = Type.getClass(t);
		if(_t != null) t = _t;
	} catch( e ) {
	}
	try {
		return Type.getClassName(t);
	} catch( e ) {
	}
	try {
		var _t = Type.getEnum(t);
		if(_t != null) t = _t;
	} catch( e ) {
	}
	try {
		return Type.getEnumName(t);
	} catch( e ) {
	}
	try {
		return Std.string(Type["typeof"](t));
	} catch( e ) {
	}
	try {
		return Std.string(t);
	} catch( e ) {
	}
	return "<unable to retrieve type name>";
}
stx.test.Assertation = $hxClasses["stx.test.Assertation"] = { __ename__ : ["stx","test","Assertation"], __constructs__ : ["Success","Failure","Error","SetupError","TeardownError","TimeoutError","AsyncError","Warning"] }
stx.test.Assertation.Success = function(pos) { var $x = ["Success",0,pos]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.Failure = function(msg,pos) { var $x = ["Failure",1,msg,pos]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.Error = function(e,stack) { var $x = ["Error",2,e,stack]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.SetupError = function(e,stack) { var $x = ["SetupError",3,e,stack]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.TeardownError = function(e,stack) { var $x = ["TeardownError",4,e,stack]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.TimeoutError = function(missedAsyncs,stack) { var $x = ["TimeoutError",5,missedAsyncs,stack]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.AsyncError = function(e,stack) { var $x = ["AsyncError",6,e,stack]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
stx.test.Assertation.Warning = function(msg) { var $x = ["Warning",7,msg]; $x.__enum__ = stx.test.Assertation; $x.toString = $estr; return $x; }
if(!stx.test._Dispatcher) stx.test._Dispatcher = {}
stx.test._Dispatcher.EventException = $hxClasses["stx.test._Dispatcher.EventException"] = { __ename__ : ["stx","test","_Dispatcher","EventException"], __constructs__ : ["StopPropagation"] }
stx.test._Dispatcher.EventException.StopPropagation = ["StopPropagation",0];
stx.test._Dispatcher.EventException.StopPropagation.toString = $estr;
stx.test._Dispatcher.EventException.StopPropagation.__enum__ = stx.test._Dispatcher.EventException;
stx.test.Dispatcher = $hxClasses["stx.test.Dispatcher"] = function() {
	this.handlers = new Array();
};
stx.test.Dispatcher.__name__ = ["stx","test","Dispatcher"];
stx.test.Dispatcher.stop = function() {
	throw stx.test._Dispatcher.EventException.StopPropagation;
}
stx.test.Dispatcher.prototype = {
	has: function() {
		return this.handlers.length > 0;
	}
	,dispatch: function(e) {
		try {
			var list = this.handlers.slice();
			var _g = 0;
			while(_g < list.length) {
				var l = list[_g];
				++_g;
				l(e);
			}
			return true;
		} catch( exc ) {
			if( js.Boot.__instanceof(exc,stx.test._Dispatcher.EventException) ) {
				return false;
			} else throw(exc);
		}
	}
	,clear: function() {
		this.handlers = new Array();
	}
	,remove: function(h) {
		var _g1 = 0, _g = this.handlers.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.handlers[i],h)) return this.handlers.splice(i,1)[0];
		}
		return null;
	}
	,add: function(h) {
		this.handlers.push(h);
		return h;
	}
	,handlers: null
	,__class__: stx.test.Dispatcher
}
stx.test.Notifier = $hxClasses["stx.test.Notifier"] = function() {
	this.handlers = new Array();
};
stx.test.Notifier.__name__ = ["stx","test","Notifier"];
stx.test.Notifier.stop = function() {
	throw stx.test._Dispatcher.EventException.StopPropagation;
}
stx.test.Notifier.prototype = {
	has: function() {
		return this.handlers.length > 0;
	}
	,dispatch: function() {
		try {
			var list = this.handlers.slice();
			var _g = 0;
			while(_g < list.length) {
				var l = list[_g];
				++_g;
				l();
			}
			return true;
		} catch( exc ) {
			if( js.Boot.__instanceof(exc,stx.test._Dispatcher.EventException) ) {
				return false;
			} else throw(exc);
		}
	}
	,clear: function() {
		this.handlers = new Array();
	}
	,remove: function(h) {
		var _g1 = 0, _g = this.handlers.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(Reflect.compareMethods(this.handlers[i],h)) return this.handlers.splice(i,1)[0];
		}
		return null;
	}
	,add: function(h) {
		this.handlers.push(h);
		return h;
	}
	,handlers: null
	,__class__: stx.test.Notifier
}
stx.test.MustMatcherExtensions = $hxClasses["stx.test.MustMatcherExtensions"] = function() { }
stx.test.MustMatcherExtensions.__name__ = ["stx","test","MustMatcherExtensions"];
stx.test.MustMatcherExtensions.negate = function(c) {
	var inverter = function(result) {
		return { assertion : result.negation, negation : result.assertion};
	};
	return function(value) {
		return stx.Eithers.map(c(value),inverter,inverter);
	};
}
stx.test.MustMatcherExtensions.or = function(c1,c2) {
	var transformer = function(r1,r2) {
		return { assertion : "(" + r1.assertion + ") || (" + r2.assertion + ")", negation : "(" + r1.negation + ") && (" + r2.negation + ")"};
	};
	return function(value) {
		return stx.Eithers.composeRight(c1(value),c2(value),transformer,transformer);
	};
}
stx.test.MustMatcherExtensions.and = function(c1,c2) {
	var transformer = function(r1,r2) {
		return { assertion : "(" + r1.assertion + ") && (" + r2.assertion + ")", negation : "(" + r1.negation + ") || (" + r2.negation + ")"};
	};
	return function(value) {
		return stx.Eithers.composeLeft(c1(value),c2(value),transformer,transformer);
	};
}
stx.test.Must = $hxClasses["stx.test.Must"] = function() { }
stx.test.Must.__name__ = ["stx","test","Must"];
stx.test.Must.equal = function(expected,equal) {
	if(equal == null) equal = stx.ds.plus.Equal.getEqualFor(expected);
	return function(value) {
		var result = { assertion : "x == " + Std.string(value), negation : "x != " + Std.string(value)};
		return !equal(value,expected)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beTrue = function() {
	return function(value) {
		var result = { assertion : "x == true", negation : "x == false"};
		return !value?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beFalse = function() {
	return function(value) {
		var result = { assertion : "x == false", negation : "x == true"};
		return value?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beGreaterThan = function(ref) {
	return function(value) {
		var result = { assertion : "x > " + ref, negation : "x <= " + ref};
		return value <= ref?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beLessThan = function(ref) {
	return function(value) {
		var result = { assertion : "x < " + ref, negation : "x >= " + ref};
		return value >= ref?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beGreaterThanInt = function(ref) {
	return function(value) {
		var result = { assertion : "x > " + ref, negation : "x <= " + ref};
		return value <= ref?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beLessThanInt = function(ref) {
	return function(value) {
		var result = { assertion : "x < " + ref, negation : "x >= " + ref};
		return value >= ref?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.haveLength = function(length) {
	return function(value) {
		var len = 0;
		var $it0 = $iterator(value)();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			++len;
		}
		var result = { assertion : "x.length == " + length, negation : "x.length != " + length};
		return len != length?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.haveClass = function(c) {
	return function(value) {
		var result = { assertion : "x.isInstanceOf(" + Type.getClassName(c) + ")", negation : "!x.isInstanceOf(" + Type.getClassName(c) + ")"};
		return !js.Boot.__instanceof(value,c)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.containElement = function(element) {
	return function(c) {
		var result = { assertion : "x.contains(" + Std.string(element) + ")", negation : "!x.contains(" + Std.string(element) + ")"};
		return !c.contains(element)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.containString = function(sub) {
	return function(value) {
		var result = { assertion : "x.contains(\"" + sub + "\")", negation : "!x.contains(\"" + sub + "\")"};
		return !stx.Strings.contains(value,sub)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.startWithString = function(s) {
	return function(value) {
		var result = { assertion : "x.startsWith(\"" + s + "\")", negation : "!x.startsWith(\"" + s + "\")"};
		return !stx.Strings.startsWith(value,s)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.endWithString = function(s) {
	return function(value) {
		var result = { assertion : "x.endsWith(\"" + s + "\")", negation : "!x.endsWith(\"" + s + "\")"};
		return !stx.Strings.endsWith(value,s)?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beNull = function() {
	return function(value) {
		var result = { assertion : "x == null", negation : "x != null"};
		return value != null?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Must.beNonNull = function() {
	return function(value) {
		var result = { assertion : "x != null", negation : "x == null"};
		return value == null?stx.Either.Left(result):stx.Either.Right(result);
	};
}
stx.test.Runner = $hxClasses["stx.test.Runner"] = function() {
	this.fixtures = new Array();
	this.onProgress = new stx.test.Dispatcher();
	this.onStart = new stx.test.Dispatcher();
	this.onComplete = new stx.test.Dispatcher();
	this.length = 0;
};
stx.test.Runner.__name__ = ["stx","test","Runner"];
stx.test.Runner.findMethodByName = function(test,name) {
	return function() {
		var method = Reflect.field(test,name);
		if(method != null) method.apply(test,[]);
	};
}
stx.test.Runner.prototype = {
	addAfterAll: function(test,totalTestsHolder,f) {
		if(Reflect.field(test,"afterAll") != null) {
			var afterAll = stx.test.Runner.findMethodByName(test,"afterAll");
			var runAfterAll = function() {
				totalTestsHolder[0] = totalTestsHolder[0] - 1;
				if(totalTestsHolder[0] == 0) afterAll();
			};
			return function(name) {
				var method = f(name);
				return function() {
					try {
						method();
					} catch( e ) {
						runAfterAll();
						throw e;
					}
					runAfterAll();
				};
			};
		}
		return f;
	}
	,addBeforeAll: function(test,f) {
		if(Reflect.field(test,"beforeAll") != null) {
			var beforeAll = stx.test.Runner.findMethodByName(test,"beforeAll");
			var totalTests = 0;
			var runBeforeAll = function() {
				++totalTests;
				if(totalTests == 1) beforeAll();
			};
			return function(name) {
				var method = f(name);
				return function() {
					runBeforeAll();
					method();
				};
			};
		}
		return f;
	}
	,testComplete: function(h) {
		this.onProgress.dispatch({ result : stx.test.TestResult.ofHandler(h), done : this.pos, totals : this.length});
		this.runNext();
	}
	,runFixture: function(fixture) {
		var handler = new stx.test.TestHandler(fixture);
		handler.onComplete.add($bind(this,this.testComplete));
		handler.execute();
	}
	,runNext: function() {
		if(this.fixtures.length > this.pos) this.runFixture(this.fixtures[this.pos++]); else this.onComplete.dispatch(this);
	}
	,run: function() {
		this.pos = 0;
		this.onStart.dispatch(this);
		this.runNext();
		return this;
	}
	,pos: null
	,isMethod: function(test,name) {
		try {
			return Reflect.isFunction(Reflect.field(test,name));
		} catch( e ) {
			return false;
		}
	}
	,getFixture: function(index) {
		return this.fixtures[index];
	}
	,addFixtures: function(fixtures) {
		var $it0 = $iterator(fixtures)();
		while( $it0.hasNext() ) {
			var fixture = $it0.next();
			this.addFixture(fixture);
		}
		return this;
	}
	,addFixture: function(fixture) {
		this.fixtures.push(fixture);
		this.length++;
		return this;
	}
	,add: function(test,prefix,pattern) {
		if(prefix == null) prefix = "test";
		if(!Reflect.isObject(test)) throw "can't add a null object as a test case";
		var patternMatches = function(field) {
			return stx.Options.map(stx.Options.toOption(pattern),function(p) {
				return p.match(field);
			});
		};
		var prefixMatches = function(field) {
			return stx.Option.Some(stx.Strings.startsWith(field,prefix));
		};
		var fieldIsTest = function(field) {
			return stx.Options.getOrElseC(stx.Options.orElseC(patternMatches(field),prefixMatches(field)),false);
		};
		var fieldIsMethod = (stx.Functions2.curry($bind(this,this.isMethod)))(test);
		var testMethods = ArrayLambda.filter(Type.getInstanceFields(Type.getClass(test)),stx.Predicates.and(fieldIsTest,fieldIsMethod));
		var getMethodByName = this.addBeforeAll(test,this.addAfterAll(test,[testMethods.length],(stx.Functions2.curry(stx.test.Runner.findMethodByName))(test)));
		var methodFixtures = ArrayLambda.map(testMethods,function(field) {
			return new stx.test.TestFixture(test,field,getMethodByName(field),"before","after");
		});
		this.addFixtures(methodFixtures);
		return this;
	}
	,addAll: function(tests,prefix,pattern) {
		if(prefix == null) prefix = "test";
		var $it0 = $iterator(tests)();
		while( $it0.hasNext() ) {
			var test = $it0.next();
			this.add(test,prefix,pattern);
		}
		return this;
	}
	,length: null
	,onComplete: null
	,onStart: null
	,onProgress: null
	,fixtures: null
	,__class__: stx.test.Runner
}
stx.test.TestCase = $hxClasses["stx.test.TestCase"] = function() {
};
stx.test.TestCase.__name__ = ["stx","test","TestCase"];
stx.test.TestCase.prototype = {
	warn: function(msg) {
		stx.test.Assert.warn(msg);
	}
	,fail: function(msg,pos) {
		if(msg == null) msg = "failure expected";
		stx.test.Assert.fail(msg,pos);
	}
	,assertNotDelivered: function(future,timeout,pos) {
		return stx.test.Assert.notDelivered(future,timeout,pos);
	}
	,assertCanceled: function(future,assertions,timeout) {
		return stx.test.Assert.canceled(future,assertions,timeout);
	}
	,assertDelivered: function(future,assertions,timeout) {
		return stx.test.Assert.delivered(future,assertions,timeout);
	}
	,assertStringSequence: function(sequence,value,msg,pos) {
		stx.test.Assert.stringSequence(sequence,value,msg,pos);
	}
	,assertStringContains: function(match,value,msg,pos) {
		stx.test.Assert.stringContains(match,value,msg,pos);
	}
	,assertNotContains: function(values,match,msg,pos) {
		stx.test.Assert.notContains(values,match,msg,pos);
	}
	,assertContains: function(values,match,msg,pos) {
		stx.test.Assert.contains(values,match,msg,pos);
	}
	,assertEqualsOneOf: function(value,possibilities,msg,pos) {
		stx.test.Assert.equalsOneOf(value,possibilities,msg,pos);
	}
	,assertThrowsException: function(method,type,msg,pos) {
		stx.test.Assert.throwsException(method,type,msg,pos);
	}
	,assertLooksLike: function(expected,value,recursive,msg,pos) {
		stx.test.Assert.looksLike(expected,value,recursive,msg,pos);
	}
	,assertFloatEquals: function(expected,value,approx,msg,pos) {
		stx.test.Assert.floatEquals(expected,value,approx,msg,pos);
	}
	,assertMatches: function(pattern,value,msg,pos) {
		stx.test.Assert.matches(pattern,value,msg,pos);
	}
	,assertEquals: function(expected,value,equal,msg,pos) {
		if(equal != null) stx.test.Assert.isTrue(equal(expected,value),msg != null?msg:"expected " + Std.string(expected) + " but found " + Std.string(value),pos); else stx.test.Assert.equals(expected,value,null,msg,pos);
	}
	,assertNotEquals: function(expected,value,msg,pos) {
		stx.test.Assert.notEquals(expected,value,msg,pos);
	}
	,assertIs: function(value,type,msg,pos) {
		stx.test.Assert["is"](value,type,msg,pos);
	}
	,assertNotNull: function(value,msg,pos) {
		stx.test.Assert.notNull(value,msg,pos);
	}
	,assertNull: function(value,msg,pos) {
		stx.test.Assert.isNull(value,msg,pos);
	}
	,assertFalse: function(value,msg,pos) {
		stx.test.Assert.isFalse(value,msg,pos);
	}
	,assertTrue: function(cond,msg,pos) {
		stx.test.Assert.isTrue(cond,msg,pos);
	}
	,assertThat: function(obj,cond,msg,pos) {
		stx.test.Assert.that(obj,cond,msg,pos);
	}
	,not: function(c) {
		return stx.test.MustMatcherExtensions.negate(c);
	}
	,afterAll: function() {
	}
	,beforeAll: function() {
	}
	,after: function() {
	}
	,before: function() {
	}
	,__class__: stx.test.TestCase
}
stx.test.TestFixture = $hxClasses["stx.test.TestFixture"] = function(target,methodName,method,setup,teardown) {
	this.target = target;
	this.methodName = methodName;
	this.method = method;
	this.setup = setup;
	this.teardown = teardown;
	this.onTested = new stx.test.Dispatcher();
	this.onTimeout = new stx.test.Dispatcher();
	this.onComplete = new stx.test.Dispatcher();
};
stx.test.TestFixture.__name__ = ["stx","test","TestFixture"];
stx.test.TestFixture.prototype = {
	checkMethod: function(name,arg) {
		var field = Reflect.field(this.target,name);
		if(field == null) throw arg + " function " + name + " is not a field of target";
		if(!Reflect.isFunction(field)) throw arg + " function " + name + " is not a function";
	}
	,onComplete: null
	,onTimeout: null
	,onTested: null
	,teardown: null
	,setup: null
	,method: null
	,methodName: null
	,target: null
	,__class__: stx.test.TestFixture
}
stx.test.TestHandler = $hxClasses["stx.test.TestHandler"] = function(fixture) {
	if(fixture == null) throw "fixture argument is null";
	this.fixture = fixture;
	this.results = new List();
	this.asyncStack = new List();
	this.onTested = fixture.onTested;
	this.onTimeout = fixture.onTimeout;
	this.onComplete = fixture.onComplete;
};
stx.test.TestHandler.__name__ = ["stx","test","TestHandler"];
stx.test.TestHandler.exceptionStack = function(pops) {
	if(pops == null) pops = 2;
	var stack = haxe.Stack.exceptionStack();
	while(pops-- > 0) stack.pop();
	return stack;
}
stx.test.TestHandler.prototype = {
	completed: function() {
		try {
			this.executeMethodByName(this.fixture.teardown);
		} catch( e ) {
			this.results.add(stx.test.Assertation.TeardownError(e,stx.test.TestHandler.exceptionStack(2)));
		}
		this.unbindHandler();
		this.onComplete.dispatch(this);
	}
	,timeout: function() {
		this.results.add(stx.test.Assertation.TimeoutError(this.asyncStack.length,[]));
		this.onTimeout.dispatch(this);
		this.completed();
	}
	,tested: function() {
		if(this.results.length == 0) this.results.add(stx.test.Assertation.Warning("no assertions"));
		this.onTested.dispatch(this);
		this.completed();
	}
	,executeMethod: function(f) {
		if(f != null) {
			this.bindHandler();
			f();
		}
	}
	,executeMethodByName: function(name) {
		if(name == null) return;
		var method = Reflect.field(this.fixture.target,name);
		if(method != null) {
			this.bindHandler();
			method.apply(this.fixture.target,[]);
		}
	}
	,addEvent: function(f,timeout) {
		if(timeout == null) timeout = 250;
		this.asyncStack.add(f);
		var handler = this;
		this.setTimeout(timeout);
		return function(e) {
			if(!handler.asyncStack.remove(f)) {
				handler.results.add(stx.test.Assertation.AsyncError("event already executed",[]));
				return;
			}
			try {
				handler.bindHandler();
				f(e);
			} catch( e1 ) {
				handler.results.add(stx.test.Assertation.AsyncError(e1,stx.test.TestHandler.exceptionStack(0)));
			}
		};
	}
	,addAsync: function(f,timeout) {
		if(timeout == null) timeout = 250;
		this.asyncStack.add(f);
		var handler = this;
		this.setTimeout(timeout);
		return function() {
			if(!handler.asyncStack.remove(f)) {
				handler.results.add(stx.test.Assertation.AsyncError("method already executed",[]));
				return;
			}
			try {
				handler.bindHandler();
				f();
			} catch( e ) {
				handler.results.add(stx.test.Assertation.AsyncError(e,stx.test.TestHandler.exceptionStack(0)));
			}
		};
	}
	,unbindHandler: function() {
		stx.test.Assert.results = null;
		stx.test.Assert.createAsync = function(f,t) {
			return function() {
			};
		};
		stx.test.Assert.createEvent = function(f,t) {
			return function(e) {
			};
		};
	}
	,bindHandler: function() {
		stx.test.Assert.results = this.results;
		stx.test.Assert.createAsync = $bind(this,this.addAsync);
		stx.test.Assert.createEvent = $bind(this,this.addEvent);
	}
	,setTimeout: function(timeout) {
		var newexpire = haxe.Timer.stamp() + timeout / 1000;
		this.expireson = this.expireson == null?newexpire:newexpire > this.expireson?newexpire:this.expireson;
	}
	,expireson: null
	,checkTested: function() {
		if(this.expireson == null || this.asyncStack.length == 0) this.tested(); else if(haxe.Timer.stamp() > this.expireson) this.timeout(); else haxe.Timer.delay($bind(this,this.checkTested),10);
	}
	,execute: function() {
		try {
			this.executeMethodByName(this.fixture.setup);
			try {
				this.executeMethod(this.fixture.method);
			} catch( e ) {
				this.results.add(stx.test.Assertation.Error(e,stx.test.TestHandler.exceptionStack()));
			}
		} catch( e ) {
			this.results.add(stx.test.Assertation.SetupError(e,stx.test.TestHandler.exceptionStack()));
		}
		this.checkTested();
	}
	,onComplete: null
	,onTimeout: null
	,onTested: null
	,asyncStack: null
	,fixture: null
	,results: null
	,__class__: stx.test.TestHandler
}
stx.test.TestResult = $hxClasses["stx.test.TestResult"] = function() {
};
stx.test.TestResult.__name__ = ["stx","test","TestResult"];
stx.test.TestResult.ofHandler = function(handler) {
	var r = new stx.test.TestResult();
	var path = Type.getClassName(Type.getClass(handler.fixture.target)).split(".");
	r.cls = path.pop();
	r.pack = path.join(".");
	r.method = handler.fixture.methodName;
	r.setup = handler.fixture.setup;
	r.teardown = handler.fixture.teardown;
	r.assertations = handler.results;
	return r;
}
stx.test.TestResult.prototype = {
	assertations: null
	,teardown: null
	,setup: null
	,method: null
	,cls: null
	,pack: null
	,__class__: stx.test.TestResult
}
if(!stx.test.mock) stx.test.mock = {}
stx.test.mock.Mock = $hxClasses["stx.test.mock.Mock"] = function(c) {
	this._expects = stx.ds.Map.create();
	this._target = Type.createEmptyInstance(c);
};
stx.test.mock.Mock.__name__ = ["stx","test","mock","Mock"];
stx.test.mock.Mock.internal_create = function(c) {
	return new stx.test.mock.Mock(c);
}
stx.test.mock.Mock.prototype = {
	internal_remove: function(name) {
		var array = this._expects.getOrElseC(name,[]);
		array.shift();
		if(array.length > 0) this[name] = array[0];
	}
	,internal_add: function(name,f) {
		var a = this._expects.getOrElseC(name,[]);
		if(a == []) this._expects.set(name,a);
		a.push(f);
		this[name] = f;
	}
	,getTarget: function() {
		return this._target;
	}
	,verifyAllExpectations: function() {
		var $it0 = $iterator(this._expects.keys())();
		while( $it0.hasNext() ) {
			var key = $it0.next();
			var array = this._expects.getOrElseC(key,[]);
			if(array.length > 0) throw "Expected function " + key + " to be invoked " + array.length + " more time" + (array.length == 1?"":"s");
		}
	}
	,allow5: function(name,f) {
		this._target[name] = f;
	}
	,allow4: function(name,f) {
		this._target[name] = f;
	}
	,allow3: function(name,f) {
		this._target[name] = f;
	}
	,allow2: function(name,f) {
		this._target[name] = f;
	}
	,allow1: function(name,f) {
		this._target[name] = f;
	}
	,expect5: function(name,f,times) {
		if(times == null) times = 1;
		var self = this;
		var _g = 0;
		while(_g < times) {
			var i = _g++;
			this.internal_add(name,function(p1,p2,p3,p4,p5) {
				self.internal_remove(name);
				return f(p1,p2,p3,p4,p5);
			});
		}
	}
	,expect4: function(name,f,times) {
		if(times == null) times = 1;
		var self = this;
		var _g = 0;
		while(_g < times) {
			var i = _g++;
			this.internal_add(name,function(p1,p2,p3,p4) {
				self.internal_remove(name);
				return f(p1,p2,p3,p4);
			});
		}
	}
	,expect3: function(name,f,times) {
		if(times == null) times = 1;
		var self = this;
		var _g = 0;
		while(_g < times) {
			var i = _g++;
			this.internal_add(name,function(p1,p2,p3) {
				self.internal_remove(name);
				return f(p1,p2,p3);
			});
		}
	}
	,expect2: function(name,f,times) {
		if(times == null) times = 1;
		var self = this;
		var _g = 0;
		while(_g < times) {
			var i = _g++;
			this.internal_add(name,function(p1,p2) {
				self.internal_remove(name);
				return f(p1,p2);
			});
		}
	}
	,expect1: function(name,f,times) {
		if(times == null) times = 1;
		var self = this;
		var _g = 0;
		while(_g < times) {
			var i = _g++;
			this.internal_add(name,function(p) {
				self.internal_remove(name);
				return f(p);
			});
		}
	}
	,target: null
	,_target: null
	,_expects: null
	,__class__: stx.test.mock.Mock
	,__properties__: {get_target:"getTarget"}
}
stx.test.mock.MockTestCase = $hxClasses["stx.test.mock.MockTestCase"] = function() {
	stx.test.TestCase.call(this);
	this._runningTest = false;
};
stx.test.mock.MockTestCase.__name__ = ["stx","test","mock","MockTestCase"];
stx.test.mock.MockTestCase.__super__ = stx.test.TestCase;
stx.test.mock.MockTestCase.prototype = $extend(stx.test.TestCase.prototype,{
	afterAll: function() {
		var _g = 0, _g1 = this._globalMocks;
		while(_g < _g1.length) {
			var mock = _g1[_g];
			++_g;
			mock.verifyAllExpectations();
		}
		this._globalMocks = [];
	}
	,after: function() {
		try {
			var _g = 0, _g1 = this._localMocks;
			while(_g < _g1.length) {
				var mock = _g1[_g];
				++_g;
				mock.verifyAllExpectations();
			}
			this._localMocks = [];
			this._runningTest = false;
		} catch( e ) {
			this._runningTest = false;
			throw e;
		}
	}
	,newMock: function(c) {
		var mock = stx.test.mock.Mock.internal_create(c);
		if(this._runningTest) this._localMocks.push(mock); else this._globalMocks.push(mock);
		return mock;
	}
	,before: function() {
		this._localMocks = [];
		this._runningTest = true;
	}
	,_runningTest: null
	,_globalMocks: null
	,_localMocks: null
	,__class__: stx.test.mock.MockTestCase
});
if(!stx.test.resources) stx.test.resources = {}
stx.test.resources.CollectionTester = $hxClasses["stx.test.resources.CollectionTester"] = function() {
	stx.test.TestCase.call(this);
};
stx.test.resources.CollectionTester.__name__ = ["stx","test","resources","CollectionTester"];
stx.test.resources.CollectionTester.__super__ = stx.test.TestCase;
stx.test.resources.CollectionTester.prototype = $extend(stx.test.TestCase.prototype,{
	testThatItXScanr1Works: function() {
		var a = [6,5,4,3,2];
		this.assertEquals("[2,5,6,7,8]",Std.string(stx.Iterables.scanr1(a,function(a1,b) {
			return a1 + b;
		})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 133, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanr1Works"});
	}
	,testThatItXScanrWorks: function() {
		var a = [6,5,4,3,2];
		this.assertEquals("[1,3,4,5,6,7]",Std.string(stx.Iterables.scanr(a,1,function(a1,b) {
			return a1 + b;
		})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 127, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanrWorks"});
	}
	,testThatItXScanl1Works: function() {
		var a = [6,5,4,3,2];
		this.assertEquals("[6,11,10,9,8]",Std.string(stx.Iterables.scanl1(a,function(a1,b) {
			return a1 + b;
		})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 121, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanl1Works"});
	}
	,testThatItXScanlWorks: function() {
		var a = [6,5,4,3,2];
		this.assertEquals("[1,7,6,5,4,3]",Std.string(stx.Iterables.scanl(a,1,function(a1,b) {
			return a1 + b;
		})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 115, className : "stx.test.resources.CollectionTester", methodName : "testThatItXScanlWorks"});
	}
	,testThatItXMapWorks: function() {
		var a = [6,5,4,3,2];
		this.assertEquals("[12,10,8,6,4]",Std.string(IterableLambda.map(a,function(a1) {
			return a1 * 2;
		})),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 109, className : "stx.test.resources.CollectionTester", methodName : "testThatItXMapWorks"});
	}
	,testThatItXAtWorks: function() {
		var a = [1,2,3,4,5,4,3,2,1,5,6,7,8,6,5,4,3,2];
		this.assertEquals(6,stx.Iterables.at(a,10),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 101, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAtWorks"});
		this.assertEquals(5,stx.Iterables.at(a,-4),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 103, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAtWorks"});
	}
	,testThatItXNubWorks: function() {
		var a = [1,2,3,4,5,4,3,2,1,5,6,7,8,6,5,4,3,2];
		this.assertEquals(8,IterableLambda.size(stx.Iterables.nub(a)),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 95, className : "stx.test.resources.CollectionTester", methodName : "testThatItXNubWorks"});
	}
	,testThatItXExistsWorks: function() {
		var i = [1,2,3,4,5];
		this.assertTrue(stx.Iterables.contains(i,2,function(a,b) {
			return a == b;
		}),null,{ fileName : "BCollectionTester.hx", lineNumber : 87, className : "stx.test.resources.CollectionTester", methodName : "testThatItXExistsWorks"});
		this.assertFalse(stx.Iterables.contains(i,1,function(a,b) {
			return a < b;
		}),null,{ fileName : "BCollectionTester.hx", lineNumber : 89, className : "stx.test.resources.CollectionTester", methodName : "testThatItXExistsWorks"});
	}
	,testThatItXDropWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals("[4,5]",Std.string(stx.Iterables.drop(i,3)),null,null,{ fileName : "BCollectionTester.hx", lineNumber : 77, className : "stx.test.resources.CollectionTester", methodName : "testThatItXDropWorks"});
		var i1 = [1];
		this.assertEquals(Std.string(stx.Iterables.drop(i1,3)),"[]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 81, className : "stx.test.resources.CollectionTester", methodName : "testThatItXDropWorks"});
	}
	,testThatItXTakeWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals(Std.string(stx.Iterables.take(i,3)),"[1,2,3]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 63, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
		var i1 = [1];
		this.assertEquals(Std.string(stx.Iterables.take(i1,3)),"[1]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 67, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
		var i2 = [];
		this.assertEquals(Std.string(stx.Iterables.take(i2,3)),"[]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 71, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTakeWorks"});
	}
	,testThatItXTailWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals(Std.string(stx.Iterables.tail(i)),"[2,3,4,5]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 57, className : "stx.test.resources.CollectionTester", methodName : "testThatItXTailWorks"});
	}
	,testThatItXAppendWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals(Std.string(stx.Iterables.add(i,2)),"[1,2,3,4,5,2]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 51, className : "stx.test.resources.CollectionTester", methodName : "testThatItXAppendWorks"});
	}
	,testThatItXHeadWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals(stx.Iterables.head(i),1,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 45, className : "stx.test.resources.CollectionTester", methodName : "testThatItXHeadWorks"});
	}
	,testThatItXReversedWorks: function() {
		var i = [1,2,3,4,5];
		this.assertEquals(Std.string(stx.Iterables.reversed(i)),"[5,4,3,2,1]",null,null,{ fileName : "BCollectionTester.hx", lineNumber : 39, className : "stx.test.resources.CollectionTester", methodName : "testThatItXReversedWorks"});
	}
	,testThatItXFoldrWorks: function() {
		var i = [1,2,3,4,5];
		var result = stx.Iterables.foldr(i,0,function(a,b) {
			return a + b;
		});
		this.assertEquals(result,15,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 33, className : "stx.test.resources.CollectionTester", methodName : "testThatItXFoldrWorks"});
	}
	,testThatItXFoldlWorks: function() {
		var i = [1,2,3,4,5];
		var result = IterableLambda.foldl(i,0,function(a,b) {
			return a + b;
		});
		this.assertEquals(result,15,null,null,{ fileName : "BCollectionTester.hx", lineNumber : 25, className : "stx.test.resources.CollectionTester", methodName : "testThatItXFoldlWorks"});
	}
	,testThatTraceWorks: function() {
		haxe.Log.trace("Trace is working",{ fileName : "BCollectionTester.hx", lineNumber : 16, className : "stx.test.resources.CollectionTester", methodName : "testThatTraceWorks"});
		this.assertTrue(true,null,{ fileName : "BCollectionTester.hx", lineNumber : 17, className : "stx.test.resources.CollectionTester", methodName : "testThatTraceWorks"});
	}
	,__class__: stx.test.resources.CollectionTester
});
stx.test.resources.BCollectionTester = $hxClasses["stx.test.resources.BCollectionTester"] = function() { }
stx.test.resources.BCollectionTester.__name__ = ["stx","test","resources","BCollectionTester"];
stx.test.resources.BCollectionTester.main = function() {
	var tr = new stx.test.Runner();
	var tester1 = new stx.test.resources.CollectionTester();
	tr.add(tester1);
	tr.run();
}
if(!stx.test.ui) stx.test.ui = {}
stx.test.ui.Report = $hxClasses["stx.test.ui.Report"] = function() { }
stx.test.ui.Report.__name__ = ["stx","test","ui","Report"];
stx.test.ui.Report.create = function(runner,displaySuccessResults,headerDisplayMode) {
	var report;
	report = new stx.test.ui.text.HtmlReport(runner,null,true);
	if(null == displaySuccessResults) report.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.ShowSuccessResultsWithNoErrors; else report.displaySuccessResults = displaySuccessResults;
	if(null == headerDisplayMode) report.displayHeader = stx.test.ui.common.HeaderDisplayMode.ShowHeaderWithResults; else report.displayHeader = headerDisplayMode;
	return report;
}
if(!stx.test.ui.common) stx.test.ui.common = {}
stx.test.ui.common.ClassResult = $hxClasses["stx.test.ui.common.ClassResult"] = function(className,setupName,teardownName) {
	this.fixtures = new Map();
	this.className = className;
	this.setupName = setupName;
	this.hasSetup = setupName != null;
	this.teardownName = teardownName;
	this.hasTeardown = teardownName != null;
	this.methods = 0;
	this.stats = new stx.test.ui.common.ResultStats();
};
stx.test.ui.common.ClassResult.__name__ = ["stx","test","ui","common","ClassResult"];
stx.test.ui.common.ClassResult.prototype = {
	methodNames: function(errorsHavePriority) {
		if(errorsHavePriority == null) errorsHavePriority = true;
		var names = [];
		var $it0 = this.fixtures.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			names.push(name);
		}
		if(errorsHavePriority) {
			var me = this;
			names.sort(function(a,b) {
				var $as = me.get(a).stats;
				var bs = me.get(b).stats;
				if($as.hasErrors) return !bs.hasErrors?-1:$as.errors == bs.errors?Reflect.compare(a,b):Reflect.compare($as.errors,bs.errors); else if(bs.hasErrors) return 1; else if($as.hasFailures) return !bs.hasFailures?-1:$as.failures == bs.failures?Reflect.compare(a,b):Reflect.compare($as.failures,bs.failures); else if(bs.hasFailures) return 1; else if($as.hasWarnings) return !bs.hasWarnings?-1:$as.warnings == bs.warnings?Reflect.compare(a,b):Reflect.compare($as.warnings,bs.warnings); else if(bs.hasWarnings) return 1; else return Reflect.compare(a,b);
			});
		} else names.sort(function(a,b) {
			return Reflect.compare(a,b);
		});
		return names;
	}
	,exists: function(method) {
		return this.fixtures.exists(method);
	}
	,get: function(method) {
		return this.fixtures.get(method);
	}
	,add: function(result) {
		if(this.fixtures.exists(result.methodName)) throw "invalid duplicated fixture result";
		this.stats.wire(result.stats);
		this.methods++;
		this.fixtures.set(result.methodName,result);
	}
	,stats: null
	,methods: null
	,hasTeardown: null
	,hasSetup: null
	,teardownName: null
	,setupName: null
	,className: null
	,fixtures: null
	,__class__: stx.test.ui.common.ClassResult
}
stx.test.ui.common.FixtureResult = $hxClasses["stx.test.ui.common.FixtureResult"] = function(methodName) {
	this.methodName = methodName;
	this.list = new List();
	this.hasTestError = false;
	this.hasSetupError = false;
	this.hasTeardownError = false;
	this.hasTimeoutError = false;
	this.hasAsyncError = false;
	this.stats = new stx.test.ui.common.ResultStats();
};
stx.test.ui.common.FixtureResult.__name__ = ["stx","test","ui","common","FixtureResult"];
stx.test.ui.common.FixtureResult.prototype = {
	add: function(assertation) {
		this.list.add(assertation);
		switch( (assertation)[1] ) {
		case 0:
			this.stats.addSuccesses(1);
			break;
		case 1:
			this.stats.addFailures(1);
			break;
		case 2:
			this.stats.addErrors(1);
			break;
		case 3:
			this.stats.addErrors(1);
			this.hasSetupError = true;
			break;
		case 4:
			this.stats.addErrors(1);
			this.hasTeardownError = true;
			break;
		case 5:
			this.stats.addErrors(1);
			this.hasTimeoutError = true;
			break;
		case 6:
			this.stats.addErrors(1);
			this.hasAsyncError = true;
			break;
		case 7:
			this.stats.addWarnings(1);
			break;
		}
	}
	,iterator: function() {
		return this.list.iterator();
	}
	,list: null
	,stats: null
	,hasAsyncError: null
	,hasTimeoutError: null
	,hasTeardownError: null
	,hasSetupError: null
	,hasTestError: null
	,methodName: null
	,__class__: stx.test.ui.common.FixtureResult
}
stx.test.ui.common.HeaderDisplayMode = $hxClasses["stx.test.ui.common.HeaderDisplayMode"] = { __ename__ : ["stx","test","ui","common","HeaderDisplayMode"], __constructs__ : ["AlwaysShowHeader","NeverShowHeader","ShowHeaderWithResults"] }
stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader = ["AlwaysShowHeader",0];
stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader.toString = $estr;
stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader.__enum__ = stx.test.ui.common.HeaderDisplayMode;
stx.test.ui.common.HeaderDisplayMode.NeverShowHeader = ["NeverShowHeader",1];
stx.test.ui.common.HeaderDisplayMode.NeverShowHeader.toString = $estr;
stx.test.ui.common.HeaderDisplayMode.NeverShowHeader.__enum__ = stx.test.ui.common.HeaderDisplayMode;
stx.test.ui.common.HeaderDisplayMode.ShowHeaderWithResults = ["ShowHeaderWithResults",2];
stx.test.ui.common.HeaderDisplayMode.ShowHeaderWithResults.toString = $estr;
stx.test.ui.common.HeaderDisplayMode.ShowHeaderWithResults.__enum__ = stx.test.ui.common.HeaderDisplayMode;
stx.test.ui.common.SuccessResultsDisplayMode = $hxClasses["stx.test.ui.common.SuccessResultsDisplayMode"] = { __ename__ : ["stx","test","ui","common","SuccessResultsDisplayMode"], __constructs__ : ["AlwaysShowSuccessResults","NeverShowSuccessResults","ShowSuccessResultsWithNoErrors"] }
stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults = ["AlwaysShowSuccessResults",0];
stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults.toString = $estr;
stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults.__enum__ = stx.test.ui.common.SuccessResultsDisplayMode;
stx.test.ui.common.SuccessResultsDisplayMode.NeverShowSuccessResults = ["NeverShowSuccessResults",1];
stx.test.ui.common.SuccessResultsDisplayMode.NeverShowSuccessResults.toString = $estr;
stx.test.ui.common.SuccessResultsDisplayMode.NeverShowSuccessResults.__enum__ = stx.test.ui.common.SuccessResultsDisplayMode;
stx.test.ui.common.SuccessResultsDisplayMode.ShowSuccessResultsWithNoErrors = ["ShowSuccessResultsWithNoErrors",2];
stx.test.ui.common.SuccessResultsDisplayMode.ShowSuccessResultsWithNoErrors.toString = $estr;
stx.test.ui.common.SuccessResultsDisplayMode.ShowSuccessResultsWithNoErrors.__enum__ = stx.test.ui.common.SuccessResultsDisplayMode;
stx.test.ui.common.IReport = $hxClasses["stx.test.ui.common.IReport"] = function() { }
stx.test.ui.common.IReport.__name__ = ["stx","test","ui","common","IReport"];
stx.test.ui.common.IReport.prototype = {
	setHandler: null
	,displayHeader: null
	,displaySuccessResults: null
	,__class__: stx.test.ui.common.IReport
}
stx.test.ui.common.PackageResult = $hxClasses["stx.test.ui.common.PackageResult"] = function(packageName) {
	this.packageName = packageName;
	this.classes = new Map();
	this.packages = new Map();
	this.stats = new stx.test.ui.common.ResultStats();
};
stx.test.ui.common.PackageResult.__name__ = ["stx","test","ui","common","PackageResult"];
stx.test.ui.common.PackageResult.prototype = {
	getOrCreatePackage: function(pack,flat,ref) {
		if(pack == null || pack == "") return ref;
		if(flat) {
			if(ref.existsPackage(pack)) return ref.getPackage(pack);
			var p = new stx.test.ui.common.PackageResult(pack);
			ref.addPackage(p);
			return p;
		} else {
			var parts = pack.split(".");
			var _g = 0;
			while(_g < parts.length) {
				var part = parts[_g];
				++_g;
				ref = this.getOrCreatePackage(part,true,ref);
			}
			return ref;
		}
	}
	,getOrCreateClass: function(pack,cls,setup,teardown) {
		if(pack.existsClass(cls)) return pack.getClass(cls);
		var c = new stx.test.ui.common.ClassResult(cls,setup,teardown);
		pack.addClass(c);
		return c;
	}
	,createFixture: function(method,assertations) {
		var f = new stx.test.ui.common.FixtureResult(method);
		var $it0 = $iterator(assertations)();
		while( $it0.hasNext() ) {
			var assertation = $it0.next();
			f.add(assertation);
		}
		return f;
	}
	,packageNames: function(errorsHavePriority) {
		if(errorsHavePriority == null) errorsHavePriority = true;
		var names = [];
		if(this.packageName == null) names.push("");
		var $it0 = this.packages.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			names.push(name);
		}
		if(errorsHavePriority) {
			var me = this;
			names.sort(function(a,b) {
				var $as = me.getPackage(a).stats;
				var bs = me.getPackage(b).stats;
				if($as.hasErrors) return !bs.hasErrors?-1:$as.errors == bs.errors?Reflect.compare(a,b):Reflect.compare($as.errors,bs.errors); else if(bs.hasErrors) return 1; else if($as.hasFailures) return !bs.hasFailures?-1:$as.failures == bs.failures?Reflect.compare(a,b):Reflect.compare($as.failures,bs.failures); else if(bs.hasFailures) return 1; else if($as.hasWarnings) return !bs.hasWarnings?-1:$as.warnings == bs.warnings?Reflect.compare(a,b):Reflect.compare($as.warnings,bs.warnings); else if(bs.hasWarnings) return 1; else return Reflect.compare(a,b);
			});
		} else names.sort(function(a,b) {
			return Reflect.compare(a,b);
		});
		return names;
	}
	,classNames: function(errorsHavePriority) {
		if(errorsHavePriority == null) errorsHavePriority = true;
		var names = [];
		var $it0 = this.classes.keys();
		while( $it0.hasNext() ) {
			var name = $it0.next();
			names.push(name);
		}
		if(errorsHavePriority) {
			var me = this;
			names.sort(function(a,b) {
				var $as = me.getClass(a).stats;
				var bs = me.getClass(b).stats;
				if($as.hasErrors) return !bs.hasErrors?-1:$as.errors == bs.errors?Reflect.compare(a,b):Reflect.compare($as.errors,bs.errors); else if(bs.hasErrors) return 1; else if($as.hasFailures) return !bs.hasFailures?-1:$as.failures == bs.failures?Reflect.compare(a,b):Reflect.compare($as.failures,bs.failures); else if(bs.hasFailures) return 1; else if($as.hasWarnings) return !bs.hasWarnings?-1:$as.warnings == bs.warnings?Reflect.compare(a,b):Reflect.compare($as.warnings,bs.warnings); else if(bs.hasWarnings) return 1; else return Reflect.compare(a,b);
			});
		} else names.sort(function(a,b) {
			return Reflect.compare(a,b);
		});
		return names;
	}
	,getClass: function(name) {
		return this.classes.get(name);
	}
	,getPackage: function(name) {
		if(this.packageName == null && name == "") return this;
		return this.packages.get(name);
	}
	,existsClass: function(name) {
		return this.classes.exists(name);
	}
	,existsPackage: function(name) {
		return this.packages.exists(name);
	}
	,addPackage: function(result) {
		this.packages.set(result.packageName,result);
		this.stats.wire(result.stats);
	}
	,addClass: function(result) {
		this.classes.set(result.className,result);
		this.stats.wire(result.stats);
	}
	,addResult: function(result,flattenPackage) {
		var pack = this.getOrCreatePackage(result.pack,flattenPackage,this);
		var cls = this.getOrCreateClass(pack,result.cls,result.setup,result.teardown);
		var fix = this.createFixture(result.method,result.assertations);
		cls.add(fix);
	}
	,stats: null
	,packages: null
	,classes: null
	,packageName: null
	,__class__: stx.test.ui.common.PackageResult
}
stx.test.ui.common.ReportTools = $hxClasses["stx.test.ui.common.ReportTools"] = function() { }
stx.test.ui.common.ReportTools.__name__ = ["stx","test","ui","common","ReportTools"];
stx.test.ui.common.ReportTools.hasHeader = function(report,stats) {
	switch( (report.displayHeader)[1] ) {
	case 1:
		return false;
	case 2:
		if(!stats.isOk) return true;
		switch( (report.displaySuccessResults)[1] ) {
		case 1:
			return false;
		case 0:
		case 2:
			return true;
		}
		break;
	case 0:
		return true;
	}
}
stx.test.ui.common.ReportTools.skipResult = function(report,stats,isOk) {
	if(!stats.isOk) return false;
	return (function($this) {
		var $r;
		switch( (report.displaySuccessResults)[1] ) {
		case 1:
			$r = true;
			break;
		case 0:
			$r = false;
			break;
		case 2:
			$r = !isOk;
			break;
		}
		return $r;
	}(this));
}
stx.test.ui.common.ReportTools.hasOutput = function(report,stats) {
	if(!stats.isOk) return true;
	return stx.test.ui.common.ReportTools.hasHeader(report,stats);
}
stx.test.ui.common.ResultAggregator = $hxClasses["stx.test.ui.common.ResultAggregator"] = function(runner,flattenPackage) {
	if(flattenPackage == null) flattenPackage = false;
	if(runner == null) throw "runner argument is null";
	this.flattenPackage = flattenPackage;
	this.runner = runner;
	runner.onStart.add($bind(this,this.start));
	runner.onProgress.add($bind(this,this.progress));
	runner.onComplete.add($bind(this,this.complete));
	this.onStart = new stx.test.Notifier();
	this.onComplete = new stx.test.Dispatcher();
	this.onProgress = new stx.test.Dispatcher();
};
stx.test.ui.common.ResultAggregator.__name__ = ["stx","test","ui","common","ResultAggregator"];
stx.test.ui.common.ResultAggregator.prototype = {
	complete: function(runner) {
		this.onComplete.dispatch(this.root);
	}
	,progress: function(e) {
		this.root.addResult(e.result,this.flattenPackage);
		this.onProgress.dispatch(e);
	}
	,createFixture: function(result) {
		var f = new stx.test.ui.common.FixtureResult(result.method);
		var $it0 = result.assertations.iterator();
		while( $it0.hasNext() ) {
			var assertation = $it0.next();
			f.add(assertation);
		}
		return f;
	}
	,getOrCreateClass: function(pack,cls,setup,teardown) {
		if(pack.existsClass(cls)) return pack.getClass(cls);
		var c = new stx.test.ui.common.ClassResult(cls,setup,teardown);
		pack.addClass(c);
		return c;
	}
	,getOrCreatePackage: function(pack,flat,ref) {
		if(ref == null) ref = this.root;
		if(pack == null || pack == "") return ref;
		if(flat) {
			if(ref.existsPackage(pack)) return ref.getPackage(pack);
			var p = new stx.test.ui.common.PackageResult(pack);
			ref.addPackage(p);
			return p;
		} else {
			var parts = pack.split(".");
			var _g = 0;
			while(_g < parts.length) {
				var part = parts[_g];
				++_g;
				ref = this.getOrCreatePackage(part,true,ref);
			}
			return ref;
		}
	}
	,start: function(runner) {
		this.root = new stx.test.ui.common.PackageResult(null);
		this.onStart.dispatch();
	}
	,onProgress: null
	,onComplete: null
	,onStart: null
	,root: null
	,flattenPackage: null
	,runner: null
	,__class__: stx.test.ui.common.ResultAggregator
}
stx.test.ui.common.ResultStats = $hxClasses["stx.test.ui.common.ResultStats"] = function() {
	this.assertations = 0;
	this.successes = 0;
	this.failures = 0;
	this.errors = 0;
	this.warnings = 0;
	this.isOk = true;
	this.hasFailures = false;
	this.hasErrors = false;
	this.hasWarnings = false;
	this.onAddSuccesses = new stx.test.Dispatcher();
	this.onAddFailures = new stx.test.Dispatcher();
	this.onAddErrors = new stx.test.Dispatcher();
	this.onAddWarnings = new stx.test.Dispatcher();
};
stx.test.ui.common.ResultStats.__name__ = ["stx","test","ui","common","ResultStats"];
stx.test.ui.common.ResultStats.prototype = {
	unwire: function(dependant) {
		dependant.onAddSuccesses.remove($bind(this,this.addSuccesses));
		dependant.onAddFailures.remove($bind(this,this.addFailures));
		dependant.onAddErrors.remove($bind(this,this.addErrors));
		dependant.onAddWarnings.remove($bind(this,this.addWarnings));
		this.subtract(dependant);
	}
	,wire: function(dependant) {
		dependant.onAddSuccesses.add($bind(this,this.addSuccesses));
		dependant.onAddFailures.add($bind(this,this.addFailures));
		dependant.onAddErrors.add($bind(this,this.addErrors));
		dependant.onAddWarnings.add($bind(this,this.addWarnings));
		this.sum(dependant);
	}
	,subtract: function(other) {
		this.addSuccesses(-other.successes);
		this.addFailures(-other.failures);
		this.addErrors(-other.errors);
		this.addWarnings(-other.warnings);
	}
	,sum: function(other) {
		this.addSuccesses(other.successes);
		this.addFailures(other.failures);
		this.addErrors(other.errors);
		this.addWarnings(other.warnings);
	}
	,addWarnings: function(v) {
		if(v == 0) return;
		this.assertations += v;
		this.warnings += v;
		this.hasWarnings = this.warnings > 0;
		this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
		this.onAddWarnings.dispatch(v);
	}
	,addErrors: function(v) {
		if(v == 0) return;
		this.assertations += v;
		this.errors += v;
		this.hasErrors = this.errors > 0;
		this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
		this.onAddErrors.dispatch(v);
	}
	,addFailures: function(v) {
		if(v == 0) return;
		this.assertations += v;
		this.failures += v;
		this.hasFailures = this.failures > 0;
		this.isOk = !(this.hasFailures || this.hasErrors || this.hasWarnings);
		this.onAddFailures.dispatch(v);
	}
	,addSuccesses: function(v) {
		if(v == 0) return;
		this.assertations += v;
		this.successes += v;
		this.onAddSuccesses.dispatch(v);
	}
	,hasWarnings: null
	,hasErrors: null
	,hasFailures: null
	,isOk: null
	,onAddWarnings: null
	,onAddErrors: null
	,onAddFailures: null
	,onAddSuccesses: null
	,warnings: null
	,errors: null
	,failures: null
	,successes: null
	,assertations: null
	,__class__: stx.test.ui.common.ResultStats
}
if(!stx.test.ui.text) stx.test.ui.text = {}
stx.test.ui.text.HtmlReport = $hxClasses["stx.test.ui.text.HtmlReport"] = function(runner,outputHandler,traceRedirected) {
	if(traceRedirected == null) traceRedirected = true;
	this.aggregator = new stx.test.ui.common.ResultAggregator(runner,true);
	runner.onStart.add($bind(this,this.start));
	this.aggregator.onComplete.add($bind(this,this.complete));
	if(null == outputHandler) this.setHandler($bind(this,this._handler)); else this.setHandler(outputHandler);
	if(traceRedirected) this.redirectTrace();
	this.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults;
	this.displayHeader = stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader;
};
stx.test.ui.text.HtmlReport.__name__ = ["stx","test","ui","text","HtmlReport"];
stx.test.ui.text.HtmlReport.__interfaces__ = [stx.test.ui.common.IReport];
stx.test.ui.text.HtmlReport.prototype = {
	_handler: function(report) {
		var isDef = function(v) {
			return typeof v != 'undefined';
		};
		var head = js.Lib.document.getElementsByTagName("head")[0];
		var script = js.Lib.document.createElement("script");
		script.type = "text/javascript";
		var sjs = report.jsScript();
		if(isDef(script.text)) script.text = sjs; else script.innerHTML = sjs;
		head.appendChild(script);
		var style = js.Lib.document.createElement("style");
		style.type = "text/css";
		var scss = report.cssStyle();
		if(isDef(style.styleSheet)) style.styleSheet.cssText = scss; else if(isDef(style.cssText)) style.cssText = scss; else if(isDef(style.innerText)) style.innerText = scss; else style.innerHTML = scss;
		head.appendChild(style);
		var el = js.Lib.document.getElementById("utest-results");
		if(null == el) {
			el = js.Lib.document.createElement("div");
			el.id = "utest-results";
			js.Lib.document.body.appendChild(el);
		}
		el.innerHTML = report.getAll();
	}
	,wrapHtml: function(title,s) {
		return "<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" />\n<title>" + title + "</title>\r\n      <style type=\"text/css\">" + this.cssStyle() + "</style>\r\n      <script type=\"text/javascript\">\n" + this.jsScript() + "\n</script>\n</head>\r\n      <body>\n" + s + "\n</body>\n</html>";
	}
	,jsScript: function() {
		return "function utestTooltip(ref, text) {\r\n  var el = document.getElementById(\"utesttip\");\r\n  if(!el) {\r\n    var el = document.createElement(\"div\")\r\n    el.id = \"utesttip\";\r\n    el.style.position = \"absolute\";\r\n    document.body.appendChild(el)\r\n  }\r\n  var p = utestFindPos(ref);\r\n  el.style.left = p[0];\r\n  el.style.top = p[1];\r\n  el.innerHTML =  text;\r\n}\r\n\r\nfunction utestFindPos(el) {\r\n  var left = 0;\r\n  var top = 0;\r\n  do {\r\n    left += el.offsetLeft;\r\n    top += el.offsetTop;\r\n  } while(el = el.offsetParent)\r\n  return [left, top];\r\n}\r\n\r\nfunction utestRemoveTooltip() {\r\n  var el = document.getElementById(\"utesttip\")\r\n  if(el)\r\n    document.body.removeChild(el)\r\n}";
	}
	,cssStyle: function() {
		return "body, dd, dt {\r\n  font-family: Verdana, Arial, Sans-serif;\r\n  font-size: 12px;\r\n}\r\ndl {\r\n  width: 180px;\r\n}\r\ndd, dt {\r\n  margin : 0;\r\n  padding : 2px 5px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n}\r\ndd.value {\r\n  text-align: center;\r\n  background-color: #eeeeee;\r\n}\r\ndt {\r\n  text-align: left;\r\n  background-color: #e6e6e6;\r\n  float: left;\r\n  width: 100px;\r\n}\r\n\r\nh1, h2, h3, h4, h5, h6 {\r\n  margin: 0;\r\n  padding: 0;\r\n}\r\n\r\nh1 {\r\n  text-align: center;\r\n  font-weight: bold;\r\n  padding: 5px 0 4px 0;\r\n  font-family: Arial, Sans-serif;\r\n  font-size: 18px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  margin: 0 2px 0px 2px;\r\n}\r\n\r\nh2 {\r\n  font-weight: bold;\r\n  padding: 2px 0 2px 8px;\r\n  font-family: Arial, Sans-serif;\r\n  font-size: 13px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  margin: 0 0 0px 0;\r\n  background-color: #FFFFFF;\r\n  color: #777777;\r\n}\r\n\r\nh2.classname {\r\n  color: #000000;\r\n}\r\n\r\n.okbg {\r\n  background-color: #66FF55;\r\n}\r\n.errorbg {\r\n  background-color: #CC1100;\r\n}\r\n.failurebg {\r\n  background-color: #EE3322;\r\n}\r\n.warnbg {\r\n  background-color: #FFCC99;\r\n}\r\n.headerinfo {\r\n  text-align: right;\r\n  font-size: 11px;\r\n  font - color: 0xCCCCCC;\r\n  margin: 0 2px 5px 2px;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  padding: 2px;\r\n}\r\n\r\nli {\r\n  padding: 4px;\r\n  margin: 2px;\r\n  border-top: 1px solid #f0f0f0;\r\n  border-left: 1px solid #f0f0f0;\r\n  border-right: 1px solid #CCCCCC;\r\n  border-bottom: 1px solid #CCCCCC;\r\n  background-color: #e6e6e6;\r\n}\r\n\r\nli.fixture {\r\n  background-color: #f6f6f6;\r\n  padding-bottom: 6px;\r\n}\r\n\r\ndiv.fixturedetails {\r\n  padding-left: 108px;\r\n}\r\n\r\nul {\r\n  padding: 0;\r\n  margin: 6px 0 0 0;\r\n  list-style-type: none;\r\n}\r\n\r\nol {\r\n  padding: 0 0 0 28px;\r\n  margin: 0px 0 0 0;\r\n}\r\n\r\n.statnumbers {\r\n  padding: 2px 8px;\r\n}\r\n\r\n.fixtureresult {\r\n  width: 100px;\r\n  text-align: center;\r\n  display: block;\r\n  float: left;\r\n  font-weight: bold;\r\n  padding: 1px;\r\n  margin: 0 0 0 0;\r\n}\r\n\r\n.testoutput {\r\n  border: 1px dashed #CCCCCC;\r\n  margin: 4px 0 0 0;\r\n  padding: 4px 8px;\r\n  background-color: #eeeeee;\r\n}\r\n\r\nspan.tracepos, span.traceposempty {\r\n  display: block;\r\n  float: left;\r\n  font-weight: bold;\r\n  font-size: 9px;\r\n  width: 170px;\r\n  margin: 2px 0 0 2px;\r\n}\r\n\r\nspan.tracepos:hover {\r\n  cursor : pointer;\r\n  background-color: #ffff99;\r\n}\r\n\r\nspan.tracemsg {\r\n  display: block;\r\n  margin-left: 180px;\r\n  background-color: #eeeeee;\r\n  padding: 7px;\r\n}\r\n\r\nspan.tracetime {\r\n  display: block;\r\n  float: right;\r\n  margin: 2px;\r\n  font-size: 9px;\r\n  color: #777777;\r\n}\r\n\r\n\r\ndiv.trace ol {\r\n  padding: 0 0 0 40px;\r\n  color: #777777;\r\n}\r\n\r\ndiv.trace li {\r\n  padding: 0;\r\n}\r\n\r\ndiv.trace li div.li {\r\n  color: #000000;\r\n}\r\n\r\ndiv.trace h2 {\r\n  margin: 0 2px 0px 2px;\r\n  padding-left: 4px;\r\n}\r\n\r\n.tracepackage {\r\n  color: #777777;\r\n  font-weight: normal;\r\n}\r\n\r\n.clr {\r\n  clear: both;\r\n}\r\n\r\n#utesttip {\r\n  margin-top: -3px;\r\n  margin-left: 170px;\r\n  font-size: 9px;\r\n}\r\n\r\n#utesttip li {\r\n  margin: 0;\r\n  background-color: #ffff99;\r\n  padding: 2px 4px;\r\n  border: 0;\r\n  border-bottom: 1px dashed #ffff33;\r\n}";
	}
	,formatTime: function(t) {
		return Math.round(t * 1000) + " ms";
	}
	,complete: function(result) {
		this.result = result;
		this.handler(this);
		this.restoreTrace();
	}
	,result: null
	,getHtml: function(title) {
		if(null == title) title = "utest: " + stx.test.ui.text.HtmlReport.platform;
		var s = this.getAll();
		if("" == s) return ""; else return this.wrapHtml(title,s);
	}
	,getAll: function() {
		if(!stx.test.ui.common.ReportTools.hasOutput(this,this.result.stats)) return ""; else return this.getHeader() + this.getTrace() + this.getResults();
	}
	,getResults: function() {
		var buf = new StringBuf();
		this.addPackages(buf,this.result,this.result.stats.isOk);
		return buf.b;
	}
	,getTrace: function() {
		var buf = new StringBuf();
		if(this._traces == null || this._traces.length == 0) return "";
		buf.b += Std.string("<div class=\"trace\"><h2>traces</h2><ol>");
		var _g = 0, _g1 = this._traces;
		while(_g < _g1.length) {
			var t = _g1[_g];
			++_g;
			buf.b += Std.string("<li><div class=\"li\">");
			var stack = StringTools.replace(this.formatStack(t.stack,false),"'","\\'");
			var method = "<span class=\"tracepackage\">" + t.infos.className + "</span><br/>" + t.infos.methodName + "(" + t.infos.lineNumber + ")";
			buf.b += Std.string("<span class=\"tracepos\" onmouseover=\"utestTooltip(this.parentNode, '" + stack + "')\" onmouseout=\"utestRemoveTooltip()\">");
			buf.b += Std.string(method);
			buf.b += Std.string("</span><span class=\"tracetime\">");
			buf.b += Std.string("@ " + this.formatTime(t.time));
			if(Math.round(t.delta * 1000) > 0) buf.b += Std.string(", ~" + this.formatTime(t.delta));
			buf.b += Std.string("</span><span class=\"tracemsg\">");
			buf.b += Std.string(StringTools.replace(StringTools.trim(t.msg),"\n","<br/>\n"));
			buf.b += Std.string("</span><div class=\"clr\"></div></div></li>");
		}
		buf.b += Std.string("</ol></div>");
		return buf.b;
	}
	,getHeader: function() {
		var buf = new StringBuf();
		if(!stx.test.ui.common.ReportTools.hasHeader(this,this.result.stats)) return "";
		var end = haxe.Timer.stamp();
		var time = ((end - this.startTime) * 1000 | 0) / 1000;
		var msg = "TEST OK";
		if(this.result.stats.hasErrors) msg = "TEST ERRORS"; else if(this.result.stats.hasFailures) msg = "TEST FAILED"; else if(this.result.stats.hasWarnings) msg = "WARNING REPORTED";
		buf.b += Std.string("<h1 class=\"" + this.cls(this.result.stats) + "bg header\">" + msg + "</h1>\n");
		buf.b += Std.string("<div class=\"headerinfo\">");
		this.resultNumbers(buf,this.result.stats);
		buf.b += Std.string(" performed on <strong>" + stx.test.ui.text.HtmlReport.platform + "</strong>, executed in <strong> " + time + " sec. </strong></div >\n ");
		return buf.b;
	}
	,addPackage: function(buf,result,name,isOk) {
		if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
		if(name == "" && result.classNames().length == 0) return;
		buf.b += Std.string("<li>");
		buf.b += Std.string("<h2>" + name + "</h2>");
		this.blockNumbers(buf,result.stats);
		buf.b += Std.string("<ul>\n");
		var _g = 0, _g1 = result.classNames();
		while(_g < _g1.length) {
			var cname = _g1[_g];
			++_g;
			this.addClass(buf,result.getClass(cname),cname,isOk);
		}
		buf.b += Std.string("</ul>\n");
		buf.b += Std.string("</li>\n");
	}
	,addPackages: function(buf,result,isOk) {
		if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
		buf.b += Std.string("<ul id=\"utest-results-packages\">\n");
		var _g = 0, _g1 = result.packageNames(false);
		while(_g < _g1.length) {
			var name = _g1[_g];
			++_g;
			this.addPackage(buf,result.getPackage(name),name,isOk);
		}
		buf.b += Std.string("</ul>\n");
	}
	,addClass: function(buf,result,name,isOk) {
		if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
		buf.b += Std.string("<li>");
		buf.b += Std.string("<h2 class=\"classname\">" + name + "</h2>");
		this.blockNumbers(buf,result.stats);
		buf.b += Std.string("<ul>\n");
		var _g = 0, _g1 = result.methodNames();
		while(_g < _g1.length) {
			var mname = _g1[_g];
			++_g;
			this.addFixture(buf,result.get(mname),mname,isOk);
		}
		buf.b += Std.string("</ul>\n");
		buf.b += Std.string("</li>\n");
	}
	,addFixture: function(buf,result,name,isOk) {
		if(stx.test.ui.common.ReportTools.skipResult(this,result.stats,isOk)) return;
		buf.b += Std.string("<li class=\"fixture\"><div class=\"li\">");
		buf.b += Std.string("<span class=\"" + this.cls(result.stats) + "bg fixtureresult\">");
		if(result.stats.isOk) buf.b += Std.string("OK "); else if(result.stats.hasErrors) buf.b += Std.string("ERROR "); else if(result.stats.hasFailures) buf.b += Std.string("FAILURE "); else if(result.stats.hasWarnings) buf.b += Std.string("WARNING ");
		buf.b += Std.string("</span>");
		buf.b += Std.string("<div class=\"fixturedetails\">");
		buf.b += Std.string("<strong>" + name + "</strong>");
		buf.b += Std.string(": ");
		this.resultNumbers(buf,result.stats);
		var messages = [];
		var $it0 = result.iterator();
		while( $it0.hasNext() ) {
			var assertation = $it0.next();
			var $e = (assertation);
			switch( $e[1] ) {
			case 0:
				var pos = $e[2];
				break;
			case 1:
				var pos = $e[3], msg = $e[2];
				messages.push("<strong>line " + pos.lineNumber + "</strong>: <em>" + StringTools.htmlEscape(msg) + "</em>");
				break;
			case 2:
				var s = $e[3], e = $e[2];
				messages.push("<strong>error</strong>: <em>" + StringTools.htmlEscape(Std.string(e)) + "</em>\n" + this.formatStack(s));
				break;
			case 3:
				var s = $e[3], e = $e[2];
				messages.push("<strong>setup error</strong>: " + StringTools.htmlEscape(Std.string(e)) + "\n" + this.formatStack(s));
				break;
			case 4:
				var s = $e[3], e = $e[2];
				messages.push("<strong>tear-down error</strong>: " + StringTools.htmlEscape(Std.string(e)) + "\n" + this.formatStack(s));
				break;
			case 5:
				var s = $e[3], missedAsyncs = $e[2];
				messages.push("<strong>missed async call(s)</strong>: " + missedAsyncs);
				break;
			case 6:
				var s = $e[3], e = $e[2];
				messages.push("<strong>async error</strong>: " + StringTools.htmlEscape(Std.string(e)) + "\n" + this.formatStack(s));
				break;
			case 7:
				var msg = $e[2];
				messages.push(StringTools.htmlEscape(msg));
				break;
			}
		}
		if(messages.length > 0) {
			buf.b += Std.string("<div class=\"testoutput\">");
			buf.b += Std.string(messages.join("<br/>"));
			buf.b += Std.string("</div>\n");
		}
		buf.b += Std.string("</div>\n");
		buf.b += Std.string("</div></li>\n");
	}
	,formatStack: function(stack,addNL) {
		if(addNL == null) addNL = true;
		var parts = [];
		var nl = addNL?"\n":"";
		var _g = 0, _g1 = haxe.Stack.toString(stack).split("\n");
		while(_g < _g1.length) {
			var part = _g1[_g];
			++_g;
			if(StringTools.trim(part) == "") continue;
			if(-1 < part.indexOf("Called from utest.")) continue;
			parts.push(part);
		}
		var s = "<ul><li>" + parts.join("</li>" + nl + "<li>") + "</li></ul>" + nl;
		return "<div>" + s + "</div>" + nl;
	}
	,blockNumbers: function(buf,stats) {
		buf.b += Std.string("<div class=\"" + this.cls(stats) + "bg statnumbers\">");
		this.resultNumbers(buf,stats);
		buf.b += Std.string("</div>");
	}
	,resultNumbers: function(buf,stats) {
		var numbers = [];
		if(stats.assertations == 1) numbers.push("<strong>1</strong> test"); else numbers.push("<strong>" + stats.assertations + "</strong> tests");
		if(stats.successes != stats.assertations) {
			if(stats.successes == 1) numbers.push("<strong>1</strong> pass"); else if(stats.successes > 0) numbers.push("<strong>" + stats.successes + "</strong> passes");
		}
		if(stats.errors == 1) numbers.push("<strong>1</strong> error"); else if(stats.errors > 0) numbers.push("<strong>" + stats.errors + "</strong> errors");
		if(stats.failures == 1) numbers.push("<strong>1</strong> failure"); else if(stats.failures > 0) numbers.push("<strong>" + stats.failures + "</strong> failures");
		if(stats.warnings == 1) numbers.push("<strong>1</strong> warning"); else if(stats.warnings > 0) numbers.push("<strong>" + stats.warnings + "</strong> warnings");
		buf.b += Std.string(numbers.join(", "));
	}
	,cls: function(stats) {
		if(stats.hasErrors) return "error"; else if(stats.hasFailures) return "failure"; else if(stats.hasWarnings) return "warn"; else return "ok";
	}
	,start: function(e) {
		this.startTime = haxe.Timer.stamp();
	}
	,startTime: null
	,_trace: function(v,infos) {
		var time = haxe.Timer.stamp();
		var delta = this._traceTime == null?0:time - this._traceTime;
		this._traces.push({ msg : StringTools.htmlEscape(Std.string(v)), infos : infos, time : time - this.startTime, delta : delta, stack : haxe.Stack.callStack()});
		this._traceTime = haxe.Timer.stamp();
	}
	,_traceTime: null
	,restoreTrace: function() {
		if(!this.traceRedirected) return;
		haxe.Log.trace = this.oldTrace;
	}
	,redirectTrace: function() {
		if(this.traceRedirected) return;
		this._traces = [];
		this.oldTrace = haxe.Log.trace;
		haxe.Log.trace = $bind(this,this._trace);
	}
	,setHandler: function(handler) {
		this.handler = handler;
	}
	,_traces: null
	,oldTrace: null
	,aggregator: null
	,handler: null
	,displayHeader: null
	,displaySuccessResults: null
	,traceRedirected: null
	,__class__: stx.test.ui.text.HtmlReport
}
stx.test.ui.text.PlainTextReport = $hxClasses["stx.test.ui.text.PlainTextReport"] = function(runner,outputHandler) {
	this.aggregator = new stx.test.ui.common.ResultAggregator(runner,true);
	runner.onStart.add($bind(this,this.start));
	this.aggregator.onComplete.add($bind(this,this.complete));
	if(null != outputHandler) this.setHandler(outputHandler);
	this.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.AlwaysShowSuccessResults;
	this.displayHeader = stx.test.ui.common.HeaderDisplayMode.AlwaysShowHeader;
};
stx.test.ui.text.PlainTextReport.__name__ = ["stx","test","ui","text","PlainTextReport"];
stx.test.ui.text.PlainTextReport.__interfaces__ = [stx.test.ui.common.IReport];
stx.test.ui.text.PlainTextReport.prototype = {
	complete: function(result) {
		this.result = result;
		this.handler(this);
	}
	,getResults: function() {
		var buf = new StringBuf();
		this.addHeader(buf,this.result);
		var _g = 0, _g1 = this.result.packageNames();
		while(_g < _g1.length) {
			var pname = _g1[_g];
			++_g;
			var pack = this.result.getPackage(pname);
			if(stx.test.ui.common.ReportTools.skipResult(this,pack.stats,this.result.stats.isOk)) continue;
			var _g2 = 0, _g3 = pack.classNames();
			while(_g2 < _g3.length) {
				var cname = _g3[_g2];
				++_g2;
				var cls = pack.getClass(cname);
				if(stx.test.ui.common.ReportTools.skipResult(this,cls.stats,this.result.stats.isOk)) continue;
				buf.b += Std.string((pname == ""?"":pname + ".") + cname + this.newline);
				var _g4 = 0, _g5 = cls.methodNames();
				while(_g4 < _g5.length) {
					var mname = _g5[_g4];
					++_g4;
					var fix = cls.get(mname);
					if(stx.test.ui.common.ReportTools.skipResult(this,fix.stats,this.result.stats.isOk)) continue;
					buf.b += Std.string(this.indents(1) + mname + ": ");
					if(fix.stats.isOk) buf.b += Std.string("OK "); else if(fix.stats.hasErrors) buf.b += Std.string("ERROR "); else if(fix.stats.hasFailures) buf.b += Std.string("FAILURE "); else if(fix.stats.hasWarnings) buf.b += Std.string("WARNING ");
					var messages = "";
					var $it0 = fix.iterator();
					while( $it0.hasNext() ) {
						var assertation = $it0.next();
						var $e = (assertation);
						switch( $e[1] ) {
						case 0:
							var pos = $e[2];
							buf.b += Std.string(".");
							break;
						case 1:
							var pos = $e[3], msg = $e[2];
							buf.b += Std.string("F");
							messages += this.indents(2) + "line: " + pos.lineNumber + ", " + msg + this.newline;
							break;
						case 2:
							var s = $e[3], e = $e[2];
							buf.b += Std.string("E");
							messages += this.indents(2) + Std.string(e) + this.dumpStack(s) + this.newline;
							break;
						case 3:
							var s = $e[3], e = $e[2];
							buf.b += Std.string("S");
							messages += this.indents(2) + Std.string(e) + this.dumpStack(s) + this.newline;
							break;
						case 4:
							var s = $e[3], e = $e[2];
							buf.b += Std.string("T");
							messages += this.indents(2) + Std.string(e) + this.dumpStack(s) + this.newline;
							break;
						case 5:
							var s = $e[3], missedAsyncs = $e[2];
							buf.b += Std.string("O");
							messages += this.indents(2) + "missed async calls: " + missedAsyncs + this.dumpStack(s) + this.newline;
							break;
						case 6:
							var s = $e[3], e = $e[2];
							buf.b += Std.string("A");
							messages += this.indents(2) + Std.string(e) + this.dumpStack(s) + this.newline;
							break;
						case 7:
							var msg = $e[2];
							buf.b += Std.string("W");
							messages += this.indents(2) + msg + this.newline;
							break;
						}
					}
					buf.b += Std.string(this.newline);
					buf.b += Std.string(messages);
				}
			}
		}
		return buf.b;
	}
	,result: null
	,addHeader: function(buf,result) {
		if(!stx.test.ui.common.ReportTools.hasHeader(this,result.stats)) return;
		var end = haxe.Timer.stamp();
		var time = ((end - this.startTime) * 1000 | 0) / 1000;
		buf.b += Std.string("results: " + (result.stats.isOk?"ALL TESTS OK":"SOME TESTS FAILURES") + this.newline + " " + this.newline);
		buf.b += Std.string("assertations: " + result.stats.assertations + this.newline);
		buf.b += Std.string("successes: " + result.stats.successes + this.newline);
		buf.b += Std.string("errors: " + result.stats.errors + this.newline);
		buf.b += Std.string("failures: " + result.stats.failures + this.newline);
		buf.b += Std.string("warnings: " + result.stats.warnings + this.newline);
		buf.b += Std.string("execution time: " + time + this.newline);
		buf.b += Std.string(this.newline);
	}
	,dumpStack: function(stack) {
		if(stack.length == 0) return "";
		var parts = haxe.Stack.toString(stack).split("\n");
		var r = [];
		var _g = 0;
		while(_g < parts.length) {
			var part = parts[_g];
			++_g;
			if(part.indexOf(" utest.") >= 0) continue;
			r.push(part);
		}
		return r.join(this.newline);
	}
	,indents: function(c) {
		var s = "";
		var _g = 0;
		while(_g < c) {
			var _ = _g++;
			s += this.indent;
		}
		return s;
	}
	,start: function(e) {
		this.startTime = haxe.Timer.stamp();
	}
	,startTime: null
	,setHandler: function(handler) {
		this.handler = handler;
	}
	,indent: null
	,newline: null
	,aggregator: null
	,handler: null
	,displayHeader: null
	,displaySuccessResults: null
	,__class__: stx.test.ui.text.PlainTextReport
}
stx.test.ui.text.PrintReport = $hxClasses["stx.test.ui.text.PrintReport"] = function(runner) {
	stx.test.ui.text.PlainTextReport.call(this,runner,$bind(this,this._handler));
	this.newline = "\n";
	this.indent = "  ";
};
stx.test.ui.text.PrintReport.__name__ = ["stx","test","ui","text","PrintReport"];
stx.test.ui.text.PrintReport.__super__ = stx.test.ui.text.PlainTextReport;
stx.test.ui.text.PrintReport.prototype = $extend(stx.test.ui.text.PlainTextReport.prototype,{
	_trace: function(s) {
		s = StringTools.replace(s,"  ",this.indent);
		s = StringTools.replace(s,"\n",this.newline);
		haxe.Log.trace(s,{ fileName : "PrintReport.hx", lineNumber : 83, className : "stx.test.ui.text.PrintReport", methodName : "_trace"});
	}
	,_handler: function(report) {
		this._trace(report.getResults());
	}
	,useTrace: null
	,__class__: stx.test.ui.text.PrintReport
});
if(!stx.time) stx.time = {}
stx.time.Clock = $hxClasses["stx.time.Clock"] = function() { }
stx.time.Clock.__name__ = ["stx","time","Clock"];
stx.time.Clock.prototype = {
	now: null
	,__class__: stx.time.Clock
}
stx.time.SystemClock = $hxClasses["stx.time.SystemClock"] = function() {
};
stx.time.SystemClock.__name__ = ["stx","time","SystemClock"];
stx.time.SystemClock.__interfaces__ = [stx.time.Clock];
stx.time.SystemClock.prototype = {
	now: function() {
		return new Date();
	}
	,__class__: stx.time.SystemClock
}
stx.time.MockClock = $hxClasses["stx.time.MockClock"] = function() {
	this.time = 0.0;
};
stx.time.MockClock.__name__ = ["stx","time","MockClock"];
stx.time.MockClock.__interfaces__ = [stx.time.Clock];
stx.time.MockClock.prototype = {
	now: function() {
		return (function($this) {
			var $r;
			var d = new Date();
			d.setTime($this.time);
			$r = d;
			return $r;
		}(this));
	}
	,time: null
	,__class__: stx.time.MockClock
}
stx.time.ScheduledExecutor = $hxClasses["stx.time.ScheduledExecutor"] = function() { }
stx.time.ScheduledExecutor.__name__ = ["stx","time","ScheduledExecutor"];
stx.time.ScheduledExecutor.prototype = {
	forever: null
	,repeatWhile: null
	,repeat: null
	,once: null
	,__class__: stx.time.ScheduledExecutor
}
stx.time.ScheduledExecutorSystem = $hxClasses["stx.time.ScheduledExecutorSystem"] = function() {
};
stx.time.ScheduledExecutorSystem.__name__ = ["stx","time","ScheduledExecutorSystem"];
stx.time.ScheduledExecutorSystem.__interfaces__ = [stx.time.ScheduledExecutor];
stx.time.ScheduledExecutorSystem.prototype = {
	forever: function(f,ms) {
		var future = new stx.Future();
		var timer = new haxe.Timer(ms);
		future.ifCanceled($bind(timer,timer.stop));
		timer.run = f;
		return future;
	}
	,repeatWhile: function(seed,f,ms,pred) {
		var future = new stx.Future();
		return pred(seed)?(function($this) {
			var $r;
			var result = seed;
			var timer = new haxe.Timer(ms);
			future.ifCanceled($bind(timer,timer.stop));
			timer.run = function() {
				result = f(result);
				if(!pred(result)) {
					timer.stop();
					future.deliver(result,{ fileName : "ScheduledExecutor.hx", lineNumber : 130, className : "stx.time.ScheduledExecutorSystem", methodName : "repeatWhile"});
				}
			};
			$r = future;
			return $r;
		}(this)):future.deliver(seed,{ fileName : "ScheduledExecutor.hx", lineNumber : 136, className : "stx.time.ScheduledExecutorSystem", methodName : "repeatWhile"});
	}
	,repeat: function(seed,f,ms,times) {
		var future = new stx.Future();
		return times > 0?(function($this) {
			var $r;
			var result = seed;
			var timer = new haxe.Timer(ms);
			future.ifCanceled($bind(timer,timer.stop));
			timer.run = function() {
				result = f(result);
				--times;
				if(times == 0) {
					timer.stop();
					future.deliver(result,{ fileName : "ScheduledExecutor.hx", lineNumber : 105, className : "stx.time.ScheduledExecutorSystem", methodName : "repeat"});
				}
			};
			$r = future;
			return $r;
		}(this)):future.deliver(seed,{ fileName : "ScheduledExecutor.hx", lineNumber : 111, className : "stx.time.ScheduledExecutorSystem", methodName : "repeat"});
	}
	,once: function(f,ms) {
		var run = false;
		var future = new stx.Future();
		var timer = haxe.Timer.delay(function() {
			run = true;
			future.deliver(f(),{ fileName : "ScheduledExecutor.hx", lineNumber : 70, className : "stx.time.ScheduledExecutorSystem", methodName : "once"});
		},ms);
		future.allowCancelOnlyIf(function() {
			return run?false:(function($this) {
				var $r;
				timer.stop();
				$r = true;
				return $r;
			}(this));
		});
		return future;
	}
	,__class__: stx.time.ScheduledExecutorSystem
}
stx.time.Timer = $hxClasses["stx.time.Timer"] = function() { }
stx.time.Timer.__name__ = ["stx","time","Timer"];
stx.time.TimeInstruction = $hxClasses["stx.time.TimeInstruction"] = { __ename__ : ["stx","time","TimeInstruction"], __constructs__ : ["Start","Stop"] }
stx.time.TimeInstruction.Start = function(id,interval) { var $x = ["Start",0,id,interval]; $x.__enum__ = stx.time.TimeInstruction; $x.toString = $estr; return $x; }
stx.time.TimeInstruction.Stop = function(id) { var $x = ["Stop",1,id]; $x.__enum__ = stx.time.TimeInstruction; $x.toString = $estr; return $x; }
if(!stx.util) stx.util = {}
stx.util.Guid = $hxClasses["stx.util.Guid"] = function() { }
stx.util.Guid.__name__ = ["stx","util","Guid"];
stx.util.Guid.generate = function() {
	var result = "";
	var _g = 0;
	while(_g < 32) {
		var j = _g++;
		if(j == 8 || j == 12 || j == 16 || j == 20) result += "-";
		result += StringTools.hex(Math.floor(Math.random() * 16));
	}
	return result.toUpperCase();
}
stx.util.OrderExtension = $hxClasses["stx.util.OrderExtension"] = function() { }
stx.util.OrderExtension.__name__ = ["stx","util","OrderExtension"];
stx.util.OrderExtension.greaterThan = function(order) {
	return function(v1,v2) {
		return order(v1,v2) > 0;
	};
}
stx.util.OrderExtension.greaterThanOrEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) >= 0;
	};
}
stx.util.OrderExtension.lessThan = function(order) {
	return function(v1,v2) {
		return order(v1,v2) < 0;
	};
}
stx.util.OrderExtension.lessThanOrEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) <= 0;
	};
}
stx.util.OrderExtension.equal = function(order) {
	return function(v1,v2) {
		return order(v1,v2) == 0;
	};
}
stx.util.OrderExtension.notEqual = function(order) {
	return function(v1,v2) {
		return order(v1,v2) != 0;
	};
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
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.Prolog = "prolog";
Xml.Document = "document";
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
AllClasses.__meta__ = { obj : { IgnoreCover : null}, statics : { main : { IgnoreCover : null}}, fields : { _ : { IgnoreCover : null}}};
js.Lib.onerror = null;
sf.event.EventSystem.__meta__ = { obj : { DefaultImplementation : ["sf.event.DefaultEventSystem"]}};
stx.Logger.__meta__ = { obj : { DefaultImplementation : ["stx.DefaultLogger"]}};
stx.Objects.__meta__ = { obj : { note : ["0b1kn00b","Does this handle reference loops, should it, could it?"]}};
stx.FieldOrder.Ascending = 1;
stx.FieldOrder.Descending = -1;
stx.FieldOrder.Ignore = 0;
stx.Promise.count = 0;
stx.Strings.SepAlphaPattern = new EReg("(-|_)([a-z])","g");
stx.Strings.AlphaUpperAlphaPattern = new EReg("-([a-z])([A-Z])","g");
stx.ds.Map.MaxLoad = 10;
stx.ds.Map.MinLoad = 1;
stx.ds.Range.MIN = -1.7976931348623157 * Math.pow(10,308);
stx.ds.Range.MAX = 1.7976931348623157 * Math.pow(10,308);
stx.ds.plus.ProductHasher._baseMapes = [[786433,24593],[196613,3079,389],[1543,49157,196613,97],[12289,769,393241,193,53]];
stx.ds.plus.Meta.__meta__ = { statics : { _hasMetaDataClass : { deprecate : ["0b1kn00b","thx"]}, _fieldsWithMeta : { deprecate : ["0b1kn00b","thx"]}}};
stx.framework._Injector.InjectorImpl.state = [];
stx.io.http.HttpJValue.__meta__ = { obj : { DefaultImplementation : ["stx.io.http.HttpJValueAsync","OneToMany"]}};
stx.io.http.HttpJValueJsonp.Responders = { };
stx.io.http.HttpJValueJsonp.RequestMod = Math.round(Math.random() * 2147483647);
stx.io.http.HttpJValueJsonp.RequestCount = 0;
stx.io.http.HttpString.__meta__ = { obj : { DefaultImplementation : ["stx.io.http.HttpStringAsync","OneToMany"]}};
stx.io.json.Json.encodeObject = stx.Functions1.compose(stx.io.json.Json.encode,stx.io.json.Json.fromObject);
stx.io.json.Json.decodeObject = stx.Functions1.compose(stx.io.json.Json.toObject,stx.io.json.Json.decode);
stx.io.json.TranscodeJValue.__meta__ = { statics : { getDecomposerFor : { note : ["#0bk1kn00b: I don´t understand why TObject can´t be decomposed"]}}};
stx.js.Env.document = document;
stx.js.Env.documentRaw = document;
stx.js.Env.screen = screen;
stx.js.Env.window = window;
stx.js.Env.navigator = navigator;
stx.js.Env.history = history;
stx.js.Env.JInfinity = Infinity;
stx.js.Env.JNaN = NaN;
stx.js.Env.JUndefined = undefined;
stx.js.XmlHttpRequestState.UNSENT = 0;
stx.js.XmlHttpRequestState.OPENED = 1;
stx.js.XmlHttpRequestState.HEADERS_RECEIVED = 2;
stx.js.XmlHttpRequestState.LOADING = 3;
stx.js.XmlHttpRequestState.DONE = 4;
stx.js.ExceptionCode.INDEX_SIZE_ERR = 1;
stx.js.ExceptionCode.DOMSTRING_SIZE_ERR = 2;
stx.js.ExceptionCode.HIERARCHY_REQUEST_ERR = 3;
stx.js.ExceptionCode.WRONG_DOCUMENT_ERR = 4;
stx.js.ExceptionCode.INVALID_CHARACTER_ERR = 5;
stx.js.ExceptionCode.NO_DATA_ALLOWED_ERR = 6;
stx.js.ExceptionCode.NO_MODIFICATION_ALLOWED_ERR = 7;
stx.js.ExceptionCode.NOT_FOUND_ERR = 8;
stx.js.ExceptionCode.NOT_SUPPORTED_ERR = 9;
stx.js.ExceptionCode.INUSE_ATTRIBUTE_ERR = 10;
stx.js.ExceptionCode.INVALID_STATE_ERR = 11;
stx.js.ExceptionCode.SYNTAX_ERR = 12;
stx.js.ExceptionCode.INVALID_MODIFICATION_ERR = 13;
stx.js.ExceptionCode.NAMESPACE_ERR = 14;
stx.js.ExceptionCode.INVALID_ACCESS_ERR = 15;
stx.js.ExceptionCode.VALIDATION_ERR = 16;
stx.js.ExceptionCode.TYPE_MISMATCH_ERR = 17;
stx.js.NodeType.ELEMENT_NODE = 1;
stx.js.NodeType.ATTRIBUTE_NODE = 2;
stx.js.NodeType.TEXT_NODE = 3;
stx.js.NodeType.CDATA_SECTION_NODE = 4;
stx.js.NodeType.ENTITY_REFERENCE_NODE = 5;
stx.js.NodeType.ENTITY_NODE = 6;
stx.js.NodeType.PROCESSING_INSTRUCTION_NODE = 7;
stx.js.NodeType.COMMENT_NODE = 8;
stx.js.NodeType.DOCUMENT_NODE = 9;
stx.js.NodeType.DOCUMENT_TYPE_NODE = 10;
stx.js.NodeType.DOCUMENT_FRAGMENT_NODE = 11;
stx.js.NodeType.NOTATION_NODE = 12;
stx.js.DocumentPosition.DOCUMENT_POSITION_DISCONNECTED = 1;
stx.js.DocumentPosition.DOCUMENT_POSITION_PRECEDING = 2;
stx.js.DocumentPosition.DOCUMENT_POSITION_FOLLOWING = 4;
stx.js.DocumentPosition.DOCUMENT_POSITION_CONTAINS = 8;
stx.js.DocumentPosition.DOCUMENT_POSITION_CONTAINED_BY = 16;
stx.js.DocumentPosition.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 32;
stx.js.DerivationMethod.DERIVATION_RESTRICTION = 1;
stx.js.DerivationMethod.DERIVATION_EXTENSION = 2;
stx.js.DerivationMethod.DERIVATION_UNION = 4;
stx.js.DerivationMethod.DERIVATION_LIST = 8;
stx.js.OperationType.NODE_CLONED = 1;
stx.js.OperationType.NODE_IMPORTED = 2;
stx.js.OperationType.NODE_DELETED = 3;
stx.js.OperationType.NODE_RENAMED = 4;
stx.js.OperationType.NODE_ADOPTED = 5;
stx.js.ErrorState.NETWORK_EMPTY = 0;
stx.js.ErrorState.NETWORK_IDLE = 1;
stx.js.ErrorState.NETWORK_LOADING = 2;
stx.js.ErrorState.NETWORK_NO_SOURCE = 3;
stx.js.ReadyState.CONNECTING = 0;
stx.js.ReadyState.OPEN = 1;
stx.js.ReadyState.CLOSED = 2;
stx.js.EventExceptionCode.UNSPECIFIED_EVENT_TYPE_ERR = 0;
stx.js.DeltaModeCode.DOM_DELTA_PIXEL = 0;
stx.js.DeltaModeCode.DOM_DELTA_Line = 1;
stx.js.DeltaModeCode.DOM_DELTA_Page = 2;
stx.js.InputModeCode.DOM_INPUT_METHOD_UNKNOWN = 0;
stx.js.InputModeCode.DOM_INPUT_METHOD_KEYBOARD = 1;
stx.js.InputModeCode.DOM_INPUT_METHOD_PASTE = 2;
stx.js.InputModeCode.DOM_INPUT_METHOD_DROP = 3;
stx.js.InputModeCode.DOM_INPUT_METHOD_IME = 4;
stx.js.InputModeCode.DOM_INPUT_METHOD_OPTION = 5;
stx.js.InputModeCode.DOM_INPUT_METHOD_HANDWRITING = 6;
stx.js.InputModeCode.DOM_INPUT_METHOD_VOICE = 7;
stx.js.InputModeCode.DOM_INPUT_METHOD_MULTIMODAL = 8;
stx.js.InputModeCode.DOM_INPUT_METHOD_SCRIPT = 9;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_STANDARD = 0;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_LEFT = 1;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_RIGHT = 2;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_NUMPAD = 3;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_MOBILE = 4;
stx.js.KeyLocationCode.DOM_KEY_LOCATION_JOYSTICK = 5;
stx.js.PhaseType.CAPTURING_PHASE = 1;
stx.js.PhaseType.AT_TARGET = 2;
stx.js.PhaseType.BUBBLING_PHASE = 3;
stx.js.AttrChangeType.MODIFICATION = 1;
stx.js.AttrChangeType.ADDITION = 2;
stx.js.AttrChangeType.REMOVAL = 3;
stx.js.AcceptNodeConstants.FILTER_ACCEPT = 1;
stx.js.AcceptNodeConstants.FILTER_REJECT = 2;
stx.js.AcceptNodeConstants.FILTER_SKIP = 1;
stx.js.WhatToShowConstants.SHOW_ALL = -1;
stx.js.WhatToShowConstants.SHOW_ELEMENT = 1;
stx.js.WhatToShowConstants.SHOW_ATTRIBUTE = 2;
stx.js.WhatToShowConstants.SHOW_TEXT = 4;
stx.js.WhatToShowConstants.SHOW_CDATA_SECTION = 8;
stx.js.WhatToShowConstants.SHOW_ENTITY_REFERENCE = 16;
stx.js.WhatToShowConstants.SHOW_ENTITY = 32;
stx.js.WhatToShowConstants.SHOW_PROCESSING_INSTRUCTION = 64;
stx.js.WhatToShowConstants.SHOW_COMMENT = 128;
stx.js.WhatToShowConstants.SHOW_DOCUMENT = 256;
stx.js.WhatToShowConstants.SHOW_DOCUMENT_TYPE = 512;
stx.js.WhatToShowConstants.SHOW_DOCUMENT_FRAGMENT = 1024;
stx.js.WhatToShowConstants.SHOW_NOTATION = 2048;
stx.js.RangeExceptionCode.BAD_BOUNDARYPOINTS_ERR = 1;
stx.js.RangeExceptionCode.INVALID_NODE_TYPE_ERR = 2;
stx.js.CompareHow.START_TO_START = 0;
stx.js.CompareHow.START_TO_END = 1;
stx.js.CompareHow.END_TO_END = 2;
stx.js.CompareHow.END_TO_START = 3;
stx.js.RuleType.UNKNOWN_RULE = 0;
stx.js.RuleType.STYLE_RULE = 1;
stx.js.RuleType.CHARSET_RULE = 2;
stx.js.RuleType.IMPORT_RULE = 3;
stx.js.RuleType.MEDIA_RULE = 4;
stx.js.RuleType.FONT_FACE_RULE = 5;
stx.js.RuleType.PAGE_RULE = 6;
stx.js.CSSValueType.CSS_INHERIT = 0;
stx.js.CSSValueType.CSS_PRIMITIVE_VALUE = 1;
stx.js.CSSValueType.CSS_VALUE_LIST = 2;
stx.js.CSSValueType.CSS_CUSTOM = 3;
stx.js.PrimitiveType.CSS_UNKNOWN = 0;
stx.js.PrimitiveType.CSS_NUMBER = 1;
stx.js.PrimitiveType.CSS_PERCENTAGE = 2;
stx.js.PrimitiveType.CSS_EMS = 3;
stx.js.PrimitiveType.CSS_EXS = 4;
stx.js.PrimitiveType.CSS_PX = 5;
stx.js.PrimitiveType.CSS_CM = 6;
stx.js.PrimitiveType.CSS_MM = 7;
stx.js.PrimitiveType.CSS_IN = 8;
stx.js.PrimitiveType.CSS_PT = 9;
stx.js.PrimitiveType.CSS_PC = 10;
stx.js.PrimitiveType.CSS_DEG = 11;
stx.js.PrimitiveType.CSS_RAD = 12;
stx.js.PrimitiveType.CSS_GRAD = 13;
stx.js.PrimitiveType.CSS_MS = 14;
stx.js.PrimitiveType.CSS_S = 15;
stx.js.PrimitiveType.CSS_HZ = 16;
stx.js.PrimitiveType.CSS_KHZ = 17;
stx.js.PrimitiveType.CSS_DIMENSION = 18;
stx.js.PrimitiveType.CSS_STRING = 19;
stx.js.PrimitiveType.CSS_URI = 20;
stx.js.PrimitiveType.CSS_IDENT = 21;
stx.js.PrimitiveType.CSS_ATTR = 22;
stx.js.PrimitiveType.CSS_COUNTER = 23;
stx.js.PrimitiveType.CSS_RECT = 24;
stx.js.PrimitiveType.CSS_RGBCOLOR = 25;
stx.js.UpdateStatus.UNCACHED = 0;
stx.js.UpdateStatus.IDLE = 1;
stx.js.UpdateStatus.CHECKING = 2;
stx.js.UpdateStatus.DOWNLOADING = 3;
stx.js.UpdateStatus.UPDATEREADY = 4;
stx.js.ErrorSeverity.SEVERITY_WARNING = 1;
stx.js.ErrorSeverity.SEVERITY_ERROR = 2;
stx.js.ErrorSeverity.SEVERITY_FATAL_ERROR = 3;
stx.js.detect.BrowserSupport.memorized = stx.ds.Map.create();
stx.js.detect.Host.Environment = stx.js.detect.Host.detectEnvironment();
stx.js.detect.Host.OS = stx.js.detect.Host.detectOS();
stx.js.detect.Host.OperaPattern = new EReg("Opera(?:/| )(\\S*)","");
stx.js.detect.Host.ChromePattern = new EReg("Chrome(?:/| )(\\S*)","");
stx.js.detect.Host.SafariPattern = new EReg("Version(?:/| )(\\S*) Safari(?:/| )(\\S*)","");
stx.js.detect.Host.FirefoxPattern = new EReg("Firefox(?:/| )(\\S*)","");
stx.js.detect.Host.IEPattern = new EReg("MSIE(?:/| )(\\S*);","");
stx.js.detect.Host.WindowsPattern = new EReg("Windows NT","");
stx.js.detect.Host.MacPattern = new EReg("Mac OS X","");
stx.js.detect.Host.MacMobilePattern = new EReg("(iPhone|iPad)","");
stx.js.detect.Host.AndroidPattern = new EReg("Android","");
stx.js.detect.Host.LinuxPattern = new EReg("Linux","");
stx.js.dom.Quirks.__meta__ = { statics : { addEventListener : { bug : ["#0b1kn00b: why do I need to use untyped here?"]}}};
stx.js.dom.Quirks.ExcludePattern = new EReg("z-?index|font-?weight|opacity|zoom|line-?height","i");
stx.js.dom.Quirks.AlphaPattern = new EReg("alpha\\([^)]*\\)","");
stx.js.dom.Quirks.OpacityPattern = new EReg("opacity=([^)]*)","");
stx.js.dom.Quirks.FloatPattern = new EReg("float","i");
stx.js.dom.Quirks.UpperCasePattern = new EReg("([A-Z])","g");
stx.js.dom.Quirks.NumberPixelPattern = new EReg("^-?\\d+(?:px)?$","i");
stx.js.dom.Quirks.NumberPattern = new EReg("^-?\\d","");
stx.js.dom.Quirks.RootPattern = new EReg("^body|html$","i");
stx.js.dom.Quirks.cssWidth = ["left","right"];
stx.js.dom.Quirks.cssHeight = ["top","bottom"];
stx.js.dom.Quirks.cssShow = stx.ds.Map.create().set("position","absolute").set("visibility","hidden").set("display","block");
stx.js.dom.Quirks.border = "border";
stx.js.dom.Quirks.margin = "margin";
stx.js.io.IFrameIOPollingMaptag.lastMessageId = 1;
stx.js.io.IFrameIOPollingMaptag.newFragmentsList = stx.ds.List.factory();
stx.math.tween.TweenerExtensions.DefaultFrequency = stx.Floats.round(1000.0 / 24.0,null);
stx.net.HttpHeaderExtensions.HeaderPattern = new EReg("^([^:]+): *(.+)$","");
stx.net.HttpHeaderExtensions.HeaderLinesPattern = new EReg("[\r\n]+","");
stx.net.UrlExtensions.UrlPattern = new EReg("^(?:([a-zA-Z]+:)(?:[/][/]))?([^:?/#\\s]*)(?:[:](\\d+))?(/[^\\s?#]*)?([?][^\\s#]*)?(#.*)?$","i");
stx.net.UrlExtensions.Protocol = 1;
stx.net.UrlExtensions.Hostname = 2;
stx.net.UrlExtensions.Port = 3;
stx.net.UrlExtensions.Pathname = 4;
stx.net.UrlExtensions.Search = 5;
stx.net.UrlExtensions.Map = 6;
stx.reactive.Stamp._stamp = 1;
stx.reactive.Rank._rank = 0;
stx.test.TestHandler.POLLING_TIME = 10;
stx.test.ui.text.HtmlReport.platform = "javascript";
stx.time.Clock.__meta__ = { obj : { DefaultImplementation : ["stx.time.SystemClock","OneToMany"]}};
stx.time.ScheduledExecutor.__meta__ = { obj : { DefaultImplementation : ["stx.time.ScheduledExecutorSystem","OneToMany"]}};
AllClasses.main();
