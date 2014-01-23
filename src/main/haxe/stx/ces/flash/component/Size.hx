package stx.ces.flash.component;

typedef SizeType = {
  var name   : Void -> String;
  var width  : Float;
  var height : Float;
}
class Sizes{
  static public function unit():SizeType{
    return {
      name      : function() { return  'size'; },
      width     : 0.0,
      height    : 0.0
    }
  }
}