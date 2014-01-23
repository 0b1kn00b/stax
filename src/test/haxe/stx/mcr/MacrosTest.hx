package stx.mcr;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using stx.UnitTest;
import stx.io.Log.*;


class MacrosTest extends Suite{
  public function testMacros(u:TestCase):TestCase{
    var a : McrTypedef = {
      a : 'boot'
    };
    var b = new McrClass();
    var c = Boob;
    //getMType(a);
    //getMType(b);
    getMType(c);

    return u;
  }
  macro public static function getMType(e:Expr):Expr{
    switch (e.expr) {
      case EConst(CIdent(str)) :
        var t = Context.typeof(e);
        //trace(t);
        switch (t) {
          case TType(tp,_) :
            switch(tp.get().type){
              case TAnonymous(tp) :
                //typedef ref;
                trace(tp.get().fields);
              default             :
            }
          case TInst(t,_) ://params?
            //class instance ref
            //trace(t.get().fields.get());
          default : 
        }
      default :
    }
    return e;
  }
}
private typedef McrTypedef = {
  a : String
}
private class McrClass{
  public function new(){

  }
  var a : String;
}
private enum McrEnum{
  Boob;
}
