// PROJECT 3B -- SHADING AND Z-BUFFER
// KALANI DISSANAYAKE
// Routines for graphics commands (especially for shading and z-buffer).
// Most of these are for you to write.

// --------------- LOCAL VARIABLES
public enum Shading { WIREFRAME, CONSTANT, FLAT, GOURAUD, PHONG }
Shading shade = Shading.CONSTANT;  // the current shading mode

PMatrix3D cmat;
PMatrix3D adj;

float field_of_view = 0.0;  // non-zero value indicates perspective projection

point[] vertStack = new point[3];
edge[] edgeGroup = new edge[3];
float[][] zBuffer = new float[500][500];
int numVert;
PVector nVect1, nVect2, nVect3, lVect;

float minY;
float maxY;
float minX;
float maxX;
float midY;
float midX;
float leftX;
float rightX;
float rightdx;
float leftdx;
color currColor = color(0,0,0);
int mini;
int maxi;
int midi;
boolean horiLine;
float currR;
float currG;
float currB;
float normal_x;
float normal_y;
float normal_z;
float lx;
float ly;
float lz;
float lr;
float lg;
float lb;
float ambR;
float ambG;
float ambB;
float sR;
float sG;
float sB;
float power;
// --------------- POINT CLASS
public class point {
  float x;
  float y;
  float z;
  float r;
  float g;
  float b;
  float nx;
  float ny;
  float nz;
  float ambR;
  float ambG;
  float ambB;
  float sR;
  float sG;
  float sB;
  float power;

  public point (float x, float y, float z, float r, float g, float b, float nx, float ny, float nz, float ambR, float ambG, float ambB, float sR, float sG, float sB, float power) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
    this.g = g;
    this.b = b;
    this.nx = nx;
    this.ny = ny;
    this.nz = nz;
    this.ambR = ambR;
    this.ambG = ambG;
    this.ambB = ambB;
    this.sR = sR;
    this.sG = sG;
    this.sB = sB;
    this.power = power;
  }
}
// --------------- EDGE CLASS
public class edge {
  point topPoint;
  point bottomPoint;
  float dx;
  float dz;
  float dr;
  float dg;
  float db;
  float dnx;
  float dny;
  float dnz;
  
  public edge (point pointOne, point pointTwo) {
    if (pointOne.y > pointTwo.y) {
      topPoint = pointOne;
      bottomPoint = pointTwo;
    } else {
      topPoint = pointTwo;
      bottomPoint = pointOne;
    }
    dx = (topPoint.x - bottomPoint.x) / (topPoint.y - bottomPoint.y);
    dz = (topPoint.z - bottomPoint.z) / (topPoint.y - bottomPoint.y);
    dr = (topPoint.r - bottomPoint.r) / (topPoint.y - bottomPoint.y);
    dg = (topPoint.g - bottomPoint.g) / (topPoint.y - bottomPoint.y);
    db = (topPoint.b - bottomPoint.b) / (topPoint.y - bottomPoint.y);
    dnx = (topPoint.nx - bottomPoint.nx) / (topPoint.y - bottomPoint.y);
    dny = (topPoint.ny - bottomPoint.ny) / (topPoint.y - bottomPoint.y);
    dnz = (topPoint.nz - bottomPoint.nz) / (topPoint.y - bottomPoint.y);
  }
  
  boolean intersection(int y) {
    if (topPoint.y == bottomPoint.y) {
      return false;
    }
    
    return bottomPoint.y <= y && topPoint.y >= y;
  }
  
  float xAtHeight(int y) {
    return bottomPoint.x + ((float)y - bottomPoint.y) * dx;
  }
  
  float zAtHeight(int y) {
    return bottomPoint.z + ((float)y - bottomPoint.y) * dz;
  }
  
  float nxAtHeight(int y) {
    return bottomPoint.nx + ((float)y - bottomPoint.y) * dnx;
  }
  
  float nyAtHeight(int y) {
    return bottomPoint.ny + ((float)y - bottomPoint.y) * dny;
  }
  
  float nzAtHeight(int y) {
    return bottomPoint.nz + ((float)y - bottomPoint.y) * dnz;
  }
  
