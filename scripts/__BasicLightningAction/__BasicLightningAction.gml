function BasicLightningAction() : Action() constructor {
	__state = 0;
	__strikeTimer = new SimpleTimer(20);
	__strikeCount = 0;
	__target_index = 0;
	
	Run = function() {
		var _attacker = __attackers[0];
		
		switch(__state) {
			case 0:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart - 64, 6)) {
					__strikeCount = array_length(__targets);
					__state ++;
				}
				break;
			case 1:
				if(__strikeTimer.IsFinished()) {
					var _victim = __targets[__target_index];
					var _effect = instance_create_depth(_victim.x, _victim.y, _victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprLightning, 24);
					_effect.image_yscale = 100;
					_effect.image_angle = -25;
					__strikeTimer.Reset();
					
					if(__target_index == 0) {
						_victim.Damage(GetDamage(_attacker, 0.8, _victim, MAG_STAT, DF_STAT, 4));
					} else {
						_victim.Damage(GetDamage(_attacker, 0.5, _victim, MAG_STAT, DF_STAT, 4));
					}
					
					__strikeCount --;
					__target_index ++;
					
					if(__strikeCount == 0) {
						__state++;
						break;
					}
				} else {
					__strikeTimer.Tick();
				}
				break;
			case 2:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart, 4)) {
					__state ++;
				}
				break;
			case 3:
				__hasEnded = true;
				break;
		}
	}
}