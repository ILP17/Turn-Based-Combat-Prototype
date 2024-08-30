function BuffTargetStrategy() : TargetStrategy() constructor {
	__targets = [];
	
	__Filter = function(_potential_target, _index) {
		return _potential_target.IsTargetable();
	}
	
	/**
		@param {Array<Id.Instance>} _target_team
		@param {struct.ActionMetadata} _action_metadata
	*/
	GetTarget = function(_target_team, _action_metadata) {
		_target_team = array_filter(_target_team, __Filter);
		
		if(array_length(_target_team) == 0) {
			return _target_team;
		}
		
		for(var i = 0; i < array_length(_target_team); i++) {
			var _target = _target_team[i];
			
			if(!_target.IsAlive()) {
				continue;
			}
			
			if(!_target.HasAnyBuff(_action_metadata.buffs)) {
				array_push(__targets, _target);
			}
		}
		
		return [__targets[irandom(array_length(__targets) - 1)]];
	}
}