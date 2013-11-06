package;


import Stax.*;
import stx.Log.*;

using stx.Arrays;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
class Doc{
  static public function main(){
    
  }
  macro static function build(){
    Context.onGenerate(
      function(a){
        a.foreach(
          function(type){
            switch (type) {
              case TMono( t )            :
              case TEnum(t, params)      :
              case TInst(t, params )     : trace(t.get().meta.get('doc'));
              case TType(t, params)      :
              case TFun(args, ret)       :
              case TAnonymous(a)         :
              case TDynamic(t)           :
              case TLazy(f)              :
              case TAbstract(t, params)  :
            }
          }
        );
      }
    );
    return null;
  }
}