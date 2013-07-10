package stx.log;

class DefaultLogger implements Logger, extends ZebraListings{
  @:noUsing
  static public function create(?listings:Array<LogListing>,?level) {
    return new DefaultLogger(listings,level);
  }
  /**Indicates whether non LogItems are traced.*/
  private var permissive                  : Bool;
  public  var level       (default,null)  : LogLevel;
  
  public function new(?listings:Array<LogListing>, ?level: LogLevel, ?permissive : Bool = true) {
    this.listings   = listings == null ? [] : listings;
    this.level      = level == null ? #if test Debug #else Warning #end: level;
    this.permissive = permissive;
  }
}