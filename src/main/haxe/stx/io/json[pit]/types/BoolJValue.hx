package stx.io.json.types;

import stx.io.json.Transcode;

class BoolJValue extends AbstractTranscode<Bool,Void>{
  public function new(){

  }
  override public function decompose(v: Bool): JValue {
    return JBool(v);
  }
  override public function extract(v: JValue): Bool {
    return switch(v) {
      case JBool(v): v;
      case JNumber(v): if (v == 0.0) false; else true;
      case JString(v): stx.Strings.toBool(v);

      default: Prelude.error("Expected Bool but found: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getEnumName(Bool)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getEnumName(Bool)).decompose;
  }
}