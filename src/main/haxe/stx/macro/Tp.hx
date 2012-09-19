package stx.macro;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import stx.Tuples;

class Tp{
	@:noUsing
	@:macro static public function l(e:Array<Expr>):Expr{
    var fst : Expr = e[0];
    var snd : Expr = e[1];
    var thd : Expr = e[2];
    var frt : Expr = e[3];
    var fth : Expr = e[4];

    var o = switch(e.length){
        case 2 : macro new stx.Tuples.Tuple2($fst,$snd);
        case 3 : macro new stx.Tuples.Tuple3($fst,$snd,$thd);
        case 4 : macro new stx.Tuples.Tuple4($fst,$snd,$thd,$frt);
        case 5 : macro new stx.Tuples.Tuple5($fst,$snd,$thd,$frt,$fth);
      }
    return o;
  }
}