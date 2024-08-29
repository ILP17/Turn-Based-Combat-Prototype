enum EffectType {
	Damage,
	Heal,
	Revive
}

function ActionStrategy() constructor {
	InitializeWeights = function(_actionList) { return array_create(array_length(_actionList), 0); }
	AdjustWeight = function(_weight, _value) { return clamp(_weight+_value, 0, 100); }
}