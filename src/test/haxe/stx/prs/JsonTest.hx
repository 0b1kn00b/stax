package stx.prs;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.UnitTest;
using stx.Parser;
using stx.parser.StringParsers;

import stx.parser.Json.*;

class JsonTest extends Suite{
  public function testJson(u:TestCase):TestCase{
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

