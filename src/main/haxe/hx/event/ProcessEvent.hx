package hx.event;

enum ProcessEvent<A,B>{
  Init;
  Info(a:A);
  Done(b:B);
}