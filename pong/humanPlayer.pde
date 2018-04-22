class HumanPlayer extends Player {
  @Override
  public Action decide(GameState state, boolean isLeft) {
    if (keyPressed) {
      if (key == 'w') return Action.GO_UP;
      if (key == 's') return Action.GO_DOWN;
    }
    return Action.DO_NOTHING;
  }
}
