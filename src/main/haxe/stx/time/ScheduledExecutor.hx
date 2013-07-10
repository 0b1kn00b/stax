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
package stx.time;

#if !(neko || php || cpp)
import haxe.Timer;
#end

import stx.Prelude;
import stx.Eventual;
/** A scheduled executor service, which can be used to execute tasks at 
 * specified times in the future.
 */
@DefaultImplementation("stx.time.ScheduledExecutorSystem", "OneToMany")
interface ScheduledExecutor {
  /** Executes the function a single time the specified number of milliseconds 
   * into the future, returning a future of the return value of the function.
   */
  public function once<T>(f: Void -> T, ms: Int): Eventual<T>;
  
  /** Executes the reducer a fixed number of times, each separated by the specified
   * number of milliseconds, returning a future of the completed reduction.
   */
  public function repeat<T>(seed: T, f: T -> T, ms: Int, times: Int): Eventual<T>;
  
  /** Executes the reducer while a predicate holds true for the reduction, each 
   * invocation separated by the specified number of milliseconds, returning a
   * future of the completed reduction.
   * <p>
   * The result of the future is always the first reduction for which the 
   * predicate holds false.
   */
  public function repeatWhile<T>(seed: T, f: T -> T, ms: Int, pred: T -> Bool): Eventual<T>;
  
  /** Executes the function an infinite number of times, each invocation 
   * separated by the specified number of milliseconds. The future will not 
   * return anything, but may be canceled in order to terminate the schedule.
   */
  public function forever(f: Void -> Void, ms: Int): Eventual<Void>;
}

#if !(neko || php || cpp)

class ScheduledExecutorSystem implements ScheduledExecutor {
  public function new() {
  }
  
  public function once<T>(f: Void -> T, ms: Int): Eventual<T> {
    var run = false;
    
    var future = new Eventual();
    
    var timer = Timer.delay(function() {
      run = true;
      
      future.deliver(f());
    }, ms);
    
    future.allowCancelOnlyIf(
      function() {
        return if (run) false;
        else {
          timer.stop();
          
          true;
        }
      }
    );
    
    return future;
  }
  
  public function repeat<T>(seed: T, f: T -> T, ms: Int, times: Int): Eventual<T> {
    var future = new Eventual();

    return if (times > 0) {
      var result = seed;
      
      var timer = new Timer(ms);
      
      future.ifCanceled(timer.stop);
  
      timer.run = function() {
        result = f(result);
    
        --times;
    
        if (times == 0) {
          timer.stop();
      
          future.deliver(result);
        }
      }
      
      future;
    }
    else future.deliver(seed);
  }
  
  public function repeatWhile<T>(seed: T, f: T -> T, ms: Int, pred: T -> Bool): Eventual<T> {
    var future = new Eventual();

    return if (pred(seed)) {
      var result = seed;
      
      var timer = new Timer(ms);
      
      future.ifCanceled(timer.stop);
  
      timer.run = function() {
        result = f(result);
        
        if (!pred(result)) {
          timer.stop();
          
          future.deliver(result);
        }
      }
      
      future;
    }
    else future.deliver(seed);
  }
  
  public function forever(f: Void -> Void, ms: Int): Eventual<Void> {
    var future: Eventual<Void> = new Eventual();
      
    var timer = new Timer(ms);
    
    future.ifCanceled(timer.stop);
  
    timer.run = f;
    
    return future;
  }
}
#end