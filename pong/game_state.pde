class GameState {
   PVector leftPosition;
   PVector rightPosition;
   PVector ballPosition;
   PVector ballVelocity;
  
  GameState() {
    leftPosition = new PVector(Game.playerWidth / 2, height / 2);
    rightPosition = new PVector(width - Game.playerWidth / 2, height / 2);
    ballPosition = new PVector(width / 2, height / 2);
    ballVelocity = new PVector(-300, 60); // in pixels per second
  }
}
