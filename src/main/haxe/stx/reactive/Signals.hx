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
package stx.reactive;

using stx.Prelude;
using stx.Tuples;
import stx.reactive.Reactive;
import stx.ds.Collection;

using stx.Iterables;

class Signals {
    private function new() { }
    
    @:noUsing
    public static function constant<T>(value: T): Signal<T> {
        return Streams.pure().startsWith(value);
    }
    
    /**
     * Switches off a supplied Bool Signal, returning
     * an 'ifTrue' Signal if true or a 'ifFalse' 
     * Signal if false.
     * 
     *
     * @param conditions    An Iterable of Tuple2s, composed of a
     *                      true/false Signals and an 'if true' 
     *                      Signal that will be returned if 
     *                      Tuple.fst() == 'true.'
     *
     * @param elseS         The Signal to return if Tuple.fst()
     *                      == false.
     *
     * @return              An 'ifTrue' Signal if Tuple.fst()
     *                      == true, else an 'ifFalse' Signal.
     */
    public static function cond<T>(conditions: Iterable<Tuple2<Signal<Bool>, Signal<T>>>, elseS: Signal<T>): Signal<T> {
        return switch (conditions.headMaybe()) {
            case None:    elseS;
            case Some(h): SignalBool.ifTrue(h.fst(), h.snd(), cond(conditions.tail(), elseS));
        }
    }
    
    /**
     * Zips together the specified Signals.
     *
     *@param    signals   An Iterable of the 
     *                      Signals to be zipped.
     */
    public static function zipN<T>(signals: Iterable<Signal<T>>): Signal<Iterable<T>> {
        var zipValueNow = function(): Iterable<T> {
            return signals.map(function(b) { return b.valueNow(); });
        }
        
        return Streams.create(
            function(pulse: Pulse<T>): Propagation<Iterable<T>> {
                return propagate(pulse.withValue(zipValueNow()));
            },
            signals.map(function(b) { return b.changes(); })
        ).startsWith(zipValueNow());
    }

    #if (js || flash)
    /**
     * Returns the time at a specified time step interval.
     *
     * @param time      The interval at which to sample time.
     */
    public static function sample(time: Int): Signal<Int> {
        return Streams.timer(time).startsWith(Std.int(External.now()));
    }
    
    /**
     * @param time      The interval at which to sample time.
     */
    public static function sampleS(time: Signal<Int>): Signal<Int> {
        return Streams.timerS(time).startsWith(Std.int(External.now()));
    }
	#end

    
    public static function toSignal<T>(s:Stream<T>,?init : T): Signal<T> {
        return new Signal<T>(cast s, init,function(pulse) { return propagate(pulse); });
    }
}