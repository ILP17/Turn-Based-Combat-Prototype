var _view_ratio = 2;	//this need to be actually calculated
var _display_health_ratio = __healthDisplay / __characterData.GetStat(HP_STAT);

draw_set_halign(sign(image_xscale) == 1 ? fa_right : fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_set_font(FonUISmall);
draw_text(
	(xstart + (abs(sprite_width) - 2) * -image_xscale) * _view_ratio,
	(ystart - sprite_height * 0.75) * _view_ratio,
	__characterData.name
);

var _middle_x = (xstart - (abs(sprite_width) + 12) * image_xscale);
var _x1 = (_middle_x - 14) * _view_ratio;
var _x2 = (_middle_x + 14) * _view_ratio;
var _y1 = (ystart - sprite_height * 0.75 + 2) * _view_ratio;
var _y2 = _y1 + 8 * _view_ratio;

draw_rectangle_color(_x1, _y1, _x2, _y2, c_black, c_black, c_black, c_black, false);

_x1 += 2 * _view_ratio;
_x2 -= 2 * _view_ratio;

if(__healthDisplay > 0) {
	draw_rectangle_color(
		_x1,
		_y1 + 2 * _view_ratio,
		_x1 + floor(abs(_x2 - _x1) * _display_health_ratio),
		_y2 - 2 * _view_ratio,
		__healthColor,
		__healthColor,
		__healthColor,
		__healthColor,
		false);
}

for(var i = 0; i < array_length(__buffs); i++) {
	draw_sprite(
		SprBuffIcons,
		__buffs[i].iconIndex,
		(sign(image_xscale) == 1 ? _x1 : _x2) + (-18 - 18 * i) * image_xscale,
		_y1);
}