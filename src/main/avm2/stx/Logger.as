package stx {
	public interface Logger {
		
		function trace(v : *,pos : * = null) : void ;
		function check(v : *,pos : *) : Boolean ;
		;
	}
}
