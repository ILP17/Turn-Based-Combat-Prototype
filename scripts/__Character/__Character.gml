function Character(_config = {}) constructor {
	name = _config[$ "name"] ?? "";
	sprite = _config[$ "sprite"] ?? SprPlayer;
	stats = _config[$ "stats"] ?? new Stats();
	actions = _config[$ "actions"] ?? [BasicHitAction];
}

function Stats(_config = {}) constructor {
	hp = _config[$ "hp"] ?? 10;
	at = _config[$ "at"] ?? 0;
	df = _config[$ "df"] ?? 0;
	sp = _config[$ "sp"] ?? 0;
}

enum TargetType {
	Enemy,
	Team,
	Self
}

function Action(_targetType = TargetType.Enemy) constructor {
	targetType = _targetType;
	__attacker = [];
	__victim = [];
	
	TargetRequirement = function(_target) {
		return true;
	}
	
	Initialize = function(_attacker, _victim) {
		__attacker = _attacker;
		__victim = _victim;
	}
}

function BasicHitAction() : Action() constructor {
	__state = 0;
	__waitTimer = 0;
	
	Run = function() {
		var _distance,
			_direction;
		switch(__state) {
			case 0:
				_distance = point_distance(__attacker.x, __attacker.y, __victim.x, __victim.y);
				_direction = point_direction(__attacker.x, __attacker.y, __victim.x, __victim.y);
				if(_distance < 24) {
					__state++;
					break;
				}
				
				__attacker.x += lengthdir_x(min(8, _distance), _direction);
				__attacker.y += lengthdir_y(min(8, _distance), _direction);
				break;
			case 1:
				__victim.Damage(__attacker, 0.4);
				__state++;
				break;
			case 2:
				_distance = point_distance(__attacker.x, __attacker.y, __attacker.xstart, __attacker.ystart);
				_direction = point_direction(__attacker.x, __attacker.y, __attacker.xstart, __attacker.ystart);
				if(_distance < 8) {
					__attacker.x = __attacker.xstart;
					__attacker.y = __attacker.ystart;
					__state++;
					break;
				}
				
				__attacker.x += lengthdir_x(min(8, _distance), _direction);
				__attacker.y += lengthdir_y(min(8, _distance), _direction);
				break;
			case 3:
				__attacker.SignalEnd();
				__state++;
				break;
		}
	}
}

function BasicHealAction() : Action(TargetType.Team) constructor {
	__state = 0;
	__zDiff = 0;
	__zSpeed = -10;
	__zgravity = 1;
	__waitTimer = 45;
	Run = function() {
		var _distance,
			_direction;
		switch(__state) {
			case 0:
				__zDiff = min(__zDiff +__zSpeed, 0);
				__zSpeed += __zgravity;
				
				__attacker.y = __attacker.ystart + __zDiff;
				if(__zDiff == 0) {
					__state++;
				}
				break;
			case 1:
				__victim.Damage(__attacker, -0.25);
				__state++;
				break;
			case 2:
				if(__waitTimer <= 0) {
					__attacker.SignalEnd();
				}
				__waitTimer--;
				break;
		}
	}
}