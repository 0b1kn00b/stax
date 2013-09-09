# Stax v0.4
## Batteries for Haxe

You need to read this. If you attempt a left recursive descent into the code itself I am not to be held accountable for any  resulting mental trauma.

If you need fast, go to polygonal, magic to tinkerbell, higher-types to scuts or java-ey to funk. This is the Honda Accord of functional programming.

### Categories

- Functional  
- Monad Instances  
- Asynchronous  
- Glossary  

### Index

- Installation  
  - GitHub
  - Haxelib
  - ClassPath
- Getting Started  
- Design  
  - Directory Structure
  - Conventions
  - Reserved Words
- Core 
  - Primitives
    - Bools
    - Strings
    - Maths
      - Ints
      - Floats
    - Dates
  - Any (Dynamic)
    - Anys  
    - Tables  
    - Objects
  - Arrays / Iterables / Iterators
  - Tuples   
  - Functional Composition  
    - Functions(stx.Functions)
    - Compose  (stx.Compose)
    - Chains
  - Options  
  - Eithers 
  - Fail (Errors) (stx.Fail) 
  - Outcomes
  - Futures
    - Eventuals
    - Contracts
  - Introspection
    - Reflection
      - Types (stx.Types)
      - Enums (stx.Enums)
      - ValueTypes (stx.ValueTypes)
      - Reflects (stx.Reflects)
    - Runtime Types  
  - Inversion of Control(IOC)  
  - Test
    - Assert (stx.Assert)
  - Plus  
    - Equal
    - Order
    - Hash
    - Show
    - Clone
  - Data Structures  
    - List
    - LazyList
    - Map
    - Set
    - Zipper
  - Log  
- Advanced
  - Parser (stx.prs.*)
  - Reactives (stx.rct.*)
    - Dispatcher
    - Notifier
    - Reactor
    - Process
  - Arrows (stx.arw.*)
  - Continuations (stx.Continuations)
  - Partial Functions (stx.PartialFunction)

