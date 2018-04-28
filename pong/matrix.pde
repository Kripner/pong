class Matrix {
  private final float[][] data;
  
  public Matrix(int rows, int columns, float minValue, float maxValue) {
    data = new float[rows][];
    for (int row = 0; row < rows; ++row) {
      data[row] = new float[columns];
      for (int column = 0; column < columns; ++column) {
        data[row][column] = random(minValue, maxValue);
      }
    }
  }
  
  private Matrix(float[][] data) {
    this.data = data;
  }
  
  public float[] timesVector(float[] vector) {
    float[] result = new float[height()];
    for (int row = 0; row < height(); ++row) {
      float sum = 0;
      for (int column = 0; column < width(); ++column)
        sum += data[row][column] * vector[column];
      result[row] = sum;
    }
    return result;
  }
  
  public int height() {
    return data.length;
  }
  
  public int width() {
    return data[0].length;
  }
  
  public Matrix crossover(Matrix another) {
    assert another.height() == height() && another.width() == width();
    int middleRow = (int) random(height());
    float[][] newMatrix = new float[height()][];
    for (int row = 0; row < height(); ++row) {
      if (row < middleRow) newMatrix[row] = data[row];
      else newMatrix[row] = another.data[row];
    }
    return new Matrix(newMatrix);
  }
  
  public void mutate(float prob) {
    for (int row = 0; row < height(); ++row) {
      for (int column = 0; column < width(); ++column) {
        if (random(1) < prob)
          data[row][column] += randomGaussian() * data[row][column] * 0.1;
      }
    }
  }
}
