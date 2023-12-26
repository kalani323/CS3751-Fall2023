// could not get working, please give me partial credit
// Sample code for starting the subdivision project
Mesh mesh;
import java.util.Arrays;
// parameters used for object rotation by mouse
float mouseX_old = 0;
float mouseY_old = 0;
int currentCorner = 0;
boolean rotate, firstShape, perVertex;
PMatrix3D rot_mat = new PMatrix3D();
int corner = 0;
// initialize stuff
void setup() {
  size (800, 800, OPENGL);
}

// Draw the scene
void draw() {
  background(170, 170, 255);
  perspective(PI * 0.333, 1.0, 0.01, 1000.0);
  camera(0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  ambientLight(52, 52, 52);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);

  pushMatrix();
  applyMatrix(rot_mat);

  ambient(200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);

  stroke(0, 0, 0);
  fill(200, 200, 200);

  if (!firstShape) {
    // Draw a default shape if firstShape is false
    beginShape();
    normal(0.0, 0.0, 1.0);
    vertex(-1.0, -1.0, 0.0);
    vertex(1.0, -1.0, 0.0);
    vertex(1.0, 1.0, 0.0);
    vertex(-1.0, 1.0, 0.0);
    endShape(CLOSE);
  } else if (mesh != null) {
    // Draw the mesh if it is initialized
    for (int i = 0; i < mesh.V.size(); i += 3) {
      beginShape();
      if (perVertex) {
        for (int j = 0; j < 3; j++) {
          Vertex vertexNormal = mesh.vertexNorms[mesh.V.get(i + j)];
          normal(vertexNormal.x, vertexNormal.y, vertexNormal.z);
          Vertex vert = mesh.G.get(mesh.V.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      } else {
        Vertex normalFace = mesh.faceNorms.get(i / 3);
        normal(normalFace.x, normalFace.y, normalFace.z);

        for (int j = 0; j < 3; j++) {
          Vertex vert = mesh.G.get(mesh.V.get(i + j));
          vertex(vert.x, vert.y, vert.z);
        }
      }
      endShape(CLOSE);
    }
  }

  popMatrix();
}

// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply", 1.5);
    firstShape = true;
  } else if (key == '2') {
    read_mesh ("octa.ply", 2.5);
    firstShape = true;
  } else if (key == '3') {
    read_mesh ("icos.ply", 2.5);
    firstShape = true;
  } else if (key == '4') {
    read_mesh ("star.ply", 1.0);
    firstShape = true;
  } else if (key == '5') {
    read_mesh ("torus.ply", 1.6);
    firstShape = true;
  } else if (key == 'n') {
    // next corner operation
    currentCorner = next(currentCorner);
  } else if (key == 'p') {
    // previous corner operation
    currentCorner = prev(currentCorner);
  } else if (key == 'o') {
    // opposite corner operation
  } else if (key == 's') {
    // swing corner operation
    currentCorner = mesh.swing(currentCorner);
  } else if (key == 'f') {
    flatShading();
  } else if (key == 'g') {
    gouraudShading();
  } else if (key == 'd') {
    mesh = subdivide(mesh);
  } else if (key == 'q') {
    // quit program
    exit();
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename, float scale_value)
{
  mesh = new Mesh(0, 0);
  String[] words;

  String lines[] = loadStrings(filename);

  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);

  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);

  // read in the vertices
  for (int i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]) * scale_value;
    float y = float(words[1]) * scale_value;
    float z = float(words[2]) * scale_value;
    Vertex vertex = new Vertex(x, y, z);
    mesh.G.add(vertex); // Add the Vertex to G ArrayList
    println ("vertex = " + x + " " + y + " " + z);
  }

  // read in the faces
  for (int i = 0; i < num_faces; i++) {

    int j = i + num_vertices + 2;
    words = split (lines[j], " ");

    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }

    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);
    println ("face = " + index1 + " " + index2 + " " + index3);

    mesh.V.add(int(words[1]));
    mesh.V.add(int(words[2]));
    mesh.V.add(int(words[3]));
  }
  mesh.oTable();
  mesh.faceNorms();
  mesh.vertexNorms();
}

