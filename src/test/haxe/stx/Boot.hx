package stx;

using stx.Functions;
using stx.Arrowlet;

class Boot{
  @:noUsing static public function boot(main:Niladic,?algo:Arrowlet<Unit,Unit>):Void{
    algo = algo == null ? Arrowlets.unit() : algo;
    algo.apply(Unit).each(main.promote());
  }
}