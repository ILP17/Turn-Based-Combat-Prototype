function ActionMetadata(_config = {}) constructor {
	targetType = _config[$ "targetType"] ?? TargetType.Enemy;
	effectType = _config[$ "effectType"] ?? EffectType.Damage;
	//Feather ignore GM2017
	targetStrategy = _config[$ "targetStrategy"] ?? AnyTargetStrategy;
	buffs = _config[$ "buffs"] ?? [];
}