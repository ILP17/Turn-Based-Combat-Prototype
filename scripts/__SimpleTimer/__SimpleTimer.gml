/**
	@param {real} _time
	@param {struct} _struct
	@param {string} _method_name
*/
function SimpleTimer(_time, _struct, _method_name) constructor {
	__time = _time;
	__initial_time = _time;
	__struct = _struct;
	__method_name = _method_name;
	
	static Set = function(_time) {
		__time = _time;
		__initial_time = _time;
	}
	
	static Reset = function() {
		__time = __initial_time;
	}
	
	static Tick = function() {
		if(IsFinished()) {
			__struct[$ __method_name]();
		}
		
		__time = max(__time - 1, 0);
	}
	
	static IsFinished = function() {
		if(__initial_time == 0) {
			return false;
		}
		
		return __time <= 0;
	}
}