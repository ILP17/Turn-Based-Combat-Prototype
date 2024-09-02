function HealTargetStrategy() : TargetStrategy() constructor {
	__ValidTargetFilter = function(_potential_target, _index) {
		return _potential_target.IsAlive() && _potential_target.GetHealthRatio() < 1;
	}
	
	GetTarget = function(_target_team, _action_metadata) {
		_target_team = array_filter(_target_team, __ValidTargetFilter);
		
		if(array_length(_target_team) == 0) {
			return _target_team;
		}
		
		var _chosen_target = _target_team[0],
			_last_hp_ratio = _chosen_target.GetHealthRatio(),
			_potential_target;
		
		for(var i = 1; i < array_length(_target_team); i++) {
			_potential_target = _target_team[i];
			if(_potential_target.GetHealthRatio() < _last_hp_ratio) {
				_chosen_target = _potential_target;
				_last_hp_ratio = _chosen_target.GetHealthRatio();
			}
		}
		
		return [_chosen_target];
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		var _current_targets = _action.GetTargets();
		var _valid = IsTargetValid(_current_targets[0]);
		var _new_targets = _current_targets;
		
		if(!_valid) {
			var _action_metadata = _action.GetMetadata();
			_new_targets = GetTarget(_turn_context.ResolveTargets(_action_metadata), _action_metadata);
		}
		
		return _new_targets;
	}
}