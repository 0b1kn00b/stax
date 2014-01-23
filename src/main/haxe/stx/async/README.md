#Reactive Extensions in a Sunflower Seed. 
##(Hope 'n Sauce)

These statements are equivalent:

    interface Dissolvable{
      public function dispose():Void
    }

    typedef Dissolvable = Void->Void

This is the interface of Observer:

    interface Observer<T>{
      public function onData(v:T) : Void;
      public function OnError(error:Fail); //@see stx.Fail
      public function OnCompleted():Void;
    }

Which I would write as an enum and one function:

    enum Observed<T>{
      Next(v:T);
      Error(f:Fail);
      Done;
    }

    interface Observer<T>{
      public function on(v:Observed<T>):Void;
    }

My version looks like, because it has other uses:

    enum Chunk<V>{
      Val(v:V); //Next
      Nil;//Done
      End(?err:Fail);//Error
    }

which again, if you factor out the interface, looks like:

    interface Observer<T>{
      public function apply(v:Chunk<T>):Void;
    }
    typedef Observer   = Chunk<T> -> Void

And lastly, make the `Observable` functional:

    interface Observable<T>{
      public functon subscribe(obs:Observer<T>):Dissolvable
    }
    typedef Observable = Observer<T> -> Dissolvable

take the functional definition of `Dissolvable` and open it in `Observable`:

    typedef Observable<T> = Observer<T> -> (Void->Void)

like so, do the same for `Observer`.

    typedef Observable<T> = (Chunk<T> -> Void) -> (Void->Void)

which, if you change it very slightly:

    Chunk<T> -> Void (sort of equals) Chunk<T> -> (Void -> Void)

so: 

    typedef Observable<T> = (Chunk<T> -> (Void->Void)) -> (Void->Void)

where:

    typedef Niladic  = Void->Void;
    typedef Observable<T> = (Chunk<T>->Niladic) -> Niladic;

and if:
  
    typedef Continuation<A,R> = (A        -> R        ) -> R
    typedef Observable<T>     = (Chunk<T> -> Niladic) -> Niladic

then:

    typedef Observable<T> = Continuation<Chunk<T>,Void->Void>


Pig, meet lipstick, lipstick, pig.