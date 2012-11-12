package stx.util {
	public class Guid {
		static public function generate() : String {
			var result : String = "";
			{
				var _g : int = 0;
				while(_g < 32) {
					var j : int = _g++;
					if(j == 8 || j == 12 || j == 16 || j == 20) result += "-";
					result += StringTools.hex(Math.floor(Math.random() * 16));
				}
			}
			return result.toUpperCase();
		}
		
	}
}
