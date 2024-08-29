draw_sprite(
	SprDamage,
	image_index,
	x,
	y
);

draw_set_color(__textColor);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(FonUISmall);
draw_text_transformed(x - 3, y, damage, image_xscale, image_yscale, 0);