package stx.ifs;
interface Monoid<A>{
	public dynamic function append(a1:A,a2:A):A;
	public dynamic function empty():A;
}