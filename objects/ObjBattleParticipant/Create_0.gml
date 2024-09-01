__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__healthColor = c_aqua;
__characterData = new Character();
__health = 0;
__healthDisplay = 0;
__buffs = [];

/**
	@param {struct.TurnContext} _turn_context
*/
__AIDetermineAction = function(_turn_context) {
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
		_min_weight = 0,
		_max_weight = 0,
		_action;
	for(var i = 0; i < array_length(_weights); i++) {
		if(_weights[i] == 0) {
			continue;
		}
		
		_max_weight = _weights[i] + _min_weight;
		
		if(_chosen_weight >= _min_weight && _chosen_weight <= _max_weight) {
			_action = _actions[i];
			break;
		}
		_min_weight = _max_weight;
	}
	
	return _action;
}

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
	var _action = __AIDetermineAction(_turn_context);
	
	//Get targets
	var _action_instance = new _action();
	var _action_metadata = _action_instance.GetMetadata();
	var _target_strategy = _action_instance.CreateTargetStrategy();
	var _targets = _target_strategy.GetTarget(_turn_context.ResolveTargets(_action_metadata), _action_metadata);
	
	if(array_length(_targets) == 0) {
		throw ($"ERROR: {instanceof(_target_strategy)} produced no targets!");
	}
	
	_action_instance.Initialize([id], _targets);
	
	return new TurnActionContext(_action_instance, _targets);
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
		__OnDeath();
	} else {
		sprite_index = __sprite;
		image_blend = c_white;
	}
}

__effects = {};

__OnDeath = function() {
	ClearBuffs();
	RemoveAllEffect();
	ObjBattleStateController.OnBattleParticipantDeath(id);
	sprite_index = __spriteDead;
	image_blend = c_gray;
}

/**
	@param {Id.Instance} _effect_object
*/
AddEffect = function(_effect_object) {
	__effects[$ $"{_effect_object.object_index}"] = _effect_object;
}

/**
	@param {Asset.GMObject} _effect_object
*/
RemoveEffect = function(_effect_object) {
	instance_destroy(__effects[$ $"{_effect_object}"]);
	variable_struct_remove(__effects, $"{_effect_object}");
}

RemoveAllEffect = function() {
	static __RemoveEffect = function(_name, _effect) {
		instance_destroy(_effect);
	}
	
	struct_foreach(__effects, __RemoveEffect)
	__effects = {};
}