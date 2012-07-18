package stx.ds;

using Std;
using Stax;
using stx.Arrays;
using stx.Iterables;
using stx.Functions;
using stx.Options;
using stx.Prelude;
using stx.Iterators;

//https://gist.github.com/1271891
enum BinaryTree<T>{
	Empty;
	Node(el:T,left:BinaryTree<T>,right:BinaryTree<T>);
}
class BinaryTrees{
	static public function tree<A>(el:A,?l:BinaryTree<A>,?r:BinaryTree<A>){
		l = l == null ? Empty : l;
		r = r == null ? Empty : r;
		return Node(el,l,r);
	}
	static public function inOrder<A>(t:BinaryTree<A>):Array<A>{
		return
			switch (t) {
				case Empty 				: [];
				case Node(el,l,r) : inOrder(l).append(el).appendAll( inOrder(r) );
			}
	}
	static public function preOrder<A>(t:BinaryTree<A>):Array<A>{
		return
			switch (t) {
				case Empty 				: [];
				case Node(el,l,r)	: [el].appendAll(preOrder(l)).appendAll(preOrder(r));
			}
	}
	static public function postOrder<A>(t:BinaryTree<A>):Array<A>{
		return
			switch (t) {
				case Empty 				: [];
				case Node(el,l,r) : postOrder(l).appendAll(postOrder(r)).append(el);
			}
	}
	static public function size<A>(t:BinaryTree<A>):Int{
		return
			switch (t) {
				case Empty 				: 0;
				case Node(el,l,r) : 1 + size(l) + size(r);
			}
	}
	static public function leafCount<A>(t:BinaryTree<A>):Int{
		return 
			switch (t) {
				case Empty 					: 0;
				case Node(el,l,r) 	:
					if(l == Empty && r == Empty){
						1;
					}else{
						leafCount(l) + leafCount(r);
					}
			}
	}
	static public function leaves<A>(t:BinaryTree<A>):Array<A>{
		return 
			switch (t) {
				case Empty 					: [];
				case Node(el,l,r) 	:
					if(l == Empty && r == Empty){
						[el];
					}else{
						leaves(l).appendAll(leaves(r));
					}
			}	
	}
	static public function height<A>(t:BinaryTree<A>):Int{
		return
			switch (t) {
				case Empty 					: 0;
				case Node(el,l,r) 	: 1 + Std.int( Math.max( height(l), height(r) ) );
			}
	}
}