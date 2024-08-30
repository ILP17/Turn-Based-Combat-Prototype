__healthColor = c_aqua;

if(GetHealthRatio() < 0.5) {
	__healthColor = c_yellow;
}

if(GetHealthRatio() < 0.25) {
	__healthColor = c_red;
}

__healthDisplay = lerp(__healthDisplay, __health, 0.1);