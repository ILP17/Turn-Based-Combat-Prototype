/**
*/
function Character(_config = {}) constructor {
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	stats = _config[$ "stats"] ?? new Stats();
	actions =  _config[$ "actions"] ?? [BasicHitAction];
	strategies = _config[$ "strategies"] [BasicActionStrategy];
}

/**
*/
function Stats(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 10;
	at = _config[$ "at"] ?? 0;
	df = _config[$ "df"] ?? 0;
	sp = _config[$ "sp"] ?? 0;
	mag = _config[$ "mag"] ?? 0;
}

/**
*/
function StatsMultiplier(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 1;
	at = _config[$ "at"] ?? 1;
	df = _config[$ "df"] ?? 1;
	sp = _config[$ "sp"] ?? 1;
	mag = _config[$ "mag"] ?? 1;
}