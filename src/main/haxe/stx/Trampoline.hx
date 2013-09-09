package stx;

//from scuts

enum Bounce<A> {
  Done(result:A);
  Call(thunk : Void->Bounce<A>);
}

class Trampolines {
  public static function trampoline<A>(bounce:Bounce<A>):A {
    return switch (bounce){
      case Done(x): x;
      case Call(thunk): trampoline(thunk());
    }
  }
}