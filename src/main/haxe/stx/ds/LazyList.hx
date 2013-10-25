package stx.ds;

import Stax.*;
import stx.Compare.*;
import stx.Fail;

import hx.ds.ifs.*;
import stx.Prelude;
import stx.plus.Plus;
import stx.plus.Equal;

using stx.Options;
using stx.Compose;
using stx.Iterables;
using stx.Iterators;
using stx.Prelude;

enum LazyListType<T>{
  Nil;
  Cons(x:T,xs:LazyListType<T>);
}
/**
  Constructor Variations
*/
enum LazyListConstructorOptions<T>{
  EmptyLazyList(?tool:Plus<T>);
  LazyListFromIterable(it:Iterable<T>,?tool:Plus<T>);
  LazyListFromListType(l:LazyListType<T>,?size:Int,?tool:Plus<T>);
}
/**
  Abstract type for lifting of values to LazyList type.
*/
abstract LazyList<T>(LazyListInstance<T>) from LazyListInstance<T> to LazyListInstance<T>{
  public function new(?v){
    this = nl().apply(v) ? new LazyListInstance(EmptyLazyList()) : v;
  }
  @:from static public function fromIterable<T>(itr:Iterable<T>):LazyList<T>{
    return new LazyListInstance(LazyListFromIterable(itr));
  }
  @:from static public function fromArray<T>(arr:Array<T>):LazyList<T>{
    return new LazyListInstance(LazyListFromIterable(arr));
  }
  @:from static public function fromListType<T>(lst:LazyListType<T>):LazyList<T>{
    return new LazyListInstance(LazyListFromListType(lst));
  }
  @:from static public function fromLazyListConstructorOptions<T>(opt:LazyListConstructorOptions<T>):LazyList<T>{
    return new LazyListInstance(opt);
  } 
  @:from static public function fromT<T>(v:T):LazyList<T>{
    var ar = [v];
    var ip = LazyListFromIterable(ar);
    var ls = new LazyListInstance(ip);
    return ls;
  }
  public function cons(v:T):LazyList<T>{
    return LazyLists.cons(this.value,v);
  }
  public function foldl<Z>(memo:Z,fn:Z->T->Z):Z{
    return LazyLists.foldl(this.value,memo,fn);
  }
  public function reverse():LazyList<T>{
    return LazyLists.reverse(this.value);
  }
  public function foldr<Z>(memo:Z,fn:T->Z->Z):Z{
    return LazyLists.foldr(this.value,memo,fn);
  }
  public function hasValues():Bool{
    return LazyLists.hasValues(this.value);
  }
  public function headOption():Option<T>{
    return LazyLists.headOption(this.value);
  }
  public function head():Null<T>{
    return LazyLists.head(this.value);
  }
  public function append(xs:LazyList<T>):LazyList<T>{
    return this.append(xs).setValTool(val_tool);
  }
  public function add(x:T):LazyListInstance<T>{
    return this.add(x).setValTool(val_tool);
  }
  public function prepend(ls:LazyList<T>):LazyList<T>{
    var ls0 : LazyList<T> = LazyLists.prepend(this.value,ls.value);
    return ls0.setValTool(val_tool);
  }
  public function map<U>(fn:T->U):LazyList<U>{
    return this.map(fn);
  }
  public function flatMap<U>(fn:T->LazyList<U>):LazyList<U>{
    return this.flatMap(fn);
  }
  public function foreach(fn:T->Void):LazyList<T>{
    return this.foreach(fn);
  }
  public function toString(){
    return this.toString();
  }
  public var val_tool(get,set):Plus<T>;
  private function get_val_tool():Plus<T>{
    return this.val_tool;
  }
  private function set_val_tool(pls:Plus<T>):Plus<T>{
    return this.val_tool = pls;
  }
  public function setValTool(pls:Plus<T>):LazyList<T>{
    return this.setValTool(pls);
  }
  public var value(get,set):LazyListType<T>;
  private function get_value():LazyListType<T>{
    return this.value;
  }
  private function set_value(pls:LazyListType<T>):LazyListType<T>{
    return this.value = pls;
  }
  public function asEnumerable(){
    return this;
  }
  public function equals(l:LazyList<T>):Bool{
    return val_tool.getEqual(cast this)(cast this,cast l);
  }
}
/**
  Enumerator / Iterators
*/
class LazyListEnumerator<T> implements Enumerator<T>{
  private var memo : LazyListType<T>;

