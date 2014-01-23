package rx.join;

import stx.Fail;
import stx.Chunk;

import hx.Run;
import hx.Action;
import hx.ds.Queue;

import stx.reactive.dissolvable.*;
import rx.observer.*;
import rx.ifs.JoinObserver in IJoinObserver;
import rx.join.ActivePlan;

using rx.Observable;
using rx.internal.SubscribeSafe;

using stx.Iterables;

class JoinObserver<T> extends ObserverBase<Chunk<T>> implements IJoinObserver{
  public var disposed(default,null) : Bool;
  public var queue(default,null)    : Queue<Chunk<T>>;

  private var observable            : rx.Observable<T>;
  private var plans                 : List<ActivePlan>;
  private var subscription          : SingleAssignmentDissolvable;

  private var fail                  : Action<Fail>;
  private var done                  : Run;

  public function new(observable:Observable<T>,onFail:Action<Fail>){
    super();
    this.observable     = observable;
    this.fail           = onFail;
    this.queue          = new Queue();
    this.subscription   = new SingleAssignmentDissolvable();
    this.plans          = new List();
  }
  public function run(){
    subscription.dissolvable = observable.materialize().subscribeSafe(this);
  }
  public function dequeue(){
    queue.dequeue();
  }
  override private function onDataCore(chk:Chunk<T>){
    if(!disposed){
      switch (chk) {
        case End(f)   : onFail(f);
        default       :
      }
    }
    queue.enqueue(chk);
    plans.each(ActivePlans.match);
  }
  override private function onFailCore(f:Fail){}
  override private function onDoneCore(){}

  public function add(plan:ActivePlan){
    this.plans.add(plan);
  }
  public function rem(plan:ActivePlan){
    this.plans.remove(plan);
  }
  override private function disposal(disposing:Bool){
    super.disposal(disposing);
    if(!disposed){
      subscription.dispose();
      disposed = true;
    }
  }
}