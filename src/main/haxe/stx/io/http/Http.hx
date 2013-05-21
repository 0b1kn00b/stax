package stx.io.http;

import stx.Prelude;
import stx.Future;
import stx.ds.Map;
import stx.net.Url;
import stx.net.HttpResponseCode;



typedef HttpResponse<T> = {
  code:     HttpResponseCode,
  body:     Option<T>,
  headers:  Map<String, String>
}

/** 
	An interface for performing HTTP requests - GET, POST, PUT, and DELETE. The
  interface is generic in the type of the request/response data, because some
  implementations (e.g. JSONP on the JavaScript target) can only deal with 
  certain kinds of data.
 */
interface Http<T> {
  public function get(url: Url, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<T>>;
    
  public function post(url: Url, data: T, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<T>>;
    
  public function put(url: Url, data: T, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<T>>;
    
  public function delete(url: Url, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<T>>;
  
  public function custom(request: String, url: Url, data: T, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<T>>;
}