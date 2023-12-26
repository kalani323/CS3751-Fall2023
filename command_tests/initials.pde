/******************************************************************************
Kalani Dissanayake => KD
Draw your initials here in perspective.
******************************************************************************/

void persp_initials() {
  Init_Matrix();

  Perspective(60.0, 1.0, 100.0);

  Push_Matrix();

  Translate(-1.0, 0.0, -4.0);
  RotateZ(-15);
  RotateX(-45);
  RotateY(20);

  // draw letter K
  Begin_Shape();

  Vertex( 0,  -1.0,  1.0);
  Vertex( 0, 1.0,  1.0);

  Vertex( 1.0, 1.0,  1.0);
  Vertex(0, 0,  1.0);

  Vertex(1.0, -1.0, 1.0);
  Vertex(0, 0, 1.0);

  End_Shape();

  //draw letter D next to K
  Translate(1.0, 0.0, 0.0);

  Begin_Shape();

  Vertex(0.0, -1.0, 1.0);
  Vertex(0.0,  1.0, 1.0);

  Vertex(0.0,  1.0, 1.0);
  Vertex(0.5,  1.0, 1.0);

  Vertex(0.5,  1.0, 1.0);
  Vertex(1.0,  0.5, 1.0);

  Vertex(1.0,  0.5, 1.0);
  Vertex(1.0, -1.0, 1.0);

  Vertex(1.0, -1.0, 1.0);
  Vertex(0.5, -1.0, 1.0);

  Vertex(0.5, -1.0, 1.0);
  Vertex(0.0, -1.0, 1.0);

  End_Shape();

  Pop_Matrix();
}