  float rAtHeight(int y) {
    return bottomPoint.r + ((float)y - bottomPoint.y) * dr;
  }
  
  float gAtHeight(int y) {
    return bottomPoint.g + ((float)y - bottomPoint.y) * dg;
  }
  
  float bAtHeight(int y) {
    return bottomPoint.b + ((float)y - bottomPoint.y) * db;
  }
}

// --------------- METHODS --------------------
// you should initialize your z-buffer here, and also various material color parameters
void Init_Scene() {
  
  // create the current transformation matrix, and its adjoint for transforming the normals
  cmat = new PMatrix3D();
  cmat.reset();             // sets the current transformation to the identity
    
  // calculate the adjoint of the transformation matrix
  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
  
  // initialize your z-buffer here
  for (int i = 0; i < 500; i++) {
    for (int j = 0; j < 500; j++) {
      zBuffer[i][j] = -5000;
    }
  }
  
  // set default values to material colors here
  ambR = 0;
  ambG = 0;
  ambB = 0;
  sR = 0;
  sG = 0;
  sB = 0;
  power = 0;
}

void Set_Field_Of_View (float fov)
{
  field_of_view = fov;
}

void Set_Color (float r, float g, float b)
{
  currR = r;
  currG = g;
  currB = b;
}

void Ambient_Specular (float ar, float ag, float ab, float sr, float sg, float sb, float pow)
{
  ambR = ar;
  ambG = ag;
  ambB = ab;
  sR = sr;
  sG = sg;
  sB = sb;
  power = pow;
}

void Normal(float nx, float ny, float nz)
{
  normal_x = nx;
  normal_y = ny;
  normal_z = nz;
}

void Set_Light (float x, float y, float z, float r, float g, float b)
{
  // set light value here
  lx = x;
  ly = y;
  lz = z;
  lr = r;
  lg = g;
  lb = b;
  // don't forget to normaize the direction of the light vector
}

void Begin_Shape() {
  numVert = 0;
  minY = 50000;
  maxY = 0;
  mini = 0;
  horiLine = false;
  
}

// some of this code is provided, but you should save the resulting projected coordinates
// and surface normals in your own data structures for vertices
void Vertex(float vx, float vy, float vz) {
  float x,y,z;
  // transform this vertex by the current transformation matrix
  x = vx * cmat.m00 + vy * cmat.m01 + vz * cmat.m02 + cmat.m03;
  y = vx * cmat.m10 + vy * cmat.m11 + vz * cmat.m12 + cmat.m13;
  z = vx * cmat.m20 + vy * cmat.m21 + vz * cmat.m22 + cmat.m23;
  // calculate the transformed surface normal (using the adjoint)
  // note that you need to provide normal_x, normal_y and normal_z set from the Normal() command
  float nx,ny,nz;
  nx = normal_x * adj.m00 + normal_y * adj.m01 + normal_z * adj.m02 + adj.m03;
  ny = normal_x * adj.m10 + normal_y * adj.m11 + normal_z * adj.m12 + adj.m13;
  nz = normal_x * adj.m20 + normal_y * adj.m21 + normal_z * adj.m22 + adj.m23;
  float xx = x;
  float yy = y;
  float zz = z;
  // field of view greater than zero means use perspective projection
  if (field_of_view > 0) {
    float theta = field_of_view * PI / 180.0;  // convert to radians
    float k = tan (theta / 2);
    xx = x / abs(z);
    yy = y / abs(z);
    xx = (xx + k) * width  / (2 * k);
    yy = (yy + k) * height / (2 * k);
    zz = z;
  }
  // xx,yy,zz are screen space coordinates of the vertex, after transformation and projection
  // !!!! store xx,yy,zz and nx,ny,nz somewhere for you to use for rasterization and shading !!!!
  vertStack[numVert] = new point(xx, yy, zz, currR, currG, currB, nx, ny, nz, ambR, ambG, ambB, sR, sG, sB, power);
  if (numVert == 1) {
    edgeGroup[0] = new edge(vertStack[0], vertStack[1]);
  } else if (numVert == 2) {
    edgeGroup[1] = new edge(vertStack[1], vertStack[2]);
    edgeGroup[2] = new edge(vertStack[2], vertStack[0]);
  }
  numVert++;
}

