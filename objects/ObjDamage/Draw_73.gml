draw_sprite_ext(
	SprDamage,
	image_index,
	x,
	y,
	image_xscale,
	image_yscale,
	0,
	c_white,
	1
);

draw_set_color(__textColor);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(FonUI);
draw_text_transformed(x - 1, y, damage, image_xscale, image_yscale, 0);