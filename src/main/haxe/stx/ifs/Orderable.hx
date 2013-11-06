package stx.ifs;

import stx.plus.Order;

interface Orderable<T>{
  @:allow(stx.ifs)private var __order__ : Reduce<T,Int>;
  public function order(ot:T):Int;
}
class TypeOrderables{
  static public function order<T:Orderable>(th:T,ot:T):Bool{
    
    if(th.__order__ == null){
      th.__order__ = Order.getOrderFor(th);
    }
    return th.__order__(th,ot);
  }
}
class ReflectOrderables{

}
class DefaultOrderable<T> implements Order<T>{
  public function new
}