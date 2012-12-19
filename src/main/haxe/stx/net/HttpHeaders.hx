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
package stx.net;

import stx.Tuples; using stx.Tuples;

using stx.Prelude;

import stx.ds.Map;
import stx.net.HttpHeader;



using stx.Strings;
 
using stx.Options;

typedef HttpHeaders = Map<String, String>

class Headers {
  static var HeaderPattern = ~/^([^:]+): *(.+)$/;
  static var HeaderLinesPattern = ~/[\r\n]+/;
  
  public static function toHttpHeader(str: String): Option<HttpHeader> {
    return if (HeaderPattern.match(str)) Some(HeaderPattern.matched(1).trim().entuple(HeaderPattern.matched(2).trim())); else None;
  }
  
  public static function toHttpHeaders(str: String): HttpHeaders {
    return Map.create().append(HeaderLinesPattern.split(str).flatMap(function(line) {
      return toHttpHeader(line.trim()).toArray();
    }));
  }
}