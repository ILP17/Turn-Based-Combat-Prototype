function SimpleTimer(_time) constructor {
	__time = _time;
	__initial_time = _time;
	
	static Set = function(_time) {
		__time = _time;
		__initial_time = _time;
	}
	
	static Reset = function() {
		__time = __initial_time;
	}
	
	static Tick = function() {
		__time = max(__time - 1, 0);
	}
	
	static IsFinished = function() {
		if(__initial_time == 0) {
			return false;
		}
		
		return __time <= 0;
	}
}