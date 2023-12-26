// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
  
  vec4 diffuse_color = vec4 (1.0, 0.0, 0.0, 1.0);  // red
  float diffuse = abs(dot (vertNormal, vertLightDir));
  gl_FragColor = vec4(diffuse * diffuse_color.rgb, 1.0);
  gl_FragColor.a = 1.0;

}
