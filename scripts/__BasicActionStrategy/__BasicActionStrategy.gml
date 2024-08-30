function BasicActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turnContext, _action_list, _weights = undefined) {
		_weights ??= __InitializeWeights(_action_list);
		
		for(var i = 0; i < array_length(_action_list); i++) {
			_weights[i] = __AdjustWeight(_weights[i], 10);
		}
		
		return _weights;
	}
}