package stx.io.json.types;


import stx.io.json.Transcode;

class FloatJValue extends AbstractTranscode<Float,Void>{
  public function new(){

  }
  override public function decompose(v: Float): JValue{
    return JNumber(v);
  }
  override public function extract(v: JValue): Float{
    return switch(v) {
      case JNumber(v): v;
      case JString(v): Std.parseFloat(v);

      default: Prelude.error("Expected Float but found: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(Float)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(Float)).decompose;
  }
}