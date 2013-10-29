package hx.sch;

import hx.ifs.Command in ICommand;

abstract Command<T>(ICommand<T>) from ICommand<T> to ICommand<T>{
  public function new(v){
    this = v;
  }
  public inline function apply(v:T):Void{
    this.apply(v);
  }
}