global.playerParty = [
	new Character({ name: "Loser", stats: new Stats({ hp: 40, at: 18, df: 13, sp: 8 }) }),
	new Character({
		name: "Kartoffel",
		sprite: SprMage,
		stats: new Stats({ hp: 35, at: 12, df: 15, mag: 20, sp: 5 }),
		actions: [BasicHitAction, BasicLightningAction, BasicExplosionAction],
		strategies: [BasicActionStrategy] }),
	new Character({ name: "#1 Harpy Fan", stats: new Stats({ hp: 50, at: 26, df: 18, sp: 3 }) }),
	new Character({
		name: "Angel",
		sprite: SprHealer,
		stats: new Stats({ hp: 30, at: 15, df: 12, mag: 25, sp: 6 }),
		actions: [BasicHitAction, BasicHealAction, BasicResurrectionAction],
		strategies: [BasicActionStrategy, HealActionStrategy, ReviveActionStrategy] })
];

global.enemyParty = [
	new Character({ name: "Weirdo", sprite: SprMonster, stats: new Stats({ hp: 25, at: 10, df: 2, sp: 3 }) }),
	new Character({ name: "Weirdo", sprite: SprMonster, stats: new Stats({ hp: 25, at: 10, df: 2, sp: 3 }) }),
	new Character({ name: "Abhorrence", sprite: SprAbhorrence, stats: new Stats({ hp: 130, at: 32, df: 8, sp: 1 }) }),
	new Character({ name: "Killer", sprite: SprAngryMonster, stats: new Stats({ hp: 15, at: 20, df: 3, sp: 2 }) }),
	new Character({ name: "Killer", sprite: SprAngryMonster, stats: new Stats({ hp: 15, at: 20, df: 3, sp: 2 }) })
];