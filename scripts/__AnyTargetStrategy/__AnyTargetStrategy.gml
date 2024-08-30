function AnyTargetStrategy() : TargetStrategy() constructor {
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsTargetable();
	}
	
	GetTarget = function(_target_team) {
		_target_team = array_filter(_target_team, __Filter);
		
		if(array_length(_target_team) == 0) {
			return _target_team;
		}
		
		return [_target_team[irandom(array_length(_target_team) - 1)]];
	}
}