function BasicExplosionAction() : Action() constructor {
	//Feather ignore GM2043
	__state = 0;
	__strikeTimer = new SimpleTimer(15, self, "DoEffect");
	__strikeCount = 6;
	__waitTimer = new SimpleTimer(30, self, "AdvanceState");
	__target_index = 0;
	//Feather restore GM2043
	
	AdvanceState = function() {
		__state++;
	}
	
	DoEffect = function() {
		if(__strikeCount == 0) {
			AdvanceState();
			return;
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
	}
	
	Run = function() {
		var _attacker = __attackers[0];
		
		switch(__state) {
			case 0:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart - 64, 6)) {
					AdvanceState();
				}
				break;
			case 1:
				__strikeTimer.Tick();
				break;
			case 2:
				for(var i = 0; i < array_length(__targets); i++) {
					var _victim = __targets[i];
					var _effect = instance_create_depth(
						_victim.x,
						_victim.y,
						_victim.depth + 1, ObjBasicEffect);
					_effect.Initialize(SprExplosion);
					_victim.Damage(GetDamage(_attacker, 0.5, _victim, MAG_STAT, DF_STAT, 5));
				}
				AdvanceState();
				break;
			case 3:
				if(ScrInstanceMoveTo(_attacker, _attacker.x, _attacker.ystart, 4)) {
					AdvanceState();
				}
				break;
			case 4:
				__waitTimer.Tick();
				break;
			case 5:
				__hasEnded = true;
				break;
		}
	}
}