function BasicActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turnContext, _actionList, _weights = undefined) {
		_weights ??= __InitializeWeights(_actionList);
		
		for(var i = 0; i < array_length(_actionList); i++) {
			_weights[i] = __AdjustWeight(_weights[i], 10);
		}
		
		return _weights;
	}
}