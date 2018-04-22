class Game {
  static final int playerWidth = 10, playerHeight = 70;
  static final int ballRadius = 7;
  static final int maxPlayerVelocity = 200; // in pixels per second

  private final GameState state;
  private final Player leftPlayer;
  private final Player rightPlayer;
  private final boolean visual;
  
  private long lastFrameMillis = -1;
  
  Game(Player leftPlayer, Player rightPlayer, boolean visual) {
    state = new GameState();
    this.visual = visual;
    this.leftPlayer = leftPlayer;
    this.rightPlayer = rightPlayer;
  }
  
  void drawPlayer(PVector position) {
    rect(position.x - playerWidth / 2, position.y - playerHeight / 2, playerWidth, playerHeight);
  }
  
  boolean ballPlayerCollision(PVector ball, PVector player) {
    return (player.y + playerHeight / 2 > ball.y - ballRadius) && // ball is above the bottom end of player
       (player.y - playerHeight / 2 < ball.y + ballRadius) && // ball is below the top end of player
       (player.x + playerWidth / 2 > ball.x - ballRadius) && // ball is to the left from the right end of player
       (player.x - playerWidth / 2 < ball.x + ballRadius); // ball is to the r from the left end of player
  }
  
  void announce(String message) {
    print(message);
    textSize(32);
    fill(0, 102, 153);
    text(message, width / 2 - 75, height / 2);
  }
  
  void nextFrame() {
    if (lastFrameMillis == -1) {
      lastFrameMillis = millis();
      return;
    }
    if (visual) draw();
    
    PVector leftPosition = state.leftPosition, rightPosition = state.rightPosition;
    PVector ballPosition = state.ballPosition, ballVelocity = state.ballVelocity;
    
    long now = millis();
    double deltaT = (now - lastFrameMillis) / 1000D;
    lastFrameMillis = now;
    
    ballPosition.x += ballVelocity.x * deltaT;
    ballPosition.y += ballVelocity.y * deltaT;
    
    if (ballPosition.y - ballRadius < 0)
      ballVelocity.y = abs(ballVelocity.y);
    if (ballPosition.y + ballRadius > height)
      ballVelocity.y = -abs(ballVelocity.y);
    if (ballPlayerCollision(ballPosition, leftPosition)) {
      ballVelocity.x = abs(ballVelocity.x);
      leftPlayer.touchedBall();
    }
    if (ballPlayerCollision(ballPosition, rightPosition)) {
      ballVelocity.x = -abs(ballVelocity.x);
      rightPlayer.touchedBall();
    }
    if(ballPosition.x < 0) {
      leftPlayer.gameOver(false);
      rightPlayer.gameOver(true);
    }
    if(ballPosition.x > width) {
      leftPlayer.gameOver(true);
      rightPlayer.gameOver(false);
    }
    
    handleAction(leftPlayer, true, leftPosition, deltaT);
    handleAction(rightPlayer, false, rightPosition, deltaT);
  }
  
  private void handleAction(Player player, boolean isLeft, PVector playerPosition, double deltaT) {
    Action action = player.decide(state, isLeft);
    double deltaY = deltaT * maxPlayerVelocity;
    if (action == Action.GO_UP)
      playerPosition.y -= deltaY;
    else if (action == Action.GO_DOWN)
      playerPosition.y += deltaY;
    playerPosition.y = constrain(playerPosition.y, playerHeight / 2, height - playerHeight / 2);
  }
  
  private void draw() {
    background(255);
    fill(0);
    
    drawPlayer(state.leftPosition);
    drawPlayer(state.rightPosition);
    ellipse(state.ballPosition.x, state.ballPosition.y, ballRadius * 2, ballRadius * 2);
  }
}
