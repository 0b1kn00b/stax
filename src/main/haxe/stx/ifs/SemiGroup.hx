package stx.ifs;

typedef SemiGroupType<T> = {
  function append(a:T,b:T):T;
}
interface SemiGroupOps<T>{
  public var ops : SemiGroupType<SemiGroupOps<T>>;
}
abstract SemiGroup<T>(SemiGroupOps<T>) from SemiGroupOps<T> to SemiGroupOps<T>{
  public function new(v){
    this = v;
  }
  public function append(v:SemiGroup<T>):SemiGroup<T>{
    return this.ops.append(this,v);
  }
}