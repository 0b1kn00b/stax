package stx.test.ui {
	import stx.test.ui.common.HeaderDisplayMode;
	import flash.external.ExternalInterface;
	import stx.test.Runner;
	import stx.test.ui.common.IReport;
	import stx.test.ui.common.SuccessResultsDisplayMode;
	import stx.test.ui.text.PrintReport;
	import stx.test.ui.text.HtmlReport;
	public class Report {
		static public function create(runner : stx.test.Runner,displaySuccessResults : stx.test.ui.common.SuccessResultsDisplayMode = null,headerDisplayMode : stx.test.ui.common.HeaderDisplayMode = null) : stx.test.ui.common.IReport {
			var report : stx.test.ui.common.IReport;
			if(flash.external.ExternalInterface.available) report = new stx.test.ui.text.HtmlReport(runner,null,true);
			else report = new stx.test.ui.text.PrintReport(runner);
			if(null == displaySuccessResults) report.displaySuccessResults = stx.test.ui.common.SuccessResultsDisplayMode.ShowSuccessResultsWithNoErrors;
			else report.displaySuccessResults = displaySuccessResults;
			if(null == headerDisplayMode) report.displayHeader = stx.test.ui.common.HeaderDisplayMode.ShowHeaderWithResults;
			else report.displayHeader = headerDisplayMode;
			return report;
		}
		
	}
}
