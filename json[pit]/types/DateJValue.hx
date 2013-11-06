package stx.io.json.types;

import stx.io.json.Transcode;

class DateJValue extends AbstractTranscode<Date,Void> {
  public function new(){

  }
  override public function decompose(v: Date): JValue {
    return JNumber(v.getTime());
  }
  override public function extract(v: JValue): Date {
    return switch(v) {
      case JNumber(v): Date.fromTime(v);
      case JString(v): Date.fromTime(Std.parseInt(v));

      default: except()("Expected Number but found: " + v);
    }
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getClassName(Date)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getClassName(Date)).decompose;
  }
}