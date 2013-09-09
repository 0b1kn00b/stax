package stx.trt;

import traits.ITrait;

import stx.ifs.IData;

interface TData<T> extends ITrait{
  @:isVar public var data : T;
  private function get_data():T{
    return data;
  }
  private function set_data(v:T):T{
    return data = v;
  }
}