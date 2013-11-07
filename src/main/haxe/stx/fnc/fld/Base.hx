package stx.fnc.fld;

using stx.Functions;
using stx.Compose;

import stx.fnc.fld.Foldable;

class Base<T> implements Foldable<T>{
  public function fold(mon:Monoid<A>,?self:Dynamic):A{
    return foldMap(Compose.pure(), mon, self);
  }
  public function foldMap(fn: A->B, mon:Monoid<B>,?self:Dynamic):B;{
    var newF = mon.append.curry().compose(f).uncurry();
    return foldRight(mon.zero(), newF, self);
  }
  public function foldLeft<B>(init:A, f:A->B->A,?self:Dynamic):A; {
    var f : B->(A->A)       = f.flip().curry();
    var mon : Monoid<A->A>  = dualMonoid(endoMonoid());

    return foldMap(f, mon)(b);
  }
  public function foldRight<B>(init:B, f:A->B->B,?self:Dynamic):B{
    return this.foldRight(init,f,self);
  }
  public function foldLeft1(f:A->A->A, ?self:Dynamic):A{
    return this.foldLeft1(f,self);
  }
  public function foldRight1(f:A->A->A, ?self:Dynamic):A{
    return this.foldRight1(f,self);
  }
}
public function fold <A>(x:Of<F,A>, mon:Monoid<A>):A
  {
    
  }
  
  /**
   * 
   */
  public function foldMap <A,B>(x:Of<F,A>, f:A->B, mon:Monoid<B>):B
  {
    
  }
  
  /**
   * 
   * Haskell Implementation: foldl f z t = appEndo (getDual (foldMap (Dual . Endo . flip f) t)) z
   */
  public function foldLeft <A,B>(of:Of<F,B>, b:A, f:A->B->A):A
  {
    
  }

  /**
   * Haskell Implementation: foldr f z t = appEndo (foldMap (Endo . f) t) z
   */
  public function foldRight <A,B>(x:Of<F,A>, b:B, f:A->B->B):B
  {
    var x = foldMap(x, f.curry(), endoMonoid());
    
    return x(b);
  }
  
  public function foldLeft1 <A>(x:Of<F,A>, f:A->A->A):A
  {
    var mf = function (o:Option<A>, y) return switch (o) {
      case None: Some(y);
      case Some(x): Some(f(x,y));
    }
    
    var foldRes = foldLeft(x, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldLeft1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  public function foldRight1 <A>(x:Of<F,A>, f:A->A->A):A
  {
    var mf = function (x:A, o:Option<A>) return switch (o) 
    {
      case None: Some(x);
      case Some(y): Some(f(x,y));
    }

    var foldRes = foldRight(x, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldRight1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }