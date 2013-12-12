package hx.ifs;

import Prelude;

import hx.ifs.Run in IRun;
import rx.ifs.Observable in IObservable;

@doc("Represents an identifyable process.")
interface Task extends IRun extends IObservable<Unit>{
  public var id(default,null) : Int;

  public var running(default,null) : Bool;
}