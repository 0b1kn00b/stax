package stx.plus;

using  stx.Arrays;

import stx.plus.Order;
import stx.plus.Equal;

class Arrays{
  static public function difference<T>(arr0:Array<T>,arr1:Array<T>):Array<T>{
    var o   = [];
    var eq0 = arr0.firstOption().map(Equal.getEqualFor);
    var eq1 = arr1.firstOption().map(Equal.getEqualFor);
    var eq2 = eq0.orElse(function() return eq1);
    if (eq.isEmpty()) return [];
    var eq  = eq2.get();
    return null;
  }
}