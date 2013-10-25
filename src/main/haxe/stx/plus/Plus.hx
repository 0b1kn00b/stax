package stx.plus;

import stx.Prelude;

typedef Tool<T> = {
  order : OrderFunction<T>,
  equal : EqualFunction<T>,
  show  : ShowFunction<T>,
  hash  : HashFunction<T>,
}
class Plus<T>{
  @:noUsing static public inline function create<T>(t:Tool<T>):Plus<T>{
    return new Plus(
      t.order,
      t.equal,
      t.show,
      t.hash
    );
  }
  static public inline function tool<A>(?order:OrderFunction<A>,?equal:EqualFunction<A>,?hash:HashFunction<A>,?show:ShowFunction<A>):Tool<A>{
    return { order : order , equal : equal , show : show , hash : hash };
  }
  public function new(?order:OrderFunction<T>,?equal:EqualFunction<T>,?show:ShowFunction<T>,?hash:HashFunction<T>){
    this.order  = order;
    this.equal  = equal;
    this.show   = show;
    this.hash   = hash;
  }
  public inline function getOrder(v:T):OrderFunction<T>{
    if(order == null) this.order  = Order.getOrderFor(v);
    return order;
  }
  public inline function getEqual(v:T):EqualFunction<T>{
    if(equal == null) this.equal  = Equal.getEqualFor(v);
    return equal;
  }
  public inline function getShow(v:T):ShowFunction<T>{
    if(show == null) this.show  = Show.getShowFor(v);
    return show;
  }
  public inline function getHash(v:T):HashFunction<T>{
    if(hash == null) this.hash  = stx.plus.Hasher.getHashFor(v);
    return hash;
  }
  public inline function withOrder(o:OrderFunction<T>):Plus<T>{
    return new Plus(o,equal,show,hash);
  }
  public inline function withEqual(e:EqualFunction<T>):Plus<T>{
    return new Plus(order,e,show,hash);
  }
  public inline function withShow(s:ShowFunction<T>):Plus<T>{
    return new Plus(order,equal,s,hash);
  }
  public inline function withHash(h:HashFunction<T>):Plus<T>{
    return new Plus(order,equal,show,h);
  }
  private var order : OrderFunction<T>;
  private var equal : EqualFunction<T>;
  private var show  : ShowFunction<T>;
  private var hash  : HashFunction<T>;
}