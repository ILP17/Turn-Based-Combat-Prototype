/**
	Dont use this directly >:(
	
	@param {real} _turn_count
	@param {real} _icon_index
*/
function Buff(_turn_count, _icon_index = 0) constructor {
	iconIndex = _icon_index;
	stats = new StatsMultiplierModifier({});
}

/**
	Kill
	
	@param {real} _turn_count
	@param {real} _icon_index
*/
function ValorBuff(_turn_count) : Buff(_turn_count, 1) constructor {
	stats = new StatsMultiplierModifier({ at: 1.5, mag: 1.25 });
}

/**
	Angel stop dying
	
	@param {real} _turn_count
*/
function ProtectionBuff(_turn_count) : Buff(_turn_count, 2) constructor {
	stats = new StatsMultiplierModifier({ df: 1.5 });
}

/**
	You wobblin big fella
	
	@param {real} _turn_count
*/
function StaggerBuff(_turn_count) : Buff(_turn_count, 3) constructor {
	stats = new StatsMultiplierModifier({ sp: 0.5 });
}