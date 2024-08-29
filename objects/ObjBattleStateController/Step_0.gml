switch(battleState) {
	case BattleStates.PreBattle: PreBattle(); break;
	case BattleStates.PreTurn: PreTurn(); break;
	case BattleStates.Turn: Turn(); break;
	case BattleStates.PostTurn: PostTurn(); break;
	case BattleStates.PostBattle: PostBattle(); break;
}