package stx.rx.ifs;

/**
  Represents an object which can be disposed.
*/
interface Disposable{
  private var disposed : Bool;
  public function dispose():Void;
}