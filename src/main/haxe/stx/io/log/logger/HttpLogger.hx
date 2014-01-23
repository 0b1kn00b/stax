package stx.io.log.logger;

import Stax.*;

import haxe.Http;
import Type;

using stx.Types;

class HttpLogger extends DefaultLogger{
  private var url : String;

  public function new(?url:String,?listings:Array<LogListing>, ?level:LogLevel, ?permissive:Bool=true){
    super(listings,level,permissive);
    this.url = url == null ? 'http://localhost:8024/var/log/flashlog/publish' : url;
  }  
  override public function apply(v:Dynamic,?pos:haxe.PosInfos){
    return switch (v.vtype()) {
      case TClass(LogItem)  : 
        var http = new Http(url).setPostData(v.toJson());
            http.setHeader('Content-Type','application/json');
            http.onError = printer();
            http.request(true);
      default               :
    }
  }
}