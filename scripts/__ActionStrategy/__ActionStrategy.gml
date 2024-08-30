function ActionStrategy() constructor {
	__InitializeWeights = function(_action_list) { return array_create(array_length(_action_list), 0); }
	__AdjustWeight = function(_weight, _value) { return clamp(_weight+_value, 0, 100); }
}