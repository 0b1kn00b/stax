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

package stx.net;

import stx.net.HttpResponseCode;

class HttpResponseCodes {
  public static function toHttpResponseCode(code: Int): HttpResponseCode {
    return switch(code) {
      case 100: Normal(Informational(Continue));
      case 101: Normal(Informational(SwitchingProtocols));
      case 102: Normal(Informational(Processing));  
      case 200: Normal(Success(OK));
      
      case 201: Normal(Success(Created));
      case 202: Normal(Success(Accepted));
      case 203: Normal(Success(Non));
      case 204: Normal(Success(NoContent));
      case 205: Normal(Success(ResetContent));
      case 206: Normal(Success(PartialContent));
      case 207: Normal(Success(Multi));
      
      case 300: Normal(Redirection(MultipleChoices));
      case 301: Normal(Redirection(MovedPermanently));
      case 302: Normal(Redirection(Found));
      case 303: Normal(Redirection(SeeOther));
      case 304: Normal(Redirection(NotModified));
      case 305: Normal(Redirection(UseProxy));
      case 307: Normal(Redirection(TemporaryRedirect));
      
      case 400: Fail(Client(BadRequest));
      case 401: Fail(Client(Unauthorized));
      case 402: Fail(Client(PaymentRequired));
      case 403: Fail(Client(Forbidden));
      case 404: Fail(Client(NotFound));
      case 405: Fail(Client(MethodNotAllowed));
      case 406: Fail(Client(NotAcceptable));
      case 407: Fail(Client(ProxyAuthenticationRequired));
      case 408: Fail(Client(RequestTimeout));
      case 409: Fail(Client(Conflict));
      case 410: Fail(Client(Gone));
      case 411: Fail(Client(LengthRequired));
      case 412: Fail(Client(PreconditionFailed));
      case 413: Fail(Client(RequestEntityTooLarge));
      case 414: Fail(Client(Request));
      case 415: Fail(Client(UnsupportedMediaType));
      case 416: Fail(Client(RequestedRangeNotSatisfiable));
      case 417: Fail(Client(ExpectationFailed));
      case 421: Fail(Client(TooManyConnections));
      case 422: Fail(Client(UnprocessableEntity));
      case 423: Fail(Client(Locked));
      case 424: Fail(Client(FailedDependency));
      case 425: Fail(Client(UnorderedCollection));
      case 426: Fail(Client(UpgradeRequired));
      case 449: Fail(Client(RetryWith));
      
      case 500: Fail(Server(InternalServerFail));
      case 501: Fail(Server(NotImplemented));
      case 502: Fail(Server(BadGateway));
      case 503: Fail(Server(ServiceUnavailable));
      case 504: Fail(Server(GatewayTimeout));
      case 505: Fail(Server(HTTPVersionNotSupported));
      case 506: Fail(Server(VariantAlsoNegotiates));
      case 507: Fail(Server(InsufficientStorage));
      case 509: Fail(Server(BandwidthLimitExceeded));
      case 510: Fail(Server(NotExtended));
      case 530: Fail(Server(UserAccessDenied));
      
      default: Normal(Success(OK));
    }
  }
  
  public static function isNormal(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Normal(_): true;
      
      default: false;
    }
  }
  
  public static function isInformational(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Normal(v): switch (v) {
        case Informational(_): true;
        
        default: false;
      }
      
      default: false;
    }
  }
  
  public static function isSuccess(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Normal(v): switch (v) {
        case Success(_): true;
        
        default: false;
      }
      
      default: false;
    }
  }
  
  public static function isRedirection(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Normal(v): switch (v) {
        case Redirection(_): true;
        
        default: false;
      }
      
      default: false;
    }
  }
  
  public static function isFail(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Fail(_): true;
      
      default: false;
    }
  }
  
  public static function isClientFail(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Fail(v): switch (v) {
        case Client(_): true;
        
        default: false;
      }
      
      default: false;
    }
  }
  
  public static function isServerFail(response: HttpResponseCode): Bool {
    return switch(response) { 
      case Fail(v): switch (v) {
        case Server(_): true;
        
        default: false;
      }
      
      default: false;
    }
  }
  
  public static function toStatusCode(response: HttpResponseCode): Int {
    return switch(response) { 
      case Normal(v): switch (v) {
        case Informational(v): switch(v) {
          case Continue: 100;
          case SwitchingProtocols: 101;
          case Processing: 102;
        }
        
        case Success(v): switch(v) {
          case OK: 200;
          case Created: 201;
          case Accepted: 202;
          case Non: 203;
          case NoContent: 204;
          case ResetContent: 205;
          case PartialContent: 206;
          case Multi: 207;
        }
        
        case Redirection(v): switch(v) {
          case MultipleChoices: 300;
          case MovedPermanently: 301;
          case Found: 302;
          case SeeOther: 303;
          case NotModified: 304;
          case UseProxy: 305;
          case TemporaryRedirect: 307;
        }
      }
      
      case Fail(v): switch(v) {
        case Client(v): switch(v) {
          case BadRequest: 400;
          case Unauthorized: 401;
          case PaymentRequired: 402;
          case Forbidden: 403;
          case NotFound: 404;
          case MethodNotAllowed: 405;
          case NotAcceptable: 406;
          case ProxyAuthenticationRequired: 407;
          case RequestTimeout: 408;
          case Conflict: 409;
          case Gone: 410;
          case LengthRequired: 411;
          case PreconditionFailed: 412;
          case RequestEntityTooLarge: 413;
          case Request: 414;
          case UnsupportedMediaType: 415;
          case RequestedRangeNotSatisfiable: 416;
          case ExpectationFailed: 417;
          case TooManyConnections: 421;
          case UnprocessableEntity: 422;
          case Locked: 423;
          case FailedDependency: 424;
          case UnorderedCollection: 425;
          case UpgradeRequired: 426;
          case RetryWith: 449;
        }
        
        case Server(v): switch(v) {
          case InternalServerFail: 500;
          case NotImplemented: 501;
          case BadGateway: 502;
          case ServiceUnavailable: 503;
          case GatewayTimeout: 504;
          case HTTPVersionNotSupported: 505;
          case VariantAlsoNegotiates: 506;
          case InsufficientStorage: 507;
          case BandwidthLimitExceeded: 509;
          case NotExtended: 510;
          case UserAccessDenied: 530;
        }
      }
    }
  }
}