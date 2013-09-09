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

typedef Vector2dType<T: Float> = {
  dx: T,
  dy: T
}
abstract Vector2d<T:Float>(Vector2dType<T>) from Vector2dType<T> to Vector2dType<T>{
  public function new(v){
    this = v;
  }
  public var dx(get,never):T;
  private function get_dx(){
    return this.dx;
  }
  public var dy(get,never):T;
  private function get_dy():T{
    return this.dy;
  }
  public inline function sub<T:Float>(v2: Vector2d<T>): Vector2d<T> {
    return Vectors2d.sub(this,v2);
  }
  
  public inline function add<T:Float>(v2: Vector2d<T>): Vector2d<T> {
    return Vectors2d.add(this,v2);
  }
  
  public inline function mul<T:Float>(factor: T): Vector2d<T> {
    return Vectors2d.mul(this,factor);
  }

  public inline function dot<T:Float>(v2: Vector2d<T>): T {
    return Vectors2d.dot(this,v2);
  }
  
  public inline function map<T:Float>(f: T -> T, g: T -> T): Vector2d<T> {
    return Vectors2d.map(this,f,g);
  }
}
class Vectors2d{
  public static inline function sub<T:Float>(v1: Vector2d<T>, v2: Vector2d<T>): Vector2d<T> {
    return {
      dx: v1.dx - v2.dx,
      dy: v1.dy - v2.dy
    }
  }
  
  public static inline function add<T:Float>(v1: Vector2d<T>, v2: Vector2d<T>): Vector2d<T> {
    return {
      dx: v1.dx + v2.dx,
      dy: v1.dy + v2.dy
    }
  }
  
  public static inline function mul<T:Float>(v: Vector2d<T>, factor: T): Vector2d<T> {
    return {
      dx: v.dx * factor,
      dy: v.dy * factor
    }
  }

  public static inline function dot<T:Float>(v1: Vector2d<T>, v2: Vector2d<T>): T {
    return v1.dx * v2.dx + v1.dy * v2.dy;
  }
  
  public static inline function map<T:Float>(v: Vector2d<T>, f: T -> T, g: T -> T): Vector2d<T> {
    return {
      dx: f(v.dx),
      dy: g(v.dy)
    }
  }
  
  public static inline function toPoint<T:Float>(v: Vector2d<T>): Point2d<T> {
    return {
      x: v.dx,
      y: v.dy
    }
  }
  public static inline function toTuple<T:Float>(v: Vector2d<T>): Tuple2<T, T> {
    return tuple2(v.dx,v.dy);
  }
}