__time = 0;
__damageChannel = animcurve_get_channel(AnimCurveElastic, 0);
__critChannel = animcurve_get_channel(AnimCurveElastic, 1);
__weakChannel = animcurve_get_channel(AnimCurveElastic, 2);

damage = 0;
style = 0;

Initialize = function(_damage, _style) {
	damage = _damage;
	style = _style;
}
