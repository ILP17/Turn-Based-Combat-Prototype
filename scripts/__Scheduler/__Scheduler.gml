function Scheduler() constructor {
	__actions = [];
	__delayedActions = [];
	
	static __ConsumeDelayedAction = function(_delayed_action) {
		array_delete(
			__delayedActions,
			array_get_index(__delayedActions, _delayed_action),
			1
		);
	}
	
	/**
		@param {struct.Action} _action
	*/
	static AddAction = function(_action) {
		array_push(__actions, _action);
	}
	
	/**
		@return {struct.Action|undefined}
	*/
	static GetCurrentAction = function() {
		if(array_length(__actions) == 0) {
			return undefined;
		}
		
		return __actions[0];
	}
	
	static ProcessCurrentAction = function() {
		if(array_length(__actions) == 0) {
			return;
		}
		
		__actions[0].Run();
		
		if(__actions[0].HasEnded()) {
			array_shift(__actions);
		}
	}
	
	static TrashCurrentAction = function() {
		array_shift(__actions);
	}
	
	/**
		@return {bool}
	*/
	static HasReadyAction = function() {
		return array_length(__actions) > 0;
	}
	
	#region Delayed Action
	/**
		@param {struct.DelayedAction} _delayed_action
	*/
	static AddDelayedAction = function(_delayed_action) {
		array_push(__delayedActions, _delayed_action);
	}
	
	/**
		@param {Id.Instance} _battle_participant
	*/
	__battle_participant_to_search_for = noone;
	static TickDelayedAction = function(_battle_participant) {
		static __Filter = function(_delayed_action, _index) {
			return _delayed_action.battleParticipant == __battle_participant_to_search_for;
		}
		
		__battle_participant_to_search_for = _battle_participant;
		
		var _delayed_actions = array_filter(__delayedActions, __Filter),
			_delayed_action;
		
		for(var i = 0; i < array_length(_delayed_actions); i++) {
			_delayed_action = _delayed_actions[i];
			if(_delayed_action.remainingTurns <= 0) {
				AddAction(_delayed_action.action);
				__ConsumeDelayedAction(_delayed_action);
				continue;
			}
			
			_delayed_action.remainingTurns --;
		}
	}
	
	/**
		@param {Id.Instance} _battle_participant
		@return {bool}
	*/
	static HasDelayedActionFor = function(_battle_participant) {
		static __Filter = function(_delayed_action, _index) {
			return _delayed_action.battleParticipant == __battle_participant_to_search_for;
		}
		
		__battle_participant_to_search_for = _battle_participant;
		
		var _actions = array_filter(__delayedActions, __Filter);
		
		return array_length(_actions) > 0;
	}
	#endregion
}

/**
	@param {Id.Instance} _battle_participant
	@param {struct.Action} _action
	@param {real} _turn_count
*/
function DelayedAction(_battle_participant, _action, _turn_count) constructor {
	battleParticipant = _battle_participant;
	action = _action;
	remainingTurns = _turn_count;
}