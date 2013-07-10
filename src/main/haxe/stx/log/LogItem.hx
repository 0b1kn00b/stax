package stx.log;

class LogItem {
  public function new(level, value) {
    this.level = level;
    this.value = value;
  }
  public function toString() {
    return level + '[ ' + value + ' ]';
  }
  public var level : LogLevel;
  public var value : Dynamic;
}