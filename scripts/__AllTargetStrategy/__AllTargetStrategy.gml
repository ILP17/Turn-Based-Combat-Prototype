function AllTargetStrategy() : TargetStrategy() constructor {
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsTargetable();
	}
	
	GetTarget = function(_targetTeam) {
		var _targetTeam = array_filter(_targetTeam, __Filter);
		
		if(array_length(_targetTeam) == 0) {
			return _targetTeam;
		}
		
		return _targetTeam;
	}
}