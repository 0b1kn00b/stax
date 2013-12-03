package rx.ifs;

using stx.Arrays;

@doc("Represents a join pattern over observable sequences.")
class Pattern<T>{
  private var observable0 : Observable<T>;
  public function new(observable0){
    this.observable0 = observable0;
  }
  @doc("Creates a pattern that matches the current plan matches and when the specified observable sequences has an available value.")
  @params(["other Observable sequence to match in addition to the current pattern."])
  @return("Pattern that matches when all observable sequences in the pattern have an available value.")
  public function and<U>(other:Observable<T,U>):Pattern2<T,U>{
    return new Pattern2(this,other);
  };

  @doc("Matches when all observable sequences in the pattern (specified using a chain of and operators) have an available value and projects the values.")
  @params("selector Selector that will be invoked with available values from the source sequences, in the same order of the sequences in the pattern.")
  @return("Plan that produces the projected values, to be fed (with other plans) to the when operator.")
  public function then(selector):Plan<T> {
    return new Plan(this, selector);
  };

}
@doc("Represents a join pattern over observable sequences.")
class Pattern1<T,U>{
  public function new(observable0,observable1){
    super(observable0);
    this.observable1 = observable1;
  }
  @doc("Creates a pattern that matches the current plan matches and when the specified observable sequences has an available value.")
  @params(["other Observable sequence to match in addition to the current pattern."])
  @return("Pattern that matches when all observable sequences in the pattern have an available value.")
  public function and(observable:Observable<T>):Pattern<T>
  Pattern.prototype.and = function (other) {
      return new Pattern(this.add(other));
  };

  @doc("Matches when all observable sequences in the pattern (specified using a chain of and operators) have an available value and projects the values.")
  @params("selector Selector that will be invoked with available values from the source sequences, in the same order of the sequences in the pattern.")
  @return("Plan that produces the projected values, to be fed (with other plans) to the when operator.")
      Pattern.prototype.then = function (selector) {
        return new Plan(this, selector);
    };

}