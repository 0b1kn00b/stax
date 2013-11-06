package stx.impl;

import stx.ifs.Container in IContainer;

class DefaultContainer<T> implements IContainer<T>{
  public function new(data:T){
    this.data = data;
  }
  @:isVar public var data(get, set):T;
  inline function get_data():T{ 
    return data; 
  }
  inline function set_data(value:T):T{
    return data = value;
  }
}