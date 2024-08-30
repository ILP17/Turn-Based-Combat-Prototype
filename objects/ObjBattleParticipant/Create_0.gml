__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__characterData = new Character();
__health = 0;
__buffs = [];

/**
	@param {struct.CharacterData} _character_data
*/
Initialize = function(_character_data) {
	__characterData = _character_data;
	
	__health = __characterData.stats.hp;
	
	var _name = sprite_get_name(__characterData.sprite);
	__sprite = __characterData.sprite;
	__spriteDead = _name + "Dead";
}

GetStat = function(_stat_key) {
	var _value = __characterData.stats[$ _stat_key];
	
	for(var i = 0; i < array_length(__buffs); i++) {
		_value *= __buffs[i].stats[$ _stat_key];
	}
	
	return _value;
}

/**
	@param {struct.TurnContext} _turn_context
	@return {struct.TurnActionContext}
*/
GetAction = function(_turn_context) {
	//Get action
	var _strategies = __characterData.strategies,
		_actions = __characterData.actions,
		_weights = undefined;
	
	//Get weights
	for(var i = 0; i < array_length(_strategies); i++) {
		_weights = _strategies.EvaluateAction(_turn_context, _actions, _weights);
	}
	
	//Get total weight
	var _total_weight = 0;
	for(var i = 0; i < array_length(_weights); i++) {
		_total_weight += _weights[i];
	}
	
	//Get action
	var _chosen_weight = random(_total_weight),
		_last_weight = 0,
		_action;
	for(var i = 0; i < array_length(_weights); i++) {
		if(_chosen_weight >= _last_weight && _chosen_weight <= _weights[i] + _last_weight) {
			_action = _actions[i];
			break;
		}
		_last_weight = _weights[i] + _last_weight;
	}
	
	//Get targets
	var _action_metadata = scr_get_action_metadata(_action);
	var _targets = (new _action_metadata.targetStrategy()).GetTarget(_turn_context.ResolveTargets(_action));
	
	return new TurnActionContext(new _action(), _targets);
}

GetHealthRatio = function() {
	return __health / __characterData.stats.hp;
}

IsAlive = function() {
	return __health > 0;
}

Damage = function(_damage) {
	var _is_crit = irandom(99) + 1 <= 25,
		_style = 1;
	
	if(_is_crit) {
		_damage = floor(_damage * 1.5);
		_style = 2;
	}
	
	if(_damage > 0) {
		_style = 3;
	}
	
	__health = clamp(__health + _damage, 0, __characterData.stats.hp);
	
	instance_create_depth(x, y, depth, ObjDamage).Initialize(_damage, _style);
}