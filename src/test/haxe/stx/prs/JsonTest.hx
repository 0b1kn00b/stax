package stx.prs;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;
using stx.Parser;
using stx.prs.StringParsers;

import stx.prs.Json.*;

class JsonTest extends TestCase{
  public function testJson(u:UnitArrow):UnitArrow{
    var a = '
      {
        a : true,
        b : 3,
        c : "string"
      }
    ';
    //var b = Json.jsonParser()(a.reader());
    /*var c = '{';
    trace(leftAccP()(c.reader()));*/
    var d = 'jhf2';
    //trace(identifierP()(d.reader()));
    //trace(jsonValueP()(d.reader()));
    var e = '[0]';
    //trace(jsonArrayP()(e.reader()));
    var f = '\t\n\r ';
    //trace(spacingP()(f.reader()));
    return u;
  }
}

