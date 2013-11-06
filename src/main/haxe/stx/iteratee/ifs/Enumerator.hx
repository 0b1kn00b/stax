package stx.iteratee.ifs;

import stx.ifs.Apply;
import stx.iteratee.Iteratee;
import stx.Eventual;

interface Enumerator<E,A,B> extends Apply<Iteratee<E,A>,Eventual<Iteratee<E,B>>>{

}