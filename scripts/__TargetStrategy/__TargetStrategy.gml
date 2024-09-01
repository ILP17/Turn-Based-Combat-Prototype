function TargetStrategy() constructor {
	/**
		Used for target list filtering and should make use of the IsTargetValid method
		@param {Id.Instance} _potential_target
		@param {real} _index
		@return {bool}
	*/
	__ValidTargetFilter = function(_potential_target, _index) {
		return IsTargetValid(_potential_target);
	}
	
	/**
		@param {Id.Instance} _potential_target
		@return {bool}
	*/
	IsTargetValid = function(_potential_target) {
		throw ($"{instanceof(self)} needs to implement {nameof(IsTargetValid)}");
	}
	
	/**
		This will check that the current targets are still valid and if not return a new target list
		This may return an empty list if no suitable targets are found
		@param {struct.Action} _action
		@param {struct.TurnContext} _turn_context
		@return {Array<Id.Instance>}
	*/
	DelayedActionTargetsCheck = function(_action, _turn_context) {
		throw ($"{instanceof(self)} needs to implement {nameof(DelayedActionTargetsCheck)}");
	}
}