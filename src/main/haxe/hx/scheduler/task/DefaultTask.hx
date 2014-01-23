package hx.scheduler.task;

import stx.Chunk;

import Stax.*;
import Prelude;
import stx.async.Arrowlet;

using stx.Arrays;

import stx.reactive.observable.BufferedObservable;

import stx.async.dissolvable.*;
import stx.async.Dissolvable;

import stx.reactive.Observer;
import stx.reactive.Observable;

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
  public function subscribe(observer:Observer<Unit>):Dissolvable{
    this.state.each(function(x) observers.each(function(o) o.apply(x)));
    observers.push(observer);
    return new NullDissolvable();
  }
}