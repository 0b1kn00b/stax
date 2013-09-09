package pax;

import stx.Prelude.Option in StaxOption;

import funk.types.Option in FunkOption;
import funk.types.Option.OptionType in FunkOptionType;

class FunkOptions{
  
  static public function toStaxOption<T>(f:FunkOptionType<T>):StaxOption<T>{
    return switch (f) {
      case FunkOptionType.Some(v) : StaxOption.Some(v);
      case FunkOptionType.None    : StaxOption.None;
    }
  }
}