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
import stx.io.http.Http;
import stx.io.http.HttpString;
import stx.io.http.HttpTransformer;
import stx.net.Url;
import stx.net.HttpResponseCode;
import stx.io.json.JValue;
import stx.io.json.Json;
import stx.ds.Map;

import stx.Future;

import stx.Options;
using stx.Options;

#if js
import stx.js.Dom;
import stx.js.Env;
import stx.js.dom.Quirks;
#end


using stx.functional.FoldableExtensions;
using stx.net.HttpResponseCodeExtensions;
using stx.net.UrlExtensions;
using stx.net.HttpHeaderExtensions;

#if js
@DefaultImplementation("stx.io.http.HttpJValueAsync", "OneToMany")
#end
interface HttpJValue implements Http<JValue> {
}

#if js

class HttpJValueAsync extends HttpTransformer<String, JValue>, implements HttpJValue {
  public function new() {
    super(new HttpStringAsync(), Json.encode, Json.decode, "application/json");
  }
}

class HttpJValueJsonp implements HttpJValue {
  static var Responders   = {};
  static var RequestMod   = Math.round(Math.random() * 2147483647);
  static var RequestCount = 0;
  
  var callbackParameterName: String;
  
  public function new(?callbackParameterName = 'callback') {
    this.callbackParameterName = callbackParameterName;
  }
  
  public function get(url_: Url, ?params_: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<JValue>> {
    // Ignore headers or throw exception???
    var future: Future<HttpResponse<JValue>> = new Future();
    
    // Request id must be globally unique even if this source is included twice
    // (hence the need for randomness):
    var requestId = Math.round(RequestMod * (++RequestCount));
    
    var callbackName     = 'stx_jsonp_callback_' + requestId;
    var callbackFullName = 'stx.io.http.HttpJValueJsonp.Responders.' + callbackName;
    
    var params = Options.create(params_).getOrElseC(Map.create()).set(callbackParameterName, callbackFullName);
    
    var url = url_.addQueryParameters(params);
    
    var doCleanup = function() {
      // Cleanup DOM & delete callback function:
      var script = Env.document.getElementById(callbackName);
      
      if (script != null) Env.document.getElementsByTagName('HEAD')[0].removeChild(script);
    
      Reflect.deleteField(Responders, callbackName);
    }
    
    future.ifCanceled(doCleanup);
    
    Reflect.setField(Responders, callbackName, function(data) {
      doCleanup();
      
      var code: HttpResponseCode;
      var response: Option<JValue>;
      
      try {
        response = Some(Json.fromObject(data));
        code     = Normal(Success(OK));
      }
      catch (e: Dynamic) {    
        response = None;
        code     = Normal(Success(NoContent));
      }
      
      future.deliver({
        body:     response,
        headers:  Map.create(),
        code:     code
      });
    });
    
    var script = Env.document.createElement('SCRIPT');
    
    script.setAttribute('type', 'text/javascript');
    script.setAttribute('src',  url);
    script.setAttribute('id',   callbackName);
    
    Env.document.getElementsByTagName('HEAD')[0].appendChild(script);
    
    return future;
  }
  
  public function post(url: Url, data: JValue, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<JValue>> {
    return SCore.error('JSONP does not support POST');
  }
  
  public function put(url: Url, data: JValue, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<JValue>> {
    return SCore.error('JSONP does not support PUT');
  }
  
  public function delete(url: Url, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<JValue>> {
    return SCore.error('JSONP does not support DELETE');
  }
  
  public function custom(request: String, url: Url, data: JValue, ?params: QueryParameters, ?headers: Map<String, String>): Future<HttpResponse<JValue>> {
    return SCore.error('JSONP does not support custom request: ' + request);
  }
}

#end