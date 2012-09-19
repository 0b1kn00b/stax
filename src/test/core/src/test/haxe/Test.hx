import stx.test.Runner;
import stx.test.ui.Report;

class Test{
	static function main(){
		var runner = new Runner();
		var report = Report.create(runner);

		var tests  =
		[
			
		];

		runner.addAll(tests);
		runner.run();
	}
}