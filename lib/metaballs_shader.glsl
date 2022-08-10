#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

// define uniforms:
layout(location = 0) uniform float gradientRadius;
layout(location = 1) uniform vec2 size;
layout(location = 2) uniform float minimumGlowSum;
layout(location = 3) uniform float glowIntensity;

// Why are these defined seperatly? Because when using a uniform vec3[40] the shader when
// loading in throws "Not a supported op", if you know a fix to this issue feel free to make a pr
layout(location = 4) uniform vec3 metaball1;
layout(location = 5) uniform vec3 metaball2;
layout(location = 6) uniform vec3 metaball3;
layout(location = 7) uniform vec3 metaball4;
layout(location = 8) uniform vec3 metaball5;
layout(location = 9) uniform vec3 metaball6;
layout(location = 10) uniform vec3 metaball7;
layout(location = 11) uniform vec3 metaball8;
layout(location = 12) uniform vec3 metaball9;
layout(location = 13) uniform vec3 metaball10;
layout(location = 14) uniform vec3 metaball11;
layout(location = 15) uniform vec3 metaball12;
layout(location = 16) uniform vec3 metaball13;
layout(location = 17) uniform vec3 metaball14;
layout(location = 18) uniform vec3 metaball15;
layout(location = 19) uniform vec3 metaball16;
layout(location = 20) uniform vec3 metaball17;
layout(location = 21) uniform vec3 metaball18;
layout(location = 22) uniform vec3 metaball19;
layout(location = 23) uniform vec3 metaball20;
layout(location = 24) uniform vec3 metaball21;
layout(location = 25) uniform vec3 metaball22;
layout(location = 26) uniform vec3 metaball23;
layout(location = 27) uniform vec3 metaball24;
layout(location = 28) uniform vec3 metaball25;
layout(location = 29) uniform vec3 metaball26;
layout(location = 30) uniform vec3 metaball27;
layout(location = 31) uniform vec3 metaball28;
layout(location = 32) uniform vec3 metaball29;
layout(location = 33) uniform vec3 metaball30;
layout(location = 34) uniform vec3 metaball31;
layout(location = 35) uniform vec3 metaball32;
layout(location = 36) uniform vec3 metaball33;
layout(location = 37) uniform vec3 metaball34;
layout(location = 38) uniform vec3 metaball35;
layout(location = 39) uniform vec3 metaball36;
layout(location = 40) uniform vec3 metaball37;
layout(location = 41) uniform vec3 metaball38;
layout(location = 42) uniform vec3 metaball39;
layout(location = 43) uniform vec3 metaball40;

float addSum(vec3 metaball, vec2 coords) {
  float dx = metaball.x - coords.x;
  float dy = metaball.y - coords.y;
  float radius = metaball.z;
  return ((radius * radius) / (dx * dx + dy * dy));
}

// dithering example from https://shader-tutorial.dev/advanced/color-banding-dithering/
const highp float NOISE_GRANULARITY = 0.5/255.0;

highp float random(vec2 coords) {
  return fract(sin(dot(coords.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
  float sum = 0.0;
  vec2 coords = gl_FragCoord.xy;

  // i know this is painful
  sum += addSum(metaball1, coords);
  sum += addSum(metaball1, coords);
  sum += addSum(metaball2, coords);
  sum += addSum(metaball3, coords);
  sum += addSum(metaball4, coords);
  sum += addSum(metaball5, coords);
  sum += addSum(metaball6, coords);
  sum += addSum(metaball7, coords);
  sum += addSum(metaball8, coords);
  sum += addSum(metaball9, coords);
  sum += addSum(metaball10, coords);
  sum += addSum(metaball11, coords);
  sum += addSum(metaball12, coords);
  sum += addSum(metaball13, coords);
  sum += addSum(metaball14, coords);
  sum += addSum(metaball15, coords);
  sum += addSum(metaball16, coords);
  sum += addSum(metaball17, coords);
  sum += addSum(metaball18, coords);
  sum += addSum(metaball19, coords);
  sum += addSum(metaball20, coords);
  sum += addSum(metaball21, coords);
  sum += addSum(metaball22, coords);
  sum += addSum(metaball23, coords);
  sum += addSum(metaball24, coords);
  sum += addSum(metaball25, coords);
  sum += addSum(metaball26, coords);
  sum += addSum(metaball27, coords);
  sum += addSum(metaball28, coords);
  sum += addSum(metaball29, coords);
  sum += addSum(metaball30, coords);
  sum += addSum(metaball31, coords);
  sum += addSum(metaball32, coords);
  sum += addSum(metaball33, coords);
  sum += addSum(metaball34, coords);
  sum += addSum(metaball35, coords);
  sum += addSum(metaball36, coords);
  sum += addSum(metaball37, coords);
  sum += addSum(metaball38, coords);
  sum += addSum(metaball39, coords);
  sum += addSum(metaball40, coords);

  if(sum >= 1.0) {
    fragColor = vec4(1,1,1,1);
  } else if(sum > minimumGlowSum) {
    float n = ((sum - minimumGlowSum) / (1.0 - minimumGlowSum)) * glowIntensity;
    fragColor = vec4(1, 1, 1, n);  
    fragColor += mix(-NOISE_GRANULARITY, NOISE_GRANULARITY, random(coords / size));
  } else {
    fragColor = vec4(0, 0, 0, 0);
  }
}