#version 460 core

precision highp float;

// Need this here because flutter for some reason skips the first uniform, so we can't use it.
uniform float iDoNothing;

uniform float glowThreshold;
uniform float glowIntensity;
uniform float count;
uniform vec3 metaballs[256];

out vec4 fragColor;

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
