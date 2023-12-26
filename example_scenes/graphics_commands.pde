// KALANI DISSANAYAKE
// Dummy routines for drawing commands.
// These are for you to write.

point[] vertexStack = new point[3];
edge[] edgeGroup = new edge[3];
int numVert = 0;

float yMin;
float yMax;
float xMin;
float xMax;
float yMid;
float xMid;
float xLeft;
float xRight;
float dxRight;
float dxLeft;

color currColor = color(0,0,0);

int minIndex;
int maxIndex;
int midIndex;

boolean horiLine;

float currR;
float currG;
float currB;

public class point {
  float x;
  float y;
  float z;
  float r;
  float g;
  float b;
  
  public point (float x, float y, float z, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

public class edge {
  point topPoint;
  point bottomPoint;
  float dx;
  float dr;
  float dg;
  float db;
  
  public edge (point pointOne, point pointTwo) {
    if (pointOne.y > pointTwo.y) {
      topPoint = pointOne;
      bottomPoint = pointTwo;
    } else {
      topPoint = pointTwo;
      bottomPoint = pointOne;
    }
    dx = (topPoint.x - bottomPoint.x) / (topPoint.y - bottomPoint.y);
    dr = (topPoint.r - bottomPoint.r) / (topPoint.y - bottomPoint.y);
    dg = (topPoint.g - bottomPoint.g) / (topPoint.y - bottomPoint.y);
    db = (topPoint.b - bottomPoint.b) / (topPoint.y - bottomPoint.y);
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

void Set_Color (float r, float g, float b)
{
  currR = r;
  currG = g;
  currB = b;
  
}

void Vertex(float x, float y, float z) {
  vertexStack[numVert] = new point(x, y, z, currR, currG, currB);
  if (numVert == 1) {
    edgeGroup[0] = new edge(vertexStack[0], vertexStack[1]);
  } else if (numVert == 2) {
    edgeGroup[1] = new edge(vertexStack[1], vertexStack[2]);
    edgeGroup[2] = new edge(vertexStack[2], vertexStack[0]);
  }
  numVert++;
}

void Begin_Shape() {
  numVert = 0;
  yMin = 50000;
  yMax = 0;
  minIndex = 0;
  horiLine = false;
}

void End_Shape() {
  //Find yMin & yMax
  for (int i = 0; i < 3; i++) {
    if (vertexStack[i].y > yMax) {
      yMax = vertexStack[i].y;
    } 
    if (vertexStack[i].y < yMin) {
      yMin = vertexStack[i].y;
    }
  }

  
  //Find xLeft & xRight, dxLeft & dxRight


  
  //Draw
  for (int y = ceil(yMin); y < yMax; y++) {

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
    
    float changeR = (rightR - leftR) / changeNum;
    float changeG = (rightG - leftG) / changeNum;
    float changeB = (rightB - leftB) / changeNum;
    
    
    for (int x = ceil(leftX); x < rightX; x++) {
      set(x, height - y, color(currRed * 255.0, currGreen * 255.0, currBlue * 255.0));
      currRed += changeR;
      currBlue += changeB;
      currGreen += changeG;
    }
  }
  
  
}
