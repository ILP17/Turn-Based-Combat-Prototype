function HealActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turn_context, _action_list, _weights = undefined) {
		_weights ??= __InitializeWeights(_action_list);
		var _should_heal = 0;
		var _target = _turn_context.myTeam;
		for(var i = 0; i < array_length(_target); i++) {
			if(!_target[i].IsAlive()) {
				continue;
			}
			
			if(_target[i].GetHealthRatio() < 1 && _should_heal == 0) {
				_should_heal = 1;
			}

			if(_target[i].GetHealthRatio() < 0.5) {
				_should_heal = 2;
				break;
			}
		}
		
		for(var i = 0; i < array_length(_action_list); i++) {
			var _metadata = ScrActionGetMetadata(_action_list[i]);
			
			if(_metadata.effectType != EffectType.Heal) {
				continue;
			}
			
			switch(_should_heal){
				case 0:
					_weights[i] = __AdjustWeight(_weights[i], -999);
					break;
				case 1:
					_weights[i] = __AdjustWeight(_weights[i], 10);
					break;
				case 2:
					_weights[i] = __AdjustWeight(_weights[i], 30);
					break;
			}
		}
		
		return _weights;
	}
}