package stx.test.ui.common {
	import stx.test.ui.common.ResultStats;
	import stx.test.ui.common.IReport;
	public class ReportTools {
		static public function hasHeader(report : stx.test.ui.common.IReport,stats : stx.test.ui.common.ResultStats) : Boolean {
			{
				var $e : enum = (report.displayHeader);
				switch( $e.index ) {
				case 1:
				return false;
				break;
				case 2:
				{
					if(!stats.isOk) return true;
					{
						var $e2 : enum = (report.displaySuccessResults);
						switch( $e2.index ) {
						case 1:
						return false;
						break;
						case 0:
						case 2:
						return true;
						break;
						}
					}
				}
				break;
				case 0:
				return true;
				break;
				}
			}
			return false;
		}
		
		static public function skipResult(report : stx.test.ui.common.IReport,stats : stx.test.ui.common.ResultStats,isOk : Boolean) : Boolean {
			if(!stats.isOk) return false;
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (report.displaySuccessResults);
					switch( $e2.index ) {
					case 1:
					$r = true;
					break;
					case 0:
					$r = false;
					break;
					case 2:
					$r = !isOk;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function hasOutput(report : stx.test.ui.common.IReport,stats : stx.test.ui.common.ResultStats) : Boolean {
			if(!stats.isOk) return true;
			return stx.test.ui.common.ReportTools.hasHeader(report,stats);
		}
		
	}
}
