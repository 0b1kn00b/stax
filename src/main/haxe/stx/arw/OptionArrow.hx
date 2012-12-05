class OptionArrow<I,O> implements Arrow<Option<I>,Option<O>>{
	private var a : Arrow<I,O>;

	public function new(a:Arrow<I,O>){
		this.a = a;
	}
	inline public function withInput(?i:Option<I>,cont:Function1<Option<O>,Void>){
		switch (i) {
			case Some(v) : Viaz.applyA().withInput( a.entuple(v) , Option.Some.then(cont));
			case None 	 : cont(None);
		}
	}
	public static function option<I,O>(a:Arrow<I,O>):Arrow<Option<I>,Option<O>>{
		return new OptionArrow(a);
	}
}