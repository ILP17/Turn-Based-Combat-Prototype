function BuffActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turnContext, _action_list, _weights = undefined) {
		_weights ??= __InitializeWeights(_action_list);
		var _shouldBuff = 0;
		var _targets =_turnContext.myTeam;
		
		//for each action
		for(var i = 0; i < array_length(_action_list); i++) {
			var _metadata = scr_get_action_metadata(_action_list[i]);
			
			if(_metadata.effectType != EffectType.Buff) {
				continue;
			}
			
			_shouldBuff = 0;
			
			//for each target
			for(var j = 0; j < array_length(_targets); j++) {
				var _target = _targets[j];
				
				if(!_target.IsAlive()) {
					continue;
				}
				
				if(!_target.HasAnyBuff(_metadata.buffs)) {
					_shouldBuff = 1;
					break;
				}
			}
			
			if(_shouldBuff == 0) {
				_weights[i] = __AdjustWeight(_weights[i], -999);
			}
		}
		
		return _weights;
	}
}