  public function new(lst:LazyListType<T>){
    memo = lst;
  }
  public function next():T{
    return switch (memo) {
      case Nil          : except()(fail(OutOfBoundsFail()));
      case Cons(x,xs)   : 
        memo = xs;
        x;
    }
  }
  public function hasNext():Bool{
    return switch (memo) {
      case Nil  : false;
      default   : true;
    }
  }
}
/** 
  List Instance
*/
class LazyListInstance<T> implements Enumerable<T>{
  static public function unit<T>():LazyListInstance<T>{
    return new LazyListInstance(EmptyLazyList());
  }
  @:isVar public var size(default,null) : Int;

  public function new(opts:LazyListConstructorOptions<T>){
    var tl = Options.create.then( Options.getOrElse.bind(_,function()return new Plus()));
    switch (opts) {
      case EmptyLazyList(tool)              :
        this.size     = 0;
        this.val_tool = tl(tool);
        this.value    = Nil;
      case LazyListFromIterable(it,tool)    :
        this.size     = it.size();
        this.val_tool = tl(tool);
        this.value    = 
          it.reversed().foldl(new LazyListInstance(EmptyLazyList(tool)),
            function(memo,next){
              return memo.cons(next);
            }
          ).value;
      case LazyListFromListType(ls,size,tool)   :
        this.val_tool = tl(tool);
        this.size     = size;
        this.value    = ls;
    }
  }
  public function iterator():Iterator<T>{
    var itr : Iterator<T> = new LazyListEnumerator(value);
    return itr;
  }
  public function cons(v:T):LazyList<T>{
    return new LazyListInstance(LazyListFromListType(Cons(v,value),size+1,val_tool));
  }
  public function foldl<Z>(memo:Z,fn:Z->T->Z):Z{
    return LazyLists.foldl(value,memo,fn);
  }
  public function reverse():LazyList<T>{
    return new LazyListInstance(LazyListFromListType(LazyLists.reverse(value)));
  }
  public function foldr<Z>(memo:Z,fn:T->Z->Z):Z{
    return LazyLists.foldr(value,memo,fn);
  }
  public function hasValues():Bool{
    return LazyLists.hasValues(value);
  }
  public function headOption():Option<T>{
    return LazyLists.headOption(value);
  }
  public function head():Null<T>{
    return LazyLists.head(value);
  }
  public function append(xs:LazyList<T>):LazyListInstance<T>{
    var lst : LazyList<T> = LazyLists.append(this.value,untyped xs.value);
    return lst.setValTool(val_tool);
  }
  public function add(x:T):LazyListInstance<T>{
    var l : LazyList<T>  = LazyLists.add(this.value, untyped xs.value);
    return l.setValTool(val_tool);
  }
  public function prepend(ls:LazyList<T>):LazyListInstance<T>{
    var l : LazyList<T>  = LazyLists.prepend(this.value,untyped ls.value);
    return l.setValTool(val_tool);
  }
  public function map<U>(fn:T->U):LazyListInstance<U>{
    var l : LazyList<U>  = LazyLists.map(value,fn);
    return l;
  }
  public function flatMap<U>(fn:T->LazyList<U>):LazyListInstance<U>{
    var l : LazyList<U>  = LazyLists.flatMap(this.value,fn.then(function(x) return x));
    return l;
  }
  public function foreach(fn:T->Void){
    var l : LazyList<T>  = LazyLists.foreach(value,fn);
    return l;
  }
  public function toString(){
    var shw = null;
    switch (value) {
      case Cons(x,_) : shw = val_tool.getShow(x);
      case Nil       : shw = val_tool.getShow(null);
    }
    return LazyLists.show(value,shw);
  }
  @:allow(stx.ds)
  private var value     : LazyListType<T>;
  @:allow(stx.ds)
  private var val_tool  : Plus<T>;

