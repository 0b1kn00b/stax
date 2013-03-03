package hx.ds.sort;

/**
 * ...
 * @author 0b1kn00b
 */

class Strings {
    public static var case_insensitive =
    function(a : String, b : String) : Int {
        var r = 0;
		a = a.toLowerCase();
		b = b.toLowerCase();

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = a.charCodeAt(i) - b.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = a.charCodeAt(0) - b.charCodeAt(0); 	
		}

		return r;
    };
    
   public static var case_insensitive_descending = 
    function(a : String, b : String) : Int {
        var r = 0;
		a = a.toLowerCase();
		b = b.toLowerCase();

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = b.charCodeAt(i) - a.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = b.charCodeAt(0) - a.charCodeAt(0); 	
		}

		return r;
    };
    
    public static var compare =
    function(a : String, b : String) : Int {
        var r = 0;

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = a.charCodeAt(i) - b.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = a.charCodeAt(0) - b.charCodeAt(0); 	
		}

		return r;
    };
    
    public static var descending =
    function(a : String, b : String) : Int {
        var r = 0;

		if (a.length + b.length > 2){
			var k = if (a.length > b.length) a.length else b.length;
			for (i in 0...k){
				r = b.charCodeAt(i) - a.charCodeAt(i);
				if (r != 0){
					break;
				}
			}
		} else {
			r = b.charCodeAt(0) - a.charCodeAt(0); 	
		}

		return r;
    };
}