#version 460 core

#include <flutter/runtime_effect.glsl>

precision highp float;

uniform float randombs;
uniform float glowThreshold;
uniform float glowIntensity;
uniform float count;
uniform vec3 metaballs[256];

out vec4 fragColor;

vec4 noise(vec4 v){
  // ensure reasonable range
  v = fract(v) + fract(v*1e4) + fract(v*1e-4);
  // seed
  v += vec4(0.12345, 0.6789, 0.314159, 0.271828);
  // more iterations => more random
  v = fract(v*dot(v, v)*123.456);
  v = fract(v*dot(v, v)*123.456);
  return v;
}

void main() {
  vec2 coords = FlutterFragCoord().xy;

  float sum = 0.0;

  for(int i = 0; i < 256; i++) {
    if(i >= count) {
      break;
    }

    vec3 metaball = metaballs[i];
    float dx = metaball.x - coords.x;
    float dy = metaball.y - coords.y;
    float radius = metaball.z;

    sum+= ((radius * radius) / (dx * dx + dy * dy));
  }

  if(sum >= 1.0) {
    fragColor = vec4(1.0,1.0,1.0,1.0);
  } else if(sum > glowThreshold) {
    float n = ((sum - glowThreshold) / (1.0 - glowThreshold)) * glowIntensity;
    
    fragColor = vec4(n);
  } else {
    fragColor = vec4(.0, .0, .0, .0);
  }
}