  public function setValTool(vlt:Plus<T>):LazyList<T>{
    return LazyListFromListType(value,size,vlt);
  }
  public function enumerator(){
    return new LazyListEnumerator(this.value);
  }
  public function equals(l:LazyList<T>){
    return Equal.getEqualFor(this.value)(value,l.value);
  }
}
/**
  Actual implementation of functions
*/    
class LazyLists {
  static public inline function hasValues<T>(lst:LazyListType<T>):Bool{
    return switch (lst) {
      case Nil  : false;
      default   : true;
    }
  }
  static public inline function reverse<T>(lst:LazyListType<T>):LazyListType<T>{
    function recursive(p:LazyListType<T>, stack) {
      return switch(p) {
          case Cons(head, tail): recursive(tail, Cons(head, stack));
          case _: stack;
      }
    }
    return recursive(lst, Nil);
  }
  static public inline function headOption<T>(lst:LazyListType<T>):Option<T>{
    return switch (lst) {
      case Nil        : None;
      case Cons(x,_)  : Some(x);
    }
  }
  static public inline function head<T>(lst:LazyListType<T>):Null<T>{
    return headOption(lst).getOrElseC(null);
  }
  static public inline function tail<T>(lst:LazyListType<T>):LazyListType<T>{
    return switch (lst) {
      case Cons(_,xs)   : xs;
      default           : Nil;
    }
  }
  static public function append<T>(lst : LazyListType<T>, xs : LazyListType<T>) : LazyListType<T> {
    var result  = xs;
    var p       = lst;

    var stack   = reverse(p);
    while(hasValues(stack)) {
        result  = Cons(head(stack), result);
        stack   = tail(stack);
    }
    return result;
  }
  static public function prepend<T>(lst : LazyListType<T>,xs : LazyListType<T>) : LazyListType<T> {
    var result  = lst;

    while(hasValues(xs)) {
      result = Cons(head(xs), result);
      xs = tail(xs);
    }

    return result;
  }
  static public function add<T>(lst:LazyListType<T>,x:T):LazyListType<T>{
    return append(lst,Cons(x,Nil));
  }
  static public function cons<T>(lst:LazyListType<T>,x:T):LazyListType<T>{
    return prepend(lst,Cons(x,Nil));
  }
  static public function foldl<Z,T>(lst:LazyListType<T>,memo:Z,fn:Z->T->Z):Z{
    var accum = lst;
    var o     = memo;
    while(true){
      switch (accum) {
        case Cons(x,xs) : o = fn(o,x); accum = xs;
        case Nil        : break;
      }
    }
    return o;
  }
  static public function foldr<Z,T>(lst:LazyListType<T>,memo:Z,fn:T->Z->Z):Z{
    var ls : Iterator<T> = new LazyListEnumerator(lst);
    var a   = ls.toArray();
    var acc = memo;

    for (i in 0...ls.size()) {
      var e = a[a.size() - 1 - i];
      acc = fn(e, acc);
    }

    return acc;
  }
  static public function map<T,U>(lst:LazyListType<T>,fn:T->U):LazyListType<U>{
    return foldr(lst,
      Nil,
      function(next,memo){
        return Cons(fn(next),memo);
      }
    );
  }
  static public function flatMap<T,U>(lst:LazyListType<T>,fn:T->LazyList<U>):LazyListType<U>{
    var memo = Nil;
    var p    = lst;
    while (hasValues(p)) {
      var h = head(p);
      var n = fn(h);
      memo = prepend(memo, cast n);
      p = tail(p);
    }

    return reverse(memo);
  }
  static public function foreach<T>(lst:LazyListType<T>,fn:T->Void):LazyListType<T>{
    return map(lst,
      function(x){
        fn(x);
        return x;
      }
    );
  }
  static public function show<T>(lst:LazyListType<T>,fn:T->String):String{
    return foldl(lst,
      '',
      function(memo,next){
        return '$memo ${fn(next)}';
      }
    );
  }
}