package stx;

enum DelegateType<T>{
  Now(now:T);
  Later(later:Eventual<T>);
}
abstract Delegate<T>(DelegateType<T>) from DelegateType<T> to DelegateType<T>{
  public function new(v){
    this = v;
  }
  @:from public static inline function fromEventual<T>(v:Eventual<T>):Delegate<T>{
    return Later(v);
  }
  @:from public static inline function fromImmediate<T>(v:T):Delegate<T>{
    return Now(v);
  }
  public function unify():Eventual<T>{
    return switch (this) {
      case Now(v)   : Eventual.pure(v);
      case Later(v) : v;
    }
  }
}