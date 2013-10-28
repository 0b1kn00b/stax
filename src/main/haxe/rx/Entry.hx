package rx.ifs;

import stx.Tuples;
typedef EntryType = Tuple2<Task<Dynamic>,Mark>;

abstract Entry(EntryType) from EntryType to EntryType{
  @:noUsing static public function entry<T>(tsk:Task<T>,mrk:Mark):Entry<T>{
    return tuple2(tsk,mrk);
  }
  public function new(v){
    this = v;
  }
}