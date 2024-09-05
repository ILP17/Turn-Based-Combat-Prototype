__healthColor = c_aqua;

if(GetHealthRatio() < 0.5) {
	__healthColor = c_yellow;
}

if(GetHealthRatio() < 0.25) {
	__healthColor = c_red;
}

var _difference = __health - __healthDisplay;

if(__health < __healthDisplay) {
	__healthDisplay += floor(_difference * 0.1);
} else if(__health > __healthDisplay) {
	__healthDisplay += ceil(_difference * 0.1);
}