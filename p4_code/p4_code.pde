// Shader Project
// KALANI DISSANAYAKE

PShader blank_shader;  // top and bottom of cube

// shaders for the four sides of the cube (you will modify these!)
PShader pattern_shader;
PShader symmetry_four_shader;
PShader edges_shader;
PShader waves_shader;

PImage example_texture;  // used by edges shader

float zoom = 400;
boolean locked = false;
float dirY = 0;
float dirX = 0;
float time = 9;
float delta_time = 0.02;

// initialize variables and load shaders
void setup() {
  
  size (800, 800, P3D);
  
  frameRate (30);

  noStroke();

  // load a texture
  example_texture = loadImage("data/initial_pic.jpg");

  // load the shaders
  blank_shader = loadShader("data/blank.frag", "data/blank.vert");
  pattern_shader = loadShader("data/circles.frag", "data/circles.vert");
  symmetry_four_shader = loadShader("data/symmetry_four.frag", "data/symmetry_four.vert");
  edges_shader = loadShader("data/edges.frag", "data/edges.vert");
  waves_shader = loadShader("data/waves.frag", "data/waves.vert");
}

void draw() {

  background (0);

  // create a single directional light
  directionalLight (190, 190, 190, 0, 0, -1);

  pushMatrix();

  camera (0, 0, zoom, 0, 0, 0, 0, 1, 0);
  
  // control the scene rotation via the current mouse location
  if (!locked) {
    dirY = (mouseY / float(height) - 0.5) * 2;
    dirX = (mouseX / float(width) - 0.5) * 2;
  }

  rotateX (-dirY);
  rotateY (dirX * 3.5);
  
  // top of cube
  shader (blank_shader);
  pushMatrix();
  rotateX (0.5 * PI);
  translate (0, 0, 100);
  one_square();
  popMatrix();

  // bottom of cube
  shader (blank_shader);
  pushMatrix();
  rotateX (1.5 * PI);
  translate (0, 0, 100);
  one_square();
  popMatrix();

  // four sides of cube
  cube_four_walls();
  
  popMatrix();

  // update the time variable
  time += delta_time;
}  

// create various textured sides of the cube
void cube_four_walls()
{
  // Render the four-fold fractal shader
  shader(symmetry_four_shader);
  
  // vary the complex number c = (cx, cy) and hand it to the shader
  float r = 0.02;
  float mx = 0.65;
  float my = 0.2;
  float cx = mx + r * sin(time);
  float cy = my + r * cos(time);
  
  symmetry_four_shader.set ("cx", cx);
  symmetry_four_shader.set ("cy", cy);
  
  textureMode(NORMAL);
  pushMatrix();
  rotateY (PI);
  translate (0, 0, 100);
  one_square();
  popMatrix();
  
  // Render the image manipulation shader
  edges_shader.set("my_texture", example_texture);
  
  // include here motion for cx and cy (similar to fractal shader above)
  
  shader(edges_shader);
  edges_shader.set ("time", time);  // pass the "time" value to the shader
  textureMode(NORMAL);
  
  pushMatrix();
  rotateY (0.5 * PI);
  translate (0, 0, 100);
  beginShape();
  texture(example_texture);
  vertex(-100, -100, 0, 0, 0);
  vertex( 100, -100, 0, 1, 0);
  vertex( 100,  100, 0, 1, 1);
  vertex(-100,  100, 0, 0, 1);
  endShape();
  popMatrix();

  // Render the waves shader
  shader(waves_shader);
  pushMatrix();
  rotateY (1.5 * PI);
  translate(-100, -100, 100);
  // replace this square with lots of little ones that your
  int quadSize = 5;
  float normalVector = 50.0;
  
  for (int i = 0; i < normalVector; i+=1) {
    for (int j = 0; j < normalVector; j+=1) {
      beginShape();
      texture(example_texture);
      
      vertex((i*quadSize), (j*quadSize), 0, (i/normalVector), (j/normalVector));
      vertex(((i+1)*quadSize), (j*quadSize), 0, ((i+1)/normalVector), (j/normalVector));
      vertex(((i+1)*quadSize),((j+1)*quadSize), 0, ((i+1)/normalVector), ((j+1)/normalVector));
      vertex((i*quadSize), ((j+1)*quadSize), 0, (i/normalVector), ((j+1)/normalVector));
      
      endShape();
    }
  }
  // vertex shader can move around to make waves
  popMatrix();
  
  // Render the circles shader
  shader(pattern_shader);
  pushMatrix();
  rotateY (0);
  translate (0, 0, 100);
  one_square();
  popMatrix();
  
  time += 0.01;
  if (time > 1)
    time = 0;
}

// a square that is used several times to make the cube
void one_square()
{
  beginShape();
  vertex(-100, -100, 0, 0, 0);
  vertex( 100, -100, 0, 1, 0);
  vertex( 100,  100, 0, 1, 1);
  vertex(-100,  100, 0, 0, 1);
  endShape();
}

void keyPressed() {
  if (key == ' ') {
    locked = !locked;
  }
}

void mouseWheel(MouseEvent event) {
  zoom += event.getCount() * 12.0;
}
