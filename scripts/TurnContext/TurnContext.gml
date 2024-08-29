function TurnContext(_turn_instance, _my_team, _enemy_team) constructor {
	turnInstance = _turn_instance;
	myTeam = _my_team;
	enemyTeam = _enemy_team;
	
	static ResolveTargets = function(_action_instance) {
		var _targets = [];
		
		switch(_action_instance.targetType) {
			case TargetType.Enemy:
				_targets = enemyTeam;
				break;
			case TargetType.Team:
				_targets = myTeam;
				break;
			case TargetType.Self:
				_targets = [turnInstance];
				break;
		}
		
		return _targets;
	}
}