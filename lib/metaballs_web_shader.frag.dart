const String fragmentShaderSource = """precision highp float;

// required for all gradients
uniform int gradientType;
uniform vec4 colors[32];
uniform float stops[32];
uniform int gradientStops;
uniform int tileMode;

// required for linear gradient
uniform vec2 gradientStart;
uniform vec2 gradientEnd;

// required for radial gradient
uniform float radius;

// required for sweeping gradient
uniform float bias;
uniform float scale;

// metaball values 
uniform vec3 metaballs[138];
uniform int metaballCount;
uniform float minimumGlowSum;
uniform float glowIntensity;
uniform float time;

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

vec4 getGradientColor(vec2 coords) {
  float t = 0.0;

  if(gradientType == 0) {
    // linear gradient
    float len = length(gradientEnd - gradientStart);
    float dot = dot(
      coords - gradientStart,
      gradientEnd - gradientStart
    );
    t = dot / (len * len);
  } else if(gradientType == 1) {
    // radial gradient
    float len = length(coords - gradientStart);
    t = len / radius;
  } else if(gradientType == 2) {
    // sweep gradient
    vec2 coord = coords - gradientStart;
    float angle = atan(-coord.y, -coord.x);

    t = (angle * 0.1591549430918 + 0.5 + bias) * scale;
  } else {
    // single color
    return colors[0];
  }

  // apply tilemode

  if ((t < 0.0 || t > 1.0) && tileMode == 3) {
    // decal
    return vec4(0);
  } else if (tileMode == 0) {
    // clamp
    t = clamp(t, 0.0, 1.0);
  } else if (tileMode == 1) {
    // repeat
    t = fract(t);
  } else if (tileMode == 2) {
    // mirror
    float t1 = t - 1.0;
    float t2 = t1 - 2.0 * floor(t1 * 0.5) - 1.0;
    t = abs(t2);
  }

  // convert point on gradient to color

  if (gradientStops == 1) {
    return colors[0];
  } else if (gradientStops > 1) {
    vec4 returnColor = colors[0];
    for (int i = 0; i < 32 - 1; i++) {
      if (i < gradientStops - 1) {
        returnColor = mix(returnColor, colors[i + 1], smoothstep(
          stops[i],
          stops[i + 1],
          t
        ));
      } else {
        break;
      }
    }
    return returnColor;
  }
}

void main(){
  vec2 coords = gl_FragCoord.xy;

  float sum = 0.0;

  for (int i = 0; i < 138; i++) {
    if(i < metaballCount) {
      vec3 metaball = metaballs[i];
      float dx = metaball.x - coords.x;
      float dy = metaball.y - coords.y;
      float radius = metaball.z;
      sum += ((radius * radius) / (dx * dx + dy * dy));
    } else {
      break;
    }
  }

  if(sum >= 1.0) {
    gl_FragColor = getGradientColor(coords);
  } else if(sum > minimumGlowSum) {
    float n = ((sum - minimumGlowSum) / (1.0 - minimumGlowSum)) * glowIntensity;
    gl_FragColor = getGradientColor(coords) * n + ((noise(vec4(coords, time, 0.0)) - 0.5) / 255.0);
  } else {
    gl_FragColor = vec4(0, 0, 0, 0);
  }
}""";