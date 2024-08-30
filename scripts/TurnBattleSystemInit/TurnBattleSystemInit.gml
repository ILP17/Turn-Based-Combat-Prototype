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
global.actionMetadata[$ nameof(BasicResurrectionAction)] = new ActionMetadata(
	{targetType: TargetType.Team, effectType: EffectType.Heal, targetStrategy: ReviveTargetStrategy});
global.actionMetadata[$ nameof(BasicLightningAction)] = new ActionMetadata(
	{targetStrategy: AdjacentTargetStrategy});
global.actionMetadata[$ nameof(BasicExplosionAction)] = new ActionMetadata(
	{targetStrategy: AllTargetStrategy});

/**
	@return {struct.ActionMetadata}
*/
function scr_get_action_metadata(_action) {
	return global.actionMetadata[instanceof(_action)];
}