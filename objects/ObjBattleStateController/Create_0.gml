enum BattleStates {
	NA,			// Pause
	PreBattle,	// Intro Animation
	PreTurn,	// Get Action and Target
	Turn,		// Turn cycle
	PostTurn,	// Advance Turn
	PostBattle	// Exp Award Animation
}

__ = {};
with (__) {
	scheduler = new Scheduler();
}

__currentTurnIndex = 0;
__alphaTeam = [];
__betaTeam = [];
__.scheduler = new Scheduler();

currentTurnOrder = [];
battleState = BattleStates.NA;

//@ignore
__SortBySpeed = function(_bp1, _bp2) {
	return _bp2.GetStat(SP_STAT) - _bp1.GetStat(SP_STAT);
}

//@ignore
__SignalTurnEnd = function() {
	battleState = BattleStates.PostTurn;
}

//@ignore
__CheckTeamAlive = function(_team) {
	for(var i = 0; i < array_length(_team); i++) {
		if(_team[i].IsAlive()) {
			return true;
		}
	}
	
	return false;
}

//@ignore
__CreateTurnOrder = function() {
	array_sort(currentTurnOrder, __SortBySpeed);
}

/**
	@param {Id.Instance} _battle_participant
	@param {struct.Action} _action
	@param {real} _turn_count the number of turns to wait, 0 will mean the very next turn
*/
AddDelayedAction = function(_battle_participant, _action, _turn_count) {
	__.scheduler.AddDelayedAction(new DelayedAction(_battle_participant, _action, _turn_count));
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
	__CreateTurnOrder();
	battleState = BattleStates.PreTurn;
}

PreTurn = function() {
	if(!__CheckTeamAlive(__alphaTeam)) {
		//player wins
		battleState = BattleStates.PostBattle;
		return;
	} else if(!__CheckTeamAlive(__betaTeam)) {
		//monsters win
		battleState = BattleStates.PostBattle;
		return;
	}
	
	var _turn_instance = currentTurnOrder[__currentTurnIndex];
	var _turn_context = new TurnContext(_turn_instance, __alphaTeam, __betaTeam);
	
	__.scheduler.TickDelayedAction(_turn_instance);
	
	if(__.scheduler.HasReadyAction()) {
		var _action = __.scheduler.GetCurrentAction();
		var _target_strategy = _action.CreateTargetStrategy();
		var _new_targets = _target_strategy.DelayedActionTargetsCheck(_action, _turn_context);
		
		if(array_length(_new_targets) == 0) {
			_action.Fail();
			__.scheduler.TrashCurrentAction();
			battleState = BattleStates.PostTurn;
			return;
		}
		
		_action.Initialize([_turn_instance], _new_targets);
		
		battleState = BattleStates.Turn;
		return;
	}
	
	if(!_turn_instance.CanAct() || __.scheduler.HasDelayedActionFor(_turn_instance)) {
		// skipTurn
		battleState = BattleStates.PostTurn;
		return;
	}
	
	var _turn_action_context = _turn_instance.GetAction(_turn_context);
	
	__.scheduler.AddAction(_turn_action_context.action);
	battleState = BattleStates.Turn;
}

Turn = function() {
	__.scheduler.ProcessCurrentAction();
	
	if(!__.scheduler.HasReadyAction()) {
		battleState = BattleStates.PostTurn;
	}
}

PostTurn = function() {
	currentTurnOrder[__currentTurnIndex].DecayBuffs();
	__currentTurnIndex++;
	
	if(__currentTurnIndex >= array_length(currentTurnOrder)) {
		__CreateTurnOrder();
		__currentTurnIndex = 0;
	}
	
	battleState = BattleStates.PreTurn;
}

PostBattle = function() {
}