function TurnContext(_turn_instance, _my_team, _enemy_team) constructor {
	turnInstance = _turn_instance;
	myTeam = _my_team;
	enemyTeam = _enemy_team;
	
	static ResolveTargets = function() {
		switch(_actionInstance.targetType) {
			case TargetType.Enemy:
				_target = _turnInstance.GetTarget(_enemyTeam);
				break;
			case TargetType.Team:
				_target = _turnInstance.GetTarget(_myTeam);
				break;
			case TargetType.Self:
				_target = _turnInstance;
				break;
		}
	}
}