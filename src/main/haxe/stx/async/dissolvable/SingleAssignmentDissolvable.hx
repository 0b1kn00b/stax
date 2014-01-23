package stx.async.dissolvable;

import Prelude;
import stx.Fail;

import stx.async.ifs.Dissolvable in IDissolvable;

class SingleAssignmentDissolvable implements IDissolvable{
  public var dissolved(default,null)           : Bool;
  private var dissolvable                      : Dissolvable;
  
  public function get(){
    return dissolvable;
  }
  public function set(v:Dissolvable):Dissolvable{
    if (dissolvable!=null){
      throw IllegalOperationError('Can only assign SingleAssignmentDissolvable once');
    }
    return this.dissolvable = v;
  }
  public function new(){
    this.dissolved = false;
  }
  public function dissolve(){
    if(!dissolved){
      dissolved = true;
      dissolvable.dissolve();
      dissolvable = null;
    }
  }
}