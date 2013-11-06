package stx;

using stx.Functions;
using stx.Arrow;

class Boot{
  @:noUsing static public function boot(main:Niladic,?algo:Arrow<Unit,Unit>):Void{
    algo = algo == null ? Arrows.unit() : algo;
    algo.apply(Unit).each(main.promote());
  }
}