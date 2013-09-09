package stx.js.arw;

import js.JQuery;
import js.Browser;

import stx.Prelude;
import stx.Tuples;
import stx.Tuples;
import stx.arw.CallbackArrow;

using stx.Options;
using stx.Arrows;
using stx.Functions;


class BrowserArrows{
  static public function windowSize():Arrow<Unit,Tuple2<Int,Int>>{
    var jqr                          = new JQuery(Browser.window).resize;
    var evt : CallbackArrow<Dynamic> = jqr.enclose();
    
    return evt.then(
        function(x){
          return tuple2(Browser.window.innerWidth, Browser.window.innerHeight);
        }
       );
  }
}