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
}
