package stx.io.http {
	import stx.Options;
	import stx.ds.Map;
	import stx.Future;
	import flash.Boot;
	import stx.io.http.Http;
	public class HttpTransformer implements stx.io.http.Http{
		public function HttpTransformer(http : stx.io.http.Http = null,encoder : Function = null,decoder : Function = null,mimeType : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.http = http;
			this.encoder = encoder;
			this.decoder = decoder;
			this.mimeType = mimeType;
		}}
		
		protected function addMimeType(map_ : stx.ds.Map) : stx.ds.Map {
			return stx.Options.getOrElseC(stx.Options.toOption(map_),stx.ds.Map.create().set("Content-Type",this.mimeType));
		}
		
		public function transformResponse(r : *) : * {
			return { body : stx.Options.map(r.body,this.decoder), headers : r.headers, code : r.code}
		}
		
		public function custom(method : String,url : String,_tmp_data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future {
			var data : * = _tmp_data;
			return this.http.custom(method,url,(this.encoder)(data),params,this.addMimeType(headers)).map(this.transformResponse);
		}
		
		public function _delete(url : String,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future {
			return this.http._delete(url,params,this.addMimeType(headers)).map(this.transformResponse);
		}
		
		public function put(url : String,_tmp_data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future {
			var data : * = _tmp_data;
			return this.http.put(url,(this.encoder)(data),params,this.addMimeType(headers)).map(this.transformResponse);
		}
		
		public function post(url : String,_tmp_data : *,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future {
			var data : * = _tmp_data;
			return this.http.post(url,(this.encoder)(data),params,this.addMimeType(headers)).map(this.transformResponse);
		}
		
		public function get(url : String,params : stx.ds.Map = null,headers : stx.ds.Map = null) : stx.Future {
			return this.http.get(url,params,this.addMimeType(headers)).map(this.transformResponse);
		}
		
		protected var mimeType : String;
		protected var decoder : Function;
		protected var encoder : Function;
		protected var http : stx.io.http.Http;
	}
}