// rasterize a triangle
void End_Shape() {
  // -------- WIREFRAME
  // make wireframe (line) drawing if that is the current shading mode
  if (shade == Shading.WIREFRAME) {
    stroke (0, 0, 0);
    strokeWeight (2.0);
    // draw lines between your stored vertices (adjust to your data structures)
    line (vertStack[0].x, height - vertStack[0].y, vertStack[1].x, height - vertStack[1].y);
    line (vertStack[0].x, height - vertStack[0].y, vertStack[2].x, height - vertStack[2].y);
    line (vertStack[1].x, height - vertStack[1].y, vertStack[2].x, height - vertStack[2].y);
    return;
  }
  if (shade == Shading.CONSTANT) {
    // -------- CONSTANT

  } else if (shade == Shading.FLAT) {
    // -------- FLAT
    nVect1 = new PVector(vertStack[0].nx, vertStack[0].ny, vertStack[0].nz);
    lVect = new PVector(lx, ly, lz);
    nVect1.normalize();
    lVect.normalize();
    vertStack[0].r *= nVect1.dot(lVect);
    vertStack[0].g *= nVect1.dot(lVect);
    vertStack[0].b *= nVect1.dot(lVect);
    vertStack[1].r *= nVect1.dot(lVect);
    vertStack[1].g *= nVect1.dot(lVect);
    vertStack[1].b *= nVect1.dot(lVect);
    vertStack[2].r *= nVect1.dot(lVect);
    vertStack[2].g *= nVect1.dot(lVect);
    vertStack[2].b *= nVect1.dot(lVect);
    
  } else if (shade == Shading.GOURAUD) {
    // -------- GOURAUD
    nVect1 = new PVector(vertStack[0].nx, vertStack[0].ny, vertStack[0].nz);
    nVect2 = new PVector(vertStack[1].nx, vertStack[1].ny, vertStack[1].nz);
    nVect3 = new PVector(vertStack[2].nx, vertStack[2].ny, vertStack[2].nz);
    lVect = new PVector(lx, ly, lz);
    nVect1.normalize();
    nVect2.normalize();
    nVect3.normalize();
    lVect.normalize();
    PVector halfA = new PVector(lx / 2, ly / 2, (lz + 1) / 2);
    vertStack[0].r = vertStack[0].r * (ambR + lr * nVect1.dot(lVect)) + lr * sR * (float)Math.pow(halfA.dot(nVect1), vertStack[0].power);
    vertStack[0].g = vertStack[0].g * (ambG + lg * nVect1.dot(lVect)) + lg * sG * (float)Math.pow(halfA.dot(nVect1), vertStack[0].power);
    vertStack[0].b = vertStack[0].b * (ambB + lb * nVect1.dot(lVect)) + lb * sB * (float)Math.pow(halfA.dot(nVect1), vertStack[0].power);
    vertStack[1].r = vertStack[1].r * (ambR + lr * nVect2.dot(lVect)) + lr * sR * (float)Math.pow(halfA.dot(nVect2), vertStack[1].power);
    vertStack[1].g = vertStack[1].g * (ambG + lg * nVect2.dot(lVect)) + lg * sG * (float)Math.pow(halfA.dot(nVect2), vertStack[1].power);
    vertStack[1].b = vertStack[1].b * (ambB + lb * nVect2.dot(lVect)) + lb * sB * (float)Math.pow(halfA.dot(nVect2), vertStack[1].power);
    vertStack[2].r = vertStack[2].r * (ambR + lr * nVect3.dot(lVect)) + lr * sR * (float)Math.pow(halfA.dot(nVect3), vertStack[2].power);
    vertStack[2].g = vertStack[2].g * (ambG + lg * nVect3.dot(lVect)) + lg * sG * (float)Math.pow(halfA.dot(nVect3), vertStack[2].power);
    vertStack[2].b = vertStack[2].b * (ambB + lb * nVect3.dot(lVect)) + lb * sB * (float)Math.pow(halfA.dot(nVect3), vertStack[2].power);
    
  } else if (shade == Shading.PHONG) {
    // -------- PHONG
    lVect = new PVector(lx, ly, lz);
    lVect.normalize();
    specialRast();
    return;
  }
  // this is where you should add your rasterization code from Project 3A
  rasterize();

}

