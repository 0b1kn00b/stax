package stx.iteratee.ifs;

import stx.ifs.Apply;
import stx.async.Contract;

interface Enumeratee<E,A,B> extends Apply<Iteratee<E,A>,Iteratee<E,Iteratee<E,B>>{

}