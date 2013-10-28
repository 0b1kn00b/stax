import stx.Prelude;
using stx.Tuples;
import haxe.io.Input;
import stx.reactive.Arrows; 	using stx.reactive.Arrows;
															using stx.Either;
															using stx.Strings;
class Run{

	static function main(){
		ProcessArrow.process.trace()
			.then(
				function(x:Input){
					return x.readLine().toString().add('stax/git/src/main/haxe');
				}.lift()
				.then(
					function(x:String):Array<String>{
						return ['haxelib','dev','stax',x];
					}.lift()
				).then( ProcessArrow.process )
			 	.then(
			 			function(x:Tuple2<Input,Input>):Tuple2<Input,Input>{
			 				trace(x._2.readLine());
			 				return x;
			 			}.lift()
			 	).trace().second()
		).run(['haxelib','config']);
	}
}