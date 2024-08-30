function Action() constructor {
	__attackers = [];
	__targets = [];
	__hasEnded = false;
	
	Initialize = function(_attackers, _targets) {
		__attackers = _attackers;
		__targets = _targets;
	}
	
	HasEnded = function() {
		return __hasEnded;
	}
	
	GetDamage = function(_attacker, _scalar, _victim, _attack_stat_key, _defense_stat_key) {
		var _damage = floor(_attacker.GetStat(_attack_stat_key) * -_scalar * random_range(0.8, 1));
		
		if(_scalar < 0) {
			_damage = max(_damage - _victim.GetStat(_defense_stat_key), 1);
		}
		
		return _damage;
	}
	
	GetDamageNoDefense = function(_attacker, _scalar, _victim, _attack_stat_key) {
		var _damage = floor(_attacker.GetStat(_attack_stat_key) * -_scalar * random_range(0.8, 1));
		
		if(_scalar < 0) {
			_damage = max(_damage, 1);
		}
		
		return _damage;
	}
}