function BasicActionStrategy() : ActionStrategy() constructor {
	EvaluateAction = function(_turnContext, actionList, _weights = undefined) {
		_weights ??= __InitializeWeights(_actionList);
		
		for(var i = 0; i < array_length(_actionList); i++) {
			__weights[i] = __AdjustWeight(_weights[i], 10);
		}
		
		return _weights;
	}
}