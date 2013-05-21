package stx.parse;

import stx.Prelude;
import stx.ds.List;
import stx.Tuples.*;

using stx.Tuples;
using stx.Options;
										
import stx.parse.InputStream;

using stx.parse.Parser; 
using Lambda;

/**
 * ...
 * @author sledorze
 */

typedef Input<I> = {
  content : Enumerable<Dynamic,I>,
	store 	: Map<String,I>,
  offset : Int,
  memo : Memo
}

typedef Memo = {
  memoEntries : Map<String,MemoEntry>,
  recursionHeads: Map<String,Head>, // key: position (string rep)
  lrStack : List<LR>
}

enum MemoEntry {
  MemoParsed(ans : ParseResult<Dynamic,Dynamic>);
  MemoLR(lr : LR);
}

typedef MemoKey = String

typedef FailureStack = stx.ds.List<FailureMsg>
typedef FailureMsg = {
  msg : String,
  pos : Int
}

enum ParseResult<I,T> {
  Success(match : T, rest : Input<I>);
  Failure(errorStack : FailureStack, rest : Input<I>, isError : Bool);
}

typedef Parser<I,T> = Input<I> -> ParseResult<I,T>

typedef LR = {
  seed: ParseResult<Dynamic,Dynamic>,
  rule: Parser<Dynamic,Dynamic>,
  head: Option<Head>
}

typedef Head = {
  headParser: Parser<Dynamic,Dynamic>,
  involvedSet: List<Parser<Dynamic,Dynamic>>,
  evalSet: List<Parser<Dynamic,Dynamic>>
}

class ParserObj {
  // inline public static function castType<I,T, U>(p : Parser<I,T>) : Parser<I,U> return 
    // untyped p
}

class ResultObj {
  
  // inline public static function castType<I,T, U>(p : ParseResult<I,T>) : ParseResult<I,U> return 
    // untyped p
  
  public static function posFromResult<I,T>(p : ParseResult<I,T>) : Input<I>
    return switch (p) {
      case Success(_, rest)     :   rest;
      case Failure(_, rest, _)  :   rest;
    };
    
  public static function matchFromResult<I,T>(p : ParseResult<I,T>) 
    return switch (p) {
      case Success(x, _)    : Std.string(x);
      case Failure(_, _, _) : "";
    };
	
	public static function ok<I,T>(p:ParseResult<I,T>):Bool{
		return switch(p) {
			case Success(_, _) 		: true;
			case Failure(_, _, _) : false;
		};
	}
  public static function allOk<I,T>(p:ParseResult<I,T>):Bool{
    return switch (p) {
      case Success(_, rest) :
        rest.content.length == rest.offset;
      case Failure(_, _, _) : false;
    };
  }
	public static function matched<I,T>(p:ParseResult<I,T>):T{
		return switch(p) {
			case Success(match, _)	: match;
			case Failure(_, _, _) 	: null;
		};
	}
	public static function toString<I,T>(p:ParseResult<I,T>):String{
		return switch (p) {
			case Success(match, _) : '\n Success \n' + Std.string(match);
			case Failure(error, rest, _) :
					"\n" + Std.string(error) + "\n\n" + rest + "\n\n" + Std.string( untyped ReaderObj.take(rest) );
  	}
	}

}

class MemoObj {
  
  inline public static function updateCacheAndGet<I>(r : Input<I>, genKey : Int -> String, entry : MemoEntry) {
    var key = genKey(r.offset);
    r.memo.memoEntries.set(key, entry);    
    return entry;
  }
  public inline static function getFromCache<I>(r : Input<I>, genKey : Int -> String) : Option<MemoEntry> {
    var key = genKey(r.offset);
    var res = r.memo.memoEntries.get(key);
    return res == null?None: Some(res);
  }

  public inline static function getRecursionHead<I>(r : Input<I>) : Option<Head> {
    var res = r.memo.recursionHeads.get(r.offset + "");
    return res == null?None: Some(res);
  }
  
  public inline static function setRecursionHead<I>(r : Input<I>, head : Head) {
    r.memo.recursionHeads.set(r.offset + "", head);
  }

  public inline static function removeRecursionHead<I>(r : Input<I>) {
    r.memo.recursionHeads.remove(r.offset + "");
  }
  
