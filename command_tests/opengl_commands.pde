// KALANI DISSANAYAKE
// CS3451 FALL 2023 Project 1B 
// changed and built on Project 1A bc added Arraylist for better stack functionality
// Dummy routines for OpenGL commands.

// You should modify the routines below to complete the assignment.
// Feel free to define any classes, global variables, and helper routines that you need.

private ArrayList<float[][]> matrixStack;
private ArrayList<float[]> vertex;
private float[] modifier;

void Init_Matrix() {
  // Initialize ArrayList, then add 2D array for identity matrix
  matrixStack = new ArrayList<float[][]>();
  matrixStack.add(new float[][]{{1, 0, 0, 0},
            {0, 1, 0, 0}, 
            {0, 0, 1, 0}, 
            {0, 0, 0, 1}});
}

float[] vertexMultiply(float[][] matrix, float[] vertex) {
  // Multiply each row of the matrix with the elements of the vertex
  float[] res = new float[vertex.length];
  for (int i = 0; i < res.length; i++) {
    res[i] = (matrix[i][0] * vertex[0]) + (matrix[i][1] * vertex[1]) + (matrix[i][2] * vertex[2]) + (matrix[i][3]);
  }
  return res;
}

float[][] multiply(float[][] l, float[][] r) {
  float[][] res = new float[l.length][r[0].length];
  
  // Each entry is the product of the corresponding row of left and col of right
  for (int i = 0; i < res.length; i++) {
    for (int j = 0; j < res[0].length; j++) {
      res[i][j] = (l[i][0] * r[0][j]) + (l[i][1] * r[1][j]) + (l[i][2] * r[2][j]) + (l[i][3] * r[3][j]);
    }
  }
  return res;
}

void Push_Matrix() {
  // Copy the top entry, then add it
  float[][] stack = matrixStack.get(matrixStack.size() - 1);
  matrixStack.add(stack);
}

void Pop_Matrix() {
  // If the stack is empty, error; else, remove the top element
  if (matrixStack.size() == 1) {
    print("Error");
    return;
  }
  matrixStack.remove(matrixStack.size() - 1); 
}

void Translate(float x, float y, float z) {
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{1, 0, 0, x}, 
                      {0, 1, 0, y}, 
                      {0, 0, 1, z}, 
                      {0, 0, 0, 1}};
  matrixStack.set(matrixStack.size() - 1, multiply(matrixStack.get(matrixStack.size() - 1), matrix)); 
}

void Scale(float x, float y, float z) {
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{x, 0, 0, 0}, 
                      {0, y, 0, 0}, 
                      {0, 0, z, 0}, 
                      {0, 0, 0, 1}};
  matrixStack.set(matrixStack.size() - 1, multiply(matrixStack.get(matrixStack.size() - 1), matrix)); 
}

void RotateX(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{1, 0, 0, 0},
                    {0, cos(theta), -sin(theta), 0},
                    {0, sin(theta), cos(theta), 0}, 
                    {0, 0, 0, 1}};
  matrixStack.set(matrixStack.size() - 1, multiply(matrixStack.get(matrixStack.size() - 1), matrix)); 
}

void RotateY(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{cos(theta), 0, sin(theta), 0}, 
                    {0, 1, 0, 0}, 
                    {-sin(theta),0, cos(theta), 0},
                    {0, 0, 0, 1}};
  matrixStack.set(matrixStack.size() - 1, multiply(matrixStack.get(matrixStack.size() - 1), matrix)); 
}

void RotateZ(float theta) {
  theta = theta * PI / 180;
  // Create appropriate transformation matrix, then multiply top of stack by it
  float[][] matrix = {{cos(theta), -sin(theta), 0, 0}, 
                    {sin(theta), cos(theta), 0, 0}, 
                    {0, 0, 1, 0}, 
                    {0, 0, 0, 1}};
  matrixStack.set(matrixStack.size() - 1, multiply(matrixStack.get(matrixStack.size() - 1), matrix)); 
}

void Print_CTM() {
  float[][] obj = matrixStack.get(matrixStack.size() - 1);
  
   for (int i = 0; i < obj.length; i++) {
      for (int j = 0; j < obj[i].length; j++) {
          System.out.print(obj[i][j] + " ");
      }
      System.out.println();
  }
  System.out.println();
}

void Perspective(float fov, float near, float far) {
  // Set the modifier to the input parameters
  modifier = new float[]{fov * PI / 180, near, far};
}

void Ortho(float left, float right, float bottom, float top, float near, float far) {
  // Set the modifier to the input parameters
  modifier = new float[]{left, right, bottom, top, near, far};
}

void Begin_Shape() {
  // Initialize vertex list
  vertex = new ArrayList<float[]>();
}

void Vertex(float x, float y, float z) {
  // Add input to vertex list
  vertex.add(new float[]{x, y, z});
}

void End_Shape() {
  for (int i = 0; i < vertex.size() - 1; i+= 2) {
    // Get the next pair of vertices to connect
    float[] vertex1 = vertexMultiply(matrixStack.get(matrixStack.size() - 1), vertex.get(i));
    float[] vertex2 = vertexMultiply(matrixStack.get(matrixStack.size() - 1), vertex.get(i + 1));
    float x1, y1, x2, y2;
    if (modifier.length == 6) {
      // If the transformation is orthogonal, use the appropriate formula on each coordinate
      x1 = (vertex1[0] - modifier[0]) * width / (modifier[1] - modifier[0]);
      y1 = (vertex1[1] - modifier[2]) * height / (modifier[3] - modifier[2]);
      x2 = (vertex2[0] - modifier[0]) * width / (modifier[1] - modifier[0]);
      y2 = (vertex2[1] - modifier[2]) * height / (modifier[3] - modifier[2]);
    } else {
      // If the transformation is perspective, use the appropriate formula on each coordinate
      float k = tan(modifier[0] / 2);
      x1 = (vertex1[0] / abs(vertex1[2]) + k) * width / (2 * k);
      y1 = (vertex1[1] / abs(vertex1[2]) + k) * height / (2 * k);
      x2 = (vertex2[0] / abs(vertex2[2]) + k) * width / (2 * k);
      y2 = (vertex2[1] / abs(vertex2[2]) + k) * height / (2 * k);
    }
    line(x1, height - y1, x2, height - y2);
  }
}
