package funk.net.http;

enum HttpStatusCode {
    HttpUnknown(code : Int);
    HttpInformational(code : HttpInformational);
    HttpSuccess(code : HttpSuccess);
    HttpRedirection(code : HttpRedirection);
    HttpClientFail(code : HttpClientFail);
    HttpServerFail(code : HttpServerFail);
}

enum HttpInformational {
    Continue;
    SwitchingProtocols;
    Processing;
}

enum HttpSuccess {
    OK;
    Created;
    Accepted;
    NonAuthoritativeInformation;
    NoContent;
    ResetContent;
    PartialContent;
    MultiStatus;
    AlreadyReported;
    IMUsed;
    AuthenticationSuccessful;
}

enum HttpRedirection {
    MultipleChoices;
    MovedPermanently;
    Found;
    SeeOther;
    NotModified;
    UseProxy;
    SwitchProxy;
    TemporaryRedirect;
    PermanentRedirect;
}

enum HttpClientFail {
    BadRequest;
    Unauthorized;
    PaymentRequired;
    Forbidden;
    NotFound;
    MethodNotAllowed;
    NotAcceptable;
    ProxyAuthenticationRequired;
    RequestTimeout;
    Conflict;
    Gone;
    LengthRequired;
    PreconditionFailed;
    RequestEntityTooLarge;
    RequestUriTooLong;
    UnsupportedMediaType;
    RequestedRangeNotSatisfiable;
    ExpectationFailed;
    ImATeapot;
    EnhanceYourCalm;
    TooManyConnections;
    UnprocessableEntity;
    Locked;
    Fail;
    UnorderedCollection;
    UpgradeRequired;
    PreconditionRequired;
    TooManyRequests;
    RequestHeaderFieldsTooLarge;
    NoResponse;
    RetryWith;
    BlockedByWindowsParentalControls;
    Redirect;
    RequestHeaderTooLarget;
    CertFail;
    NoCert;
    HttpToHttps;
    ClientClosedRequest;
}

enum HttpServerFail {
    InternalServerFail;
    NotImplemented;
    BadGateway;
    ServiceUnavailable;
    GatewayTimeout;
    HTTPVersionNotSupported;
    VariantAlsoNegotiates;
    InsufficientStorage;
    LoopDetected;
    BandwidthLimitExceeded;
    NotExtended;
    NetworkAuthenticationRequired;
    AccessDenied;
    NetworkReadTimeoutFail;
    NetworkConnectTimeoutFail;
}

class HttpStatusCodeTypes {

