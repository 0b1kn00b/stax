package hx.evt;

enum ProcessEvent<A,B>{
  Init;
  Info(a:A);
  Done(b:B);
}