/*
 HaXe library written by John A. De Goes <john@socialmedia.com>
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
package stx.io.http;

import stx.Prelude;
import stx.test.TestCase;
import stx.test.Assert;
import stx.io.http.Http;
import stx.io.http.HttpJValue;
import stx.io.json.Json;


using stx.io.json.JValueExtensions;
using stx.Options;
using stx.ds.Map;

class HttpJValueJsonpTestCase extends TestCase {
  var h: HttpJValue;
  
  public function new() {
    super();
  }
  
  override public function before() {
    h = new HttpJValueJsonp();
  }
  
  public function testGet() {
    var async = Assert.createAsync( function() {} , 10000 );
    Assert.delivered( h.get('http://search.twitter.com/search.json', { q: 'santa' }.toMap()) ,
        function(data){
          var results = data.body.get().get('results');
          Assert.notNull(results);
          async();
        }
    );
    /*Assert.delivered(,
      function(data) {
        var results = data.body.get().get('results');
        
        Assert.notNull(results);
      },
      4000
    );*/
  }
}