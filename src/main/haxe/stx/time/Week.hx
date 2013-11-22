package stx.time;

enum Week{
  Sunday;
  Monday;
  Tuesday;
  Wednesday;
  Thursday;
  Friday;
  Saturday;
}

class Weeks{
  static public function toInt(d:Week):Int{
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