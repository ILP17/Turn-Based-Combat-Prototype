function ReviveActionStrategy() : ActionStrategy() constructor {
	/**
		@param {struct.Character} _character_data
		@param {struct.TurnContext} _turn_context
		@param {Array<real>|undefined} _weights
		@return {Array<real>}
	*/
	EvaluateAction = function(_character_data, _turn_context, _weights = undefined) {
		var _action_count = _character_data.GetActionCount();
		_weights ??= __InitializeWeights(_action_count);
		var _should_heal = 0;
		
		//for each action
		for(var i = 0; i < _action_count; i++) {
			var _metadata = _character_data.GetAction(i).GetMetadata();
			
			if(_metadata.effectType != EffectType.Revive) {
				continue;
			}
			
			_should_heal = 0;
			var _targets = _turn_context.ResolveTargets(_metadata);
			
			//for each target
			for(var j = 0; j < array_length(_targets); j++) {
				var _target = _targets[j];
				
				if(!_target.IsAlive()) {
					_should_heal = 1;
					break;
				}
			}
			
			switch(_should_heal) {
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