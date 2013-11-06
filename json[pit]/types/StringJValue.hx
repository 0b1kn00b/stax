package stx.io.json.types;
import stx.io.json.Transcode;
using Std;

class StringJValue extends AbstractTranscode<String,Void>{
  public function new(){}
	override public function decompose(v: String): JValue {
    return JString(v);
  }
  override public function extract(val: JValue): String {
    return switch(val) {
      case JNumber(v)   : '$v'.format();
      case JBool(v)     : '$v'.format();
      case JString(v)   : v;

      default: except()("Expected String but found: " + val);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(String)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(String)).decompose;
  }
}