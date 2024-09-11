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
		@return {real}
	*/
	GetActionCount = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetActionCount));
	}
	
	/**
		@param {real} _index
		@return {struct.Action}
	*/
	GetAction = function(_index) {
		ScrEnforceImplementation(instanceof(self), nameof(GetAction));
	}
	
	/**
		@return {real}
	*/
	GetStrategyCount = function() {
		ScrEnforceImplementation(instanceof(self), nameof(GetStrategyCount));
	}
	
	/**
		@param {real} _index
		@return {struct.ActionStrategy}
	*/
	GetStrategy = function(_index) {
		ScrEnforceImplementation(instanceof(self), nameof(GetStrategy));
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
		@return {real}
	*/
	GetActionCount = function() {
		return array_length(__.actions) + array_length(__.class.GetActions());
	}
	
	/**
		@param {real} _index
		@return {Array<Function>}
	*/
	GetAction = function(_index) {
		var _array = array_union(__.actions, __.class.GetActions());
		//Feather ignore once GM1045
		return new _array[_index]();
	}
	
	/**
		@return {real}
	*/
	GetStrategyCount = function() {
		return array_length(__.strategies) + array_length(__.class.GetStrategies());
	}
	
	/**
		@param {real} _index
		@return {Array<struct.ActionStrategy>}
	*/
	GetStrategy = function(_index) {
		var _array = array_union(__.strategies, __.class.GetStrategies());
		//Feather ignore once GM1045
		return new _array[_index]();
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
		@return {real}
	*/
	GetActionCount = function() {
		return array_length(__.actions);
	}
	
	/**
		@param {real} _index
		@return {Array<Function>}
	*/
	GetAction = function(_index) {
		//Feather ignore once GM1045
		return new __.actions[_index]();
	}
	
	/**
		@return {real}
	*/
	GetStrategyCount = function() {
		return array_length(__.strategies);
	}
	
	/**
		@param {real} _index
		@return {Array<struct.ActionStrategy>}
	*/
	GetStrategy = function(_index) {
		//Feather ignore once GM1045
		return new __.strategies[_index]();
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