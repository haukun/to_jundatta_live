// こちらがオリジナルです。
// 【作者】はぅ君さん
// 【作品名】ShadowDemoScene
// https://openprocessing.org/sketch/1732323

// 敗北宣言...orz
// 私には太刀打ちできませんでした...orz

float t=0;
void setup() {
  size(720, 720, P3D);

  // 激重＼(^_^)／
  // 。。。しかも影に対する効果が見えない...orz
  // ⇒
  // （projection == transformみたいな感じの最適化はしない）
  // （もともとのOpenGLイメージにview行列やmodel行列の扱いを戻す）
  //hint(DISABLE_OPTIMIZED_STROKE);
}

void draw() {
  translate(width/2, height/2);

  t+=.02;
  _systemInit();
  background(0);
  noStroke();
  ambientLight(0, 0, 0);
  lightFalloff(0, 0, 0.0001);
  setShadowNormalVector(new PVector(0, -1, 0));

  camera(cos(t/2.0f)*300, -200+sin(t*.5)*200-100, sin(t/2.0f)*300, 0, 0, 0, 0, 1, 0);

  addLight(255, 255, 255, new PVector(cos(-t)*50, -100 + 50*sin(t/2.0f), sin(-t)*50));
  addLight(255, 64, 64, new PVector(cos(t)*200, -100, sin(t)*200));
  addLight(32, 32, 128, new PVector(cos(t)*200, -10-abs(sin(t*5))*50, (cos(t)*200) * 1.25f));

  //  drawGround
  float F=0;
  for (float x=-900; x<900; x+=100) {
    F++;
    for (float z=-900; z<900; z+=100) {
      F++;
      push();
      translate(x, .1, z);
      rotateX(PI/2.0f);
      fill((F%2)*192, 64, 192);
      square(0, 0, 100);
      pop();
    }
  }

  //  drawWall
  for (float r=-PI/8.0f; r<TAU+PI/8.0f; r+=PI/4.0f) {
    drawWall(cos(r)*150, 0-pow(tan(sin(t*.5+r/2.0f)/1.2), 8)*50, sin(r)*150, 50, r+PI/2.0f+(t%(TAU*2)>TAU?sin(t):0));
  }

  //  draw light wall
  drawLightGround();
}

void drawWall(float x, float y, float z, float l, float rot) {
  push();

  push();
  translate(x, y-l, z);
  rotateY(-rot+PI);
  box(2*l, 2*l, 0.0001f);
  pop();

  //  draw shadow
  fill(0, 128);
  for (int i=0; i<_lights.size(); i++) {
    push();
    translate(x, y-l, z);
    rotateY(-rot+PI);
    // あたまの中の置き換えはこうなのですが...orz
    // ぜんぜんうまくいかにゃい＼(^_^)／
    //shadowMatrix(_lights.get(i), _normalVector, new PVector(0, -_wallCount/100, 0));
    float srcX = 2*l;
    float srcY = 2*l;
    float srcZ = 0.0001f;
    //box(srcX, srcY, srcZ);
    PMatrix3D m = getShadowMatrix(_lights.get(i), _normalVector, new PVector(0, -_wallCount/100, 0));
    float dstX = m.multX(srcX, srcY, srcZ);
    float dstY = m.multY(srcX, srcY, srcZ);
    float dstZ = m.multZ(srcX, srcY, srcZ);
    box(dstX, dstY, dstZ);

    _wallCount++;
    pop();
  }
  pop();
}

float _wallCount = 0;
ArrayList<PVector> _lights;
PVector _normalVector = new PVector(0, 0, 0);
void _systemInit() {
  _wallCount = 0;
  _lights = new ArrayList();
}
void addLight(float r, float g, float b, PVector vector) {
  pointLight(r, g, b, vector.x, vector.y, vector.z);
  _lights.add(vector);

  push();
  noStroke();
  //emissiveMaterial(r, g, b);
  emissive(r, g, b);
  fill(r, g, b);
  translate(vector.x, vector.y, vector.z);
  sphere(5);
  pop();
}
void setShadowNormalVector(PVector normalVector) {
  _normalVector = normalVector;
}
void drawLightGround() {
  push();
  blendMode(ADD);
  fill(64);
  translate(0, -1, 0);
  rotateX(PI/2.0f);
  //plane(1000, 1000);
  box(1000, 1000, 1);
  pop();
}

// l : light position
// n : normal vector
// p : target point position
void shadowMatrix(PVector l, PVector n, PVector p) {
  //applyMatrix(getShadowMatrix(l, n, p));
}

// from @tercel_s
//  https://twitter.com/tercel_s/status/1589937810626469888
//  Thanks ;)
PMatrix3D getShadowMatrix(PVector l, PVector n, PVector p) {
  var d = n.dot(new PVector(l.x, l.y, l.z).sub(p));
  var np = n.dot(p);
  var nl = n.dot(l);

  //return [-n.x * l.x + d, -n.x * l.y, -n.x * l.z, -n.x,
  //  -n.y * l.x, -n.y * l.y + d, -n.y * l.z, -n.y,
  //  -n.z * l.x, -n.z * l.y, -n.z * l.z + d, -n.z,
  //  np*l.x, np*l.y, np*l.z, nl];
  return new PMatrix3D(
    -n.x * l.x + d, -n.x * l.y, -n.x * l.z, -n.x,
    -n.y * l.x, -n.y * l.y + d, -n.y * l.z, -n.y,
    -n.z * l.x, -n.z * l.y, -n.z * l.z + d, -n.z,
    np*l.x, np*l.y, np*l.z, nl);
}
