// Genetic algorithm

class GAPlayer extends Player {
  private static final int NUM_OF_INPUTS = 5;
  private static final int NUM_OF_HIDDEN = 5;
  private static final float ACTION_THRESHOLD = 0.5;
  
  
  private final NeuralNetwork brain;
  private Boolean won;
  
  GAPlayer() {
    this(new NeuralNetwork(NUM_OF_INPUTS, NUM_OF_HIDDEN, 1));
  }
  
  private GAPlayer(NeuralNetwork brain) {
    this.brain = brain;
  }
  
  @Override
  public Action decide(GameState state, boolean isLeft) {
    if (isLeft) throw new RuntimeException("GAPlayer always has to be on the right");
    float[] inputs = {
      map(state.leftPosition.y, 0, Game.HEIGHT, 0, 1),
      map(state.rightPosition.y, 0, Game.HEIGHT, 0, 1),
      map(state.ballPosition.x, 0, Game.WIDTH, 0, 1),
      map(state.ballPosition.y, 0, Game.HEIGHT, 0, 1), 
      // ball's x velocity grows because of acceleration - multiply bounds by arbitrary number
      // to keep the result small
      map(state.ballVelocity.x, -Game.minBallXVelocity * 3, Game.minBallXVelocity * 3, 0, 1),
      map(state.ballVelocity.y, -Game.maxBallYVelocity-1, Game.maxBallYVelocity+1, 0, 1)
    };
    float output = brain.computeOutputs(inputs)[0];

    if (output > ACTION_THRESHOLD) return Action.GO_UP;
    if (output < -ACTION_THRESHOLD) return Action.GO_DOWN;
    return Action.DO_NOTHING;
  }
  
  @Override
  public void gameOver(boolean won) {
    this.won = won;
  }
  
  public Boolean didWin() {
    return won;
  }
  
  public GAPlayer crossover(GAPlayer another) {
    return new GAPlayer(brain.crossover(another.brain));
  }
  
  public void mutate(float prob) {
    brain.mutate(prob);
  }
}
