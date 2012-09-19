package stx.io.json.types;
using Std;
import stx.io.json.Transcode;
class IntJValue extends AbstractTranscode<Int,Void>{
  public function new(){

  }
	override public function decompose(v: Int): JValue {
    return JNumber(v);
  }
  override public function extract(v: JValue): Int {
    return switch(v) {
      case JNumber(v): Std.int(v);
      case JString(v): Std.parseInt(v);

      default: Prelude.error("Expected Int but found: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(Int)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(Int)).decompose;
  }
}