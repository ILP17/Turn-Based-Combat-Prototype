function AllTargetStrategy() : TargetStrategy() constructor {
	IsTargetValid = function(_potential_target) {
		return _potential_target.IsTargetable();
	}
	
	GetTarget = function(_target_team, _action_metadata) {
		_target_team = array_filter(_target_team, __ValidTargetFilter);
		
		if(array_length(_target_team) == 0) {
			return _target_team;
		}
		
		return _target_team;
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		var _action_metadata = scr_get_action_metadata_from_instance(_action);
		return GetTarget(_turn_context.ResolveTargets(_action_metadata));
	}
}