function BasicMultiTurnAction() : Action() constructor {
	__state = 0;
	__waitTimer = new SimpleTimer(35);
	__z = 0;
	__zSpeed = -12;
	__zGravity = 1;
	__part_system = undefined;
	
	Run = function() {
		var _attacker = __attackers[0];
		
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
				var _action = new BasicMultiTurnAttackAction();
				
				_action.Initialize(__attackers, __targets);
				
				ObjBattleStateController.AddDelayedAction(_attacker, _action, 0);
				_attacker.AddEffect(instance_create_depth(_attacker.x, _attacker.y, _attacker.depth + 1, ObjAngelBeamCharge));
				__state++;
				break;
			case 2:
				__hasEnded = true;
				break;
		}
	}
}