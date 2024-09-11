/**
	@param {struct.Character} _character_data
*/
function CPUActionEvaluator(_character_data) constructor {
	__characterData = _character_data
	
	/**
		@param {struct.TurnContext} _turn_context
		@return {struct.Action}
	*/
	DetermineAction = function(_turn_context) {
		var _weights = undefined;
	
		//Get weights
		var _action_strategy;
		for(var i = 0; i < __characterData.GetStrategyCount(); i++) {
			_action_strategy = __characterData.GetStrategy(i);
			_weights = _action_strategy.EvaluateAction(__characterData, _turn_context, _weights);
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
				_action = __characterData.GetAction(i);
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
		@return {Array<Id.Instance>}
	*/
	UpdateTargets = function(_action, _turn_context) {
		var _target_strategy = _action.CreateTargetStrategy();
		var _new_targets = _target_strategy.DelayedActionTargetsCheck(_action, _turn_context);
		
		return _new_targets;
	}
}