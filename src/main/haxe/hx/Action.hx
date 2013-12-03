package hx;

import hx.action.AnonymousAction;

import hx.ifs.Action in IAction;

abstract Action<T>(IAction<T>) from IAction<T> to IAction<T>{
  public function new(v){
    this = v;
  }
  public function apply(v:T):Void{
    this.apply(v);
  }
  @:from static public function fromAnonymousAction<T>(v:T->Void):Action<T>{
    return new AnonymousAction(v);
  }
}