### Installation  
#### GitHub
#### Haxelib
#### ClassPath
### Getting Started  
### Design  
#### Directory Structure
###### stx
Base functional namespace, only the Stax helper class is outside this. I consider it good ettiquette (I'm looking at you, franco).
###### hx
Base imperative namespace, mostly for the distinction between `hx.ds` : mutable datastructures and `stx.ds` : immutable datastructures.
###### stx.arw
Arrow instances, normally unnecessary as most is imported by `stx.Arrow`
###### stx.ds
Immutable Datastructures
###### stx.ifs
General interfaces, very few of them atm.
###### stx.ioc
Inversion of Control. A blend of the Stax and Funk injectors, can use the package system or arbitrary modules.
###### stx.js
Javascript specific functionality. Is a treasure trove of quirks fixes though not under active maintenence (09/13), so be warned
###### stx.log
Various supporting things for `stx.Log`
###### stx.math
Mathematical things here. Due an overhaul
###### stx.mcr
Macros, nothing to see here.
###### stx.net  
Networking, due for integration into another library (quiver)
###### stx.plus
Helper tools for comparisons, equalities, hashcodes, metadata and structure cloning.
###### stx.prs
Parser Combinator, largely parsex, but with Stax datastructures.
###### stx.rct
Reactive, including events, streams and behaviours. (perhaps events will move to the `hx` namespace)
###### stx.rtti
Runtime Types and Reflection: fairly early in it's integration /  battletesting, but useful nonetheless
###### stx.rx
Proposed port of RXJS will go here hopefully
###### stx.trt
Traits, watch this space.

#### Conventions
There are on or two kinks left in it, but there is pretty consistent vocubulary to Stax.

##### Metadata
I tend to leave notes in the metadata, these include
```
@:note
@:bug
@:todo
```
the general form being @:tag("[author] : ...")
##### Function Arity
Haxe doesn't have a unifying function type so a few conventions have arisen to signify functions of different arities and returns in interfaces.
###### run
  no parameters, no returns. A niladic function or CodeBlock
###### execute
  one parameter, no returns. 
###### apply
  one parameter, one return. Might also find apply[n].
###### reply
  no parameters, one return. A Thunk.
##### Accessors
###### get
A function `(key:K):V` used to get the `V` at `K`
###### set
A function `(key:K,val:V)` used to place V at index K.
###### put
A function `(val:V)` used to place the value, may also find `(kv:Tuple2<K,V>)`
###### rem
A function `(val:V)` used to remove a value, there is still some question about how to distinguish between single and multiple values.
###### del
A function `(key:K)` used to delete a value (as there is no assurance that the value at `key` has any other references).
###### has
A little arbitrary, but refers to the existence of a key, for values: use `contains`.
###### lookup
A function `(key:K):Option<V>`
###### find
A function `(val:S):Option<T>`
###### search
A function `(fn:S->Bool):Option<T>` (subject to change)
###### gather
A function `(fn:S->Bool):Array<T>` (subject to change)

#### Reserved Words
### Core 
#### Primitives
##### Bools
`static function public toInt(v: Bool): Float;`  
Returns the Int representation of a Bool.
  
`static public function ifTrue<T>(v: Bool, f: Thunk<T>): Option<T>;`  
Produces the result of `f` if `v` is true.
  
`static public function ifFalse<T>(v: Bool, f: Thunk<T>): Option<T>;`  
Produces the result of `f` if `v` is false.

`static public function ifElse<T>(v: Bool, f1: Thunk<T>, f2: Thunk<T>): T;`  
Produces the result of `f1` if `v` is true, `f2` otherwise.

`static public function compare(v1 : Bool, v2 : Bool) : Int;`  
Compares Ints, returning -1 if (false,true), 1 if (true,false), 0 otherwise

`static public function equals(v1 : Bool, v2 : Bool) : Bool;`  
Returns `true` if `v1` and `v2` are the same, `false` otherwise.

`static public inline function eq(v1:Bool, v2:Bool) return v1 == v2;`  
Shortcut for "equals"

`static public inline function and(v1:Bool, v2:Bool) return v1 && v2;`  
Returns `true` if both `v1` and `v2` are `true`, `false` otherwise.

`static public inline function nand(v1:Bool, v2:Bool);`  
Returns `true` if `v1` and `v2` are different, `false` otherwise.

`static public inline function or(v1:Bool, v2:Bool);`  
Returns `true` if `v1` or `v2` are true, `false` otherwise.

`static public inline function not(v:Bool);`  
Returns `true` if `v` is `true`, `false` otherwise.
##### Strings
##### Maths
###### Ints
###### Floats
##### Dates
#### Any (Dynamic)
##### Anys  
##### Tables  
##### Objects
#### Arrays / Iterables / Iterators
#### Tuples   
#### Functional Composition  
##### Functions(stx.Functions)
##### Compose  (stx.Compose)
##### Chains
#### Options  
#### Eithers 
#### Fail (Errors) (stx.Fail) 
#### Outcomes
#### Futures
##### Eventuals
##### Contracts
#### Introspection
##### Reflection
###### Types (stx.Types)
###### Enums (stx.Enums)
###### ValueTypes (stx.ValueTypes)
###### Reflects (stx.Reflects)
##### Runtime Types  
#### Inversion of Control(IOC)  
#### Test
##### Assert (stx.Assert)
#### Plus  
##### Equal
##### Order
##### Hash
##### Show
##### Clone
#### Data Structures  
##### List
##### LazyList
##### Map
##### Set
##### Zipper
#### Log  
### Advanced
#### Parser (stx.prs.*)
#### Reactives (stx.rct.*)
##### Dispatcher
##### Notifier
##### Reactor
#### Arrows (stx.arw.*)
#### Continuations (stx.Continuations)
#### Partial Functions (stx.PartialFunction)


### Glossary
###### arity  
> The number of parameters serving a function, a function of arity one has one parameter, and so on
###### thunk
> A function with no inputs and one return. Indicates that all necessary data for successful execution has been collected, may also be used to 
defer computation for effectful functions.   

#### Functional
#### Monad Instances
#### Asynchronous

### Appendix

#### Constructs  
  Because there are various ways of importing and using functions and variables in Haxe, here is a taxonomy.
##### Type (Type I)  
###### Class  
###### Typedef  
###### Enum  
###### Dynamics  
##### Decorators (Type II)  
Haxe has a form of dynamic dispatch in the case where class variables aren't found, and it uses shadowing (a more recent matching type declaration overrides any previous where there is name aliasing). There is no explicit resolution on this so it would behoove you to design carefully around it. (behooving is in this season)
##### Abstracts (Type III)  
##### Global Namespace (Type IV)  
###### Macro (Type V)  









