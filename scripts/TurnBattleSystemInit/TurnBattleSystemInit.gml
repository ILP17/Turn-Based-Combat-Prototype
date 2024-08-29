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