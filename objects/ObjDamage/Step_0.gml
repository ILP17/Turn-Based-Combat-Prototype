var _value = 0;
var _t = min(__time / 20, 1);

switch(style) {
	case 0:
		image_index = 0;
		_value = animcurve_channel_evaluate(__weakChannel, _t);
		break;
	case 1:
		image_index = 1;
		_value = animcurve_channel_evaluate(__damageChannel, _t);
		break;
	case 2:
		image_index = 2;
		_value = animcurve_channel_evaluate(__critChannel, _t);
		break;
	case 3:
		image_index = 3;
		_value = animcurve_channel_evaluate(__weakChannel, _t);
		break;
}

image_xscale = _value;
image_yscale = _value;

if(__time >= 60) {
	instance_destroy();
	exit;
}

__time++;