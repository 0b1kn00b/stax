package stx.async.dissolvable;

using stx.Arrays;
using stx.Iterables;

import hx.ds.Set;

import stx.async.Dissolvable;
import stx.async.ifs.Dissolvable in IDissolvable;

@doc("Represents a group of dissolvable resources that are dissolved together.")
class CompositeDissolvable implements IDissolvable{
  public var dissolved(default,null) : Bool;
  private var dissolvables : Array<Dissolvable>;

  public function new(?dissolvables){
    this.dissolvables = dissolvables == null ? [] : dissolvables;  
  }
  public function dissolve(){
    if(!dissolved){
      dissolved = true;
      this.each(
        function(x){
          x.dissolve();
        }
      );
    }
  }
  public function add(dissolvable:Dissolvable){
    var shouldDispose = dissolved;

    if (!dissolved){
        dissolvables.add(dissolvable);
    }
    if(shouldDispose){
      dissolvable.dissolve();
    }
  }
  public function rem(dissolvable:Dissolvable){
    var shouldDispose = dissolved;

    if (!dissolved){
      shouldDispose = dissolvables.remove(dissolvable);
    }
    if(shouldDispose){
      dissolvable.dissolve();
    }
  }
  public function size():Int{
    return dissolvables.length;
  }
  public function clear(){
    dissolvables.each(Dissolvables.dissolve);
    dissolvables = [];
  }
  public function contains(v:Dissolvable):Bool{
    return dissolvables.indexOf(v) != -1;
  }
  public function iterator():Iterator<Dissolvable>{
    return dissolvables.iterator();
  }
}