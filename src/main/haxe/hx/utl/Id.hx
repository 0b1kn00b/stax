package hx.utl;

abstract Id(Int) from Int{
  public function new(v){
    this = v;
  }
  public inline function native():Int{
    return this;
  }
}
class IdCache{
  private var recycle : Array<Id>;
  private var index   : Int;

  public function new(){
    this.recycle  = [];
    this.index    = 0;
  }
  public function next():Id{
    return if(recycle.length > 0){
      recycle.pop();
    }else{
      var o : Id = index;
      index+=1;
      o;
    }
  }
  public function free(id:Id){
    recycle.push(id);
  }
}