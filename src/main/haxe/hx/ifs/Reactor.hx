package hx.ifs;

import stx.utl.Selector;

/**
  The reactor makes use of Haxe's enumerations, typically building an Enum

  ```
  enum SomeEvent{
    EventType(data:Type)
  }
  ```
  and then building a Selector, usually using `Enums.alike` which would, in this example check only EventType and pass any `data`.
  This allows both highly specific and very general filters to be built easily.

  To get any event dispatched, use `Reactors.any()`
*/
interface Reactor<I> extends Receiver<I>{
  private function emit(event:I):Bool;
}
