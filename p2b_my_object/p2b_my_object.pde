// Kalani Dissanayake
// Project 2B - Animation
// Attempt at creating an animation where a caterpillar dramatically turns into a butterfly

float time = 0;

float walkStart = 0;
float walkStop = 5;
float fallStart = 5;
float toFloor = 9;
float fallStop = 10;
float panStart = 10;
float panStop = 13;
float darkStart = 13.2;
float dramaticZoomStart = 14.5;
float dramaticZoomStop = 17;
float addWings = 20;
float flyingStart = 20;

int runCycle = 0;

void setup() {
  size(800, 800, P3D);  // must use 3D here!
  noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a box and a sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  // background color animation sequences
  if (time > darkStart && time < flyingStart) {
    float dark = min(170.0 + (time - flyingStart) * 50, 255);
    background(dark, dark, dark);
  } else if (time > flyingStart) {
    float light = max(255.0 - (time-darkStart)*50,170);
    background(light,light,light);
  } else {
    background(173, 216, 230); // clear the screen to LIGHT BLUE
  }
  

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // camera animation sequences #cameramotion
  if (time < fallStop) {
    camera (0.0 + (time*10), 0.0, 84.0, 0.0 + (time*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time < panStop) {
    camera (0.0 + (time*10), 0.0, 84.0, (fallStop*10) - ((time - fallStop)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > panStop && time < dramaticZoomStart) {
    camera (0.0 + (panStop*10), 0.0, 84.0, (fallStop*10) - ((panStop - fallStop)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > dramaticZoomStart && time < dramaticZoomStop) {
    camera (0.0 + (panStop*10), 0.0, 84.0 - (time - dramaticZoomStart)*10, (fallStop*10) - ((panStop - fallStop)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > dramaticZoomStop && time < flyingStart) {
      camera (0.0 + (panStop*10), 0.0, 84.0 - (dramaticZoomStop - dramaticZoomStart)*10, (fallStop*10) - ((panStop - fallStop)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > flyingStart) {
    camera (0.0 + (panStop*10) + (time-flyingStart)*8, (time - flyingStart)*2, 84.0 - (dramaticZoomStop - dramaticZoomStart)*10, (fallStop*10) - ((panStop - fallStop)*10) + (time-flyingStart)*10, 0.0, -1.0, 0.0, 1.0, 0.0);
  }
  
  ambientLight (10, 10, 10);
  lightSpecular (204, 204, 204);
  directionalLight (255, 253, 224, 70, 100, -50);
  directionalLight (64, 64, 60, 0, 0, -1);

  pushMatrix();
  translate(0,-8,0);
  scene();
  translate(62,4,0);
  scene();
  translate(62,-3,0);
  scene();
  translate(62,2,0);
  scene();
  translate(62,10,0);
  scene();
  translate(62,15,0);
  scene();
  popMatrix();

  float modelScale = 0.5;
 
  pushMatrix();
  if (time > walkStart && time < walkStop) {
    translate(time*10,0,0);
  } else if (time > fallStart && time < fallStop) {
    if (time > toFloor) {
      translate(time*10, (time - toFloor)*5, 0);
      rotateZ((toFloor - fallStart)*5.1);
    } else {
      translate(time*10,0,0);
      rotateZ((time - fallStart )*5.1);
    }
  } else if (time > fallStop && time < dramaticZoomStop) {
    translate(fallStop*10,(fallStop - toFloor)*5,0);
    rotateZ((toFloor - fallStart)*5.1);
  } else if (time > dramaticZoomStop && time < flyingStart) {
    translate(fallStop*10,(fallStop - toFloor)*5,0);
    rotateZ((toFloor - fallStart)*5.1);
  } else if (time > flyingStart) {
    translate((fallStop*10) + (time - flyingStart)*8, ((fallStop - toFloor)*5) - (time - flyingStart)*2, (time-flyingStart)*0.5);
    rotateY(min(radians(55),(time-flyingStart)*0.05));
    rotateZ(((toFloor - fallStart)*5.1) - min((time - flyingStart)*0.5, radians(25)));
  }
  scale(modelScale,modelScale,modelScale);
  character(time);
  popMatrix();

  // step forward the time
  time += 0.03;
}
// ------- CREATE SCENE --------
void scene() {
  pushMatrix();
  translate(-19,0,43);
  rotateY(radians(10));
  flower();
  popMatrix();
  
  pushMatrix();
  translate(-9,-2,-52);
  rotateY(radians(30));
  flower();
  popMatrix();

  pushMatrix();
  translate(9,2,-23);
  rotateY(radians(20));
  flower();
  popMatrix();

  pushMatrix();
  translate(5,1,14);
  rotateY(radians(10));
  flower();
  popMatrix();

  pushMatrix();
  translate(35,-1,-35);
  rotateY(radians(40));
  flower();
  popMatrix();
}

// ------ CREATE FLOWER -------
void flower() {
  pushMatrix();
  fill(0, 100, 0);
  ambient(74, 41, 7);
  shininess(15.0);
  cylinder(2, 13, 12);
  popMatrix();

  pushMatrix();
  ambient(174, 80, 30);
  shininess(20.0);

  pushMatrix();
  fill(255, 192, 203);
  translate(-2.5, -3, 0);
  sphere(6);
  popMatrix();

  pushMatrix();
  fill(255, 192, 203);
  translate(0, -5, 2);
  sphere(6);
  popMatrix();

  pushMatrix();
  fill(255, 255, 204);
  translate(2, -3, 0);
  sphere(6);
  popMatrix();

  pushMatrix();
  fill(255, 255, 204);
  translate(-4, -4, 0);
  sphere(6); 
  popMatrix();

  popMatrix();
}


// ------------------------ CREATE CHARACTER -------------------------
void character(float time) {
  // ------ HEAD
  pushMatrix();
  head();
  popMatrix();

  // ------ BODY
  pushMatrix();
  fill (128, 159, 209);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (50.0);

  body();
  popMatrix();
  
  // ------ ARMS AND LEGS
  pushMatrix();
  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (100);

  arms();
  legs(time);
  popMatrix();

  // ------ WINGS
  pushMatrix();
    fill (196, 255, 199);
    ambient (50, 50, 50);
    specular (155, 155, 155);
    shininess (15);
    wings(time);
  popMatrix();
}
// ---------------------------- METHODS TO HELP WITH EACH ELEMENT OF OBJECT ---------------------------
// ------- CREATE HEAD -------
void head() {
  pushMatrix();
  fill (7, 25, 54);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  pushMatrix();
  fill(94, 53, 177);
  scale(4,4,4);
  translate(0, -4, 0);
  sphere(1);
  popMatrix();

  popMatrix();

  // EYES

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotateY(radians(90));
  translate(2, -16, 3);
  eye();

  popMatrix();

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotateY(radians(90));
  translate(-2, -16, 3);
  eye();

  popMatrix();
}
// ------- CREATE BODY -------
void body() {
  pushMatrix();
  fill(94, 53, 177);
  scale(0.8, 0.9, 1);
  pushMatrix();
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(173, 143, 219);
  translate(0, -9, 0);
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, 0, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, -2, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  
  pushMatrix();
  fill(0,0,0);
  translate(0, -9, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  popMatrix();
}
// ------- CREATE LEGS -------
void legs(float time) {

  if (time > walkStart && time <walkStop) {
    //RUNCYCLES #objectanimation
    //  0=extrema, 1=thedown 2, 3=pass, 4=thehigh, 5,
    //  6=extrema', 7=thedown' 8, 9=pass', 10=thehigh', 11,
    
    switch (runCycle) {
      case 0:
      case 1:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 2:
      case 3:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-5));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 4:
      case 5:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(2, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-45));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 6:
      case 7:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-75));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(15));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 8:
      case 9:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-72));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(35));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 10:
      case 11:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-65));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(30));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 12:
      case 13:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 14:
      case 15:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-5));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 16:
      case 17:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(2, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-45));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 18:
      case 19:
        pushMatrix(); //leg 1
        fill(0,0,0);
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(15));
        limb();
        popMatrix();
        
        pushMatrix(); //leg 2
        fill(0,0,0);
        translate(3, 6.25, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-75));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 20:
      default:
        if (runCycle == 20) { //reset if max reached
          runCycle = 0;
        } else {
          runCycle++;
        }
        break;  
    }
  } else {
    // natural position
    pushMatrix();
    fill(0,0,0);
    translate(0.5, 7.5, 2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(-10));
    limb();
    popMatrix();

    pushMatrix();
    fill(0,0,0);
    translate(0.5, 7.5, -2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(-10));
    limb();
    popMatrix();

  }
}
// ------- CREATE ARMS -------
void arms() {
  pushMatrix();
  rotateX(radians(45));
  translate(0, -0.5, 10); // (z,x,y)
  scale(0.75, 1.2, 1.5);
  limb();
  popMatrix();


  pushMatrix();
  rotateX(radians(-45));
  translate(0, -0.5, -10); // (z,x,y)
  scale(0.75, 1.2, 1.5);
  limb();
  popMatrix();


  pushMatrix();
  rotateX(radians(-45));
  translate(0, -0.5, -10); // (z,x,y)
  scale(0.75, 1.2, 1.5);
  limb();
  popMatrix();
}
// ------- CREATE LIMBS -------
void limb() {
  pushMatrix();
  translate(0, -2.5, 0);
  cylinder(0.5, 5, 10);
  popMatrix();

  pushMatrix();
  translate(0, -2.5, 0);
  sphere(0.45);
  popMatrix();

  pushMatrix();
  translate(0, 2.5, 0);
  sphere(0.45);
  popMatrix();
}

