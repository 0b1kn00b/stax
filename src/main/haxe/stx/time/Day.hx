package stx.time;

enum Day{
  Sunday;
  Monday;
  Tuesday;
  Wednesday;
  Thursday;
  Friday;
  Saturday;
}
class Days{
  static public function toInt(d:Day):Int{
    return switch (d) {
      case Sunday    : 0;
      case Monday    : 1;
      case Tuesday   : 2; 
      case Wednesday : 3;   
      case Thursday  : 4;  
      case Friday    : 5;
      case Saturday  : 6;  
    }
  }
}