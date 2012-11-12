package stx.reactive {
	import stx.reactive.Stream;
	public class StreamStream {
		public function StreamStream() : void {
		}
		
		static public function switchE(streams : stx.reactive.Stream) : stx.reactive.Stream {
			return stx.reactive.StreamStream.flatten(streams);
		}
		
		static public function join(stream : stx.reactive.Stream) : stx.reactive.Stream {
			return stx.reactive.StreamStream.flatten(stream);
		}
		
		static public function flatten(stream : stx.reactive.Stream) : stx.reactive.Stream {
			return stream.bind(function(stream1 : stx.reactive.Stream) : stx.reactive.Stream {
				return stream1;
			});
		}
		
	}
}
