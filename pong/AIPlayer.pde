class AIPlayer extends Player {
  int expectedBallY = -1;
  
  @Override
  public Action decide(GameState state, boolean isLeft) {
    if (isLeft ^ state.ballVelocity.x < 0) return Action.DO_NOTHING;
    int playerX = isLeft ? Game.playerWidth / 2 : Game.WIDTH - Game.playerWidth / 2;
    PVector position = isLeft ? state.leftPosition : state.rightPosition;
    
    if (expectedBallY == -1) expectedBallY = expectedBallY(state.ballVelocity, state.ballPosition, playerX);
    if (abs(position.y - expectedBallY) > 10)
      return position.y > expectedBallY ? Action.GO_UP : Action.GO_DOWN;
     return Action.DO_NOTHING;
  }
  
   int expectedBallY(PVector ballVel, PVector ballPos, int playerX) {
    float timeToCollision = (abs(playerX - ballPos.x) - Game.ballRadius - Game.playerWidth / 2) / abs(ballVel.x);
    float endY = ballPos.y + ballVel.y * timeToCollision;
    if (endY >= Game.ballRadius && endY <= Game.HEIGHT - Game.ballRadius) return (int) endY;
    
    endY = constrain(endY, Game.ballRadius, Game.HEIGHT - Game.ballRadius);
    timeToCollision = (abs(ballPos.y - endY)) / abs(ballVel.y);
    float endX = ballPos.x + ballVel.x * timeToCollision;
    return expectedBallY(new PVector(ballVel.x, -ballVel.y), new PVector(endX, endY), playerX); 
  }
  
  @Override
  public void touchedBall() {
    reset();
  }
  
  public void reset() {
    expectedBallY = -1;
  }
}
