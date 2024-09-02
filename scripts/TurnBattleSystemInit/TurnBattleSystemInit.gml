#macro AT_STAT "at"
#macro DF_STAT "df"
#macro MAG_STAT "mag"
#macro SP_STAT "sp"

enum EffectType {
	Damage,
	Heal,
	Revive,
	Buff
}

enum TargetType {
	Enemy,
	Team,
	Self
}

global.actionMetadata = {};

#region Action Metadata
global.actionMetadata[$ nameof(BasicHitAction)] = new ActionMetadata();
global.actionMetadata[$ nameof(BasicHealAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Heal,
	targetStrategy: HealTargetStrategy});
global.actionMetadata[$ nameof(BasicResurrectionAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Revive,
	targetStrategy: ReviveTargetStrategy});
global.actionMetadata[$ nameof(BasicLightningAction)] = new ActionMetadata({
	targetStrategy: AdjacentTargetStrategy});
global.actionMetadata[$ nameof(BasicExplosionAction)] = new ActionMetadata({
	targetStrategy: AllTargetStrategy});
global.actionMetadata[$ nameof(BasicBuffAction)] = new ActionMetadata({
	targetType: TargetType.Team,
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [ValorBuff]});
global.actionMetadata[$ nameof(BasicDebuffAction)] = new ActionMetadata({
	effectType: EffectType.Buff,
	targetStrategy: BuffTargetStrategy,
	buffs: [StaggerBuff]});
global.actionMetadata[$ nameof(BasicMultiTurnAction)] = new ActionMetadata();
global.actionMetadata[$ nameof(BasicMultiTurnAttackAction)] = new ActionMetadata();
#endregion

/**
	@param {Function} _action
	@return {struct.ActionMetadata}
*/
function ScrActionGetMetadata(_action) {
	return global.actionMetadata[$ script_get_name(_action)];
}

/**
	@param {struct.Action} _action
	@return {struct.ActionMetadata}
*/
function ScrActionGetMetadataFromInstance(_action) {
	return global.actionMetadata[$ instanceof(_action)];
}