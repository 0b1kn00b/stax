package  {
	public class StringBuf {
		public function StringBuf() : void {
		}
		
		public function toString() : String {
			return this.b;
		}
		
		public function addSub(s : String,pos : int,len : * = null) : void {
			this.b += s.substr(pos,len);
		}
		
		public function addChar(c : int) : void {
			this.b += String.fromCharCode(c);
		}
		
		public function add(x : *) : void {
			this.b += Std.string(x);
		}
		
		protected var b : String = "";
	}
}
