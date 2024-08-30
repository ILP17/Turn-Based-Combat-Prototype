function BasicHealAction() : Action() constructor {
	__state = 0;
	__waitTimer = new SimpleTimer(35);
	__z = 0;
	__zSpeed = -12;
	__zGravity = 1;
	
	Run = function() {
		var _attacker = __attackers[0],
			_victim = __targets[0];
		
		switch(__state) {
			case 0:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_attacker.y = _attacker.ystart + __z;
				if(__z == 0) {
					__state++;
					break;
				}
				break;
			case 1:
				_victim.Damage(GetDamageNoDefense(_attacker, -0.25, _victim, MAG_STAT));
				__state++;
				break;
			case 2:
				if(__waitTimer.IsFinished()) {
					__state++;
					break;
				} else {
					__waitTimer.Tick();
				}
				break;
			case 3:
				__hasEnded = true;
				break;
		}
	}
}