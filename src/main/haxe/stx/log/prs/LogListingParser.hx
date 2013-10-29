package stx.log.prs;

import stx.prs.*;

import stx.Positions;

import stx.log.Listing;
import stx.log.LogListing;
import stx.log.LogScope;

import stx.prs.Base.*;
import stx.prs.Parser.Parsers.*;

using stx.Tuples;

using stx.prs.Base;
using stx.prs.Parser;
using stx.prs.StringParsers;

/**
  *\  -> prefix for file
  $   -> prefix for classname
  &   -> prefix for method
  @   -> prefix for line number

  Not sure how to crank sensible error reporting out of this.

  '#' at the beginning of a line will ignore the line.
*/
class LogListingParser{
  static public var p_line        = '@'.id()._and(digit.many().token().then(Std.parseInt));
  static public var p_method      = '&'.id()._and(alphanum.or('_'.id()).many().token());
  static public var p_type        = "$".id()._and(alphanum.or('_'.id()).or('.'.id()).many().token());
  static public var p_file        = '*\\'.id()._and(alphanum.or('_'.id()).or('.'.id()).many().token());
  
  /**
    must figure out combinatorials.
  */
  static public var p_pos         = 
    p_file.and(p_type).andWith(p_method,Tuples2.entuple).andWith(p_line,Tuples3.entuple).then(
      function(file,type,method,line){
        return tuple2(LLineScope,Positions.create(file,type,method,line));
      }.tupled()
    ).or(
      p_file.and(p_type).andWith(p_method,Tuples2.entuple).then(
        function(file,type,method){
          return tuple2(LMethodScope,Positions.create(file,type,method,null));
        }.tupled()
      )
    ).or(
      p_file.and(p_type).then(
        function(type,file){
          return tuple2(LClassScope,Positions.create(file,type,null,null));
        }.tupled()
      )
    ).or(
      p_file.then(
        function(file){
          return tuple2(LFileScope,Positions.create(file,null,null,null));
        }
      )
    ).or(
      p_type.and(p_method).andWith(p_line,Tuples2.entuple).then(
        function(type,method,line){
          return tuple2(LMethodScope,Positions.create(null,type,method,line));
        }.tupled()
      )
    ).or(
      p_type.and(p_line).then(
        function(type,line){
          return tuple2(LLineScope,Positions.create(null,type,null,line));
        }.tupled()
    ).or(
      p_type.and(p_method).then(
        function(type,method){
          return tuple2(LMethodScope,Positions.create(null,type,method,null));
        }.tupled()
      )
    ).or(
      p_type.then(
        function(type){
          return tuple2(LClassScope,Positions.create(null,type,null,null));
        }
      )
    ).or(
      p_file.and(p_line).then(
        function(file,line){
          return tuple2(LLineScope,Positions.create(file,null,null,line));
        }.tupled()
      )
    )
  );
  static public var p_include = '+'.id()._and(p_pos).then(Include);
  static public var p_exclude = '-'.id()._and(p_pos).then(Exclude);
  static public var p_ignore  = 
    '#'.id()._and(anything().many().token().then(
      function(spare){
        return LogListings.nil;
      }
    ));
  static public var p_entry   = 
    gap.many()._and(
      p_ignore.or(p_include).or(p_exclude)
    ).and_(gap.many());

  static public var p_parse   = p_entry.and_(nl.option()).oneMany().and_(whitespace.many()).and_(end);

  static public function parse(str:String):Array<LogListing>{
    return switch (p_parse()(str.reader())) {
      case Success(match , _)             : match;
      case Fail(errorStack, rest, isFail) :
        return throw errorStack;
    }
  }
}