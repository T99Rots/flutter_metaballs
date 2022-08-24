const vertexShaderSrc = `
attribute vec2 position;

void main() {
  // position specifies only x and y.
  // We set z to be 0.0, and w to be 1.0
  gl_Position = vec4(position, 0.0, 1.0);
}
`;

const fragmentShaderSrc = `
precision highp float;

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
uniform vec3 metaballs[128];
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

  for (int i = 0; i < 128; i++) {
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
}
`;

class Vec4 {
  constructor(x, y, z, w) {
    this.x = x ?? 0;
    this.y = y ?? 0;
    this.z = z ?? 0;
    this.w = w ?? 0;
  }
}

class Vec3 {
  constructor(x, y, z) {
    this.x = x ?? 0;
    this.y = y ?? 0;
    this.z = z ?? 0;
  }
}

class Vec2 {
  constructor(x, y) {
    this.x = x ?? 0;
    this.y = y ?? 0;
  }
}

class FLutterMetaballsWebRenderer {
  constructor(canvas) {
    this._canvas = canvas;
    const gl = this._gl = canvas.getContext('webgl2');

    const vertexShader = this._compileShader(vertexShaderSrc, gl.VERTEX_SHADER);
    const fragmentShader = this._compileShader(fragmentShaderSrc, gl.FRAGMENT_SHADER);

    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    gl.useProgram(program);

    const vertexData = new Float32Array([
      -1.0, 1.0, // top left
      -1.0, -1.0, // bottom left
      1.0, 1.0, // top right
      1.0, -1.0, // bottom right
    ]);
    const vertexDataBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, vertexDataBuffer);
    gl.bufferData(gl.ARRAY_BUFFER, vertexData, gl.STATIC_DRAW);

    const positionHandle = this._getAttribLocation(program, 'position');
    gl.enableVertexAttribArray(positionHandle);
    gl.vertexAttribPointer(positionHandle,
      2, // position is a vec2
      gl.FLOAT, // each component is a float
      gl.FALSE, // don't normalize values
      2 * 4, // two 4 byte float components per vertex
      0 // offset into each span of vertex data
    );

    this._gradientTypeHandle = this._getUniformLocation(program, 'gradientType'); // int gradientType;
    this._colorsHandle = this._getUniformLocation(program, 'colors'); // vec4 colors[32];
    this._stopsHandle = this._getUniformLocation(program, 'stops'); // float stops[32];
    this._gradientStopsHandle = this._getUniformLocation(program, 'gradientStops'); // int gradientStops;
    this._tileModeHandle = this._getUniformLocation(program, 'tileMode'); // int tileMode;
    
    // required for linear gradient
    this._gradientStartHandle = this._getUniformLocation(program, 'gradientStart'); // vec2 gradientStart;
    this._gradientEndHandle = this._getUniformLocation(program, 'gradientEnd'); // vec2 gradientEnd;
    
    // required for radial gradient
    this._radiusHandle = this._getUniformLocation(program, 'radius'); // float radius;
    
    // required for sweeping gradient
    this._biasHandle = this._getUniformLocation(program, 'bias'); // float bias;
    this._scaleHandle = this._getUniformLocation(program, 'scale'); // float scale;
    
    // metaball values 
    this._metaballsHandle = this._getUniformLocation(program, 'metaballs'); // vec3 metaballs[128];
    this._metaballCountHandle = this._getUniformLocation(program, 'metaballCount'); // int metaballCount;
    this._minimumGlowSumHandle = this._getUniformLocation(program, 'minimumGlowSum'); // float minimumGlowSum;
    this._glowIntensityHandle = this._getUniformLocation(program, 'glowIntensity'); // float glowIntensity;
    this._timeHandle = this._getUniformLocation(program, 'time'); // float time;
  }

  _compileShader (shaderSource, shaderType) {
    const shader = this._gl.createShader(shaderType);
    this._gl.shaderSource(shader, shaderSource);
    this._gl.compileShader(shader);
  
    if (!this._gl.getShaderParameter(shader, this._gl.COMPILE_STATUS)) {
      throw "Shader compile failed with: " + this._gl.getShaderInfoLog(shader);
    }
  
    return shader;
  }

  _getUniformLocation (program, name) {
    const uniformLocation = this._gl.getUniformLocation(program, name);
    if (uniformLocation === -1) {
      throw 'Can not find uniform ' + name + '.';
    }
    return uniformLocation;
  }

  _getAttribLocation (program, name) {
    const attributeLocation = this._gl.getAttribLocation(program, name);
    if (attributeLocation === -1) {
      throw 'Can not find attribute ' + name + '.';
    }
    return attributeLocation;
  }

  _coeffFromAngles (startAngle, endAngle) {
    const tBias = -(startAngle / (Math.PI * 2));
    const tScale = 1 / ((endAngle / (Math.PI * 2)) + tBias);
    return { tBias, tScale };
  }

  draw(
    // metaballs values
    metaballs, // List<Vec3>
    minimumGlowSum, // double
    glowIntensity, // double
    time, // double

    // general gradient values
    gradientType, // int
    colors, // List<Vec4>
    stops, // List<double>
    tileMode, // int

    // linear gradient values
    gradientStart, // Vec2
    gradientEnd, // Vec2

    // radial gradient values
    radius, // double

    // sweep gradient values
    bias, // double
    scale, // double
  ) {
    // metaballs values
    const metaballData = new Float32Array(3*128);

    for(let i = 0; i < metaballs.length; i++) {
      const metaball = metaballs[i];
      const offset = i*3;
      metaballData[offset] = metaball.x;
      metaballData[offset + 1] = metaball.y;
      metaballData[offset + 2] = metaball.z;
    }

    gl.uniform3fv(this._metaballsHandle, metaballData);
    gl.uniform1i(this._metaballCountHandle, metaballs.length);
    gl.uniform1f(this._minimumGlowSumHandle, minimumGlowSum);
    gl.uniform1f(this._glowIntensityHandle, glowIntensity);
    gl.uniform1f(this._timeHandle, time);

    // general gradient values
    const colorData = new Float32Array(4 * 32);
    for(let i = 0; i < colors; i++) {
      const offset = i * 4;
      const color = colors[i].vec4;
      colorData[offset] = color.x;
      colorData[offset + 1] = color.y;
      colorData[offset + 2] = color.z;
      colorData[offset + 3] = color.w;
    }

    const stopsData = new Float32Array(32);
    for(let i = 0; i < stops.length; i++) {
      stopsData[i] = stops[i];
    }

    gl.uniform4fv(this._colorsHandle, colorData);
    gl.uniform1i(this._gradientTypeHandle, gradientType);
    gl.uniform1fv(this._stopsHandle, stopsData);
    gl.uniform1i(this._gradientStopsHandle, stops.length);
    gl.uniform1i(this._tileModeHandle, tileMode);

    // linear gradient values
    gl.uniform2f(this._gradientStartHandle, gradientStart);
    gl.uniform2f(this._gradientEndHandle, gradientEnd);

    // radial gradient values
    gl.uniform1f(this._radiusHandle, radius);

    // sweep gradient values
    gl.uniform1f(this._biasHandle, bias);
    gl.uniform1f(this._scaleHandle, scale);

    //Draw
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  }
}