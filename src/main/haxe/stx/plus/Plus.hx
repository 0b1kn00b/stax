package stx.plus;

import Prelude;

typedef Tool<T> = {
  order : Reduce<T,Int>,
  equal : Reduce<T,Bool>,
  hash  : T->Int,
  show  : T->String,
}
class Plus<T>{
  @:noUsing static public inline function create<T>(t:Tool<T>):Plus<T>{
    return new Plus(
      t.order,
      t.equal,
      t.hash,
      t.show
    );
  }
  static public inline function tool<A>(?order:Reduce<A,Int>,?equal:Reduce<A,Bool>,?hash:A->Int,?show:A->String):Tool<A>{
    return { order : order , equal : equal , show : show , hash : hash };
  }
  public function new(?order:Reduce<T,Int>,?equal:Reduce<T,Bool>,?hash:T->Int,?show:T->String){
    this.order  = order;
    this.equal  = equal;
    this.hash   = hash;
    this.show   = show;
  }
  public inline function getOrder(v:T):Reduce<T,Int>{
    if(order == null) this.order  = Order.getOrderFor(v);
    return order;
  }
  public inline function getEqual(v:T):Reduce<T,Bool>{
    if(equal == null) this.equal  = Equal.getEqualFor(v);
    return equal;
  }
  public inline function getHash(v:T):T->Int{
    if(hash == null) this.hash  = stx.plus.Hasher.getHashFor(v);
    return hash;
  }
  public inline function getShow(v:T):T->String{
    if(show == null) this.show  = Show.getShowFor(v);
    return show;
  }
  public inline function withOrder(o:Reduce<T,Int>):Plus<T>{
    return new Plus(o,equal,hash,show);
  }
  public inline function withEqual(e:Reduce<T,Bool>):Plus<T>{
    return new Plus(order,e,hash,show);
  }
  public inline function withShow(s:T->String):Plus<T>{
    return new Plus(order,equal,hash,s);
  }
  public inline function withHash(h:T->Int):Plus<T>{
    return new Plus(order,equal,h,show);
  }
  private var order : Reduce<T,Int>;
  private var equal : Reduce<T,Bool>;
  private var hash  : T->Int;
  private var show  : T->String;
}