/*
 HaXe library written by John A. De Goes <john@socialmedia.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.io.http;

import stx.Prelude;
import stx.Future;
import stx.io.http.Http;
import stx.net.Url;
import stx.net.HttpResponseCode;
import stx.ds.Map;
import stx.Maybes;
using stx.Maybes;

#if js
import stx.js.Dom;
import stx.js.Env;
import stx.js.dom.Quirks;
#end


using stx.functional.Foldables;
using stx.net.HttpResponseCodes;
using stx.net.Urls;
using stx.net.HttpHeaders;

#if js
@DefaultImplementation("stx.io.http.HttpStringAsync", "OneToMany")
#end
interface HttpString extends Http<String> {
}

#if js

class HttpStringAsync implements HttpString {
  public function new() { }
  
  public function get(url: Url, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<String>> {
    return custom('GET', url, null, params, headers);
  }
  
  public function post(url: Url, data: String, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<String>> {
    return custom('POST', url, data, params, makeHeader(headers, "application/x-www-form-urlencoded"));
  }
  
  public function put(url: Url, data: String, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<String>> {
    return custom('PUT', url, data, params, makeHeader(headers, "application/x-www-form-urlencoded"));
  }
  
  public function delete(url: Url, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<String>> {
    return custom('DELETE', url, null, params, headers);
  }
  
  public function custom(method: String, _url: Url, data: String, ?_params: QueryParameters, ?_headers: Map<String, String>): Future<HttpResponse<String>> {
    var url = if (_params != null) _url.addQueryParameters(Maybes.create(_params).getOrElseC(Map.create())); else _url;
    var future: Future<HttpResponse<String>> = new Future();
    
    var request = Quirks.createXMLHttpRequest();

    future.ifCanceled(function() {
      try {
        request.abort();
      }
      catch (e: Dynamic) { }
    });
     
    request.onreadystatechange = function() {
      var toBody = function(text: String): Maybe<String> { return if (text == null || text.length == 0) None; else Some(text); }
      if (request.readyState == XmlHttpRequestState.DONE) {
        var responseHeaders = if (request.getAllResponseHeaders() == null) ''; else request.getAllResponseHeaders();
        
        future.deliver({
          body:     toBody(request.responseText),
          headers:  responseHeaders.toHttpHeaders(),
          code:     request.status.toHttpResponseCode()
        });
      }
    }

    try {
      request.open(method, url, true);
    }
    catch (e: Dynamic) {
      future.cancel();
    }

    _headers.toMaybe().map(function(headers) {
      headers.foreach(function(header) {
        request.setRequestHeader(header._1, header._2);
      });
    });
    request.send(data);
    
    return future;
  }
  
  private function makeHeader(?_headers: Map<String, String>, contentType: String): Map<String, String>{
    return Maybes.create(_headers).getOrElseC(Map.create().set("Content-Type", contentType));
  }
}

#end