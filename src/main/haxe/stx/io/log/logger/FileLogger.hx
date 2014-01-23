package stx.log.logger;

using stx.Strings;
import sys.FileSystem;
import sys.io.File;

class FileLogger extends DefaultLogger{
  private var location : String;
  public function new(location,?listings:Array<LogListing>, ?level:LogLevel, ?permissive:Bool=true){
    super(listings,level,permissive);
    this.location = location;
    if(!FileSystem.exists(location)){
      var fl = File.write(location);
          fl.writeString('Log Initialized/n');
          fl.close();
    }
  }
  override public function apply(v:Dynamic,?pos:haxe.PosInfos){
    var handle  = File.append(location);
    var val     = stx.Show.getShowFor(v)(v);
    if(!val.contains('\n')){
      val+="\n";
    }
    handle.writeString(val);
    handle.close();
  }
}