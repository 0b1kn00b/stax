package stx.io.json {
	public final class JValue extends enum {
		public static const __isenum : Boolean = true;
		public function JValue( t : String, index : int, p : Array = null ) : void { this.tag = t; this.index = index; this.params = p; }
		public static function JArray(v : Array) : JValue { return new JValue("JArray",4,[v]); }
		public static function JBool(v : Boolean) : JValue { return new JValue("JBool",1,[v]); }
		public static function JField(k : String, v : stx.io.json.JValue) : JValue { return new JValue("JField",6,[k,v]); }
		public static var JNull : JValue = new JValue("JNull",0);
		public static function JNumber(v : Number) : JValue { return new JValue("JNumber",2,[v]); }
		public static function JObject(v : Array) : JValue { return new JValue("JObject",5,[v]); }
		public static function JString(v : String) : JValue { return new JValue("JString",3,[v]); }
		public static var __constructs__ : Array = ["JNull","JBool","JNumber","JString","JArray","JObject","JField"];;
	}
}
