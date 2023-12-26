// Kalani Dissanayake
// Project 2A - Object Modeling
// Attempt at buzz-like character (i tried)
float time = 0;  // keep track of the passing of time

void setup() {
  size(800, 800, P3D);  // must use 3D here!
  noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a box and a sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(255, 255, 255);  // clear the screen to white

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // place the camera in the scene
  camera (0.0, 0.0, 85.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  // create an ambient light source
  ambientLight (102, 102, 102);

  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);

  //--------- EYES ------------

  pushMatrix(); // start eye1
  fill(0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);
  rotate(time,0,1,0);
  rotateY(radians(90));
  translate(2, -16, 3);
  scale(0.75, 0.75, 1);
  eye();
  popMatrix(); // end eye1

  pushMatrix(); // start eye2
  fill(0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);
  rotate(time,0,1,0);
  rotateY(radians(90));
  translate(-2, -16, 3);
  scale(0.75, 0.75, 1);
  eye();
  popMatrix(); // end eye2

  // --------- BODY ------------

  pushMatrix(); //start body
  fill(247, 213, 96);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);
  rotate(time,0,1,0);
  scale(0.8, 0.9, 1);
  body();
  popMatrix(); //end body

  // --------- WINGS ------------
    pushMatrix();
    ambient (50, 50, 50);
    specular (155, 155, 155);
    shininess (15.0);
    rotate(time,0,1,0);
    rotateX(radians(90));
    rotateY(radians(90));
    translate(-7, 0, -4);
    wings();
    popMatrix();
    
    pushMatrix();
    ambient (50, 50, 50);
    specular (155, 155, 155);
    shininess (15.0);
    rotate(time,0,1,0);
    rotateX(radians(90));
    rotateY(radians(90));
    translate(-2, 0, -4);
    wings();
    popMatrix();
    

  // --------- HEAD ------------

  pushMatrix(); // start head
  fill(247, 213, 96);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);
  head();
  
  // Draw antennas at the top of the head
  pushMatrix();
  fill (0, 0, 0);
  scale(0.35, 0.35, 0.35);
  translate(0.5, -1, -2); // Adjust the position of antennas
  rotate(time,0,1,0);
  rotateX(radians(150)); // Rotate antennas to stand up
  antenna();
  popMatrix();
  
  pushMatrix();
  scale(0.35, 0.35, 0.35);
  translate(-0.5, -1, -2); // Adjust the position of antennas
  rotate(time,0,1,0);
  rotateX(radians(-150)); // Rotate antennas to stand up
  antenna();
  popMatrix();

  popMatrix(); // end head

  // --------- ARMS ------------
  pushMatrix(); // start arm 1
  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (100);
  rotate(time,0,1,0);
  
  pushMatrix(); // start arm 1
  rotateX(radians(45));
  translate(0, -3, 10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix(); // end arm 1

  pushMatrix(); // start arm 2
  rotateX(radians(-45));
  translate(0, -3, -10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix(); // end arm 2

  // --------- LEGS ------------

  pushMatrix(); //start leg 1
  rotateZ(radians(-10));
  translate(0, 5, 2);
  scale(0.5, 0.5, 0.5);
  arm();
  popMatrix(); //end leg 1

  pushMatrix(); // start leg 2
  rotateZ(radians(-10));
  translate(0, 5, -2);
  scale(0.5, 0.5, 0.5);
  arm();
  popMatrix(); // end leg 2

  popMatrix(); // end shape
  

  // step forward the time
  time += 0.03;
}
// ---------------------------------------------- CREATE ARM
void arm() {
  pushMatrix();
  translate(0, 0, 0);
  cylinder(0.5, 5, 10);
  popMatrix();

  pushMatrix();
  translate(0, 0, 0);
  sphere(0.45);
  popMatrix();

  pushMatrix();
  translate(0, 5, 0);
  sphere(0.45);
  popMatrix();
}
// ---------------------------------------------- CREATE HEAD
void head() {
  scale(4,4,4);
  translate(0, -4, 0);
  sphere(1);
}
// ---------------------------------------------- CREATE SHOULDER
void wings() {
  pushMatrix();
  translate(0, 6, 2);
  rotateX(radians(20));
  wingsHelper();
  popMatrix();

 
  pushMatrix();
  translate(0, -6, 2);
  rotateZ(radians(180));
  rotateX(radians(20));
  wingsHelper();
  popMatrix();  
}

void wingsHelper() {
  pushMatrix();
  fill(255, 255, 255);
  rotateZ(radians(-35));
  translate(-1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(255, 255, 255);
  rotateZ(radians(35));
  translate(1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(0, 0, 0);
  scale(2, 4, 1);
  sphere(1);
  popMatrix();
}
// ---------------------------------------------- CREATE BODY
void body() {
  pushMatrix();
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  scale(1, 3, 4.5/6);
  translate(0, -3, 0);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  translate(0, -9, 0);
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(150, 75, 0);
  translate(0, -10, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(150, 75, 0);
  translate(0, -7, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(150, 75, 0);
  translate(0, -4, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  
  pushMatrix();
  fill(150, 75, 0);
  translate(0, 0, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
}
// ---------------------------------------------- CREATE EYE
void eye() {
  pushMatrix();
  scale(1, 1, 0.75);
  sphere(1);
  popMatrix();
}
// ---------------------------------------------- CREATE ANTENNA
void antenna() {
  pushMatrix();
  translate(0, 0, 0);
  cylinder(0.05, 5, 10); // Adjust the size and shape of the antenna
  popMatrix();
}
// ---------------------------------------------- CREATE CYLINDER
// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}

// Process key press events
void keyPressed()
{
  if (key == 's' || key =='S') {
    save ("image_file.jpg");
    println ("Screen shot was saved in JPG file.");
  }
}
