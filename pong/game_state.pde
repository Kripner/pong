class GameState {
   PVector leftPosition;
   PVector rightPosition;
   PVector ballPosition;
   PVector ballVelocity;
  
  GameState() {
    leftPosition = new PVector(Game.playerWidth / 2, Game.HEIGHT / 2);
    rightPosition = new PVector(Game.WIDTH - Game.playerWidth / 2, Game.HEIGHT / 2);
    reset();
  }
  
  public void reset() {
    ballPosition = new PVector(Game.WIDTH / 2, Game.HEIGHT / 2);
    ballVelocity = new PVector(-Game.minBallXVelocity, random(-Game.maxBallYVelocity, Game.maxBallYVelocity)); // in pixels per second
  }
}
