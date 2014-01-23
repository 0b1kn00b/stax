package stx;

import stx.fnc.ifs.Monoid in IMonoid;
import stx.fnc.AnonymousMonoid;

@:scuts
abstract Monoid<T>(IMonoid<T>) from IMonoid<T> to IMonoid<T>{
  public function new(v){
    this = v;
  }
  public function append(a1:T, a2:T):T{
    return this.append(a1,a2);
  }
  public function zero():T{
    return this.zero();
  }
  @:from static public function fromArray<T>(cls:Class<Array<T>>):Monoid<Array<T>>{
    return new AnonymousMonoid(Arrays.unit,Arrays.append);
  }
}
class Monoids{

  /*static public function set(predicate:O->Bool,plus:O->I->O):O->I->O{
    return function(memo:O,next:I){
      return predicate(memo,next) ? memo : plus(memo,next);
    }
  }
  static public function select(){
    return function(memo:O,next:I){

    }
  }
  static public function from(fn:I->O,plus:O->I->O){
    return function(memo:O,next:I){
      return plus(memo,fn(next));
    }
  }*/
}