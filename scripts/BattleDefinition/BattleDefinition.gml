global.monsters = {
	Weirdo: new MonsterCharacter(
		{ name: "Weirdo", sprite: SprMonster, stats: new Stats({ hp: 25, at: 10, df: 2, sp: 3 }) }),
	Killer: new MonsterCharacter(
		{ name: "Killer", sprite: SprAngryMonster, stats: new Stats({ hp: 15, at: 25, df: 3, sp: 2 }) }),
	Abhorrence: new MonsterCharacter(
		{ name: "Abhorrence", sprite: SprAbhorrence, isBoss: true, stats: new Stats({ hp: 130, at: 38, df: 8, sp: 1 }) }),
	SassyWitch: new MonsterCharacter({
		name: "Sassy Witch",
		sprite: SprSassyWitch,
		stats: new Stats({ hp: 40, at: 15, df: 5, sp: 5 }),
		actions: [ BasicHitAction, BasicBuffAction, BasicDebuffAction],
		strategies: [BasicActionStrategy, BuffActionStrategy] })
};

global.classes = {
	Rouge: new Class({
		baseStats: new Stats({ hp: 12, at: 5, df: 1, sp: 5 }),
		maxStats: new Stats({ hp: 275, at: 175, df: 75, sp: 100 })}),
	Warrior: new Class({
		baseStats: new Stats({ hp: 15, at: 5, df: 5, sp: 3 }),
		maxStats: new Stats({ hp: 350, at: 225, df: 95, sp: 75 })}),
	Mage: new Class({
		baseStats: new Stats({ hp: 10, at: 3, df: 1, sp: 3, mag: 1}),
		maxStats: new Stats({ hp: 250, at: 120, df: 75, sp: 85, mag: 140 }),
		actions: [BasicHitAction, BasicLightningAction, BasicExplosionAction]}),
	Angel: new Class({
		baseStats: new Stats({ hp: 10, at: 3, df: 1, sp: 4, mag: 1 }),
		maxStats: new Stats({ hp: 195, at: 100, df: 80, sp: 90, mag: 168 }),
		actions: [BasicHitAction, BasicHealAction, BasicResurrectionAction, BasicMultiTurnAction],
		strategies: [BasicActionStrategy, HealActionStrategy, ReviveActionStrategy]})
}

global.playerParty = [
	new PlayerCharacter({
		name: "Loser",
		class: global.classes.Rouge}),
	new PlayerCharacter({
		name: "Kartoffel",
		sprite: SprMage,
		class: global.classes.Mage,
		level: 50}),
	new PlayerCharacter({
		name: "#1 Harpy Fan",
		class: global.classes.Warrior}),
	new PlayerCharacter({
		name: "Angel",
		sprite: SprHealer,
		class: global.classes.Angel})
];

global.enemyParty = [
	global.monsters.Weirdo,
	global.monsters.Weirdo,
	global.monsters.Abhorrence,
	global.monsters.SassyWitch,
	global.monsters.Killer,
	global.monsters.Killer
];