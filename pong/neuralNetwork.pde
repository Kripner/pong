class NeuralNetwork {
  private static final float minStartValue = -1;
  private static final float maxStartValue = 1;
  
  final Matrix weights1;
  final Matrix weights2;
  
  public NeuralNetwork(int inputs, int hidden, int outputs) {
    this(new Matrix(hidden, inputs, minStartValue, maxStartValue), 
         new Matrix(outputs, hidden, minStartValue, maxStartValue));
  }
  
  private NeuralNetwork(Matrix weights1, Matrix weights2) {
    this.weights1 = weights1;
    this.weights2 = weights2;
  }
  
  public float[] computeOutputs(float[] inputs) {
    float[] z1 = weights1.timesVector(inputs);
    activation(z1);
    float[] outputs = weights2.timesVector(z1);
    return outputs;
  }
  
  private void activation(float[] z) {
    for (int i = 0; i < z.length; ++i) {
      z[i] = max(0.01 * z[i], z[i]); // ReLU
    }
  }
  
  public NeuralNetwork crossover(NeuralNetwork another) {
    return new NeuralNetwork(weights1.crossover(another.weights1), weights2.crossover(another.weights2));
  }
  
  public void mutate(float prob) {
    weights1.mutate(prob);
    weights2.mutate(prob);
  }
}
