package stx.io;
import stx.Prelude;
using stx.Eithers;
#if (neko || cpp || php )
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
#end
using stx.Functions;

class Files{
	#if (neko || cpp || php )
	public static function read(s:String,?binary:Bool):Either<Dynamic,FileInput>{
		return File.read.lazy(s,binary).catching();
	}
	public static function write(s:String,?binary:Bool):Either<Dynamic,FileOutput>{
		return File.write.lazy(s,binary).catching();
	}
	public static function append(s:String,?binary:Bool):Either<Dynamic,FileOutput>{
		return File.append.lazy(s,binary).catching();
	}
	#end
}