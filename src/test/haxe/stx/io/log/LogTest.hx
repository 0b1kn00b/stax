package stx.io.log;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.test.Assert;					using stx.test.Assert;
import stx.test.TestCase;
import stx.Log;									using stx.Log;
import stx.framework.Injector; 	using stx.framework.Injector;
																using stx.Functions;
																using stx.Dynamics;
																
class LogTest extends TestCase{

	public function new() {
		super();
	}
	public function testFalseBecauseNotIncluded() {
		var dl = new DefaultLogger( 
				[
						LogListing.Include('sas')
					, LogListing.Exclude('tds')
				]);
				dl.check('boop',Stax.here()).isFalse();
	}
	public function testTrueBecauseNotExcluded():Void {
		var dl = new DefaultLogger( 
				[
					LogListing.Exclude('tsd')
				]);
				dl.check('boop',Stax.here()).isTrue();
	}
	public function testFalseBecauseExcludedPack() {
		var dl = new DefaultLogger( 
				[
					LogListing.Exclude(
						Log.pack('stx.io.log')
						)
				]);
				dl.check('boop', Stax.here()).isFalse();
	}
	public function testTrueBecauseIncludedPack() {
		var dl = new DefaultLogger( 
				[
					LogListing.Include(
						Log.pack('stx.io.log')
						)
				]);
				dl.check('boop', Stax.here()).isTrue();
	}
	public function testTrueBecauseIncludedFunction() {
		var dl = new DefaultLogger( 
				[
					LogListing.Include(
						Log.func('testTrueBecauseIncludedFunction')
						)
				]);
				dl.check('boop', Stax.here()).isTrue();
	}
	public function testFalseBecauseExcludedFunction() {
		var dl = new DefaultLogger( 
				[
					'stx.io.log'.pack().whitelist(),
					'testFalseBecauseExcludedFunction'.func().blacklist()
				]);
				dl.check('boop', Stax.here()).isFalse();
	}
	public function testTrueBecauseOtherExcludedFunction() {
		var dl = new DefaultLogger( 
				[
						'testTrueBecauseIncludedFunction'.func().blacklist()
				]);
				dl.check('boop', Stax.here()).isTrue();
	}
	public function testTrueBecauseIncludedFile() {
		var dl = new DefaultLogger( 
				[
					LogListing.Include(
						'LogTest'.file()
						)
				]);
				dl.check('boop', Stax.here()).isTrue();
	}
	public function testTrueBecauseNoListings() {
		var dl = new DefaultLogger();
		dl.check('boop', Stax.here()).isTrue();
	}
	public function testLogLevel() {
		Injector.enter(
				function(config) {
						config.bindF( 
								Log
							,	function() { 
										return cast new DefaultLogger(['testLogLevel'.func().whitelist()], Error); 
								}.memoize()
						);
								haxe.Log.trace = Log.trace;
								Log.trace('sdfsd'.debug());
								Log.trace('sdfsd'.warning());
								Log.trace('sdfsd'.fatal());
								
								
								trace( 'dooby'.error() );
								trace( 'woozan' );
				}
		);
		
	}
}