package stx.async.ifs;

/**
  Represents an object which can be disposed.
*/
interface Dissolvable{
  public var dissolved(default,null) : Bool;
  public function dissolve():Void;
}