#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

// define uniforms:
layout ( location = 0 ) uniform float time;
layout ( location = 1 ) uniform float minimumGlowSum;
layout ( location = 2 ) uniform float glowIntensity;
layout ( location = 3 ) uniform int metaballCount;
layout ( location = 4 ) uniform vec3 metaballs[128];

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

void main(){
  float sum = 0.0;

  vec2 coords = gl_FragCoord.xy;

  for(int i = 0; i < metaballCount; i++) {
    float dx = metaballs[i].x - coords.x;
    float dy = metaballs[i].y - coords.y;
    float radius = metaballs[i].z;
    sum += ((radius * radius) / (dx * dx + dy * dy));
  }

  if(sum >= 1.0) {
    fragColor = vec4(1,1,1,1);
  } else if(sum > minimumGlowSum) {
    float n = ((sum - minimumGlowSum) / (1.0 - minimumGlowSum)) * glowIntensity;
    
    fragColor = vec4(n) + ((noise(vec4(coords, time, 0.0)) - 0.5) / 255.0);
  } else {
    fragColor = vec4(0, 0, 0, 0);
  }
}