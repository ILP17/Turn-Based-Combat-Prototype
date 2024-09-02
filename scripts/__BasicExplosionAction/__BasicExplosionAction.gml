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
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart - 64, 6)) {
					__state ++;
				}
				break;
			case 1:
				if(__strikeTimer.IsFinished()) {
					if(__strikeCount == 0) {
						__state++;
						break;
					}
					
					var _victim = __targets[irandom(array_length(__targets) - 1)];
					var _effect = instance_create_depth(
						_victim.x + irandom_range(-24, 24),
						_victim.y + irandom_range(-16, 16),
						_victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprExplosion);
					ScrInstanceSetScale(_effect, 0.5, 0.5);
					__strikeTimer.Reset();
					__strikeCount --;
					if(__strikeCount == 0) {
						__strikeTimer.Set(35);
					}
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
					_victim.Damage(GetDamage(_attacker, 0.3, _victim, MAG_STAT, DF_STAT));
				}
				__state ++;
				break;
			case 3:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart, 4)) {
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