void rasterize() {
  //Find minY & maxY
  for (int i = 0; i < 3; i++) {
    if (vertStack[i].y > maxY) {
      maxY = vertStack[i].y;
    } 
    if (vertStack[i].y < minY) {
      minY = vertStack[i].y;
    }
  }
  for (int y = ceil(minY); y < maxY; y++) {
    edge leftEdge = null;
    edge rightEdge = null;
    if (edgeGroup[0].intersection(y)) {
      leftEdge = edgeGroup[0];
      rightEdge = edgeGroup[0];
    }
    if (edgeGroup[1].intersection(y)) {
      if (leftEdge == null || leftEdge.xAtHeight(y) > edgeGroup[1].xAtHeight(y)) {
        leftEdge = edgeGroup[1];
      }
      if (rightEdge == null || rightEdge.xAtHeight(y) < edgeGroup[1].xAtHeight(y)) {
        rightEdge = edgeGroup[1];
      }
    }
    if (edgeGroup[2].intersection(y)) {
      if (leftEdge == null || leftEdge.xAtHeight(y) > edgeGroup[2].xAtHeight(y)) {
        leftEdge = edgeGroup[2];
      }
      if (rightEdge == null || rightEdge.xAtHeight(y) < edgeGroup[2].xAtHeight(y)) {
        rightEdge = edgeGroup[2];
      }
    }
    if (leftEdge == null || rightEdge == null) {
      continue;
    }
    float leftX = leftEdge.xAtHeight(y);
    float rightX = rightEdge.xAtHeight(y);
    
    float leftZ = leftEdge.zAtHeight(y);
    float rightZ = rightEdge.zAtHeight(y);
    
    float leftR = leftEdge.rAtHeight(y);
    float rightR = rightEdge.rAtHeight(y);
    
    float leftG = leftEdge.gAtHeight(y);
    float rightG = rightEdge.gAtHeight(y);
    
    float leftB = leftEdge.bAtHeight(y);
    float rightB = rightEdge.bAtHeight(y);
    
    float changeNum = ((int)Math.floor(rightX) - (int)Math.ceil(leftX) + 1);
    
    float currRed = leftR;
    float currGreen = leftG;
    float currBlue = leftB;
    float currZ = leftZ;
    
    float changeR = (rightR - leftR) / changeNum;
    float changeG = (rightG - leftG) / changeNum;
    float changeB = (rightB - leftB) / changeNum;
    float changeZ = (rightZ - leftZ) / changeNum;
    

    

    
    for (int x = ceil(leftX); x < rightX; x++) {
      if (currZ > zBuffer[x][y]) {
        set(x, height - y, color(currRed * 255.0, currGreen * 255.0, currBlue * 255.0));
        currRed += changeR;
        currBlue += changeB;
        currGreen += changeG;
        currZ += changeZ;
        zBuffer[x][y] = currZ;
      } 
      
    }
  }
}

