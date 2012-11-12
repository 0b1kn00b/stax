package haxe.rtti {
	public class Meta {
		static public function getType(t : *) : * {
			var meta : * = t.__meta__;
			return ((meta == null || meta.obj == null)?{ }:meta.obj);
		}
		
		static public function getStatics(t : *) : * {
			var meta : * = t.__meta__;
			return ((meta == null || meta.statics == null)?{ }:meta.statics);
		}
		
		static public function getFields(t : *) : * {
			var meta : * = t.__meta__;
			return ((meta == null || meta.fields == null)?{ }:meta.fields);
		}
		
	}
}
