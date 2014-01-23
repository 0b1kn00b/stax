package stx.js.arw;

import js.JQuery;
import js.Browser;

import Prelude;
import stx.Tuples;
import stx.Tuples;
import stx.arrowlet.CallbackArrowlet;

using stx.Option;
using stx.async.Arrowlet;
using stx.Functions;


class BrowserArrowlets{
  static public function windowSize():Arrowlet<Unit,Tuple2<Int,Int>>{
    var jqr                          = new JQuery(Browser.window).resize;
    var evt : CallbackArrowlet<Dynamic> = jqr.enclose();
    
    return evt.then(
        function(x){
          return tuple2(Browser.window.innerWidth, Browser.window.innerHeight);
        }
       );
  }
}