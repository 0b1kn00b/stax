package stx.ces.flash.component;

typedef PositionType = {
  var name : Void -> String;
  var x    : Float;
  var y    : Float;
}
class Positions{
  static public function unit():PositionType{
    return {
      name : function() { return  'position'; },
      x    : 0.0,
      y    : 0.0
    }
  }
}