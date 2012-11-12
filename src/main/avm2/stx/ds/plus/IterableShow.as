package stx.plus {
	public class IterableShow {
		static public function toString(i : *,show : Function = null,prefix : String = "(",suffix : String = ")",sep : String = ", ") : String {
			if(prefix==null) prefix="(";
			if(suffix==null) suffix=")";
			if(sep==null) sep=", ";
			return stx.plus.IterableShow.mkString(i,show,prefix,suffix,sep);
		}
		
		static public function mkString(i : *,show : Function = null,prefix : String = "(",suffix : String = ")",sep : String = ", ") : String {
			if(prefix==null) prefix="(";
			if(suffix==null) suffix=")";
			if(sep==null) sep=", ";
			if(show == null) show = Std.string;
			var s : String = prefix;
			var isFirst : Boolean = true;
			{ var $it : * = i.iterator();
			while( $it.hasNext() ) { var t : * = $it.next();
			{
				if(isFirst) isFirst = false;
				else s += sep;
				s += show(t);
			}
			}}
			return s + suffix;
		}
		
	}
}
