package ;

/**
 * ...
 * @author sledorze
 */

import com.mindrocks.text.Parser;
// import js.JQuery;
// import js.Lib;
using com.mindrocks.text.Parser;

import com.mindrocks.functional.Functional;
using com.mindrocks.functional.Functional;

using com.mindrocks.macros.LazyMacro;

using Lambda; 

import com.mindrocks.text.ParserMonad;
using com.mindrocks.text.ParserMonad;

/**
 * Quick n dirty.
 */
class JsonPrettyPrinter {
  public static function prettify(json : JsValue) : String return {
    function internal(json : JsValue) : String return {
      switch (json) {
        case JsObject(fields):
          "{\n" + fields.map(function (field) return field.name + " : " + internal(field.value)).join(",\n") + "\n}";
        case JsArray(elements):
          "[\n" + elements.map(internal).join(",\n") + "\n]";
        case JsData(x):
          x;
      } 
    }
    internal(json);
  }
}

class LRTest {

  static var posNumberR = ~/[0-9]+/;
  
  static var plusP = "+".identifier();
  
  static var posNumberP = posNumberR.regexParser().tag("number");
    
  static var binop = (expr.and_(plusP)).andWith(expr.commit(), function (a, b) return a + " + " + b).tag("binop").lazyF();
  public static var expr : Void -> Parser<String,String> = binop.or(posNumberP).memo().tag("expression");
}


class MonadParserTest {

  public static var parser : Void -> Parser<String,Array<String>> = ParserM.dO({
      a <= "a".identifier();
      b <= "b".identifier();
      c <= "c".identifier();
      ret([a,b,c]);
  });

}

class ParserTest {

  static function expectFailure<T> (s:String, parser:Parser<String,T>, at){
    switch (parser(s.reader())) {
      case Success(res, rest):
        trace(res);
        trace("unexpected success, result line above ");
        return false;
      case Failure(err, rest, _):
        if (rest.offset == at)
        return true;
        else {
          trace("unexpected failure offset: "+ rest.errorMessage(err));
          return false;
        }
        return true;
    }
  }

  static function expectSucces<A> (s:String, parser: Parser<String, A>, result:A):Bool{
    switch (parser(s.reader())) {
      case Success(res, rest):
        if (""+res == ""+result)
        return true;
        else {
          trace("result does not match: "+res+" expected :"+result);
          return false;
        }
      case Failure(err, rest, _):
        trace("unexpected failure : "+rest.errorMessage(err));
        return false;
    }
  }
  
  public static function jsonTest() {
    
    var ok = true;
    ok = ok && expectFailure(" {  aaa : aa, bbb :: [cc, dd] } ", JsonParser.jsonParser(), 19);
    ok = ok && expectFailure("5++3+2+3", LRTest.expr(), 2);

    ok = ok && expectSucces("abc", MonadParserTest.parser(), ['a','b','c']);

    trace(ok ? "test passed " : "test FAILED!");
    /*
    var elem = Lib.document.getElementById("haxe:trace");
    if (elem != null) {
      trace("elem[0] " + elem);
      new JQuery(elem).css("font-family", "Courier New, monospace");      // monospace!
    }
    */
    
    
  }
  
}

