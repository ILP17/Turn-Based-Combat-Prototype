function HealTargetStrategy() : TargetStrategy() constructor {
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsAlive() && _potential_target.GetHealthRatio() < 1;
	}
	
	GetTarget = function(_target_team) {
		_target_team = array_filter(_target_team, __Filter);
		
		if(array_length(_target_team) == 0) {
			return _target_team;
		}
		
		var _lastHPRatio = 1,
			_chosen_target = _target_team[0],
			_potential_target;
		
		for(var i = 1; i < array_length(_target_team); i++) {
			_potential_target = _target_team[i];
			if(_potential_target.GetHealthRatio() < _lastHPRatio) {
				_chosen_target = _potential_target;
				_lastHPRatio = _chosen_target.GetHealthRatio();
			}
		}
		
		return [_chosen_target];
	}
}