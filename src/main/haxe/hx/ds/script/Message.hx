package hx.ds.script;

@:note("From the Scala standard library")
enum Message<T>{
  Update(v:T,?lc:Location);
  Remove(v:T,?lc:Location);
  Include(v:T,?lc:Location);
  Reset;
  Script(vals:Array<Message<T>>);
}