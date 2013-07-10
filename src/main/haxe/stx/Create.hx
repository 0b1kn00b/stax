package stx;
class Create{
	@:generic static public function create<A>(typ:A):A{
		return Prelude.error()('static function "create" not found"');
	}
}