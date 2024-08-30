function ReviveActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turnContext, _action_list, _weights = undefined) {
		_weights ??= __InitializeWeights(_action_list);
		var _shouldHeal = 0;
		var _target =_turnContext.myTeam;
		for(var i = 0; i < array_length(_target); i++) {
			if(!_target[i].IsAlive()) {
				_shouldHeal = 1;
				break;
			}
		}
		
		for(var i = 0; i < array_length(_action_list); i++) {
			var _metadata = scr_get_action_metadata(_action_list[i]);
			
			if(_metadata.effectType != EffectType.Revive) {
				continue;
			}
			
			switch(_shouldHeal){
				case 0:
					_weights[i] = __AdjustWeight(_weights[i], -999);
					break;
				case 1:
					_weights[i] = __AdjustWeight(_weights[i], 100);
					break;
			}
		}
		
		return _weights;
	}
}