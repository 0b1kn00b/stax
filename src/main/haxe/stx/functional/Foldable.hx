package stx.functional;

/** 
  A structure that can be folded over. The type system cannot enforce it, but
  a structure that implements this interface should specify its own type as the
  first type parameter; e.g.: Set<T> implements Foldable<Set<T>, T>
 */
interface Foldable<A, B> {
  /** Creates an "empty" version of the foldable structure. */    
  function empty<C, D>() : Foldable<C, D>;  
  
  /** Append a value to the specified foldable and returns the result. */
  function add(b: B): A;
  
  /** Left folds over the structure. */
  function foldl<T>(t: T, f: T -> B -> T): T;
}