// remember old mouse position
void mousePressed()
{
  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

// modify rotation matrix when mouse is dragged
void mouseDragged()
{
  if (!mousePressed)
    return;

  float dx = mouseX - mouseX_old;
  float dy = mouseY - mouseY_old;
  dy *= -1;

  float len = sqrt (dx*dx + dy*dy);
  if (len == 0)
    len = 1;

  dx /= len;
  dy /= len;
  PMatrix3D rmat = new PMatrix3D();
  rmat.rotate (len * 0.005, dy, dx, 0);
  rot_mat.preApply (rmat);

  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

Mesh subdivide(Mesh old) {
  ArrayList<Integer> newV = new ArrayList<Integer>();
  ArrayList<Vertex> newG = new ArrayList<Vertex>();

  // Compute even vertices
  ArrayList<ArrayList<Integer>> adjacentVertices = adjVertices(old); // Neighbors of each vertex
  for (int i = 0; i < old.G.size(); i++) {
    // Add adjacent vertices * u + (1 - n*u) * original vertex
    ArrayList<Integer> adjVerts = adjacentVertices.get(i);
    Vertex sumOfNeighbors = new Vertex(0.0, 0.0, 0.0);
    for (int j = 0; j < adjVerts.size(); j++) sumOfNeighbors = sumOfNeighbors.add(old.G.get(adjVerts.get(j)));
    float u = adjVerts.size() == 3 ? 3.0 / 16.0 : 3.0 / (8.0 * adjVerts.size());
    newG.add(old.G.get(i).mult(1 - adjVerts.size() * u).add(sumOfNeighbors.mult(u)));
  }

  // Compute odd vertices (one for each edge of currentMesh)
  ArrayList<int[]> traversedEdges = new ArrayList<int[]>();
  int[] innerTriangleIDs = new int[3];
  int firstID = 0;
  int secondID = 0;

  // Go through each corner
  for (int j = 0; j < old.V.size(); j++) {
    int currentVertex = old.V.get(j);
    int nextVertex = old.V.get(next(j));
    int prevVertex = old.V.get(prev(j));

    // Construct adjacent edges, check if they have already been traversed
    int[] firstEdge = {currentVertex, nextVertex};
    Arrays.sort(firstEdge);

    int[] secondEdge = {currentVertex, prevVertex};
    Arrays.sort(secondEdge);

    boolean hasFirstEdge = false;
    boolean hasSecondEdge = false;

    for (int k = 0; k < traversedEdges.size(); k++) {
      int[] check = traversedEdges.get(k);
      if (check[0] == firstEdge[0] && check[1] == firstEdge[1]) hasFirstEdge = true;
      if (check[0] == secondEdge[0] && check[1] == secondEdge[1]) hasSecondEdge = true;
    }

    Vertex leftVert = old.G.get(prevVertex);
    Vertex rightVert = old.G.get(old.V.get(old.O[prev(j)]));

    Vertex currentVert = old.G.get(currentVertex);
    Vertex prevVert = old.G.get(prevVertex);

    Vertex newVert = currentVert.add(old.G.get(nextVertex)).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));


    // If not traversed, add the new vertex to G
    // Otherwise, note the ID of the vertex already in G
    if (!hasFirstEdge) {
      traversedEdges.add(firstEdge);
      firstID = newG.size();
      newG.add(newVert);
    } else {
      for (int k = 0; k < newG.size(); k++) {
        Vertex check = newG.get(k);
        if (check.equals(newVert)) {
          firstID = k;
          break;
        }
      }
    }

    leftVert = old.G.get(nextVertex);
    rightVert = old.G.get(old.V.get(old.O[next(j)]));

    newVert = currentVert.add(prevVert).mult(3.0 / 8.0).add(leftVert.add(rightVert).mult(1.0 / 8.0));

    // If not traversed, add the new vertex to G
    // Otherwise, note the ID of the vertex already in G
    if (!hasSecondEdge) {
      traversedEdges.add(secondEdge);
      secondID = newG.size();
      newG.add(newVert);
    } else {
      for (int k = 0; k < newG.size(); k++) {
        Vertex check = newG.get(k);
        if (check.equals(newVert)) {
          secondID = k;
          break;
        }
      }
    }

    // Add the vertex and its adjacent new vertices to V
    newV.add(currentVertex);
    newV.add(firstID);
    newV.add(secondID);

    // If all 3 corners of a triangle have been visited, add the new middle face to V
    if (j % 3 == 0) innerTriangleIDs[0] = firstID;
    else if (j % 3 == 1) innerTriangleIDs[1] = firstID;
    else {
      newV.add(innerTriangleIDs[0]);
      newV.add(innerTriangleIDs[1]);
      newV.add(firstID);
    }
  }


  // Create data tables for the new mesh
  Mesh newMesh = new Mesh(newG.size(), newV.size() / 3);
  newMesh.V = newV;
  newMesh.G = newG;

  newMesh.oTable();
  newMesh.faceNorms();
  newMesh.vertexNorms();

  return newMesh;
}

// For each vertex, create a list of its neighbors by swinging around that vertex and getting the next vertex of each corner
ArrayList<ArrayList<Integer>> adjVertices(Mesh mesh) {
  ArrayList<ArrayList<Integer>> adjVertices = new ArrayList<ArrayList<Integer>>();
  boolean[] found = new boolean[mesh.G.size()];

  for (int i = 0; i < mesh.G.size(); i++) adjVertices.add(new ArrayList<Integer>());

  for (int i = 0; i < mesh.V.size(); i++) {
    if (found[mesh.V.get(i)] == false) {
      ArrayList<Integer> vertices = new ArrayList<Integer>();
      vertices.add(mesh.V.get(next(i)));
      int swing = mesh.swing(i);

      while (swing != i) {
        vertices.add(mesh.V.get(next(swing)));
        swing = mesh.swing(swing);
      }

      found[mesh.V.get(i)] = true;
      adjVertices.set(mesh.V.get(i), vertices);
    }
  }

  return adjVertices;
}

int next(int corner) {
  return (corner / 3) * 3 + (corner + 1) % 3;
}

