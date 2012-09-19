package stx.io;
import stx.Error;

import stx.Prelude;
using stx.Eithers;
#if (neko || cpp || php || java)
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.FileSystem;
#end
using stx.Functions;
using stx.Promises;
using stx.Dynamics;

/**
Safe file handlers
*/
class Files{
	#if (neko || cpp || php || java)
	@:noUsing
	static public function read(s:String,?binary:Bool):Future<Either<Error,FileInput>>{
		return Future.pure(File.read.lazy(s,binary).catching());
	}
	@:noUsing
	static public function write(s:String,?binary:Bool):Future<Either<Error,FileOutput>>{
		return Future.pure(File.write.lazy(s,binary).catching());
	}
	@:noUsing
	static public function append(s:String,?binary:Bool):Future<Either<Error,FileOutput>>{
		return Future.pure(File.append.lazy(s,binary).catching());
	}
	@:noUsing
	static public function copy(s:String,to:String){
		return Future.pure(File.copy.lazy(s,to).catching());
	}
	#end
}
typedef Dirs = Directories;
class Directories{
	#if (neko || cpp || php || java)
	@:noUsing
	static public function create(s:String):Future<Either<Error,Directory>>{
		return Future.pure(FileSystem.createDirectory.lazy(s).catching()).mapR( Directory.create(s).toThunk().promote() );
	}
	#end
}
class Directory{
	@:noUsing
	static public function create(s:String){
		return new Directory(s);
	}
	public var location : String;
	public function new(l){
		this.location = l;
	}
}