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
package stx.math.geom;

import stx.Tuples;

typedef Point2dType<T: Float> = {
  x: T,
  y: T
}
abstract Point2d<T:Float>(Point2dType<T>) from Point2dType<T> to Point2dType<T>{
  public function new(v){
    this = v;
  }
  public var x(get,never):T;
  public function get_x(){
    return this.x;
  }
  public var y(get,never):T;
  public function get_y(){
    return this.y;
  }
  public inline function sub(p1:Point2d<T>):Point2d<T>{
    return Points2d.sub(this,p1);
  }
  public inline function add(p1:Point2d<T>):Point2d<T>{
    return Points2d.add(this,p1);
  }
  public inline function map(f:T->T,g:T->T):Point2d<T>{
    return Points2d.map(this,f,g);
  }
}
class Points2d {
  public static inline function sub<T:Float>(p1: Point2d<T>, p2: Point2d<T>): Point2d<T> {
    return {
      x: p1.x - p2.x,
      y: p1.y - p2.y
    }
  }
  public static inline function add<T:Float>(p: Point2d<T>, v: Point2d<T>): Point2d<T> {
    return {
      x: p.x + v.x,
      y: p.y + v.y
    }
  }
  public static inline function map<T:Float>(p: Point2d<T>, f: T -> T, g: T -> T): Point2d<T> {
    return {
      x: f(p.x),
      y: g(p.y)
    }
  }
  public static inline function toVector<T:Float>(p: Point2d<T>): Point2d<T> {
    return {
      x: p.x,
      y: p.y
    }
  }  
  public static inline function toTuple<T:Float>(p: Point2d<T>): Tuple2<T, T> {
    return tuple2(p.x,p.y);
  }
}