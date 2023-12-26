// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// set by host code
uniform float time;

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
  vec4 diffuse_color = texture2D(texture, vertTexCoord.xy);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);

  // Calculate distance from the center of the circle
  vec2 circleCenter = vec2(0.5, 0.5); // Adjust as needed
  float distanceToCenter = distance(vertTexCoord.xy, circleCenter);

  // Check if the fragment is inside the circle
  if (distanceToCenter < time) {
    vec2 d = textureSize(texture, 0);
    float dx = 1.0/d.x;
    float dy = 1.0/d.y;

    vec4 v00 = texture2D(texture, vec2(vertTexCoord.x - dx, vertTexCoord.y - dy));
    vec4 v01 = texture2D(texture, vec2(vertTexCoord.x - dx, vertTexCoord.y + dy));
    vec4 v10 = texture2D(texture, vec2(vertTexCoord.x + dx, vertTexCoord.y - dy));
    vec4 v11 = texture2D(texture, vec2(vertTexCoord.x + dx, vertTexCoord.y + dy));
    
    float laplacian = 0.25 * (v00.r + v01.r + v10.r + v11.r) - diffuse_color.r;
    laplacian = (laplacian + 1.0) / 2.0; // Adjusting for middle gray
    laplacian = pow(laplacian, 2.0); // Boosting contrast
    
    gl_FragColor = vec4(laplacian, laplacian, laplacian, 1.0);
  } else {
    gl_FragColor = vec4(diffuse * diffuse_color.rgb, 1.0);
  }
}

