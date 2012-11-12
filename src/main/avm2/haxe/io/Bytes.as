package haxe.io {
	import flash.utils.ByteArray;
	import haxe.io._Error;
	import flash.Boot;
	public class Bytes {
		public function Bytes(length : int = 0,b : flash.utils.ByteArray = null) : void { if( !flash.Boot.skip_constructor ) {
			this.length = length;
			this.b = b;
		}}
		
		public function getData() : flash.utils.ByteArray {
			return this.b;
		}
		
		public function toHex() : String {
			var s : StringBuf = new StringBuf();
			var chars : Array = [];
			var str : String = "0123456789abcdef";
			{
				var _g1 : int = 0, _g : int = str.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					chars.push(str["charCodeAtHX"](i));
				}
			}
			{
				var _g11 : int = 0, _g2 : int = this.length;
				while(_g11 < _g2) {
					var i1 : int = _g11++;
					var c : int = this.get(i1);
					s.addChar(chars[c >> 4]);
					s.addChar(chars[c & 15]);
				}
			}
			return s.toString();
		}
		
		public function toString() : String {
			this.b.position = 0;
			return this.b.readUTFBytes(this.length);
		}
		
		public function readString(pos : int,len : int) : String {
			if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io._Error.OutsideBounds;
			this.b.position = pos;
			return this.b.readUTFBytes(len);
		}
		
		public function compare(other : haxe.io.Bytes) : int {
			var len : int = ((this.length < other.length)?this.length:other.length);
			var b1 : flash.utils.ByteArray = this.b;
			var b2 : flash.utils.ByteArray = other.b;
			b1.position = 0;
			b2.position = 0;
			{
				var _g1 : int = 0, _g : int = len >> 2;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(b1.readUnsignedInt() != b2.readUnsignedInt()) {
						b1.position -= 4;
						b2.position -= 4;
						return b1.readUnsignedInt() - b2.readUnsignedInt();
					}
				}
			}
			{
				var _g11 : int = 0, _g2 : int = len & 3;
				while(_g11 < _g2) {
					var i1 : int = _g11++;
					if(b1.readUnsignedByte() != b2.readUnsignedByte()) return b1[b1.position - 1] - b2[b2.position - 1];
				}
			}
			return this.length - other.length;
		}
		
		public function sub(pos : int,len : int) : haxe.io.Bytes {
			if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io._Error.OutsideBounds;
			this.b.position = pos;
			var b2 : flash.utils.ByteArray = new flash.utils.ByteArray();
			this.b.readBytes(b2,0,len);
			return new haxe.io.Bytes(len,b2);
		}
		
		public function blit(pos : int,src : haxe.io.Bytes,srcpos : int,len : int) : void {
			if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io._Error.OutsideBounds;
			this.b.position = pos;
			if(len > 0) this.b.writeBytes(src.b,srcpos,len);
		}
		
		public function set(pos : int,v : int) : void {
			this.b[pos] = v;
		}
		
		public function get(pos : int) : int {
			return this.b[pos];
		}
		
		protected var b : flash.utils.ByteArray;
		public var length : int;
		static public function alloc(length : int) : haxe.io.Bytes {
			var b : flash.utils.ByteArray = new flash.utils.ByteArray();
			b.length = length;
			return new haxe.io.Bytes(length,b);
		}
		
		static public function ofString(s : String) : haxe.io.Bytes {
			var b : flash.utils.ByteArray = new flash.utils.ByteArray();
			b.writeUTFBytes(s);
			return new haxe.io.Bytes(b.length,b);
		}
		
		static public function ofData(b : flash.utils.ByteArray) : haxe.io.Bytes {
			return new haxe.io.Bytes(b.length,b);
		}
		
	}
}
