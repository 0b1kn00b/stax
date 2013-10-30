package hx.utl;

using stx.Maths;

class RetreatTimer{
  private var min     : Float;
  private var max     : Float;
  private var mul     : Float;
  private var current : Float;

  public function new(min=0.00001,max=4,mul=1.8){
    this.current  = min;
    this.min      = min;
    this.max      = max;
    this.mul      = mul;
  }
  public function reset(){
    this.current  = min;
  }
  public function step():Void{
    this.current  = (this.current*mul).clamp(min,max);
  }
  public function next():Float{
    step();
    return this.current;
  }
}