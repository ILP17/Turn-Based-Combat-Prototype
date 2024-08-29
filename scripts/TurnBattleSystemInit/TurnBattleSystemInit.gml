#macro AT_STAT "at"
#macro DF_STAT "df"
#macro MAG_STAT "mag"

enum EffectType {
	Damage,
	Heal,
	Revive
}

enum TargetType {
	Enemy,
	Team,
	Self
}

global.actionMetadata = {};

global.actionMetadata[$ nameof(BasicHitAction)] = new ActionMetadata();
global.actionMetadata[$ nameof(BasicHealAction)] = new ActionMetadata(
	{targetType: TargetType.Team, effectType: EffectType.Heal, targetStrategy: HealTargetStrategy});