__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__characterData = new Character();
__health = 0;
__buffs = [];

/**
	@param {struct.CharacterData} _character_data
*/
Initialize = function(_character_data) {
	__characterData = _character_data;
	
	__health = __characterData.stats.hp;
	
	var _name = sprite_get_name(__characterData.sprite);
	__sprite = __characterData.sprite;
	__spriteDead = _name + "Dead";
}

GetStat = function(_stat_key) {
	var _value = __characterData.stats[$ _stat_key];
	
	for(var i = 0; i < array_length(__buffs); i++) {
		_value *= __buffs[i].stats[$ _stat_key];
	}
	
	return _value;
}

GetAction = function(_turn_context) {
	
}

GetHealthRatio = function() {
	return __health / __characterData.stats.hp;
}

IsAlive = function() {
	return __health > 0;
}

Damage = function(_damage) {
	__health = clamp(__health + _damage, 0, __characterData.stats.hp);
}