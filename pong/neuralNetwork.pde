class NeuralNetwork {
  private static final float minStartValue = -1;
  private static final float maxStartValue = 1;
  
  private final Matrix weights1;
  private final Matrix weights2;
  
  public NeuralNetwork(int inputs, int hidden, int outputs) {
    weights1 = new Matrix(hidden, inputs, minStartValue, maxStartValue);
    weights2 = new Matrix(outputs, hidden, minStartValue, maxStartValue);
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
}
