package hx.reactive.ds.imp;

import hx.evt.*;
import hx.reactive.ds.Array in AArray;

using stx.Arrays;

class Array<T> extends DefaultReactor<Collection<std.Array<T>,Int,T>>{
  private var array:std.Array<T>;

  public function new(?arr:std.Array<T>){
    super();
    this.array = arr == null ? [] : arr.copy();
  }
  public function get(i:Int):T{
    return this.array[i];
  }
  public function set(i:Int,v:T):Void{
    this.array[i] = v;
    emit(Add(v,i));
  }
  public function append(arr:std.Array<T>){
    this.array = this.array.concat(arr);
    emit(Chg(this.array.copy()));
  }
  public function prepend(arr:std.Array<T>){
    this.array = arr.concat(this.array);
    emit(Chg(this.array.copy()));
  }
  public function pop():T{
    var o = this.array.pop();
    emit(Rem(o,this.array.length));
    return o;
  }
  public function push(v:T):Int{
    this.array.push(v);
    emit(Add(v,this.array.length-1));
    return this.array.length;
  }
  public function reverse(){
    this.array.reverse();
    emit(Chg(this.array.copy()));
  }
  public function sort(fn){
    this.array.sort(fn);
    emit(Chg(this.array.copy()));
  }
  public function splice(pos:Int, len:Int){
    this.array.splice(pos,len);
    emit(Chg(this.array.copy()));
  }
  public function unshift(x:T){
    this.array.unshift(x);
    emit(Add(x,0));
  }
  public function shift():T{
    var o = this.array.shift();
    emit(Rem(o,0));
    return o;
  }
  public function insert(pos:Int,x:T){
    this.array.insert(pos,x);
    emit(Add(x,pos));
  }
  public function remove(v:T){
    var loc = this.array.indexOf(v);
    return if(loc!=-1){
      this.array.remove(v);
      emit(Rem(v,loc));
      true;
    }else{
      false;
    }
  }
  public function clear(){
    this.array = [];
    emit(Clr);
  }
  public function native():std.Array<T>{
    return array.copy();
  }
}