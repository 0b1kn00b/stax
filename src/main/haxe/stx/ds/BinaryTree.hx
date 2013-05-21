package stx.ds;

using Std;
using stx.Prelude;
using stx.Arrays;
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
				case Node(el,l,r) : inOrder(l).add(el).append( inOrder(r) );
			}
	}
	static public function preOrder<A>(t:BinaryTree<A>):Array<A>{
		return
			switch (t) {
				case Empty 				: [];
				case Node(el,l,r)	: [el].append(preOrder(l)).append(preOrder(r));
			}
	}
	static public function postOrder<A>(t:BinaryTree<A>):Array<A>{
		return
			switch (t) {
				case Empty 				: [];
				case Node(el,l,r) : postOrder(l).append(postOrder(r)).add(el);
			}
	}
	static public function size<A>(t:BinaryTree<A>):Int{
		return
			switch (t) {
				case Empty 				: 0;
				case Node(_,l,r) : 1 + size(l) + size(r);
			}
	}
	static public function leafCount<A>(t:BinaryTree<A>):Int{
		return 
			switch (t) {
				case Empty 					: 0;
				case Node(_,l,r) 	:
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
						leaves(l).append(leaves(r));
					}
			}	
	}
	static public function height<A>(t:BinaryTree<A>):Int{
		return
			switch (t) {
				case Empty 					: 0;
				case Node(_,l,r) 	: 1 + Std.int( Math.max( height(l), height(r) ) );
			}
	}
}