package stx.io;

using stx.Prelude;
using stx.Strings;
using stx.Arrays;
using stx.macro.F;

using stx.io.FileSystem;
typedef FS = stx.io.FileSystem;

class FileSystem{
	/**
		Returns a platform string.
	*/
	@:untested
	static public function platform():String{
		return 
			#if nodejs
				js.Node.os.platform();
			#elseif (js || as3)
				'Remote';
			#else
				if( sys.FileSystem.exists('/cygdrive') ){
					'Cygwin';
				}else{
					Sys.systemName();
				}
			#end
	}
	/**
		Returns the platform specific directory seperator.
	*/
	static public function sep():String{
		return 
			switch(platform()){
				case 'Windows' 	: '\\';
				default 				: '/';
			}
	}
	static public function otherSep(){
		return 
			switch(platform()){
				case 'Windows' 	: '/';
				default 				: '\\';
			}	
	}
	/**
		Transforms a foreign file system seperated path into a local one.
	*/
	static public function convert(s:String){
		return 
			s.split(otherSep()).join(sep());
	}
	/**
		Returns the Array seperated by the platfomr specific seperator.
	*/
	static public function pathify(a:Array<String>){
		return a.join(sep());
	}
	/**
		Adds a trailing slash to a path.
	*/
	static public function bookend(s:String){
		return 
			if(s.indexOf(sep()) != s.length-1){
				s.append(sep());
			}else{
				s;
			}
	}
	/**
		Turns a path into a directory, assuming the file has a file extension.
	*/
	static public function directory(s:String){
		var a = s.split(sep());
		return 
			if( a[a.length-1].indexOf('.') != -1){
				a.reversed().drop(1).reversed().pathify();
			}else{
				s;
			}
	}
	static public function directories(s:String){
		return s.split(sep()).filter(F.n(s,return s!=''));
	}
}