function BasicSpeedDebuffAction() : Action() constructor {
	//Feather ignore GM2043
	__state = 0;
	__waitTimer = new SimpleTimer(35, self, "AdvanceState");
	__z = 0;
	__zSpeed = -12;
	__zGravity = 1;
	__part_system = undefined;
	//Feather restore GM2043
	
	AdvanceState = function() {
		__state++;
	}
	
	Run = function() {
		var _attacker = __attackers[0],
			_victim = __targets[0];
		
		switch(__state) {
			case 0:
				__z = min(__z + __zSpeed, 0);
				__zSpeed += __zGravity;
				_attacker.y = _attacker.ystart + __z;
				if(__z == 0) {
					AdvanceState();
					break;
				}
				break;
			case 1:
				__part_system = part_system_create_layer("Instances", false, PartSysStaggerBuff);
				part_system_position(__part_system, _victim.x, _victim.y - 34);
				AdvanceState();
				break;
			case 2:
				_victim.ApplyBuff(new StaggerBuff(3));
				AdvanceState();
				break;
			case 3:
				__waitTimer.Tick();
				break;
			case 4:
				part_system_destroy(__part_system);
				__hasEnded = true;
				break;
		}
	}
}