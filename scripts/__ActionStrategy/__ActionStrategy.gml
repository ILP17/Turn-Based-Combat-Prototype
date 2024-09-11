function ActionStrategy() constructor {
	__InitializeWeights = function(_action_count) { return array_create(_action_count, 0); }
	__AdjustWeight = function(_weight, _value) { return clamp(_weight+_value, 0, 100); }
}