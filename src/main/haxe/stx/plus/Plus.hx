package stx.plus;

import stx.Prelude;

class Plus<T>{
  public function new(){}
  public function getOrder(v:T):OrderFunction<T>{
    if(order == null) this.order  = Order.getOrderFor(v);
    return order;
  }
  public function getEqual(v:T):EqualFunction<T>{
    if(equal == null) this.equal  = Equal.getEqualFor(v);
    return equal;
  }
  public function getShow(v:T):ShowFunction<T>{
    if(show == null) this.show  = Show.getShowFor(v);
    return show;
  }
  public function getHash(v:T):HashFunction<T>{
    if(hash == null) this.hash  = stx.plus.Hasher.getHashFor(v);
    return hash;
  }
  private var order : OrderFunction<T>;
  private var equal : EqualFunction<T>;
  private var show  : ShowFunction<T>;
  private var hash  : HashFunction<T>;
}