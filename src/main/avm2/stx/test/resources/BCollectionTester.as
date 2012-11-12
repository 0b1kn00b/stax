package stx.test.resources {
	import stx.test.Runner;
	import stx.test.resources.CollectionTester;
	public class BCollectionTester {
		static public function main() : void {
			var tr : stx.test.Runner = new stx.test.Runner();
			var tester1 : stx.test.resources.CollectionTester = new stx.test.resources.CollectionTester();
			tr.add(tester1);
			tr.run();
		}
		
	}
}
