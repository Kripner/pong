class Game {
  static final int WIDTH = 750;
  static final int HEIGHT = 300;
  
  static final int playerWidth = 10, playerHeight = 70;
  static final int ballRadius = 7;
  static final int maxBallYVelocity = 100;
  static final int minBallXVelocity = 300;
  static final int maxPlayerVelocity = 200; // in pixels per second
  private static final float defaultAcceleration = 1.001;

  private final GameState state;
  private final Player leftPlayer;
  private final Player rightPlayer;
  private final boolean visual;
  private final float ballAcceleration;
  
  private long lastFrameMillis = -1;
  private int leftScore = 0;
  private int rightScore = 0;
  private double time = 0; // how long the game lasted so far (in millis)
  
  Game(Player leftPlayer, Player rightPlayer, boolean visual, float ballAcceleration) {
    state = new GameState();
    this.visual = visual;
    this.leftPlayer = leftPlayer;
    this.rightPlayer = rightPlayer;
    this.ballAcceleration = ballAcceleration;
  }
  
  Game(Player leftPlayer, Player rightPlayer, boolean visual) {
    this(leftPlayer, rightPlayer, visual, defaultAcceleration);
  }
  
  void drawPlayer(PVector position) {
    rect(position.x - playerWidth / 2, position.y - playerHeight / 2, playerWidth, playerHeight);
  }
  
  void handleBallPlayerCollision(Player player, PVector playerPos, boolean isLeft) {
    PVector ball = state.ballPosition, ballVelocity = state.ballVelocity;
    if (!((playerPos.y + playerHeight / 2 > ball.y - ballRadius) && // ball is above the bottom end of player
       (playerPos.y - playerHeight / 2 < ball.y + ballRadius) && // ball is below the top end of player
       (playerPos.x + playerWidth / 2 > ball.x - ballRadius) && // ball is to the left from the right end of player
       (playerPos.x - playerWidth / 2 < ball.x + ballRadius))) return; // ball is to the r from the left end of player
    ballVelocity.x = abs(ballVelocity.x) * (isLeft ? 1 : -1);
    ballVelocity.y = map(ball.y - playerPos.y, -playerHeight / 2, playerHeight / 2, -maxBallYVelocity, maxBallYVelocity);
    
    
    player.touchedBall();
  }
  
  //void announce(String message) {
  //  print(message);
  //  textSize(32);
  //  fill(0, 102, 153);
  //  text(message, width / 2 - 75, height / 2);
  //}
  
  boolean nextFrame() {
    if (lastFrameMillis == -1) {
      lastFrameMillis = millis();
      return false;
    }
    long now = millis();
    double deltaT = (now - lastFrameMillis) / 1000D;
    lastFrameMillis = now;
    
    return nextFrame(deltaT);
  }
  
  private boolean nextFrame(double deltaT) {
    if (visual) draw();
    
    PVector leftPosition = state.leftPosition, rightPosition = state.rightPosition;
    PVector ballPosition = state.ballPosition, ballVelocity = state.ballVelocity;
    
    time += deltaT;
    
    ballVelocity.x *= ballAcceleration;
    ballPosition.x += ballVelocity.x * deltaT;
    ballPosition.y += ballVelocity.y * deltaT;
    
    if (ballPosition.y - ballRadius < 0)
      ballVelocity.y = abs(ballVelocity.y);
    if (ballPosition.y + ballRadius > Game.HEIGHT)
      ballVelocity.y = -abs(ballVelocity.y);
    handleBallPlayerCollision(leftPlayer, leftPosition, true);
    handleBallPlayerCollision(rightPlayer, rightPosition, false);
    
    if(ballPosition.x < 0) {
      leftPlayer.gameOver(false);
      rightPlayer.gameOver(true);
      rightScore += 1;
      return true;
    }
    if(ballPosition.x > Game.WIDTH) {
      leftPlayer.gameOver(true);
      rightPlayer.gameOver(false);
      leftScore += 1;
      return true;
    }
    
    handleAction(leftPlayer, true, leftPosition, deltaT);
    handleAction(rightPlayer, false, rightPosition, deltaT);
    return false;
  }
  
  private void handleAction(Player player, boolean isLeft, PVector playerPosition, double deltaT) {
    Action action = player.decide(state, isLeft);
    double deltaY = deltaT * maxPlayerVelocity;
    if (action == Action.GO_UP)
      playerPosition.y -= deltaY;
    else if (action == Action.GO_DOWN)
      playerPosition.y += deltaY;
    playerPosition.y = constrain(playerPosition.y, playerHeight / 2, Game.HEIGHT - playerHeight / 2);
  }
  
  private void draw() {
    background(0);
    fill(255);
    
    drawPlayer(state.leftPosition);
    drawPlayer(state.rightPosition);
    ellipse(state.ballPosition.x, state.ballPosition.y, ballRadius * 2, ballRadius * 2);
    
    textSize(24);
    text(String.valueOf(leftScore), 20, 40);
    text(String.valueOf(rightScore), Game.WIDTH - 40, 40);
  }
  
  void playToEnd(double frequency) {
    while(!nextFrame(1D/frequency))
      ;
  }
  
  double getTime() {
    return time;
  }
  
  void reset() {
    state.reset();
  }
}
