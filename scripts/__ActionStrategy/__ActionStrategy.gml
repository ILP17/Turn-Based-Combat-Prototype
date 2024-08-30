function ActionStrategy() constructor {
	__InitializeWeights = function(_actionList) { return array_create(array_length(_actionList), 0); }
	__AdjustWeight = function(_weight, _value) { return clamp(_weight+_value, 0, 100); }
}