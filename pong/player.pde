abstract class Player {
  public abstract Action decide(GameState state, boolean isLeft);
  
  public void touchedBall() {}
  
  public void gameOver(boolean won) {}
}
