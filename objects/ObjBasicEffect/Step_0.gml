if(__initialLife != -1) {
	if(__life <= 0) {
		instance_destroy();
		exit;
	} else {
		__life --;
	}
}