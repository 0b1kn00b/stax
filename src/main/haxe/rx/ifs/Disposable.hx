package rx.ifs;

/**
  Represents an object which can be disposed.
*/
interface Disposable{
  public var disposed(default,null) : Bool;
  public function dispose():Void;
}