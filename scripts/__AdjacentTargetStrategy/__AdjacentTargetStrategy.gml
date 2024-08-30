function AdjacentTargetStrategy() : TargetStrategy() constructor {
	__targets = [];
	
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsTargetable();
	}
	
	GetTarget = function(_target_team) {
		_target_team = array_filter(_target_team, __Filter);
		var _targetsLength = array_length(_target_team);
		
		if(_targetsLength == 0) {
			return _target_team;
		}
		
		var _chosen_index = irandom(_targetsLength - 1);
		
		array_push(__targets, _target_team[_chosen_index]);
		
		if(_chosen_index + 1 < _targetsLength && _target_team[_chosen_index + 1].IsTargetable()) {
			array_push(__targets, _target_team[_chosen_index + 1]);
		}
		
		if(_chosen_index - 1 >= 0 && _target_team[_chosen_index - 1].IsTargetable()) {
			array_push(__targets, _target_team[_chosen_index - 1]);
		}
		
		return __targets;
	}
}