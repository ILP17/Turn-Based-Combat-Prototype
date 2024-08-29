__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__characterData = new Character();

/**
	@param {struct.CharacterData} _character_data
*/
Initialize = function(_character_data) {
	__characterData = _character_data;
	var _name = sprite_get_name(_character_data.sprite);
	__sprite = _character_data.sprite;
	__spriteDead = _name + "Dead";
}