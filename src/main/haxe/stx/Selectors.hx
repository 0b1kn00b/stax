package stx;

class Selectors{
  static public function count<T>(n:Int):T->Bool{
    var ct = 0;
    return function(v:T):Bool{
      return ct++ == n ? false : true;
    }
  }
}