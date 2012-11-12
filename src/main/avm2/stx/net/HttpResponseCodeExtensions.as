package stx.net {
	import stx.net.HttpNormal;
	import stx.net.HttpSuccess;
	import stx.net.HttpResponseCode;
	import stx.net.HttpServerError;
	import stx.net.HttpInformational;
	import stx.net.HttpError;
	import stx.net.HttpRedirection;
	import stx.net.HttpClientError;
	public class HttpResponseCodeExtensions {
		static public function toHttpResponseCode(code : int) : stx.net.HttpResponseCode {
			return function() : stx.net.HttpResponseCode {
				var $r : stx.net.HttpResponseCode;
				switch(code) {
				case 100:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.Continue));
				break;
				case 101:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.SwitchingProtocols));
				break;
				case 102:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Informational(stx.net.HttpInformational.Processing));
				break;
				case 200:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.OK));
				break;
				case 201:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Created));
				break;
				case 202:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Accepted));
				break;
				case 203:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Non));
				break;
				case 204:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.NoContent));
				break;
				case 205:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.ResetContent));
				break;
				case 206:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.PartialContent));
				break;
				case 207:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.Multi));
				break;
				case 300:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.MultipleChoices));
				break;
				case 301:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.MovedPermanently));
				break;
				case 302:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.Found));
				break;
				case 303:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.SeeOther));
				break;
				case 304:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.NotModified));
				break;
				case 305:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.UseProxy));
				break;
				case 307:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Redirection(stx.net.HttpRedirection.TemporaryRedirect));
				break;
				case 400:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.BadRequest));
				break;
				case 401:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Unauthorized));
				break;
				case 402:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.PaymentRequired));
				break;
				case 403:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Forbidden));
				break;
				case 404:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.NotFound));
				break;
				case 405:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.MethodNotAllowed));
				break;
				case 406:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.NotAcceptable));
				break;
				case 407:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.ProxyAuthenticationRequired));
				break;
				case 408:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestTimeout));
				break;
				case 409:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Conflict));
				break;
				case 410:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Gone));
				break;
				case 411:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.LengthRequired));
				break;
				case 412:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.PreconditionFailed));
				break;
				case 413:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestEntityTooLarge));
				break;
				case 414:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Request));
				break;
				case 415:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnsupportedMediaType));
				break;
				case 416:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RequestedRangeNotSatisfiable));
				break;
				case 417:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.ExpectationFailed));
				break;
				case 421:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.TooManyConnections));
				break;
				case 422:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnprocessableEntity));
				break;
				case 423:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.Locked));
				break;
				case 424:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.FailedDependency));
				break;
				case 425:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UnorderedCollection));
				break;
				case 426:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.UpgradeRequired));
				break;
				case 449:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Client(stx.net.HttpClientError.RetryWith));
				break;
				case 500:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.InternalServerError));
				break;
				case 501:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.NotImplemented));
				break;
				case 502:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.BadGateway));
				break;
				case 503:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.ServiceUnavailable));
				break;
				case 504:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.GatewayTimeout));
				break;
				case 505:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.HTTPVersionNotSupported));
				break;
				case 506:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.VariantAlsoNegotiates));
				break;
				case 507:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.InsufficientStorage));
				break;
				case 509:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.BandwidthLimitExceeded));
				break;
				case 510:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.NotExtended));
				break;
				case 530:
				$r = stx.net.HttpResponseCode.Error(stx.net.HttpError.Server(stx.net.HttpServerError.UserAccessDenied));
				break;
				default:
				$r = stx.net.HttpResponseCode.Normal(stx.net.HttpNormal.Success(stx.net.HttpSuccess.OK));
				break;
				}
				return $r;
			}();
		}
		
		static public function isNormal(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 0:
					var v : stx.net.HttpNormal = $e2.params[0];
					$r = true;
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isInformational(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 0:
					var v : stx.net.HttpNormal = $e2.params[0];
					$r = function() : Boolean {
						var $r3 : Boolean;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 0:
							var v1 : stx.net.HttpInformational = $e4.params[0];
							$r3 = true;
							break;
							default:
							$r3 = false;
							break;
							}
						}
						return $r3;
					}();
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isSuccess(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 0:
					var v : stx.net.HttpNormal = $e2.params[0];
					$r = function() : Boolean {
						var $r3 : Boolean;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 1:
							var v1 : stx.net.HttpSuccess = $e4.params[0];
							$r3 = true;
							break;
							default:
							$r3 = false;
							break;
							}
						}
						return $r3;
					}();
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isRedirection(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 0:
					var v : stx.net.HttpNormal = $e2.params[0];
					$r = function() : Boolean {
						var $r3 : Boolean;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 2:
							var v1 : stx.net.HttpRedirection = $e4.params[0];
							$r3 = true;
							break;
							default:
							$r3 = false;
							break;
							}
						}
						return $r3;
					}();
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isError(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 1:
					var v : stx.net.HttpError = $e2.params[0];
					$r = true;
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isClientError(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 1:
					var v : stx.net.HttpError = $e2.params[0];
					$r = function() : Boolean {
						var $r3 : Boolean;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 0:
							var v1 : stx.net.HttpClientError = $e4.params[0];
							$r3 = true;
							break;
							default:
							$r3 = false;
							break;
							}
						}
						return $r3;
					}();
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isServerError(response : stx.net.HttpResponseCode) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 1:
					var v : stx.net.HttpError = $e2.params[0];
					$r = function() : Boolean {
						var $r3 : Boolean;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 1:
							var v1 : stx.net.HttpServerError = $e4.params[0];
							$r3 = true;
							break;
							default:
							$r3 = false;
							break;
							}
						}
						return $r3;
					}();
					break;
					default:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function toStatusCode(response : stx.net.HttpResponseCode) : int {
			return function() : int {
				var $r : int;
				{
					var $e2 : enum = (response);
					switch( $e2.index ) {
					case 0:
					var v : stx.net.HttpNormal = $e2.params[0];
					$r = function() : int {
						var $r3 : int;
						{
							var $e4 : enum = (v);
							switch( $e4.index ) {
							case 0:
							var v1 : stx.net.HttpInformational = $e4.params[0];
							$r3 = function() : int {
								var $r5 : int;
								{
									var $e6 : enum = (v1);
									switch( $e6.index ) {
									case 0:
									$r5 = 100;
									break;
									case 1:
									$r5 = 101;
									break;
									case 2:
									$r5 = 102;
									break;
									}
								}
								return $r5;
							}();
							break;
							case 1:
							var v2 : stx.net.HttpSuccess = $e4.params[0];
							$r3 = function() : int {
								var $r7 : int;
								{
									var $e8 : enum = (v2);
									switch( $e8.index ) {
									case 0:
									$r7 = 200;
									break;
									case 1:
									$r7 = 201;
									break;
									case 2:
									$r7 = 202;
									break;
									case 3:
									$r7 = 203;
									break;
									case 4:
									$r7 = 204;
									break;
									case 5:
									$r7 = 205;
									break;
									case 6:
									$r7 = 206;
									break;
									case 7:
									$r7 = 207;
									break;
									}
								}
								return $r7;
							}();
							break;
							case 2:
							var v3 : stx.net.HttpRedirection = $e4.params[0];
							$r3 = function() : int {
								var $r9 : int;
								{
									var $e10 : enum = (v3);
									switch( $e10.index ) {
									case 0:
									$r9 = 300;
									break;
									case 1:
									$r9 = 301;
									break;
									case 2:
									$r9 = 302;
									break;
									case 3:
									$r9 = 303;
									break;
									case 4:
									$r9 = 304;
									break;
									case 5:
									$r9 = 305;
									break;
									case 6:
									$r9 = 307;
									break;
									}
								}
								return $r9;
							}();
							break;
							}
						}
						return $r3;
					}();
					break;
					case 1:
					var v4 : stx.net.HttpError = $e2.params[0];
					$r = function() : int {
						var $r11 : int;
						{
							var $e12 : enum = (v4);
							switch( $e12.index ) {
							case 0:
							var v5 : stx.net.HttpClientError = $e12.params[0];
							$r11 = function() : int {
								var $r13 : int;
								{
									var $e14 : enum = (v5);
									switch( $e14.index ) {
									case 0:
									$r13 = 400;
									break;
									case 1:
									$r13 = 401;
									break;
									case 2:
									$r13 = 402;
									break;
									case 3:
									$r13 = 403;
									break;
									case 4:
									$r13 = 404;
									break;
									case 5:
									$r13 = 405;
									break;
									case 6:
									$r13 = 406;
									break;
									case 7:
									$r13 = 407;
									break;
									case 8:
									$r13 = 408;
									break;
									case 9:
									$r13 = 409;
									break;
									case 10:
									$r13 = 410;
									break;
									case 11:
									$r13 = 411;
									break;
									case 12:
									$r13 = 412;
									break;
									case 13:
									$r13 = 413;
									break;
									case 14:
									$r13 = 414;
									break;
									case 15:
									$r13 = 415;
									break;
									case 16:
									$r13 = 416;
									break;
									case 17:
									$r13 = 417;
									break;
									case 18:
									$r13 = 421;
									break;
									case 19:
									$r13 = 422;
									break;
									case 20:
									$r13 = 423;
									break;
									case 21:
									$r13 = 424;
									break;
									case 22:
									$r13 = 425;
									break;
									case 23:
									$r13 = 426;
									break;
									case 24:
									$r13 = 449;
									break;
									}
								}
								return $r13;
							}();
							break;
							case 1:
							var v6 : stx.net.HttpServerError = $e12.params[0];
							$r11 = function() : int {
								var $r15 : int;
								{
									var $e16 : enum = (v6);
									switch( $e16.index ) {
									case 0:
									$r15 = 500;
									break;
									case 1:
									$r15 = 501;
									break;
									case 2:
									$r15 = 502;
									break;
									case 3:
									$r15 = 503;
									break;
									case 4:
									$r15 = 504;
									break;
									case 5:
									$r15 = 505;
									break;
									case 6:
									$r15 = 506;
									break;
									case 7:
									$r15 = 507;
									break;
									case 8:
									$r15 = 509;
									break;
									case 9:
									$r15 = 510;
									break;
									case 10:
									$r15 = 530;
									break;
									}
								}
								return $r15;
							}();
							break;
							}
						}
						return $r11;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
