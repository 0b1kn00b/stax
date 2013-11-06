package stx.fnc.ifs;

interface Box<T>{
  function unbox():Dynamic;
  function box(v:Dynamic):T;
}