int prev(int corner) {
  return (corner - 1 + 3) % 3 + (corner / 3) * 3;
}

class Mesh {
  ArrayList<Integer> V;
  ArrayList<Vertex> G, faceNorms;
  int[] O;
  ArrayList<int[]> colors;
  Vertex[] vertexNorms;
  int num_vertices, num_faces;

  Mesh(int v, int f) {
    V = new ArrayList<Integer>();
    G = new ArrayList<Vertex>();
    O = new int[3 * f]; // Initialize O array with the correct length
    faceNorms = new ArrayList<Vertex>();
    vertexNorms = new Vertex[v];
    colors = new ArrayList<int[]>();
    num_vertices = v;
    num_faces = f;
  }

  // Swing to the next corner that shares a vertex
  int swing(int corner) {
    if (O == null || O.length <= corner || O.length <= next(corner)) {
      System.out.println("Error: Array O is not properly initialized.");
      return -1; // Return an invalid index to indicate error
    }
    return next(O[next(corner)]);
  }

  // Create O by comparing all vertices to each other to see if their next/prev match each other
  void oTable() {
    // Check if arrays are initialized and have enough elements
    if (O == null || V == null || O.length < V.size() || V.isEmpty()) {
      System.out.println("Error: Arrays not initialized or have insufficient length.");
      return; // Exit the method if arrays are not properly initialized
    }

    // Initialize the O array with -1 to indicate unassigned values
    Arrays.fill(O, -1);

    for (int a = 0; a < V.size(); a++) {
      if (O[a] != -1) continue; // Skip if already assigned

      for (int b = 0; b < V.size(); b++) {
        if (next(a) < V.size() && prev(b) < V.size() && V.get(next(a)).equals(V.get(prev(b))) && V.get(prev(a)).equals(V.get(next(b)))) {
          O[a] = b;
          O[b] = a;
          break; // Break the inner loop once a pair is found
        }
      }
    }
  }
  void faceNorms() {
    for (int i = 0; i < V.size(); i += 3) faceNorms.add(faceNorm(G.get(V.get(i)), G.get(V.get(i + 1)), G.get(V.get(i + 2))));
  }

  Vertex faceNorm(Vertex a, Vertex b, Vertex c) {
    return b.sub(a).cross(c.sub(a)).norm();
  }

  void vertexNorms() {
    if (V == null || V.isEmpty() || O == null || O.length < V.size()) {
      System.out.println("Error: Arrays V or O are not properly initialized.");
      return;
    }

    boolean[] normalized = new boolean[G.size()];
    vertexNorms = new Vertex[G.size()]; // Ensure this is correctly initialized

    for (int i = 0; i < V.size(); i++) {
      if (!normalized[V.get(i)]) {
        Vertex vertNormal = faceNorms.get(i / 3);
        int swing = swing(i);
        if (swing == -1) continue; // Skip if swing returns an error

        while (swing != i && swing < V.size()) {
          vertNormal = vertNormal.add(faceNorms.get(swing / 3));
          swing = swing(swing);
          if (swing == -1) break; // Break if swing returns an error
        }

        vertexNorms[V.get(i)] = vertNormal.norm();
        normalized[V.get(i)] = true;
      }
    }
  }
}

class Vertex {
  float x, y, z;

  Vertex(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vertex sub(Vertex second) {
    return new Vertex(x - second.x, y - second.y, z - second.z);
  }

  Vertex add(Vertex second) {
    return new Vertex(x + second.x, y + second.y, z + second.z);
  }

  Vertex cross(Vertex second) {
    return new Vertex(y * second.z - z * second.y, z * second.x - x * second.z, x * second.y - y * second.x);
  }

  Vertex norm() {
    return new Vertex(x / sqrt(x * x + y * y + z * z), y / sqrt(x * x + y * y + z * z), z / sqrt(x * x + y * y + z * z));
  }

  Vertex mult(float scale) {
    return new Vertex(x * scale, y * scale, z * scale);
  }

  boolean equals(Vertex other) {
    return x == other.x && y == other.y && z == other.z;
  }
}
void flatShading() {
  if (mesh != null) {
    for (int i = 0; i < mesh.V.size(); i += 3) {
      beginShape();
      Vertex normalFace = mesh.faceNorms.get(i / 3);
      normal(normalFace.x, normalFace.y, normalFace.z);

      for (int j = 0; j < 3; j++) {
        Vertex vert = mesh.G.get(mesh.V.get(i + j));
        vertex(vert.x, vert.y, vert.z);
      }

      endShape(CLOSE);
    }
  }
}

// Gouraud Shading with Per-Vertex Normals
void gouraudShading() {
  if (mesh != null) {
    for (int i = 0; i < mesh.V.size(); i += 3) {
      beginShape();
      for (int j = 0; j < 3; j++) {
        Vertex vertexNormal = mesh.vertexNorms[mesh.V.get(i + j)];
        normal(vertexNormal.x, vertexNormal.y, vertexNormal.z);
        Vertex vert = mesh.G.get(mesh.V.get(i + j));
        vertex(vert.x, vert.y, vert.z);
      }
      endShape(CLOSE);
    }
  }
}
