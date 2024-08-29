//Dont use this directly >:(
function Buff(_icon_index = 0) constructor {
	iconIndex = _icon_index;
	stats = new StatsMultiplierModifier({});
}

//Kill
function ValorBuff() : Buff(1) constructor {
	stats = new StatsMultiplierModifier({ at: 1.5, mag: 1.25 });
}

//Angel stop dying
function ProtectionBuff() : Buff(2) constructor {
	stats = new StatsMultiplierModifier({ df: 1.5 });
}

//You wobblin big fella
function StaggerBuff() : Buff(3) constructor {
	stats = new StatsMultiplierModifier({ sp: 0.5 });
}