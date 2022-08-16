// https://openprocessing.org/sketch/1440964

// ----------------------------------------
// Pendulum - People
// ----------------------------------------
// I started writing this code for #つぶやきProcessing tweets
// but I realized it can't be done in 280 characters.
// It is a bare bones script tweaked for 800x80 display.
// Ask me if you need more info.
// ----------------------------------------
float t = 0;
float  M = 56.8;
float  m = 1;
void setup() {
  size(800, 800);
}
void draw() {
  t++;
  background(0);
  stroke(255);
  strokeWeight(.5);
  scale(2.5);

  for (float x = 48; x < (270 * 0.5); x += 6.5) {
    rect(x, 18, 5, 7.5, 1, 1, .5, .5);
    rect(x + .5, 24, 1.4, 9, 6, 6, .5, .75);
    rect(x + 3.2, 24, 1.4, 9, 6, 6, .5, .75);
  }

  push();
  translate(45.7, 18.2);
  //rotate(sin(t / 15) < 0 ? sin(t / 7.5) * (sin(t / 7.5) > 0) : 0);
  float s;
  if (sin(t / 15) < 0) {
    if (sin(t / 7.5) > 0) {
      s = sin(t / 7.5);
    } else {
      s = 0;
    }
  } else {
    s = 0;
  }
  rotate(s);
  rect(0, 0, .75, 7.2, 6);
  pop();

  push();
  translate(275.5 * 0.5, 18.2);
  //rotate(sin(t / 15) > 0 ? -sin(t / 7.5) * (sin(t / 7.5) > 0) : 0);
  if (sin(t / 15) > 0) {
    if (sin(t / 7.5) > 0) {
      s = -sin(t / 7.5);
    } else {
      s = 0;
    }
  } else {
    s = 0;
  }
  rotate(s);
  rect(0, 0, .75, 7.2, 6);
  pop();

  push();
  translate(M, 21);
  for (float x = 0; x < (34 * 0.5); x++) {
    circle(x * 6.5, -7, 4);
  }
  pop();
  q(50.5, 1);
  q((220.8 * 0.5), 4);
}
void q(float v, float d) {
  translate(v, 0);
  float r = sin(t / 15);
  push();
  //rotate(h = d == 1 ? r * (r > 0) : r * (r < 0));
  float h;
  if (d == 1) {
    if (r > 0) {
      h = r;
    } else {
      h = 0;
    }
  } else {
    if (r < 0) {
      h = r;
    } else {
      h = 0;
    }
  }
  rotate(h);
  //  h > 0 && m > 0 ? m = -3 : h < 0 && m < 0 ? m = 3 : 0;
  if (h > 0 && m > 0) {
    m = -3;
  } else {
    if (h < 0 && m < 0) {
      m = 3;
    }
  }
  M += m *= .68;
  line(0, 0, 0, 15);
  circle(0, 14, 4);
  pop();
}
