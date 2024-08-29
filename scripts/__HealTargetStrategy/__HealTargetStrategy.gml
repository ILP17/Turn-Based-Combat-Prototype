function HealTargetStrategy() : TargetStrategy() constructor {
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsAlive() && _potential_target.GetHealthRatio() < 1;
	}
	
	GetTarget = function(_targetTeam) {
		var _targetTeam = array_filter(_targetTeam, __Filter);
		
		if(array_length(_targetTeam) == 0) {
			return _targetTeam;
		}
		
		var _lastHPRatio = 1,
			_chosen_target = _targetTeam[0],
			_potential_target;
		
		for(var i = 1; i < array_length(_targetTeam); i++) {
			_potential_target = _targetTeam[i];
			if(_potential_target.GetHealthRatio() < _lastHPRatio) {
				_chosen_target = _potential_target;
				_lastHPRatio = _chosen_target.GetHealthRatio();
			}
		}
		
		return [_chosen_target];
	}
}