  inline public static function forKey(m : Memo, key : MemoKey) : Option<MemoEntry> {
    var value = m.memoEntries.get(key);
    if (value == null) {
      return None;
    } else {
      return Some(value);
    }
  }
}

class ReaderObj {  
  inline public static function position<I>(r : Input<I>) : Int return
    r.offset;
  
  inline public static function take<I>(r : Input<I>, ?len : Int) : I {
    return r.content.range(r.offset, len);
  }
	inline public static function one<I>(r : Input<I>) : I {
		return r.content.at(r.offset);
	}
  inline public static function drop<I>(r : Input<I>, len : Int) : Input<I> {
    return {
      content : r.content,
      offset 	: r.offset + len,
      memo  	: r.memo,
			store 	: r.store
    };
  }
}

class FailureObj {
  inline public static function newStack(failure : FailureMsg) : FailureStack {
    var newStack = FailureStack.nil();
    return newStack.cons(failure);
  }
  inline public static function errorAt<I>(msg : String, pos : Input<I>) : FailureMsg {
    return {
      msg : msg,
      pos : pos.offset      
    };
  }
  inline public static function report(stack : FailureStack, msg : FailureMsg) : FailureStack {
    return stack.cons(msg);
  }
}

@:native("Parsers") class Parsers {
  
  public static function mkLR<I,T>(seed: ParseResult<I,Dynamic>, rule: Parser<I,T>, head: Option<Head>) : LR return {
    seed: seed,
    rule: cast(rule),
    head: head
  }
  
  public static function mkHead<I,T>(p: Parser<I,T>) : Head return {
    headParser: cast(p),
    involvedSet: List.nil(),
    evalSet: List.nil()
  }
  
  public static function getPos<I>(lr : LR) : Input<I> return 
    switch(lr.seed) {
      case Success(_, rest): rest;
      case Failure(_, rest, _): rest;
    }

  public static function getHead<I,T>(hd : Head) : Parser<I,T> return 
    cast (hd.headParser);
  
  public static function __init__(){
    _parserUid = 0;
  }  
  static var _parserUid;

  static function parserUid() {
    return ++_parserUid;
  }
  
  
  static function lrAnswer<I,T>(p: Parser<I,T>, genKey : Int -> String, input: Input<I>, growable: LR): ParseResult<I,T> {
    switch (growable.head) {
      case None: throw "lrAnswer with no head!!";
      case Some(head): 
        if (head.getHead() != p) /*not head rule, so not growing*/{
          return cast( growable.seed );
        } else {
          input.updateCacheAndGet(genKey, MemoParsed(growable.seed));
          switch (growable.seed) {
            case Failure(_, _, _) :
              return cast( growable.seed );
            case Success(_, _) :
              return grow(p, genKey, input, head); /*growing*/ 
          }
        }
    }
  }
  
  static function recall<I,T>(p : Parser<I,T>, genKey : Int -> String, input : Input<I>) : Option<MemoEntry> {
    var cached = input.getFromCache(genKey);
    switch (input.getRecursionHead()) {
      case None: return cached;
      case Some(head):
        if (cached == None && !(head.involvedSet.cons(head.headParser).contains(p))) {
          return Some(MemoParsed(Failure("dummy ".errorAt(input).newStack(), input, false)));
        }          
        if (head.evalSet.contains(p)) {
          head.evalSet = head.evalSet.filter(function (x) return x != p);
          
          var memo = MemoParsed(p(input));
          input.updateCacheAndGet(genKey, memo); // beware; it won't update lrStack !!! Check that !!!
          cached = Some(memo);
        }
        return cached;
    }
  }
  
  static function setupLR<I>(p: Parser<I,Dynamic>, input: Input<I>, recDetect: LR) {
    if (recDetect.head == None)
      recDetect.head = Some(p.mkHead());
    
    var stack = input.memo.lrStack;

    var h = recDetect.head.get(); // valid (see above)
    while (stack.head.rule != p) {
      var head = stack.head;
      head.head = recDetect.head;
      h.involvedSet = h.involvedSet.cons(head.rule);
      stack = stack.tail;
    }
  }
  
  static function grow<I,T>(p: Parser<I,T>, genKey : Int -> String, rest: Input<I>, head: Head): ParseResult<I,T> {
    //store the head into the recursionHeads
    rest.setRecursionHead(head);
    var oldRes =
      switch (rest.getFromCache(genKey).get()) {
        case MemoParsed(ans): ans;
        default : throw "impossible match";
      };
      
    //resetting the evalSet of the head of the recursion at each beginning of growth
    
    head.evalSet = head.involvedSet;
    var res = p(rest);
    switch (res) {
      case Success(_, _) :        
        if (oldRes.posFromResult().offset < res.posFromResult().offset ) {
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          return grow(p, genKey, rest, head);
        } else {
          //we're done with growing, we can remove data from recursion head
          rest.removeRecursionHead();
          switch (rest.getFromCache(genKey).get()) {
            case MemoParsed(ans): return cast(ans);
            default: throw "impossible match";
          }
        }
      case Failure(_, _, isError):
        if (isError) { // the error must be propagated  and not discarded by the grower!
          
          rest.updateCacheAndGet(genKey, MemoParsed(res));
          rest.removeRecursionHead();
          return res;
          
        } else {
          rest.removeRecursionHead();
          return cast(oldRes);
        }
        
    }
  }

  inline public static var baseFailure = "Base Failure";

  /**
   * Lift a parser to a packrat parser (memo is derived from scala's library)
   */
  public static function memo<I,T>(_p : Void -> Parser<I,T>) : Void -> Parser<I,T>
    return stx.Anys.toThunk({
      // generates an uid for this parser.
      var uid = parserUid();
      function genKey(pos : Int) return uid+"@"+pos;
      function (input :Input<I>) {
        
        switch (recall(_p(), genKey, input)) {
          case None :
            var base = Failure(baseFailure.errorAt(input).newStack(), input, false).mkLR(_p(), None);
            
            input.memo.lrStack  = input.memo.lrStack.cons(base);
            input.updateCacheAndGet(genKey, MemoLR(base));
            
            var res = _p()(input);
            
            input.memo.lrStack = input.memo.lrStack.tail;
            
            switch (base.head) {
              case None:
                input.updateCacheAndGet(genKey, MemoParsed(res));
                return res;
              case Some(_):
                base.seed = res;
                return lrAnswer(_p(), genKey, input, base);
            }
            
          case Some(mEntry):            
            switch(mEntry) {
              case  MemoLR(recDetect):
                setupLR(_p(), input, recDetect);
                return cast(recDetect.seed);
              case  MemoParsed(ans):
                return cast(ans);
            }
        }
        
      };
    });
  
  public static function fail<I,T>(error : String, isError : Bool) : Void -> Parser <I,T>
    return stx.Anys.toThunk(function (input :Input<I>) return Failure(error.errorAt(input).newStack(), input, isError));

  public static function success<I,T>(v : T) : Void -> Parser <I,T>
    return stx.Anys.toThunk(function (input) return Success(v, input));

  public static function identity<I,T>(p : Void -> Parser<I,T>) : Void -> Parser <I,T> return p;

  public static function andWith < I, T, U, V > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>, f : T -> U -> V) : Void -> Parser <I,V>
    return stx.Anys.toThunk({
      function (input:Input<I>):ParseResult<I,V> {
        var res = p1()(input);
        switch (res) {
          case Success(m1, r) :
            var res = p2()(r);
            switch (res) {
              case Success(m2, r) : return Success(f(m1, m2), r);
              case Failure(_, _, _): return cast(res);
            }
          case Failure(_, _, _): return cast(res);
        }
      }
    });

  inline public static function and < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>) : Void -> Parser < I, Tuple2 < T, U >> return
    andWith(p1, p2, tuple2);
    
  inline static function sndParam<A,B>(_, b) return b;
    
  inline public static function _and < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,U>) : Void -> Parser < I, U > return
    andWith(p1, p2, sndParam);

  inline static function fstParam<A,B>(a, _) return a;

  inline public static function and_ < I, T, U > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I, U>) : Void -> Parser < I, T > return
    andWith(p1, p2, fstParam);

  // aka flatmap
  public static function andThen < I, T, U > (p1 : Void -> Parser<I, T>, fp2 : T -> (Void -> Parser<I, U>)) : Void -> Parser < I, U >
    return stx.Anys.toThunk({
      function (input:Input<I>):ParseResult<I,U> {
        var res = p1()(input);
        switch (res) {
          case Success(m, r): return fp2(m)()(r);
          case Failure(_, _, _): return cast(res);
        }
      }
    });

  // map
  public static function then < I, T, U > (p1 : Void -> Parser<I,T>, f : T -> U) : Void -> Parser < I, U >
    return stx.Anys.toThunk({
      function (input):ParseResult<I,U> {
        var res = p1()(input);
        switch (res) {
          case Success(m, r): return Success(f(m), r);
          case Failure(_, _, _): return cast(res);
        };
      }
    });

  static var defaultFail =
    fail("not matched", false);
    
  static public function forPredicate<T>(pred : T -> Bool) return function (x : T) return
    pred(x) ? success(x) : defaultFail;
    
  inline public static function filter<I,T>(p : Void -> Parser<I,T>, pred : T -> Bool) : Void -> Parser <I,T> return
    andThen(p, forPredicate(pred));
  
	/**
	 * Takes a predicate function for an item of Input and returns it's parser.
	 */
	public static function predicated<I,I>(p:I->Bool) : Void -> Parser<I,I> {
		return stx.Anys.toThunk(
			function(x:Input<I>) {
				var res = p( x.content.at(x.offset) ) ;
				//trace(x.offset + ":z" + x.content.at(x.offset)  + " " + Std.string(res));
				return
					if ( res && !x.isEnd() ) {
						Success( x.take(1) , x.drop(1) );
					}else {
						Failure( ("predicate failed".errorAt(x).newStack()),x,false ); 
					}
			}
		);
	}
  /**
   * Generates an error if the parser returns a failure (an error make the choice combinator fail with an error without evaluating alternatives).
   */
  public static function commit < I, T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I, T >
    return stx.Anys.toThunk( {
      function (input) {        
        var res = p1()(input);
        return switch(res) {
          case Success(_, _): res;
          case Failure(err, rest, isError) :
            (isError || (err.last.msg == baseFailure))  ? res : Failure(err, rest, true);
        }
      }
    });
  
  public static function or < I,T > (p1 : Void -> Parser<I,T>, p2 : Void -> Parser<I,T>) : Void -> Parser < I, T >
    return stx.Anys.toThunk({
      function (input) {
        var res = p1()(input);
        switch (res) {
          case Success(_, _) : return res;
          case Failure(_, _, isError) : return isError ? res : p2()(input); // isError means that we commited to a parser that failed; this reports to the top..
        };
      }
    });
  
