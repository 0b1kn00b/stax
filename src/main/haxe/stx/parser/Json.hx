package stx.parser;

import Prelude;

using stx.Functions;
using stx.Parser;
using stx.parser.StringParsers;

using stx.Tuples;

typedef JsEntry = { name : String, value : JsValue}
enum JsValue {
  JsObject(fields : Array<JsEntry>);
  JsArray(elements : Array<JsValue>);
  JsData(x : String);
}

class Json {
  
  public static function makeField(t : Tuple2<String, JsValue>) {
    return { name : t.fst(), value : t.snd() };
  }
  
  public static var identifierR = ~/[a-zA-Z0-9_-]+/;

  public static  var spaceP = " ".identifier();    
  public static  var tabP = "\t".identifier();
  public static  var retP = ("\r".identifier().or("\n".identifier()));
  
  public static  var spacingP =
    [
      spaceP.oneMany(),
      tabP.oneMany(),
      retP.oneMany()
    ].ors().many().lazyF();
  
  public static  var leftAccP = withSpacing("{".identifier());
  public static  var rightAccP = withSpacing("}".identifier());
  public static  var leftBracketP = withSpacing("[".identifier());
  public static  var rightBracketP = withSpacing("]".identifier());
  public static  var sepP = withSpacing(":".identifier());
  public static  var commaP = withSpacing(",".identifier());
  public static  var equalsP = withSpacing(",".identifier());
  
  
  public static function withSpacing<I,T>(p : Void -> Parser<String,T>) return
    spacingP._and(p);

  public static var identifierP =
    withSpacing(identifierR.regexParser());

  public static var jsonDataP =
    identifierP.then(JsData);
    
  public static var jsonValueP : Void -> Parser<String,JsValue> =
    jsonParser.or(jsonDataP).or(jsonArrayP).tag("json value").lazyF();

  public static var jsonArrayP2 =
    leftBracketP._and(jsonValueP.repsep(commaP).and_(rightBracketP)).commit().then(JsArray);
    
  /*public static var jsonArrayPM =
    ParserM.dO({
      jsons <= ParserM.dO({
        leftBracketP;
        jsons <= jsonValueP.repsep(commaP);
        rightBracketP;
        ret(jsons);
      }).commit();
      ret(JsArray(jsons));
    });
*/
  public static var jsonArrayP = leftBracketP._and(jsonValueP.repsep(commaP)).and_(rightBracketP).then(JsArray).commit();

  public static var jsonEntryP =
    identifierP.and(sepP._and(jsonValueP).commit());
  
  public static  var jsonEntriesP =
    jsonEntryP.repsep(commaP).commit();

  public static var jsonParser =
    leftAccP._and(jsonEntriesP).and_(rightAccP.commit()).then(function (entries)
      return JsObject(entries.map(makeField)));
}