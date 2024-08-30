enum BattleStates {
	NA,			// Pause
	PreBattle,	// Intro Animation
	PreTurn,	// Get Action and Target
	Turn,		// Turn cycle
	PostTurn,	// Advance Turn
	PostBattle	// Exp Award Animation
}

__currentTurnIndex = 0;
__alphaTeam = [];
__betaTeam = [];

battleParticipants = [];
battleParticipants = [];
currentTurnOrder = [];
battleState = BattleStates.NA;
__actions = [];							//This will act as a queue for actions to perform

__SortBySpeed = function(_bp1, _bp2) {
	return _bp1.stats.sp - _bp2.stats.sp;
}

__SignalTurnEnd = function() {
	battleState = BattleStates.PostTurn;
}

__CheckTeamAlive = function(_team) {
	for(var i = 0; i < array_length(_team); i++) {
		if(_team[i].IsAlive()) {
			return true;
		}
	}
	
	return false;
}

CreateTurnOrder = function() {
	array_sort(battleParticipants, __SortBySpeed);
}

PreBattle = function() {
	var _characterData,
		_battleParticipant = noone,
		_playerX = room_width / 3,
		_monsterX = room_width * (2 / 3),
		_y = (room_height / 2) - (array_length(global.playerParty) * 34) / 2;
	
	for(var i = 0; i < array_length(global.playerParty); i++) {
		_characterData = global.playerParty[i];
		_battleParticipant = instance_create_layer(
			_playerX + irandom_range(-18, 18), _y + i * 34, layer, ObjBattleParticipant);
		_battleParticipant.Initialize(_characterData);
		array_push(__alphaTeam, _battleParticipant);
	}
	
	_y = (room_height / 2) - (array_length(global.enemyParty) * 34 / 2);
	for(var i = 0; i < array_length(global.enemyParty); i++) {
		_characterData = global.enemyParty[i];
		
		var _realMonsterX = _monsterX + irandom_range(-18, 18);
		
		if(_characterData.isBoss) {
			_realMonsterX += 80;
		}
		
		_battleParticipant = instance_create_layer(
			_realMonsterX, _y + i * 34, layer, ObjBattleParticipant);
		_battleParticipant.Initialize(_characterData);
		_battleParticipant.image_xscale = -1;
		array_push(__betaTeam, _battleParticipant);
	}
	
	currentTurnOrder = array_concat(__alphaTeam, __betaTeam);
	battleState = BattleStates.PreTurn;
}

PreTurn = function() {
	if(!__CheckTeamAlive(__alphaTeam)) {
		//player wins
		battleState = BattleStates.PostBattle;
		return;
	}
	
	if(!__CheckTeamAlive(__betaTeam)) {
		//monsters win
		battleState = BattleStates.PostBattle;
		return;
	}
	
	var _turnInstance = currentTurnOrder[__currentTurnIndex],
		_target = noone;
	
	if(!_turnInstance.CanAct()) {
		// skipTurn
		battleState = BattleStates.PostTurn;
		return;
	}
	
	var _myTeam,
		_enemyTeam;
	
	if(array_contains(__alphaTeam, _turnInstance)) {
		_myTeam = __alphaTeam;
		_enemyTeam = __betaTeam;
	}
	
	if(array_contains(__betaTeam, _turnInstance)) {
		_myTeam = __betaTeam;
		_enemyTeam = __alphaTeam;
	}
	
	var _turn_action_context = _turnInstance.GetAction(new TurnContext(_turnInstance, _myTeam, _enemyTeam));
	
	if(_target == noone) {
		//assume end of battle
		battleState = BattleStates.PostBattle;
		return;
	}
	
	_actionInstance.Initialize(_turn_action_context.action, _turn_action_context.targets);
	array_push(__actions, _actionInstance);
	battleState = BattleStates.Turn;
}

Turn = function() {
	if(array_length(__actions) > 0)	{
		__actions[0].Run();
		
		if(__actions[0].HasEnded()) {
			array_shift(__actions);
		}
	}
	
	if(array_length(__actions) == 0)	{
		battleState = BattleStates.PostTurn;
	}
}

PostTurn = function() {
	array_pop(__actions);
	__currentTurnIndex++;
	
	if(__currentTurnIndex >= array_length(currentTurnOrder)) {
		__currentTurnIndex = 0;
	}
	battleState = BattleStates.PreTurn;
}

PostBattle = function() {
}