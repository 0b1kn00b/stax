using SCore;

using sys.FileSystem;

using stx.io.Files;
using stx.io.FileSystem;

using stx.Prelude;

using stx.macro.F;
using stx.Tuples;

import stx.Prelude;

class Core {
	static function main(){
		var here 		= FileSystem.fullPath( neko.vm.Module.local().name );
		var src 		= here.split(FS.sep()).reversed().drop(2).reversed().toArray().append(['src','main','haxe']).toArray().pathify().bookend();
		var folder 	= here.split(FS.sep()).reversed().drop(1).reversed().toArray().join(FS.sep());
		var tmp 		= folder.add(FS.sep().add('.tmp'));

		(tmp.exists())
			.ifElse(
					 	Directory.create.lazy(tmp).andThen(Right).andThen(Future.pure)
					, Directories.create.lazy(tmp)
			 ).flatMapR(
			 		function(d){
				 		return
					 		classes.map(
					 				FS.directory
					 		).nub()
					 		.map(FS.directories)
					 		.filter(Arrays.hasValues)
					 		.flatMap( 
					 			function(a:Array<String>){
					 				var str 	= a[0];
					 				var strs 	= [str];
					 						a.shift();
					 						a.foreach(
					 							F.n(x,strs.push(str = str.add(FS.sep()).add(x)))
					 						);
					 				return strs;
					 			}
					 		)
					 		.nub()
					 		.map(Strings.append.p1(tmp.bookend()))
					 		.map(
					 			F.n(s,
					 				return 
					 					FileSystem.exists(s)
					 						.ifElse(
					 								Directory.create.lazy(s).andThen( Right ).andThen( Future.pure )
					 							, Directories.create(s).toThunk()
					 						)
					 			)
					 		).wait();
				 	}
			 ).flatMapR(
			 	F.n(vs,{
			 		return 
			 			classes.zip(classes)
				 			.map(
				 				Tuple2.translate.ccw().a2
					 				(
				 					 	src.append
				 					, tmp.bookend().append
				 				)
				 			).map(
				 				Tuple2.into.ccw().p1(Files.copy)	
				 			).wait();		
			 			}
		 			)
			 );
	}
	static var classes 
		=
			[
				'stx/Prelude.hx'

			,	'stx/Arrays.hx'
			, 'stx/Bools.hx'
			, 'stx/Dates.hx'
			, 'stx/Dynamics.hx'
			, 'stx.Either.hx'
			, 'stx/Enums.hx'
			, 'stx/Functions.hx'
			, 'stx/Future.hx'
			, 'stx/Mapes.hx'
			, 'stx/Iterables.hx'
			, 'stx/Iterators.hx'
			, 'stx/Log.hx'
			, 'stx/LogLevel.hx'
			, 'stx/Maths.hx'
			, 'stx/Objects.hx'
			, 'stx/Maybes.hx'
			, 'stx/Predicates.hx'
			, 'stx/Prelude.hx'
			, 'stx/Promises.hx'
			, 'stx/Strings.hx'
			, 'stx/Tuples.hx'

			, 'stx/plus/Equal.hx'
			, 'stx/plus/Hasher.hx'
			, 'stx/plus/Order.hx'
			, 'stx/plus/Show.hx'
			, 'stx/plus/Meta.hx'

			, 'stx/macro/F.hx'
			, 'stx/macro/Tp.hx'

			, 'stx/Error.hx'

			, 'stx/framework/Injector.hx'

			, 'stx/io/json/Json.hx'
			, 'stx/io/json/JValue.hx'
			, 'stx/io/json/JValues.hx'
			, 'stx/io/json/PrimitivesJValue.hx'
			, 'stx/io/json/Transcode.hx'
			, 'stx/io/json/TranscodeJValue.hx'
			, 'stx/io/json/TranscodeJValues.hx'

		].map( FS.convert );
}