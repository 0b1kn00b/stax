package stx {
	public class Functions6 {
		static public function curry(f : Function) : Function {
			return function(p1 : *) : Function {
				return function(p2 : *) : Function {
					return function(p3 : *) : Function {
						return function(p4 : *) : Function {
							return function(p5 : *) : Function {
								return function(p6 : *) : * {
									return f(p1,p2,p3,p4,p5,p6);
								}
							}
						}
					}
				}
			}
		}
		
	}
}
