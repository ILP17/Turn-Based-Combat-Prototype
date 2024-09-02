__sprite = SprPlayer;
__spriteDead = SprPlayerDead;
__healthColor = c_aqua;
__characterData = new Character();
__health = 0;
__healthDisplay = 0;
__buffs = [];
__actionEvaluator = new CPUActionEvaluator(__characterData);

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
	
	__actionEvaluator = new CPUActionEvaluator(__characterData);
	
	return id;
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
	var _action = __actionEvaluator.DetermineAction(_turn_context);
	var _action_instance = new _action();
	var _targets = __actionEvaluator.DetermineTargets(_action_instance, _turn_context);
	
	if(array_length(_targets) == 0) {
		throw ($"ERROR: {instanceof(_target_strategy)} produced no targets!");
	}
	
	_action_instance.Initialize([id], _targets);
	
	return new TurnActionContext(_action_instance, _targets);
}

/**
	@param {struct.Action} _action
	@param {struct.TurnContext} _turn_context
	@return {Array<Id.Instance>}
*/
UpdateTargets = function(_action, _turn_context) {
	return __actionEvaluator.UpdateTargets(_action, _turn_context);
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