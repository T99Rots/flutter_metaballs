#version 320 es

precision highp float;

layout(location = 0) out vec4 fragColor;

// define uniforms:
layout(location = 0) uniform float gradientRadius;
layout(location = 1) uniform vec3 color1;
layout(location = 2) uniform vec3 color2;
layout(location = 3) uniform vec2 size;
layout(location = 4) uniform float minimumGlowSum;
layout(location = 5) uniform float glowIntensity;
layout(location = 6) uniform vec2 gradientPosition;

// Why are these defined seperatly? Because when using a uniform vec3[40] the shader when
// loading in throws "Not a supported op", if you know a fix to this issue feel free to make a pr
layout(location = 7) uniform vec3 metaball1;
layout(location = 8) uniform vec3 metaball2;
layout(location = 9) uniform vec3 metaball3;
layout(location = 10) uniform vec3 metaball4;
layout(location = 11) uniform vec3 metaball5;
layout(location = 12) uniform vec3 metaball6;
layout(location = 13) uniform vec3 metaball7;
layout(location = 14) uniform vec3 metaball8;
layout(location = 15) uniform vec3 metaball9;
layout(location = 16) uniform vec3 metaball10;
layout(location = 17) uniform vec3 metaball11;
layout(location = 18) uniform vec3 metaball12;
layout(location = 19) uniform vec3 metaball13;
layout(location = 20) uniform vec3 metaball14;
layout(location = 21) uniform vec3 metaball15;
layout(location = 22) uniform vec3 metaball16;
layout(location = 23) uniform vec3 metaball17;
layout(location = 24) uniform vec3 metaball18;
layout(location = 25) uniform vec3 metaball19;
layout(location = 26) uniform vec3 metaball20;
layout(location = 27) uniform vec3 metaball21;
layout(location = 28) uniform vec3 metaball22;
layout(location = 29) uniform vec3 metaball23;
layout(location = 30) uniform vec3 metaball24;
layout(location = 31) uniform vec3 metaball25;
layout(location = 32) uniform vec3 metaball26;
layout(location = 33) uniform vec3 metaball27;
layout(location = 34) uniform vec3 metaball28;
layout(location = 35) uniform vec3 metaball29;
layout(location = 36) uniform vec3 metaball30;
layout(location = 37) uniform vec3 metaball31;
layout(location = 38) uniform vec3 metaball32;
layout(location = 39) uniform vec3 metaball33;
layout(location = 40) uniform vec3 metaball34;
layout(location = 41) uniform vec3 metaball35;
layout(location = 42) uniform vec3 metaball36;
layout(location = 43) uniform vec3 metaball37;
layout(location = 44) uniform vec3 metaball38;
layout(location = 45) uniform vec3 metaball39;
layout(location = 46) uniform vec3 metaball40;

float dist(vec2 p0, vec2 pf){return sqrt((pf.x-p0.x)*(pf.x-p0.x)+(pf.y-p0.y)*(pf.y-p0.y));}

float addSum(vec3 metaball, float x, float y) {
  float dx = metaball.x - x;
  float dy = metaball.y - y;
  float radius = metaball.z;
  return ((radius * radius) / (dx * dx + dy * dy));
}

void main(){
  float x = gl_FragCoord.x;
  float y = gl_FragCoord.y;
  float sum = 0.0;

  // i know this is painful
  sum += addSum(metaball1, x, y);
  sum += addSum(metaball1, x, y);
  sum += addSum(metaball2, x, y);
  sum += addSum(metaball3, x, y);
  sum += addSum(metaball4, x, y);
  sum += addSum(metaball5, x, y);
  sum += addSum(metaball6, x, y);
  sum += addSum(metaball7, x, y);
  sum += addSum(metaball8, x, y);
  sum += addSum(metaball9, x, y);
  sum += addSum(metaball10, x, y);
  sum += addSum(metaball11, x, y);
  sum += addSum(metaball12, x, y);
  sum += addSum(metaball13, x, y);
  sum += addSum(metaball14, x, y);
  sum += addSum(metaball15, x, y);
  sum += addSum(metaball16, x, y);
  sum += addSum(metaball17, x, y);
  sum += addSum(metaball18, x, y);
  sum += addSum(metaball19, x, y);
  sum += addSum(metaball20, x, y);
  sum += addSum(metaball21, x, y);
  sum += addSum(metaball22, x, y);
  sum += addSum(metaball23, x, y);
  sum += addSum(metaball24, x, y);
  sum += addSum(metaball25, x, y);
  sum += addSum(metaball26, x, y);
  sum += addSum(metaball27, x, y);
  sum += addSum(metaball28, x, y);
  sum += addSum(metaball29, x, y);
  sum += addSum(metaball30, x, y);
  sum += addSum(metaball31, x, y);
  sum += addSum(metaball32, x, y);
  sum += addSum(metaball33, x, y);
  sum += addSum(metaball34, x, y);
  sum += addSum(metaball35, x, y);
  sum += addSum(metaball36, x, y);
  sum += addSum(metaball37, x, y);
  sum += addSum(metaball38, x, y);
  sum += addSum(metaball39, x, y);
  sum += addSum(metaball40, x, y);

  if(sum > minimumGlowSum) {
    // calculate gradient color based on distance to gradient center
    float t = dist(gradientPosition, gl_FragCoord.xy)/gradientRadius;
    vec3 color = mix(color1, color2, t);

    if(sum >= 1.0) {
      fragColor = vec4(color, 1.0);
    } else {
      float n = ((sum - minimumGlowSum) / (1.0 - minimumGlowSum)) * glowIntensity;
      fragColor = vec4(color * n, n);  
    }
  } else {
    fragColor = vec4(0, 0, 0, 0);
  }
}