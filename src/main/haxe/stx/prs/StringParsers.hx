package stx.prs;

import stx.prs.InputStream;

using stx.Functions;
using stx.Parser;
using stx.prs.StringParsers;

using stx.Iterables;

class StringParsers {

  public static function identifier(x : String) : Void -> Parser<String,String>
    return stx.Anys.toThunk(function (input : Input<String>)
      if (input.startsWith(x)) {
        return Success(x, input.drop(x.length));
      } else {
        return Fail((x + " expected and not found").errorAt(input).newStack(), input, false);
      }
    ).lazy();

  public static function regexParser(r : EReg) : Void -> Parser<String,String>
    return stx.Anys.toThunk(function (input : Input<String>) return
      if (input.matchedBy(r)) {
        var pos = r.matchedPos();
        if (pos.pos == 0) {
          Success(input.take(pos.len), input.drop(pos.len));
        } else {
          Fail((Std.string(r) + "not matched at position " + input.offset ).errorAt(input).newStack(), input, false);
        }
      } else {
        Fail((Std.string(r) + " not matched").errorAt(input).newStack(), input, false);
      }
    ).lazy();
}
class StringReader {
	 inline public static function startsWith(r : Input<String>, x : String) : Bool {    
    return ReaderObj.take(r, x.length) == x;
  }
  
  inline public static function matchedBy(r : Input<String>, e : EReg) : Bool { // this is deadly unfortunate that RegEx don't support offset and first char maching constraint..
    return e.match(rest(r));
  }
  
  public inline static function rest(r : Input<String>) : String {
    return r.content.range(r.offset);
  }
	inline public static function reader(str : String) : Input<String> return {
    content : Tools.enumerable(str),
		store 					: new Map(),
    offset : 0,
    memo : {
      memoEntries 		: new Map<String,MemoEntry>(),
      recursionHeads	: new Map<String,Head>(),
      lrStack 				: stx.ds.List.nil(),
    }
  }
	
  public static function textAround(r : Input<String>, ?before : Int = 10, ?after : Int = 10) : { text : String, indicator : String } {
    
    var offset = Std.int(Math.max(0, r.offset - before));
    
    var text = r.content.range(offset, before + after);
    
    var indicPadding = Std.int(Math.min(r.offset, before));
    var indicator = StringTools.lpad("^", "_", indicPadding+1);
    
    return {    
      text : text,
      indicator : indicator
    };
  }
	public static function errorMessage(r : Input<String>, msg: ParseFail){
    var x = r.textAround();

    var itr : Array<FailMsg> = Type.enumParameters(msg)[0];
    var r = "";
    for (err in itr){
      r += "Fail at " + err.pos + " : " + err.msg+"\n";
    }

    return r + " "+x.text+"\n"+x.indicator;
  }
	public static function token<I,O>(p:Void->Parser<I,Array<O>>):Void->Parser<I,String> {
		return Parsers.then( p, function(x) return x.join("") );
	}
	public static function range(min:Int, max:Int):String->Bool {
		return function(s:String):Bool {
			var x = s.charCodeAt(0);
			return (x >= min) && (x <= max);
		}
	}
}