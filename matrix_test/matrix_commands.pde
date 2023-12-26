// CS3451 PROJECT 1A - Transformation Matrices
// Kalani Dissanayake

// Matrix Stack Library - You will write this!

// You should modify the routines below to complete the assignment.
// Feel free to define any classes, global variables, and helper routines that you need.
private float[][] matrix; //stack
private static final int MATRIX_SIZE = 4; //4x4 matrix
private int stackPointer; //pointer var
void Init_Matrix()
{
  matrix = new float[MATRIX_SIZE][MATRIX_SIZE];
  stackPointer = 0;
  for (int i = 0; i < MATRIX_SIZE; i++) {
      for (int j = 0; j < MATRIX_SIZE; j++) {
          if (i == j) {
              matrix[i][j] = 1; // diagonal elements are 1
          } else {
              matrix[i][j] = 0; // non-diagonal elements are 0
          }
      }
   }
}

void Push_Matrix()
{
  if (stackPointer < matrix.length - 1) {
        float[][] currentMatrix = matrix;
        float[][] newMatrix = new float[MATRIX_SIZE][MATRIX_SIZE];
  
        for (int i = 0; i < MATRIX_SIZE; i++) {
            for (int j = 0; j < MATRIX_SIZE; j++) {
              newMatrix[i][j] = currentMatrix[i][j];
            }
        }
  
        stackPointer++;
        matrix = newMatrix;
    }
}
void Pop_Matrix()
{
  if (stackPointer > 0) {
        stackPointer--;
  } else {
      System.out.println("Error: cannot pop the matrix stack"); //error thrown when nothing is on stack
  }
}

void Print_CTM()
{
  for (int i = 0; i < MATRIX_SIZE; i++) {
      for (int j = 0; j < MATRIX_SIZE; j++) {
          System.out.print(matrix[i][j] + " ");
      }
      System.out.println();
  }
  System.out.println();
}

void Translate(float x, float y, float z)
{
  float[][] translateMatrix = new float[][] {
      { 1, 0, 0, x },
      { 0, 1, 0, y },
      { 0, 0, 1, z },
      { 0, 0, 0, 1 }
  };
  multiplyMatrices(matrix, translateMatrix);
}

void Scale(float x, float y, float z)
{
  float[][] scaleMatrix = new float[][] {
      { x, 0, 0, 0 },
      { 0, y, 0, 0 },
      { 0, 0, z, 0 },
      { 0, 0, 0, 1 }
  };
  multiplyMatrices(matrix, scaleMatrix);
}

void RotateX(float theta)
{
  float angleRadians = (float)Math.toRadians(theta);
  float cosA = (float)Math.cos(angleRadians);
  float sinA = (float)Math.sin(angleRadians);

  float[][] rotateMatrixX = new float[][] {
      { 1, 0, 0, 0 },
      { 0, cosA, -sinA, 0 },
      { 0, sinA, cosA, 0 },
      { 0, 0, 0, 1 }
  };
  multiplyMatrices(matrix, rotateMatrixX);
}

void RotateY(float theta)
{
  float angleRadians = (float)Math.toRadians(theta);
  float cosA = (float)Math.cos(angleRadians);
  float sinA = (float)Math.sin(angleRadians);

  float[][] rotateMatrixY = new float[][] {
      { cosA, 0, sinA, 0 },
      { 0, 1, 0, 0 },
      { -sinA, 0, cosA, 0 },
      { 0, 0, 0, 1 }
  };
  multiplyMatrices(matrix, rotateMatrixY);
}

void RotateZ(float theta)
{
  float angleRadians = (float)Math.toRadians(theta);
  float cosA = (float)Math.cos(angleRadians);
  float sinA = (float)Math.sin(angleRadians);
  
  float[][] rotateMatrixZ = new float[][] {
        { cosA, -sinA, 0, 0 },
        { sinA, cosA, 0, 0 },
        { 0, 0, 1, 0 },
        { 0, 0, 0, 1 }
    };
    multiplyMatrices(matrix, rotateMatrixZ);
}

// multiply matrix helper method
private void multiplyMatrices(float[][] matA, float[][] matB) {
  float[][] result = new float[MATRIX_SIZE][MATRIX_SIZE];
  for (int i = 0; i < MATRIX_SIZE; i++) {
      for (int j = 0; j < MATRIX_SIZE; j++) {
          result[i][j] = 0;
          for (int k = 0; k < MATRIX_SIZE; k++) {
              result[i][j] += matA[i][k] * matB[k][j];
          }
      }
  }
  matrix = result;
}
