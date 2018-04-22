class AIPlayer extends Player {
  int expectedBallY = -1;
  
  @Override
  public Action decide(GameState state, boolean isLeft) {
    if (state.ballVelocity.x < 0) return Action.DO_NOTHING;
    if (expectedBallY == -1) expectedBallY = expectedBallY(state.ballVelocity, state.ballPosition, width - Game.playerWidth / 2);
    if (abs(state.rightPosition.y - expectedBallY) > 10)
      return state.rightPosition.y > expectedBallY ? Action.GO_UP : Action.GO_DOWN;
     return Action.DO_NOTHING;
  }
  
   int expectedBallY(PVector ballVel, PVector ballPos, int playerX) {
    float timeToCollision = (abs(playerX - ballPos.x) - Game.ballRadius - Game.playerWidth / 2) / abs(ballVel.x);
    float endY = ballPos.y + ballVel.y * timeToCollision;
    if (endY >= Game.ballRadius && endY <= height - Game.ballRadius) return (int) endY;
    
    endY = constrain(endY, Game.ballRadius, height - Game.ballRadius);
    timeToCollision = (abs(ballPos.y - endY)) / abs(ballVel.y);
    float endX = ballPos.x + ballVel.x * timeToCollision;
    return expectedBallY(new PVector(ballVel.x, -ballVel.y), new PVector(endX, endY), playerX); 
  }
  
  @Override
  public void touchedBall() {
    expectedBallY = -1;
  }
}
