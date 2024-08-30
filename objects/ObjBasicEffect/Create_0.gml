__life = -1;
__initialLife = -1;

Initialize = function(_sprite, _life = -1) {
	sprite_index = _sprite;
	__initialLife = _life;
	__life = __initialLife;
}