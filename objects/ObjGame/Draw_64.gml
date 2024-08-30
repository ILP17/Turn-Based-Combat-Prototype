draw_set_halign(fa_center);
draw_set_font(FonUI);

var _gui_width = display_get_gui_width(),
	_gui_height = display_get_gui_height();

if(ObjBattleStateController.battleState == BattleStates.NA) {
	draw_set_color(c_yellow);
	draw_text_transformed(_gui_width/2, _gui_height*0.8, "Press Space to begin!", 2, 2, 0);
}

draw_set_color(c_orange);
draw_text_transformed(_gui_width/2, _gui_height*0.9, "Press R to restart.", 1, 1, 0);