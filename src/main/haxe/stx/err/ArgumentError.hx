package stx.err;

class ArgumentError extends stx.Error{
  public function new(msg,?pos){
    super(msg,pos);
  }
}