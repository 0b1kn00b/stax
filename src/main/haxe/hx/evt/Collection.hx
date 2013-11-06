package hx.evt;

@doc("
  Represents a change to a collection.
")
enum Collection<C,K,V>{
  Add(v:V,?k:K);
  Rem(v:V,?k:K);
  Chg(v:C);
  Clr;
}