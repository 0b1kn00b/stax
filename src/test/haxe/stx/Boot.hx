package stx;

using stx.Functions;
using stx.Arrow;

class Boot{
  @:noUsing static public function boot(main:CodeBlock,?algo:Arrow<Unit,Unit>):Void{
    algo = algo == null ? Arrows.unit() : algo;
    algo.apply(Unit).foreach(main.promote());
  }
}