/*
 HaXe JSON library written by Spencer Tipping <spencer@socialmedia.com>
 Contributed by Social Media Networks

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

package stx.io.json.types.stx.io.json;

using stx.Tuples;							using stx.Tuples;
import stx.Prelude;
using stx.Prelude;


import stx.io.json.JValue;
import stx.io.json.Transcode;

using stx.Options;

using stx.Anys;

using stx.io.json.JValue;

class JValue extends AbstractTranscode<JValue,Void>{  
  public function new(){}
  public function decompose(v: JValue): JValue {
    return v;
  }
  public function extract(v: JValue): JValue {
    return v;
  }
  static public function extractor(){
    return Transcodes.transcoders.get(Type.getEnumName(stx.io.json.JValue)).extract;
  }
  static public function decomposer(){
    return Transcodes.transcoders.get(Type.getEnumName(stx.io.json.JValue)).decompose;
  }
  static public function transcoder(){
    return Transcodes.transcoders.get(Type.getEnumName(stx.io.json.JValue)); 
  }

}