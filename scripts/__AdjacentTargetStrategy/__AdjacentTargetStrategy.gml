function AdjacentTargetStrategy() : TargetStrategy() constructor {
	__target_indecies = [];
	__targets = [];
	
	__Filter = function(_potential_target, _index) {
		var _valid = _potential_target.IsTargetable();
		
		if(_valid) {
			array_push(__target_indecies, _index);
		}
		
		return _valid;
	}
	
	GetTarget = function(_original_target_team) {
		var _target_team = array_filter(_original_target_team, __Filter);
		var _targetsLength = array_length(_target_team);
		
		if(_targetsLength == 0) {
			return _target_team;
		}
		
		var _chosen_index = __target_indecies[irandom(_targetsLength - 1)];
		
		array_push(__targets, _original_target_team[_chosen_index]);
		
		if(_chosen_index + 1 < array_length(_original_target_team) && _original_target_team[_chosen_index + 1].IsTargetable()) {
			array_push(__targets, _original_target_team[_chosen_index + 1]);
		}
		
		if(_chosen_index - 1 >= 0 && _original_target_team[_chosen_index - 1].IsTargetable()) {
			array_push(__targets, _original_target_team[_chosen_index - 1]);
		}
		
		return __targets;
	}
}