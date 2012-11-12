package stx.io.http {
	import stx.ds.Map;
	import stx.Future;
	public interface Http {
		function custom(request : String,url : String,data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future ;
		function delete(url : String,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future ;
		function put(url : String,data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future ;
		function post(url : String,data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future ;
		function get(url : String,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future ;
	}
}
