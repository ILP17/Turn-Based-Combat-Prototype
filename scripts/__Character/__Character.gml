/**
	Interface representing a character
*/
function Character() constructor {
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		ScrEnforceImplementation(instanceof(self), nameof(GetStat));
	}
	
	/**
		@return {Array<struct.Action>}
	*/
	GetActions = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetActions));
	}
	
	/**
		@return {Array<struct.ActionStrategy>}
	*/
	GetStrategies = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetStrategies));
	}
}

/**
	@param _config
*/
function PlayerCharacter(_config = {}) : Character() constructor {
	__ = {};
	with(__) {
		actions = _config[$ "actions"] ?? [];
		strategies = _config[$ "strategies"] ?? [];
		level = _config[$ "level"] ?? 1;
		class = ThrowIfUndefined(_config[$ "class"], "class");
	}
	
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		return __.class.GetStat(_stat_key, __.level);
	}
	
	/**
		@return {Array<struct.Action>}
	*/
	GetActions = function() {
		//Feather ignore once GM1045
		return array_union(__.actions, __.class.GetActions());
	}
	
	/**
		@return {Array<struct.ActionStrategy>}
	*/
	GetStrategies = function() {
		//Feather ignore once GM1045
		return array_union(__.strategies, __.class.GetStrategies());
	}
	
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	isBoss = _config[$ "isBoss"] ?? false;
}

/**
	@param _config
*/
function MonsterCharacter(_config = {}) : Character() constructor {
	__ = {};
	with(__) {
		actions = _config[$ "actions"] ?? [BasicHitAction];
		strategies = _config[$ "strategies"] ?? [BasicActionStrategy];
		stats = _config[$ "stats"] ?? new Stats();
	}
	
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		return __.stats[$ _stat_key];
	}
	
	/**
		@return {Array<struct.Action>}
	*/
	GetActions = function() {
		//Feather ignore once GM1045
		return __.actions;
	}
	
	/**
		@return {Array<struct.ActionStrategy>}
	*/
	GetStrategies = function() {
		//Feather ignore once GM1045
		return __.strategies;
	}
	
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	isBoss = _config[$ "isBoss"] ?? false;
}

/**
*/
function Stats(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 10;
	at = _config[$ "at"] ?? 0;
	df = _config[$ "df"] ?? 0;
	sp = _config[$ "sp"] ?? 0;
	mag = _config[$ "mag"] ?? 0;
	
	/**
		@param {string} _stat_key
		@return {real}
	*/
	GetStat = function(_stat_key) {
		return self[$ _stat_key];
	}
}

/**
*/
function StatsMultiplierModifier(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 1;
	at = _config[$ "at"] ?? 1;
	df = _config[$ "df"] ?? 1;
	sp = _config[$ "sp"] ?? 1;
	mag = _config[$ "mag"] ?? 1;
}