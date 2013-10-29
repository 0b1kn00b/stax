package stx;
enum LogLevel {
	Debug; 
	Info;
	Warning;
	Error;
	Fatal;
}
class LogLevels{
  static public function toInt(ll:LogLevel):Int{
    return switch (ll) {
      case Debug    : 0;
      case Info     : 1;
      case Warning  : 2;
      case Error    : 3;
      case Fatal    : 4;
    }
  }
}