// Genetic algorithm

class GAPlayer extends Player {
  private static final int NUM_OF_INPUTS = 5;
  private static final int NUM_OF_HIDDEN = 5;
  private static final float ACTION_THRESHOLD = 0.5;
  
  private final NeuralNetwork brain;
  
  GAPlayer() {
    brain = new NeuralNetwork(NUM_OF_INPUTS, NUM_OF_HIDDEN, 1);
  }
  
  @Override
  public Action decide(GameState state, boolean isLeft) {
    if (isLeft) throw new RuntimeException("GAPlayer always has to be on the right");
    float[] inputs = {
      map(state.leftPosition.y, 0, height, 0, 1),
      map(state.rightPosition.y, 0, height, 0, 1),
      map(state.ballPosition.x, 0, width, 0, 1),
      map(state.ballPosition.y, 0, height, 0, 1), 
      map(state.ballVelocity.x, -Game.ballXVelocity-1, Game.ballXVelocity+1, 0, 1),
      map(state.ballVelocity.y, -Game.maxBallYVelocity-1, Game.maxBallYVelocity+1, 0, 1)
    };
    float output = brain.computeOutputs(inputs)[0];

    if (output > ACTION_THRESHOLD) return Action.GO_UP;
    if (output < -ACTION_THRESHOLD) return Action.GO_DOWN;
    return Action.DO_NOTHING;
  }
}