/*
  public static function ors<T>(ps : Array < Void -> Parser<T> > ) : Void -> Parser<T> return {
    ps.fold(function (p, accp) return or(accp, p), fail("none match", false));
  }
*/    
  // unrolled version of the above one
  public static function ors<I,T>(ps : Array < Void -> Parser<I,T> > ) : Void -> Parser<I,T>
    return stx.Anys.toThunk({
      function (input) {
        var pIndex = 0;
        while (pIndex < ps.length) {
          var res = ps[pIndex]()(input);
          switch (res) {
            case Success(_, _) : return res;
            case Failure(_, _, isError) :
              if (isError || (++pIndex == ps.length)) return res; // isError means that we commited to a parser that failed; this reports to the top..
          };
        }
        return Failure("none match".errorAt(input).newStack(), input, false);
      }
    });
    
  /*
   * 0..n
   */
  public static function many < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I, Array<T> >
    return stx.Anys.toThunk( {
      function (input) {
        var parser = p1();
        var arr = [];
        var matches = true;
        while (matches) {
          var res = parser(input);
          switch (res) {
            case Success(m, r): arr.push(m); input = r;
            case Failure(_, _, isError):
              if (isError)
                return cast(res);
              else 
                matches = false;
          }
        }
        return Success(arr, input);
      }
    });

    
  static public function notEmpty<T>(arr:Array<T>) return arr.length>0;
  /*
   * 1..n
   */
  inline public static function oneMany < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I,Array<T> > return
    filter(many(p1), notEmpty);
	public static function isEnd<I>(i:Input<I>):Bool {
		return i.content.length == i.offset;
	}
  inline public static function oneAsMany<I,T>(p1:Void->Parser<I,T>):Void->Parser<I,Array<T>>{
    return p1.then(
      function(x){
        return[x];
      }
    );
  }
	/**
	 * Returns the original input if the parse operation succeeds.
	 */
	public static function lookahead<I,O>(p0:Void->Parser<I,O> ):Void->Parser<I,O>  {
		return stx.Anys.toThunk( 
			function(input:Input<I>) {
				return switch(p0()(input)) {
					case Success(_, _)								: Success( null , input );
					case Failure(errorStack, rest, isError)	: Failure(errorStack, rest, isError);
				}
			}
		);
	}
	/**
	 * Returns true if the parser fails and vice versa.
	 */
	public static function not<I,O>(p:Void->Parser<I,O>):Void->Parser<I,O>{
		return stx.Anys.toThunk( 
			function(input:Input<I>) {
				return switch(p()(input)) {
					case Success(_, _)								: 
							var f : FailureMsg = { msg : "Parser succeeded rather than failed" , pos : input.position() };
						var o = List.nil().add(f);
						Failure( o , input , false);
					case Failure(errorStack, rest, isError)	: 
							if (isError) {
								Failure(errorStack, rest, isError);
							}
						Success( null , input );
				}
			}
		);
	}
	/**
	 * Returns true if there is anything left on the InputStream.
	 */
	public static function anything<I,I>():Void->Parser<I,I> {
		return stx.Anys.toThunk(
			function(input:Input<I>) {
				return if ( !input.isEnd() ) {
					Success( input.take(1) , input.drop(1) );
				}else {
					Failure( 'Reached end of input'.errorAt(input).newStack() , input , false );
				}
			}
		);
	}
	/**
	 * Takes a transform and creates a Parser.
	 */
	public static function parser < I, O > (f:I->O, ?isError:Bool = false ):Void-> Parser<I,O>{
		return 
				available()._and(
						stx.Anys.toThunk(
								function(input:Input<I>) : ParseResult < I, O > {
									var o = null;
									try {
										o = f(input.one());
										}catch (e:Dynamic) {
											return Failure(Std.string(e).errorAt(input).newStack(), input, isError);
										}
										return Success(o, input.drop(1));
									}
						)
				);
	}
	public static function available<I,O>() : Void -> Parser<I,O> {
		return not( end );
	}
  public static var none = available().or( not(available()) );
	/**
	 * Returns a parser detecting the End of InputStream.
	 */
	public static function end<I,O>() : Parser<I,O> {
			return function(x:Input<I>) {
				return if ( x.offset == x.content.length ) {
					Success( null , x );
				}else {
					Failure( ('not the end'.errorAt(x).newStack()), x, false );
				}
			}
	}
  /*
   * 0..n
   */
  public static function rep1sep < I, T > (p1 : Void -> Parser<I,T>, sep : Void -> Parser<I,Dynamic> ) : Void -> Parser < I, Array<T> > return    
    then(and(p1, many(_and(sep, p1))), function (t) { t.snd().insert(0, t.fst()); return t.snd();}) ;/* Optimize that! */

  /*
   * 0..n
   */
  public static function repsep < I,T > (p1 : Void -> Parser<I,T>, sep : Void -> Parser<I,Dynamic> ) : Void -> Parser < I, Array<T> > return
    or(rep1sep(p1, sep), success([]));

  /*
   * 0..1
   */
  public static function option < I,T > (p1 : Void -> Parser<I,T>) : Void -> Parser < I,Option<T> > return
    p1.then(Some).or(success(None));

  public static function trace<I,T>(p : Void -> Parser<I,T>, f : T -> String) : Void -> Parser<I,T> return
    then(p, function (x) { trace(f(x)); return x;} );

  public static function withError<I,T>(p : Void -> Parser<I,T>, f : String -> String ) : Void -> Parser<I,T>
    return stx.Anys.toThunk(function (input : Input<I>) {
      var r = p()(input);
      switch(r) {
        case Failure(err, input, isError): return Failure(err.report((f(err.head.msg)).errorAt(input)), input, isError);
        default: return r;
      }
    });
    
  public static function tag<I,T>(p : Void -> Parser<I,T>, tag : String) : Void -> Parser<I,T> return  
    withError(p, function (_) return tag +" expected");
  
}