    public static function isHttpInformational(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpInformational(_): true;
            default: false;
        }
    }

    public static function isHttpSuccess(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpSuccess(_): true;
            default: false;
        }
    }

    public static function isHttpRedirection(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpRedirection(_): true;
            default: false;
        }
    }

    public static function isHttpClientFail(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpClientFail(_): true;
            default: false;
        }
    }

    public static function isHttpServerFail(code : HttpStatusCode) : Bool {
        return switch(code) {
            case HttpServerFail(_): true;
            default: false;
        }
    }

    public static function toHttpStatusCode(code : Int) : HttpStatusCode {
        // Note (Simon) : This has to be this way so we pass full coverage (I'd rather use a switch tbh)
        return if (code >= 100 && code <= 199) {

            if (code == 100) { HttpInformational(Continue); }
            else if (code == 101) { HttpInformational(SwitchingProtocols); }
            else if (code == 102) { HttpInformational(Processing); }
            else { HttpUnknown(code); }

        } else if (code >= 200 && code <= 299) {

            if (code == 200) { HttpSuccess(OK); }
            else if (code == 201) { HttpSuccess(Created); }
            else if (code == 202) { HttpSuccess(Accepted); }
            else if (code == 203) { HttpSuccess(NonAuthoritativeInformation); }
            else if (code == 204) { HttpSuccess(NoContent); }
            else if (code == 205) { HttpSuccess(ResetContent); }
            else if (code == 206) { HttpSuccess(PartialContent); }
            else if (code == 207) { HttpSuccess(MultiStatus); }
            else if (code == 208) { HttpSuccess(AlreadyReported); }
            else if (code == 226) { HttpSuccess(IMUsed); }
            else if (code == 230) { HttpSuccess(AuthenticationSuccessful); }
            else { HttpUnknown(code); }

        } else if (code >= 300 && code <= 399) {

            if (code == 300) { HttpRedirection(MultipleChoices); }
            else if (code == 301) { HttpRedirection(MovedPermanently); }
            else if (code == 302) { HttpRedirection(Found); }
            else if (code == 303) { HttpRedirection(SeeOther); }
            else if (code == 304) { HttpRedirection(NotModified); }
            else if (code == 305) { HttpRedirection(UseProxy); }
            else if (code == 306) { HttpRedirection(SwitchProxy); }
            else if (code == 307) { HttpRedirection(TemporaryRedirect); }
            else if (code == 308) { HttpRedirection(PermanentRedirect); }
            else { HttpUnknown(code); }

        } else if (code >= 400 && code <= 499) {

            if (code == 400) { HttpClientFail(BadRequest); }
            else if (code == 401) { HttpClientFail(Unauthorized); }
            else if (code == 402) { HttpClientFail(PaymentRequired); }
            else if (code == 403) { HttpClientFail(Forbidden); }
            else if (code == 404) { HttpClientFail(NotFound); }
            else if (code == 405) { HttpClientFail(MethodNotAllowed); }
            else if (code == 406) { HttpClientFail(NotAcceptable); }
            else if (code == 407) { HttpClientFail(ProxyAuthenticationRequired); }
            else if (code == 408) { HttpClientFail(RequestTimeout); }
            else if (code == 409) { HttpClientFail(Conflict); }
            else if (code == 410) { HttpClientFail(Gone); }
            else if (code == 411) { HttpClientFail(LengthRequired); }
            else if (code == 412) { HttpClientFail(PreconditionFailed); }
            else if (code == 413) { HttpClientFail(RequestEntityTooLarge); }
            else if (code == 414) { HttpClientFail(RequestUriTooLong); }
            else if (code == 415) { HttpClientFail(UnsupportedMediaType); }
            else if (code == 416) { HttpClientFail(RequestedRangeNotSatisfiable); }
            else if (code == 417) { HttpClientFail(ExpectationFailed); }
            else if (code == 418) { HttpClientFail(ImATeapot); }
            else if (code == 420) { HttpClientFail(EnhanceYourCalm); }
            else if (code == 421) { HttpClientFail(TooManyConnections); }
            else if (code == 422) { HttpClientFail(UnprocessableEntity); }
            else if (code == 423) { HttpClientFail(Locked); }
            else if (code == 424) { HttpClientFail(Fail); }
            else if (code == 425) { HttpClientFail(UnorderedCollection); }
            else if (code == 426) { HttpClientFail(UpgradeRequired); }
            else if (code == 428) { HttpClientFail(PreconditionRequired); }
            else if (code == 429) { HttpClientFail(TooManyRequests); }
            else if (code == 431) { HttpClientFail(RequestHeaderFieldsTooLarge); }
            else if (code == 444) { HttpClientFail(NoResponse); }
            else if (code == 449) { HttpClientFail(RetryWith); }
            else if (code == 450) { HttpClientFail(BlockedByWindowsParentalControls); }
            else if (code == 451) { HttpClientFail(Redirect); }
            else if (code == 494) { HttpClientFail(RequestHeaderTooLarget); }
            else if (code == 495) { HttpClientFail(CertFail); }
            else if (code == 496) { HttpClientFail(NoCert); }
            else if (code == 497) { HttpClientFail(HttpToHttps); }
            else if (code == 499) { HttpClientFail(ClientClosedRequest); }
            else { HttpUnknown(code); }

        } else if (code >= 500 && code <= 599)  {

            if (code == 500) { HttpServerFail(InternalServerFail); }
            else if (code == 501) { HttpServerFail(NotImplemented); }
            else if (code == 502) { HttpServerFail(BadGateway); }
            else if (code == 503) { HttpServerFail(ServiceUnavailable); }
            else if (code == 504) { HttpServerFail(GatewayTimeout); }
            else if (code == 505) { HttpServerFail(HTTPVersionNotSupported); }
            else if (code == 506) { HttpServerFail(VariantAlsoNegotiates); }
            else if (code == 507) { HttpServerFail(InsufficientStorage); }
            else if (code == 508) { HttpServerFail(LoopDetected); }
            else if (code == 509) { HttpServerFail(BandwidthLimitExceeded); }
            else if (code == 510) { HttpServerFail(NotExtended); }
            else if (code == 511) { HttpServerFail(NetworkAuthenticationRequired); }
            else if (code == 531) { HttpServerFail(AccessDenied); }
            else if (code == 598) { HttpServerFail(NetworkReadTimeoutFail); }
            else if (code == 599) { HttpServerFail(NetworkConnectTimeoutFail); }
            else { HttpUnknown(code); }

        } else {

            HttpUnknown(code);

        }
    }

    public static function toStatusCode(code : HttpStatusCode) : Int {
        return switch(code) {
            case HttpInformational(Continue): 100;
            case HttpInformational(SwitchingProtocols): 101;
            case HttpInformational(Processing): 102;
            case HttpSuccess(OK): 200;
            case HttpSuccess(Created): 201;
            case HttpSuccess(Accepted): 202;
            case HttpSuccess(NonAuthoritativeInformation): 203;
            case HttpSuccess(NoContent): 204;
            case HttpSuccess(ResetContent): 205;
            case HttpSuccess(PartialContent): 206;
            case HttpSuccess(MultiStatus): 207;
            case HttpSuccess(AlreadyReported): 208;
            case HttpSuccess(IMUsed): 226;
            case HttpSuccess(AuthenticationSuccessful): 230;
            case HttpRedirection(MultipleChoices): 300;
            case HttpRedirection(MovedPermanently): 301;
            case HttpRedirection(Found): 302;
            case HttpRedirection(SeeOther): 303;
            case HttpRedirection(NotModified): 304;
            case HttpRedirection(UseProxy): 305;
            case HttpRedirection(SwitchProxy): 306;
            case HttpRedirection(TemporaryRedirect): 307;
            case HttpRedirection(PermanentRedirect): 308;
            case HttpClientFail(BadRequest): 400;
            case HttpClientFail(Unauthorized): 401;
            case HttpClientFail(PaymentRequired): 402;
            case HttpClientFail(Forbidden): 403;
            case HttpClientFail(NotFound): 404;
            case HttpClientFail(MethodNotAllowed): 405;
            case HttpClientFail(NotAcceptable): 406;
            case HttpClientFail(ProxyAuthenticationRequired): 407;
            case HttpClientFail(RequestTimeout): 408;
            case HttpClientFail(Conflict): 409;
            case HttpClientFail(Gone): 410;
            case HttpClientFail(LengthRequired): 411;
            case HttpClientFail(PreconditionFailed): 412;
            case HttpClientFail(RequestEntityTooLarge): 413;
            case HttpClientFail(RequestUriTooLong): 414;
            case HttpClientFail(UnsupportedMediaType): 415;
            case HttpClientFail(RequestedRangeNotSatisfiable): 416;
            case HttpClientFail(ExpectationFailed): 417;
            case HttpClientFail(ImATeapot): 418;
            case HttpClientFail(EnhanceYourCalm): 420;
            case HttpClientFail(TooManyConnections): 421;
            case HttpClientFail(UnprocessableEntity): 422;
            case HttpClientFail(Locked): 423;
            case HttpClientFail(Fail): 424;
            case HttpClientFail(UnorderedCollection): 425;
            case HttpClientFail(UpgradeRequired): 426;
            case HttpClientFail(PreconditionRequired): 428;
            case HttpClientFail(TooManyRequests): 429;
            case HttpClientFail(RequestHeaderFieldsTooLarge): 431;
            case HttpClientFail(NoResponse): 444;
            case HttpClientFail(RetryWith): 449;
            case HttpClientFail(BlockedByWindowsParentalControls): 450;
            case HttpClientFail(Redirect): 451;
            case HttpClientFail(RequestHeaderTooLarget): 494;
            case HttpClientFail(CertFail): 495;
            case HttpClientFail(NoCert): 496;
            case HttpClientFail(HttpToHttps): 497;
            case HttpClientFail(ClientClosedRequest): 499;
            case HttpServerFail(InternalServerFail): 500;
            case HttpServerFail(NotImplemented): 501;
            case HttpServerFail(BadGateway): 502;
            case HttpServerFail(ServiceUnavailable): 503;
            case HttpServerFail(GatewayTimeout): 504;
            case HttpServerFail(HTTPVersionNotSupported): 505;
            case HttpServerFail(VariantAlsoNegotiates): 506;
            case HttpServerFail(InsufficientStorage): 507;
            case HttpServerFail(LoopDetected): 508;
            case HttpServerFail(BandwidthLimitExceeded): 509;
            case HttpServerFail(NotExtended): 510;
            case HttpServerFail(NetworkAuthenticationRequired): 511;
            case HttpServerFail(AccessDenied): 531;
            case HttpServerFail(NetworkReadTimeoutFail): 598;
            case HttpServerFail(NetworkConnectTimeoutFail): 599;
            case HttpUnknown(v): v;
        }
    }

    public static function toHttpVersion(code : HttpStatusCode) : HttpVersion {
        return switch(code) {
            case HttpInformational(Continue): Http("1.1");
            case HttpInformational(SwitchingProtocols): Http("1.1");
            case HttpInformational(Processing): WebDav("RFC 2518");
            case HttpSuccess(OK): Http("1.0");
            case HttpSuccess(Created): Http("1.0");
            case HttpSuccess(Accepted): Http("1.0");
            case HttpSuccess(NonAuthoritativeInformation): Http("1.1");
            case HttpSuccess(NoContent): Http("1.0");
            case HttpSuccess(ResetContent): Http("1.0");
            case HttpSuccess(PartialContent): Http("1.0");
            case HttpSuccess(MultiStatus): WebDav("RFC 4918");
            case HttpSuccess(AlreadyReported): WebDav("RFC 5842");
            case HttpSuccess(IMUsed): Unknown("RFC 3229");
            case HttpSuccess(AuthenticationSuccessful): Unknown("RFC 2229");
            case HttpRedirection(MultipleChoices): Http("1.0");
            case HttpRedirection(MovedPermanently): Http("1.0");
            case HttpRedirection(Found): Http("1.0");
            case HttpRedirection(SeeOther): Http("1.1");
            case HttpRedirection(NotModified): Http("1.0");
            case HttpRedirection(UseProxy): Http("1.1");
            case HttpRedirection(SwitchProxy): Http("1.0");
            case HttpRedirection(TemporaryRedirect): Http("1.1");
            case HttpRedirection(PermanentRedirect): Unknown("RFC ?");
            case HttpClientFail(BadRequest): Http("1.0");
            case HttpClientFail(Unauthorized): Http("1.0");
            case HttpClientFail(PaymentRequired): Http("1.0");
            case HttpClientFail(Forbidden): Http("1.0");
            case HttpClientFail(NotFound): Http("1.0");
            case HttpClientFail(MethodNotAllowed): Http("1.0");
            case HttpClientFail(NotAcceptable): Http("1.0");
            case HttpClientFail(ProxyAuthenticationRequired): Http("1.0");
            case HttpClientFail(RequestTimeout): Http("1.0");
            case HttpClientFail(Conflict): Http("1.0");
            case HttpClientFail(Gone): Http("1.0");
            case HttpClientFail(LengthRequired): Http("1.0");
            case HttpClientFail(PreconditionFailed): Http("1.0");
            case HttpClientFail(RequestEntityTooLarge): Http("1.0");
            case HttpClientFail(RequestUriTooLong): Http("1.0");
            case HttpClientFail(UnsupportedMediaType): Http("1.0");
            case HttpClientFail(RequestedRangeNotSatisfiable): Http("1.0");
            case HttpClientFail(ExpectationFailed): Http("1.0");
            case HttpClientFail(ImATeapot): Unknown("RFC 2324");
            case HttpClientFail(EnhanceYourCalm): Unknown("?");
            case HttpClientFail(TooManyConnections): Unknown("?");
            case HttpClientFail(UnprocessableEntity): WebDav("RFC 4918");
            case HttpClientFail(Locked): WebDav("RFC 4918");
            case HttpClientFail(Fail): WebDav("RFC 4918");
            case HttpClientFail(UnorderedCollection): Unknown("?");
            case HttpClientFail(UpgradeRequired): Unknown("RFC 2817");
            case HttpClientFail(PreconditionRequired): Unknown("RFC 6585");
            case HttpClientFail(TooManyRequests): Unknown("RFC 6585");
            case HttpClientFail(RequestHeaderFieldsTooLarge): Unknown("RFC 6585");
            case HttpClientFail(NoResponse): Unknown("Nginx");
            case HttpClientFail(RetryWith): Unknown("Microsoft");
            case HttpClientFail(BlockedByWindowsParentalControls): Unknown("Microsoft");
            case HttpClientFail(Redirect): Unknown("Microsoft");
            case HttpClientFail(RequestHeaderTooLarget): Unknown("Nginx");
            case HttpClientFail(CertFail): Unknown("Nginx");
            case HttpClientFail(NoCert): Unknown("Nginx");
            case HttpClientFail(HttpToHttps): Unknown("Nginx");
            case HttpClientFail(ClientClosedRequest): Unknown("Nginx");
            case HttpServerFail(InternalServerFail): Http("1.0");
            case HttpServerFail(NotImplemented): Http("1.0");
            case HttpServerFail(BadGateway): Http("1.0");
            case HttpServerFail(ServiceUnavailable): Http("1.0");
            case HttpServerFail(GatewayTimeout): Http("1.0");
            case HttpServerFail(HTTPVersionNotSupported): Http("1.0");
            case HttpServerFail(VariantAlsoNegotiates): WebDav("RFC 2295");
            case HttpServerFail(InsufficientStorage): WebDav("RFC 4918");
            case HttpServerFail(LoopDetected): WebDav("RFC 5842");
            case HttpServerFail(BandwidthLimitExceeded): Unknown("Apache");
            case HttpServerFail(NotExtended): Unknown("RFC 2774");
            case HttpServerFail(NetworkAuthenticationRequired): Unknown("RFC 6585");
            case HttpServerFail(AccessDenied): Unknown("RFC 2229");
            case HttpServerFail(NetworkReadTimeoutFail): Unknown("Microsoft");
            case HttpServerFail(NetworkConnectTimeoutFail): Unknown("Microsoft");
            case HttpUnknown(_): Unknown("?");
        }
    }
}
