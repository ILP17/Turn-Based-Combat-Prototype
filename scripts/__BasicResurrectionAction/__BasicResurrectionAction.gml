function BasicResurrectionAction() : Action() constructor {
	__state = 0;
	__shakeTimer = new SimpleTimer(45);
	__waitTimer = new SimpleTimer(15);
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
				_attacker.y = ystart + __z;
				if(__z == 0) {
					state++;
					break;
				}
				break;
			case 1:
				__part_system = part_system_create_layer("Instances", false, PartSysResurrect);
				part_system_position(__part_system, _victim.x, _victim.y);
				break;
			case 2:
				if(__shakeTimer.IsFinished()) {
					__state++;
					break;
				} else {
					_victim.x = _victim.xstart + irandom_range(-4, 4);
					__shakeTimer.Tick();
				}
				break;
			case 3:
				_victim.Damage(GetDamageNoDefense(_attacker, -0.25, _victim, MAG_STAT));
				__state++;
				__z = 0;
				__zSpeed = -14;
				break;
			case 4:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_victim.y = ystart + __z;
				if(__z == 0) {
					state++;
					break;
				}
				break;
			case 5:
				if(__waitTimer.IsFinished()) {
					__state++;
					break;
				} else {
					__waitTimer.Tick();
				}
				break;
			case 6:
				part_system_destroy(__part_system);
				__hasEnded = true;
				break;
		}
	}
}