// // ------- CREATE WINGS -------
void wings(float time) {
  if (time > addWings && time < flyingStart) {
    pushMatrix();
    translate(-6,1,0);
    scale(2,2,2);
    pushMatrix();
    translate(0,-5,-5);
    rotateX(radians(45));
    rotateZ(radians(-30));
    rotateY(radians(90));
    wingshelper();
    popMatrix();
    pushMatrix();
    translate(0,-5,5);
    rotateX(radians(-45));
    rotateZ(radians(-30));
    rotateY(radians(90));
    wingshelper();
    popMatrix();
    popMatrix();
  } else if (time > flyingStart) {
    // if I rotate the angle of the wings within a range of angles, the animation happens fast enough to visualize flapping of hummingbirdlike wings
    pushMatrix();
    translate(-6,1,0);
    scale(2,2,2);
    pushMatrix();
    translate(0,-5,-5);
    rotateX(radians(45));
    rotateZ(radians(random(-38, -22)));
    rotateY(radians(90));
    wingshelper();
    popMatrix();
    pushMatrix();
    translate(0,-5,5);
    rotateX(radians(-45));
    rotateZ(radians(random(-38,-22)));
    rotateY(radians(90));
    wingshelper();
    popMatrix();
    popMatrix();
  }
}

void wingshelper() {
  pushMatrix();
  fill(26, 40, 71);
  rotateZ(radians(-35));
  translate(-1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(44, 82, 130);
  rotateZ(radians(35));
  translate(1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(125, 173, 217);
  scale(2, 4, 1);
  sphere(1);
  popMatrix();
}
// ------- CREATE EYES -------
void eye() {
  pushMatrix();
  scale(1, 1.5, 0.75);
  sphere(1);
  popMatrix();
}

// ------- CREATE CYLINDER -------
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
