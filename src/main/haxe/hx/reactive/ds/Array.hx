package hx.reactive.ds;

import hx.reactive.ds.imp.Array in CArray;

abstract Array<T>(CArray<T>) from CArray<T> to CArray<T>{
  @:from static public function fromArray<T>(arr:std.Array<T>):Array<T>{
    return new CArray(arr);
  }
  public function new(?v){
    this = v == null ? new CArray() : v;
  }
  public function get(i:Int):T{
    return this.get(i);
  }
  public function set(i:Int,v:T):Void{
    this.set(i,v);
  }
  public function append(arr:Array<T>){
    this.append(arr.native());
  }
  public function prepend(arr:Array<T>){
    this.prepend(arr.native());
  }
  public function pop():T{
    return this.pop();
  }
  public function push(v:T):Int{
    return this.push(v);
  }
  public function reverse(){
    this.reverse();
  }
  public function sort(f){
    this.sort(f);
  }
  public function splice(pos:Int, len:Int){
    this.splice(pos,len);
  }
  public function unshift(x:T){
    this.unshift(x);
  }
  public function shift():T{
    return this.shift();
  }
  public function insert(pos:Int,x:T){
    this.insert(pos,x);
  }
  public function remove(v:T){
    return this.remove(v);
  }
  public function clear(){
    this.clear();
  }
  public function native():std.Array<T>{
    return this.native();
  }
}