void specialRast() {
  //Find minY & maxY
  for (int i = 0; i < 3; i++) {
    if (vertStack[i].y > maxY) {
      maxY = vertStack[i].y;
    } 
    if (vertStack[i].y < minY) {
      minY = vertStack[i].y;
    }
  }
  
  for (int y = ceil(minY); y < maxY; y++) {

    edge leftEdge = null;
    edge rightEdge = null;
    
    if (edgeGroup[0].intersection(y)) {
      leftEdge = edgeGroup[0];
      rightEdge = edgeGroup[0];
    }
    
    if (edgeGroup[1].intersection(y)) {
      if (leftEdge == null || leftEdge.xAtHeight(y) > edgeGroup[1].xAtHeight(y)) {
        leftEdge = edgeGroup[1];
      }
      if (rightEdge == null || rightEdge.xAtHeight(y) < edgeGroup[1].xAtHeight(y)) {
        rightEdge = edgeGroup[1];
      }
    }
    
    if (edgeGroup[2].intersection(y)) {
      if (leftEdge == null || leftEdge.xAtHeight(y) > edgeGroup[2].xAtHeight(y)) {
        leftEdge = edgeGroup[2];
      }
      if (rightEdge == null || rightEdge.xAtHeight(y) < edgeGroup[2].xAtHeight(y)) {
        rightEdge = edgeGroup[2];
      }
    }
    
    if (leftEdge == null || rightEdge == null) {
      continue;
    }
    
    float leftX = leftEdge.xAtHeight(y);
    float rightX = rightEdge.xAtHeight(y);
    
    float leftZ = leftEdge.zAtHeight(y);
    float rightZ = rightEdge.zAtHeight(y);
    
    float leftR = leftEdge.rAtHeight(y);
    float rightR = rightEdge.rAtHeight(y);
    
    float leftG = leftEdge.gAtHeight(y);
    float rightG = rightEdge.gAtHeight(y);
    
    float leftB = leftEdge.bAtHeight(y);
    float rightB = rightEdge.bAtHeight(y);
    
    float leftNX = leftEdge.nxAtHeight(y);
    float leftNY = leftEdge.nyAtHeight(y);
    float leftNZ = leftEdge.nzAtHeight(y);
    float rightNX = rightEdge.nxAtHeight(y);
    float rightNY = rightEdge.nyAtHeight(y);
    float rightNZ = rightEdge.nzAtHeight(y);
    float changeNum = ((int)Math.floor(rightX) - (int)Math.ceil(leftX) + 1);
    float currRed = leftR;
    float currGreen = leftG;
    float currBlue = leftB;
    float currZ = leftZ;
    float currNX = leftNX;
    float currNY = leftNY;
    float currNZ = leftNZ;
    float changeR = (rightR - leftR) / changeNum;
    float changeG = (rightG - leftG) / changeNum;
    float changeB = (rightB - leftB) / changeNum;
    float changeZ = (rightZ - leftZ) / changeNum;
    float changeNX = (rightNX - leftNX) / changeNum;
    float changeNY = (rightNY - leftNY) / changeNum;
    float changeNZ = (rightNZ - leftNZ) / changeNum;
    for (int x = ceil(leftX); x < rightX; x++) {
      float r;
      float g;
      float b;
      if (currZ > zBuffer[x][y]) {
        PVector halfA = new PVector(lx / 2, ly / 2, (lz + 1) / 2);
        PVector normalBoi = new PVector(currNX, currNY, currNZ);
        normalBoi.normalize();
    
        r = currRed * (ambR + lr * normalBoi.dot(lVect)) + lr * sR * (float)Math.pow(halfA.dot(normalBoi), power);
        g = currGreen * (ambG + lg * normalBoi.dot(lVect)) + lg * sG * (float)Math.pow(halfA.dot(normalBoi), power);
        b = currBlue * (ambB + lb * normalBoi.dot(lVect)) + lb * sB * (float)Math.pow(halfA.dot(normalBoi), power);
        
        set(x, height - y, color(r * 255.0, g * 255.0, b * 255.0));
        
        zBuffer[x][y] = currZ;
      } 
      currRed += changeR;
      currBlue += changeB;
      currGreen += changeG;
      currZ += changeZ;
      currNX += changeNX;
      currNY += changeNY;
      currNZ += changeNZ;
    }
  }
}

// set the current transformation matrix and its adjoint
void Set_Matrix (
float m00, float m01, float m02, float m03,
float m10, float m11, float m12, float m13,
float m20, float m21, float m22, float m23,
float m30, float m31, float m32, float m33)
{
  cmat.set (m00, m01, m02, m03, m10, m11, m12, m13,
            m20, m21, m22, m23, m30, m31, m32, m33);

  // calculate the adjoint of the transformation matrix
  PMatrix3D imat = cmat.get(); 
  boolean okay = imat.invert();
  if (!okay) {
    println ("matrix singular, cannot invert");
    exit();
  }
  adj = imat.get();
  adj.transpose();
}
