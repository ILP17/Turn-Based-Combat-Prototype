/**
	@param {struct.Character} _character_data
*/
function CPUActionEvaluator(_character_data) constructor {
	__characterData = _character_data
	
	/**
		@param {struct.TurnContext} _turn_context
		@return {Function}
	*/
	DetermineAction = function(_turn_context) {
		var _strategies = __characterData.strategies,
			_actions = __characterData.actions,
			_weights = undefined;
	
		//Get weights
		for(var i = 0; i < array_length(_strategies); i++) {
			_weights = (new _strategies[i]()).EvaluateAction(_turn_context, _actions, _weights);
		}
	
		//Get total weight
		var _total_weight = 0;
		for(var i = 0; i < array_length(_weights); i++) {
			_total_weight += _weights[i];
		}
	
		//Get action
		var _chosen_weight = random(_total_weight),
			_min_weight = 0,
			_max_weight = 0,
			_action;
		for(var i = 0; i < array_length(_weights); i++) {
			if(_weights[i] == 0) {
				continue;
			}
		
			_max_weight = _weights[i] + _min_weight;
		
			if(_chosen_weight >= _min_weight && _chosen_weight <= _max_weight) {
				_action = _actions[i];
				break;
			}
			_min_weight = _max_weight;
		}
	
		return _action;
	}
	
	/**
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
		@return {Array<Id.Instance>}
	*/
	DetermineTargets = function(_action, _turn_context) {
		var _action_metadata = _action.GetMetadata();
		var _target_strategy = _action.CreateTargetStrategy();
		var _target_team = _turn_context.ResolveTargets(_action_metadata);
		var _targets = _target_strategy.GetTarget(_target_team, _action_metadata);
		
		return _targets;
	}
	
	/**
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
		@param {Array<Id.Instance>}
	*/
	UpdateTargets = function(_action, _turn_context) {
		var _target_strategy = _action.CreateTargetStrategy();
		var _new_targets = _target_strategy.DelayedActionTargetsCheck(_action, _turn_context);
		
		return _new_targets;
	}
}