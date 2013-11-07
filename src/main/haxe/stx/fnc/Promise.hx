package stx.fnc;

import Prelude.Outcome in TOutcome;

abstract Promise<T>(Future<Outcome<T>>) from Future<Outcome<T>> to Future<Outcome<T>>{
  public function new(v){
    this = v;
  }
  public function retry(fn:Fail->Outcome<T>):Promise<T>{
    return this.map(
      function(e){
        return e.fold(
          Compose.pure(),
          fn
        );
      }
    );
  }
}