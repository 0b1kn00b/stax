package rx.join;

import Prelude;
import Stax.*;

using stx.Tuples;
using stx.Arrays;
using stx.Chunk;
using stx.Option;

import hx.Action;
import hx.Run;

import rx.ifs.JoinObserver in IJoinObserver;

class ActivePlan{
  private var observers : Array<IJoinObserver>;

  public function new(){
    observers = [];
  }
  public function add(observer:IJoinObserver){
    observers.push(observer);
  }
  public function dequeue(){
    observers.each(
      function(x){
        x.dequeue();
      }
    );
  }
  @:unimplemented
  public function match():Void{
    except()(ArgumentError('match',NullError()));
  }
}
class ActivePlans{
  static public function match<T>(plan:ActivePlan){
    plan.match();
  }
}
class ActivePlan1<T> extends ActivePlan{
  private var onData  : Action<T>;
  private var onDone  : Run;
  private var first   : JoinObserver<T>;

  public function new(first,onData,onDone){
    super();
    assert(first);assert(onData);assert(onDone);
    this.first     = first;
    this.onData    = onData;
    this.onDone    = onDone;
    this.add(first);
  }
  override public function match(){
    if(first.queue.size() > 0){
      var n1 = first.queue.peek();
      switch (n1) {
        case Nil    : onDone.run();
        case Val(v) : dequeue(); onData.apply(v);
        default     : dequeue(); 
      }
    }
  }
}
class ActivePlan2<T,U> extends ActivePlan{
  private var onData  : Action<Tuple2<T,U>>;
  private var onDone  : Run;
  private var first   : JoinObserver<T>;
  private var second  : JoinObserver<U>;

  public function new(first:JoinObserver<T>,second:JoinObserver<U>,onData,onDone){
    super();
    this.first  = first;
    this.second = second;
    this.onData = onData;
    this.onDone = onDone;
    add(first);
    add(second);
  }
  override public function match(){
    if(first.queue.size() > 0 && second.queue.size() > 0){
      var n1 = first.queue.peek();
      var n2 = second.queue.peek();
      switch (n1.sure().zip(n2.sure())){
        case Some(tp) : 
          dequeue();
          onData.apply(tp);
        case None     :
          onDone.run();
      }
    }
  }
}
class ActivePlan3<T,U,V> extends ActivePlan{
  private var onData  : Action<Tuple3<T,U,V>>;
  private var onDone  : Run;

  private var first   : JoinObserver<T>;
  private var second  : JoinObserver<U>;  
  private var third   : JoinObserver<V>;  

  public function new(first:JoinObserver<T>,second:JoinObserver<U>,third:JoinObserver<V>,onData,onDone){
    super();
    this.first  = first;
    this.second = second;
    this.third  = third;
    this.onData = onData;
    this.onDone = onDone;
    add(first);
    add(second);
    add(third);
  }
  override public function match(){
    if(first.queue.size() > 0 && second.queue.size() > 0 && third.queue.size() > 0){
      var n1 = first.queue.peek();
      var n2 = second.queue.peek();
      var n3 = third.queue.peek();
      switch (n1.sure().zip(n2.sure()).zipWith(n3.sure(),Tuples2.entuple)){
        case Some(tp) : 
          dequeue();
          onData.apply(tp);
        case None     :
          onDone.run();
      }
    }
  }
}
class ActivePlan4<T,U,V,W> extends ActivePlan{
  private var onData  : Action<Tuple4<T,U,V,W>>;
  private var onDone  : Run;

  private var first   : JoinObserver<T>;
  private var second  : JoinObserver<U>;  
  private var third   : JoinObserver<V>;  
  private var fourth  : JoinObserver<W>;

  public function new(first:JoinObserver<T>,second:JoinObserver<U>,third:JoinObserver<V>,fourth:JoinObserver<W>,onData,onDone){
    super();
    this.first  = first;
    this.second = second;
    this.third  = third;
    this.fourth = fourth;
    this.onData = onData;
    this.onDone = onDone;
    add(first);
    add(second);
    add(third);
    add(fourth);
  }
  override public function match(){
    if(first.queue.size() > 0 && second.queue.size() > 0 && third.queue.size() > 0 && fourth.queue.size() > 0){
      var n1 = first.queue.peek();
      var n2 = second.queue.peek();
      var n3 = third.queue.peek();
      var n4 = fourth.queue.peek();
      switch (n1.sure().zip(n2.sure()).zipWith(n3.sure(),Tuples2.entuple).zipWith(n4.sure(),Tuples3.entuple)){
        case Some(tp) : 
          dequeue();
          onData.apply(tp);
        case None     :
          onDone.run();
      }
    }
  }
}
class ActivePlan5<T,U,V,W,X> extends ActivePlan{
  private var onData  : Action<Tuple5<T,U,V,W,X>>;
  private var onDone  : Run;

  private var first   : JoinObserver<T>;
  private var second  : JoinObserver<U>;  
  private var third   : JoinObserver<V>;  
  private var fourth  : JoinObserver<W>;
  private var fifth   : JoinObserver<X>;

  public function new(first:JoinObserver<T>,second:JoinObserver<U>,third:JoinObserver<V>,fourth:JoinObserver<W>,fifth:JoinObserver<X>,onData,onDone){
    super();
    this.first  = first;
    this.second = second;
    this.third  = third;
    this.fourth = fourth;
    this.onData = onData;
    this.onDone = onDone;
    add(first);
    add(second);
    add(third);
    add(fourth);
    add(fifth);
  }
  override public function match(){
    if(first.queue.size() > 0 && second.queue.size() > 0 && third.queue.size() > 0 && fourth.queue.size() > 0 && fifth.queue.size() > 0){
      var n1 = first.queue.peek();
      var n2 = second.queue.peek();
      var n3 = third.queue.peek();
      var n4 = fourth.queue.peek();
      var n5 = fifth.queue.peek();
      switch (n1.sure().zip(n2.sure()).zipWith(n3.sure(),Tuples2.entuple).zipWith(n4.sure(),Tuples3.entuple).zipWith(n5.sure(),Tuples4.entuple)){
        case Some(tp) : 
          dequeue();
          onData.apply(tp);
        case None     :
          onDone.run();
      }
    }
  }
}