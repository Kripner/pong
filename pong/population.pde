class Population {
  private static final float MATING_POOL_PORTION = 0.5;
  private static final float MUTATION_PROB = 0.01;
  private static final float TRAIN_ENVIRONMENT_FREQUENCY = 30;
  
  private GAPlayer[] agents;
  private GAPlayer best;
  private float bestFitness = -1;
  private final AIPlayer oponent;
  
  public Population(int size) {
    agents = new GAPlayer[size];
    for (int i = 0; i < agents.length; ++i)
      agents[i] = new GAPlayer();
    oponent = new AIPlayer();
  }
  
  public void train(int iterations) {
    double fitnessSum = 0;
    for (int i = 0; i < iterations; ++i)
      fitnessSum += doIteration();
    println("Average fitness: " + (fitnessSum / iterations));
    println("Best so far: " + bestFitness);
  }
  
  private double doIteration() {
    float[] fitnessValues = new float[agents.length];
    float fitnessSum = 0;
    for (int i = 0; i < agents.length; ++i) {
      fitnessValues[i] = getFitness(agents[i]);
      fitnessSum += fitnessValues[i];
      if (fitnessValues[i] > bestFitness) {
        best = agents[i];
        bestFitness = fitnessValues[i];
      }
    }
    float averageFitness = fitnessSum / agents.length;
    
    GAPlayer[] matingPool = getMatingPool(fitnessValues, fitnessSum);
    for (int i = 0; i < agents.length; ++i) {
      GAPlayer parentA = matingPool[(int) (random(matingPool.length))];
      GAPlayer parentB = matingPool[(int) (random(matingPool.length))];
      GAPlayer child = parentA.crossover(parentB);
      child.mutate(MUTATION_PROB);
      agents[i] = child;
    }
    
    return averageFitness;
  }
  
  private GAPlayer[] getMatingPool(float[] fitnessValues, float fitnessSum) {
    GAPlayer[] matingPool = new GAPlayer[(int) (agents.length * MATING_POOL_PORTION)];
    int matingPoolIndex = 0;
    while (matingPoolIndex < matingPool.length) {
      for (int i = 0; i < agents.length; ++i) {
        float pickProb = fitnessValues[i] / fitnessSum * MATING_POOL_PORTION;
        if (random(1) <= pickProb) {
          matingPool[matingPoolIndex++] = agents[i];
          if (matingPoolIndex >= matingPool.length) break;
        }
      }
    }
    return matingPool;
  }
  
  private float getFitness(GAPlayer player) {
    oponent.reset();
    Game game = new Game(oponent, player, false);
    game.playToEnd(TRAIN_ENVIRONMENT_FREQUENCY);
    //float fitness = player.didWin() ? Float.POSITIVE_INFINITY : (float) game.getTime();
    float fitness = (float) game.getTime();
    return fitness;
  }
  
  public GAPlayer getBest() {
    return best;
  }
}
