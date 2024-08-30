function BasicExplosionAction() : Action() constructor {
	__state = 0;
	__strikeTimer = new SimpleTimer(15);
	__strikeCount = 6;
	__waitTimer = new SimpleTimer(30);
	__target_index = 0;
	
	Run = function() {
		var _attacker = __attackers[0];
		
		switch(__state) {
			case 0:
				if(scr_instance_move_to(_attacker, _attacker.x, _attacker.ystart - 64, 6)) {
					__state ++;
				}
				break;
			case 1:
				if(__strikeTimer.IsFinished()) {
					var _victim = __targets[irandom(array_length(__targets) - 1)];
					var _effect = instance_create_depth(
						_victim.x + irandom_range(-24, 24),
						_victim.y + irandom_range(-16, 16),
						_victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprExplosion);
					_effect.image_xscale = 0.5;
					_effect.image_yscale = 0.5;
					__strikeTimer.Reset();
					
					if(__strikeCount == 0) {
						__state++;
						break;
					}
					
					__strikeCount --;
				} else {
					__strikeTimer.Tick();
				}
				break;
			case 2:
				for(var i = 0; i < array_length(__targets); i++) {
					var _victim = __targets[i];
					var _effect = instance_create_depth(
						_victim.x,
						_victim.y,
						_victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprExplosion);
					_victim.Damage(GetDamage(_attacker, 0.3, _victim, AT_STAT, DF_STAT));
				}
				__state ++;
				break;
			case 3:
				if(scr_instance_move_to(_attacker, _attacker.x, _attacker.ystart, 4)) {
					__state ++;
				}
				break;
			case 4:
				if(__waitTimer.IsFinished()) {
					__state++;
					break;
				} else {
					__waitTimer.Tick();
				}
				break;
			case 5:
				__hasEnded = true;
				break;
		}
	}
}