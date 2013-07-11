package stx.rct;

import stx.Prelude;
import stx.rct.Pulse;
import stx.rct.Propagation;
import stx.rct.Stream;
import stx.Functions;

using stx.ds.List;
using stx.Options;

class StreamValues<T> {

    private var _lazyOption : Option<Thunk<List<T>>>;

    public function new(lazyOption : Option<Thunk<List<T>>>) {
        _lazyOption = lazyOption;
    }

    public function iterator() : Iterator<T> {
      return getList().iterator();
    }

    public function size() : Int return getList().size();

    inline private function getList() : List<T> return _lazyOption.getOrElse(function() return function() return List.create())();
}
