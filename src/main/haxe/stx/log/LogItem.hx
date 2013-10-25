package stx.log;

import stx.utl.TaggedValue;

class LogItem extends TaggedValue<LogLevel,Dynamic>{
  public function new(level, value) {
    super(level,value);
  }
  public function toString() {
    return tag + '[ ' + val + ' ]';
  }
}