package hx.sch.cmd;

import hx.ifs.Command in ICommand;

class AnonymousCommand<T> implements ICommand{
  private var method : T -> Void;
  public function new(method){
    this.method = method;
  }
  public inline function apply(v:T){
    this.method(v);
  }
}