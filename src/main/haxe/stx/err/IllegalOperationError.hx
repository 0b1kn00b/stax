package stx.err;

import stx.Error;

class IllegalOperationError extends Error{
  public function new(?pos){
    super('illegal operation');
  }
}