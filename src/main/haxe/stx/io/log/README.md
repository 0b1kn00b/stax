#Logging

`LogItem` is used via `import stx.io.Log.*` and provides global namespace functions. Logging is simply a trace statement.

    trace(debug('hello world'))

The `DefaultLogger` tries to open a resource `zebra` which has white(+)/black(-) listings, using `#` for ignoring a line.

    (+|-)*\file.hx$classname&method@line
  
e.g

    +*\Strings.hx$stx.Strings&append

And all the sensible combinations of file, classname, method and line are supported. @see `stx.log.LogListingParser`

if using `împort Stax.*` or `import Log.*`, you can also use `printer(pos:PosInfos)`

    [0,1,2,3].each(printer());

Or with `using stx.Compose` and `import stx.io.Log.*`

    [0,1,2,3].each(warning.then(printer()))

`DefaultLogger` also has a `permissive` parameter which, if set to false, filters out all traces which are not LogItems.

Set up Logger by calling `Stax.init()`, which uses the ioc framework.