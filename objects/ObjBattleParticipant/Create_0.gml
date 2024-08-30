__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__healthColor = c_aqua;
__characterData = new Character();
__health = 0;
__healthDisplay = 0;
__buffs = [];

/**
	@param {struct.Character} _character_data
*/
Initialize = function(_character_data) {
	__characterData = _character_data;
	
	__health = __characterData.stats.hp;
	__healthDisplay = __health;
	
	var _name = sprite_get_name(__characterData.sprite);
	__sprite = __characterData.sprite;
	__spriteDead = asset_get_index(_name + "Dead");
	sprite_index = __sprite;
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
		_weights = (new _strategies[i]()).EvaluateAction(_turn_context, _actions, _weights);
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
		if(_weights[i] == 0) {
			continue;
		}
		
		if(_chosen_weight >= _last_weight && _chosen_weight <= _weights[i] + _last_weight) {
			_action = _actions[i];
			break;
		}
		_last_weight = _weights[i] + _last_weight;
	}
	
	//Get targets
	var _action_metadata = scr_get_action_metadata(_action);
	var _target_strategy = new _action_metadata.targetStrategy();
	var _targets = _target_strategy.GetTarget(_turn_context.ResolveTargets(_action_metadata), _action_metadata);
	
	if(array_length(_targets) == 0) {
		throw ($"ERROR: {script_get_name(_action_metadata.targetStrategy)} produced no targets!");
	}
	
	var _actionInstance = new _action();
	
	_actionInstance.Initialize([self], _targets);
	
	return new TurnActionContext(_actionInstance, _targets);
}

GetHealthRatio = function() {
	return __health / __characterData.stats.hp;
}

IsAlive = function() {
	return __health > 0;
}

IsTargetable = function() {
	return IsAlive();
}

CanAct = function() {
	return IsAlive();
}

/**
	@param {struct.Buff}
*/
__buff_constructor = undefined;
HasBuff = function(_buff_constructor) {
	static __InstanceIsBuff = function(_buff, _index) {
		return instanceof(_buff) == script_get_name(__buff_constructor);
	}
	__buff_constructor = _buff_constructor;
	return array_any(__buffs, __InstanceIsBuff);
}

/**
	Returns true if battle participant has any of the provided buffs
	@param {Array<struct.Buff>} _buffs
*/
HasAnyBuff = function(_buffs) {
	for(var i = 0; i < array_length(_buffs); i++) {
		if(HasBuff(_buffs[i])) {
			return true;
		}
	}
	
	return false;
}

/**
	@param {struct.Buff}
*/
ApplyBuff = function(_buff) {
	array_push(__buffs, _buff);
}

/**
	Clears buffs
*/
ClearBuffs = function() {
	__buffs = [];
}

/**
	Decays all buffs' turn timers by 1
*/
DecayBuffs = function() {
	static __Filter = function(_buff, _index) {
		return _buff.turnCount > 0;
	}
	
	__buffs = array_filter(__buffs, __Filter);
	
	for(var i = 0; i < array_length(__buffs); i++) {
		__buffs[i].turnCount --;
	}
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
	
	instance_create_depth(
		x + irandom_range(-12, 12),
		y + irandom_range(-34, -8),
		depth,
		ObjDamage).Initialize(abs(_damage), _style);
	
	if(__health == 0) {
		ClearBuffs();
		sprite_index = __spriteDead;
		image_blend = c_gray;
	} else {
		sprite_index = __sprite;
		image_blend = c_white;
	}
}