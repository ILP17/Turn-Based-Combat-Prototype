function BuffActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turn_context, _action_list, _weights = undefined) {
		_weights ??= __InitializeWeights(_action_list);
		var _should_buff = 0;
		var _targets =_turn_context.myTeam;
		
		//for each action
		for(var i = 0; i < array_length(_action_list); i++) {
			var _metadata = ScrActionGetMetadata(_action_list[i]);
			
			if(_metadata.effectType != EffectType.Buff) {
				continue;
			}
			
			_should_buff = 0;
			
			//for each target
			for(var j = 0; j < array_length(_targets); j++) {
				var _target = _targets[j];
				
				if(!_target.IsAlive()) {
					continue;
				}
				
				if(!_target.HasAnyBuff(_metadata.buffs)) {
					_should_buff = 1;
					break;
				}
			}
			
			if(_should_buff == 0) {
				_weights[i] = __AdjustWeight(_weights[i], -999);
			}
		}
		
		return _weights;
	}
}