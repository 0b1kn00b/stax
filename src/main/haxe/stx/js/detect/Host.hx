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
package stx.js.detect;

enum EnvironmentType {
  UnknownServer;
  NodeJs;
  IE(version: String);
  Firefox(version: String);
  Safari(version: String);
  Chrome(version: String);
  Unknown(what: String);
	Opera(version:String);
}

enum OSType {
  Windows;
  MacMobile;
  Android;
  Mac;
  Linux;
  Unknown(userAgent:String);
}

class Host {
  public static var Environment         = detectEnvironment();
  public static var OS                  = detectOS();
  
  private static var OperaPattern       = ~/Opera(?:\/| )(\S*)/;
  private static var ChromePattern      = ~/Chrome(?:\/| )(\S*)/;
  private static var SafariPattern      = ~/Version(?:\/| )(\S*) Safari(?:\/| )(\S*)/;
  private static var FirefoxPattern     = ~/Firefox(?:\/| )(\S*)/;
  private static var IEPattern          = ~/MSIE(?:\/| )(\S*);/;
  
  private static var WindowsPattern     = ~/Windows NT/;
  private static var MacPattern         = ~/Mac OS X/;
  private static var MacMobilePattern   = ~/(iPhone|iPad)/;
  private static var AndroidPattern     = ~/Android/;
  private static var LinuxPattern       = ~/Linux/;
  
  private static function detectEnvironment(): EnvironmentType {
    if (Env.navigator == null) return UnknownServer;
    else if (untyped __js__('process') != null) return NodeJs;
    
    var userAgent = Env.navigator.userAgent;

    return if (OperaPattern.match(userAgent)) Opera(OperaPattern.matched(1));
    else if (ChromePattern.match(userAgent)) Chrome(ChromePattern.matched(1));
    else if (SafariPattern.match(userAgent)) Safari(SafariPattern.matched(1));
    else if (FirefoxPattern.match(userAgent)) Firefox(FirefoxPattern.matched(1));
    else if (IEPattern.match(userAgent)) IE(IEPattern.matched(1));
    else Unknown(userAgent);
  }
  
  private static function detectOS(): OSType {
    if (Env.navigator == null) return OSType.Unknown('unknown');
    
    var userAgent = Env.navigator.userAgent;
    
    return if (WindowsPattern.match(userAgent)) OSType.Windows;
    else if (MacMobilePattern.match(userAgent)) OSType.MacMobile;
    else if (AndroidPattern.match(userAgent)) OSType.Android;
    else if (MacPattern.match(userAgent)) OSType.Mac;
    else if (LinuxPattern.match(userAgent)) OSType.Linux;
    else OSType.Unknown(userAgent);
  }
}