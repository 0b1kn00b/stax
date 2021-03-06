package stx.rtti;

import Prelude;
import Stax.*;

import haxe.rtti.CType;

using stx.Option;
using stx.Compose;

class Classdefs{
  static public function ancestors(v:Classdef):Option<Array<Classdef>>{
    var _ancestors : Classdef -> Array<Classdef> -> Option<Array<Classdef>>= null;
        _ancestors = function(v:Classdef,a:Array<Classdef>):Option<Array<Classdef>>{
          a.push(v);
          if(v.superClass == null) return Some(a);
          return Options.create(v.superClass)
            .map(function(x) return x.path)
            .flatMap(Types.classify.then(option))
            .flatMap(RTypes.typetree)
            .flatMap(TypeTrees.classdef)
            .flatMap(_ancestors.bind(_,a));
        } 
    return _ancestors(v,[]);
  }
}