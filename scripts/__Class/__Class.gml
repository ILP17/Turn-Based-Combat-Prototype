function Class(_config = {}) constructor {
	__ = {};
	with(__) {
		baseStats = _config[$ "baseStats"];
		maxStats = _config[$ "maxStats"];
		actions = _config[$ "actions"] ?? [BasicHitAction];
		strategies = _config[$ "strategies"] ?? [BasicActionStrategy];
	}
	
	GetActions = function() {
		return __.actions;
	}
	
	GetStrategies = function() {
		return __.strategies;
	}
	
	GetStat = function(_stat_key, _level = 1) {
		_level = clamp(_level, 1, MAX_LEVEL);
		var _t = (_level - 1) / (MAX_LEVEL - 1);
		return floor(lerp(__.baseStats[$ _stat_key], __.maxStats[$ _stat_key], _t));
	}
}