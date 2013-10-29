package hx.rct.evt;

enum ProcessEvent<A,B>{
  Init;
  Info(a:A);
  Done(b:B);
}