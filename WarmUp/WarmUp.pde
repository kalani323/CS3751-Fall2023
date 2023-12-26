// cs3451 warmup assignment
// kalani dissanayake

void setup() {
  size(800, 800); //size = 800x800
}

void draw() {
  background(255); // set background to white
  float centerX = width / 2; //middle of screen (x position)
  float centerY = height / 2; //middle of screen (y position)
  float mainRadius = width / 4; // radius of main pentagon is 1/4 the size of the screens width
  drawPattern(centerX, centerY, mainRadius, 0, 5); // call the recursive function
}

void drawPattern(float x, float y, float radius, float rotationAngle, int levels) {
  // break recursion when level is 0
  if (levels == 0) {
    return; // base case --> stop recursion
  }
   
  float shrinkFactor = map(mouseY, height, 0, 0, 0.5); // amount of shrink is based on y position of cursor
  float shift = map(mouseX, 0, width, 0, 1); // amount of shift is based on x position of cursor
  
  float closestEdgeAngle = atan2(y - height / 2, x - width / 2);
  float offset = radius * (1 + shift);
  
  //set color based on level (for variation purposes) -- pink & purple
  noFill();
  fill(levels*50,levels*10, 60+levels*30);
  
  //draw initial pentagon
  drawPentagon(x, y, radius, closestEdgeAngle);

  float pentagonAngle = TWO_PI / 5; // angles in the pentagon
  float startingAngle = PI - pentagonAngle;

  // create surrounding smaller pentagons
  for (int i = 0; i < 5; i++) {
    float newX = x + cos(startingAngle + i * pentagonAngle) * offset;
    float newY = y + sin(startingAngle + i * pentagonAngle) * offset;
    drawPattern(newX, newY, radius * shrinkFactor, closestEdgeAngle, levels - 1);
  }
}

//helper method for creating pentagons based on given position, radius, and angle
void drawPentagon(float x, float y, float radius, float rotationAngle) {
  float angle = TWO_PI / 5;
  beginShape(); //creates shape
  for (int i = 0; i < 5; i++) {
    float px = x + cos(angle * i - HALF_PI + rotationAngle) * radius;
    float py = y + sin(angle * i - HALF_PI + rotationAngle) * radius;
    vertex(px, py);
  }
  endShape(CLOSE);
}
