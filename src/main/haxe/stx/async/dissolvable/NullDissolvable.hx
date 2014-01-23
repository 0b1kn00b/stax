package stx.async.dissolvable;

import Stax.*;
import Prelude;
import stx.reactive.ifs.*;

import stx.async.ifs.Dissolvable in IDissolvable;

class NullDissolvable extends AnonymousDissolvable{
  public function new(){
    super(function(){});
  }
}