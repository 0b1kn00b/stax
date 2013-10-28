package stx.rct.evt;

@doc("
  Represents a change to a collection.
")
enum CollectionEvent<T>{
  Add(v:T);
  Rem(v:T);
  Chg;
}