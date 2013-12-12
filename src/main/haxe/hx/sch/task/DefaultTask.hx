
package hx.sch.task;

import stx.Chunk;

import Stax.*;
import Prelude;
import stx.Arrowlet;

using stx.Arrays;

import rx.observable.BufferedObservable;

import rx.Disposable;
import rx.Observer;
import rx.Observable;

import hx.ifs.Task in ITask;

class DefaultTask implements ITask{

  static private var __id__;
  private static function __init__(){
    __id__ = 0;
  } 
  private var state                 : Array<Chunk<Unit>>;
  private var observers             : Array<Observer<Unit>>;

  public var running(default,null)  : Bool;
  public var id(default,null)       : Int;

  public function new(){
    this.id         = ++__id__;
    this.running    = false;
    this.state      = [];
    this.observers  = [];
  }
  public function run(){
    state.push(Val(Unit));
    observers.each(function(x) x.apply(Val(Unit)));
    state.push(Nil);
    observers.each(function(x) x.apply(Nil));
  }
  public function subscribe(observer:Observer<Unit>):Disposable{
    this.state.each(function(x) observers.each(function(o) o.apply(x)));
    observers.push(observer);
    return noop;
  }
}