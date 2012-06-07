package stx.io;
import Prelude;
using stx.Eithers;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
using stx.Functions;

class Files{
	public static function read(s:String,?binary:Bool):Either<Dynamic,FileInput>{
		return File.read.lazy(s,binary).catching();
	}
	public static function write(s:String,?binary:Bool):Either<Dynamic,FileOutput>{
		return File.write.lazy(s,binary).catching();
	}
	public static function append(s:String,?binary:Bool):Either<Dynamic,FileOutput>{
		return File.append.lazy(s,binary).catching();
	}
}