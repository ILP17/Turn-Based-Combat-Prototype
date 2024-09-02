function AdjacentTargetStrategy() : TargetStrategy() constructor {
	__target_indecies = [];
	__targets = [];
	
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	__ValidTargetFilter = function(_potential_target, _index) {
		var _valid = IsTargetValid(_potential_target);
		
		if(_valid) {
			array_push(__target_indecies, _index);
		}
		
		return _valid;
	}
	
	static __TryAddAdjacentTarget = function(_index, _valid_targets) {
		if(scr_array_contains_index(_valid_targets, _index) && _valid_targets[_index].IsTargetable()) {
			array_push(__targets, _valid_targets[_index]);
		}
	}
	
	GetTarget = function(_target_team, _action_metadata) {
		var _valid_targets = array_filter(_target_team, __ValidTargetFilter);
		var _targets_length = array_length(_valid_targets);
		
		if(_targets_length == 0) {
			return _valid_targets;
		}
		
		var _chosen_index = __target_indecies[irandom(_targets_length - 1)];
		
		array_push(__targets, _target_team[_chosen_index]);
		
		__TryAddAdjacentTarget(_chosen_index - 1, _target_team);
		__TryAddAdjacentTarget(_chosen_index + 1, _target_team);
		
		return __targets;
	} 
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		var _current_targets = _action.GetTargets();
		var _action_metadata = _action.GetMetadata();
		var _valid = IsTargetValid(_current_targets[0]);
		var _new_targets = _current_targets;
		var _targets = _turn_context.ResolveTargets(_action_metadata);
		
		if(!_valid) {
			_new_targets = GetTarget(_targets);
		} else {
			var _target_index = array_get_index(_targets, _current_targets[1]);
			if(array_length(_current_targets) >= 2 && !IsTargetValid(_current_targets[1])) {
				array_delete(_current_targets, _target_index, 1);
			}
			_target_index = array_get_index(_targets, _current_targets[2]);
			if(array_length(_current_targets) >= 3 && !IsTargetValid(_current_targets[2])) {
				array_delete(_current_targets, _target_index, 1);
			}
			_new_targets = _current_targets;
		}
		
		return _new_targets;
	}
}