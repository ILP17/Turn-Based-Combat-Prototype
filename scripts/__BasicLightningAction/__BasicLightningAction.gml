function BasicLightningAction() : Action() constructor {
	__state = 0;
	__strikeTimer = new SimpleTimer(15);
	__strikeCount = 0;
	__waitTimer = new SimpleTimer(15);
	__target_index = 0;
	
	Run = function() {
		var _attacker = __attackers[0];
		
		switch(__state) {
			case 0:
				if(scr_instance_move_to(_attacker, _attacker.x, _attacker.ystart - 64, 12)) {
					__strikeCount = array_length(__targets);
					__state ++;
				}
				break;
			case 1:
				if(__strikeTimer.IsFinished()) {
					__strikeCount --;
					
					var _victim = __targets[0];
					var _effect = instance_create_depth(_victim.x, _victim.y, _victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprLightning, 24);
					_effect.image_yscale = 100;
					_effect.image_angle = -45;
					
					if(__strikeCount == 0) {
						__state++;
						break;
					}
				} else {
					__strikeTimer.Tick();
				}
				break;
			case 2:
				if(scr_instance_move_to(_attacker, _attacker.x, _attacker.ystart, 8)) {
					__state ++;
				}
				break;
			case 3:
				__hasEnded = true;
				break;
		}
	}
}