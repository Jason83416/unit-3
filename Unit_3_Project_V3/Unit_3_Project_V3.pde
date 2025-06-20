
// Jason Zhao – Programming 11

int toolbarWidth = 100;

color c1, c2, c3, c4, c5, c6;
color currentColor;
float currentThickness = 5;

float sliderX = 50, sliderY = 280, sliderH = 150;

int currentTool = 0;

PImage savedImg;

void setup() {
  size(800, 600);
  background(255);

  c1 = color(255, 0, 0);
  c2 = color(0, 255, 0);
  c3 = color(0, 0, 255);
  c4 = color(255, 255, 0);
  c5 = color(255, 0, 255);
  c6 = color(0, 255, 255);

  currentColor = c1;
  currentThickness = 5;
}

void draw() {
  // Draw cool gradient side toolbar
  for (int i = 0; i < height; i++) {
    float t = map(i, 0, height, 0, 1);
    stroke(lerpColor(color(0, 120, 255), color(180, 0, 255), t));
    line(0, i, toolbarWidth, i);
  }

  drawButtons();
}

void drawButtons() {
  circleButton(c1, 50,  40, 30);
  circleButton(c2, 50,  90, 30);
  circleButton(c3, 50, 140, 30);
  circleButton(c4, 50, 190, 30);
  circleButton(c5, 50, 240, 30);
  circleButton(c6, 50, 290, 30);

  stroke(0);
  line(sliderX, sliderY, sliderX, sliderY + sliderH);
  float handleY = map(currentThickness, 1, 20, sliderY + sliderH, sliderY);
  circleButton(color(150), sliderX, handleY, 16);

  stroke(0);
  strokeWeight(currentThickness);
  fill(currentColor);
  ellipse(50, 460, 30, 30);
  strokeWeight(1);

  circleButton(currentTool == 1 ? color(150, 200, 255) : color(200), 50, 510, 30);
  rectButton(currentTool == 2 ? color(150, 200, 255) : color(200), 35, 545, 30, 30);

  rectButton(color(200), 20, 600 - 90, 60, 20);
  rectButton(color(200), 20, 600 - 60, 60, 20);
  rectButton(color(200), 20, 600 - 30, 60, 20);

  fill(0);
  textSize(12);
  textAlign(CENTER, CENTER);
  text("New",  50, 600 - 80);
  text("Save", 50, 600 - 50);
  text("Load", 50, 600 - 20);
}

void mousePressed() {
  if (mouseX < toolbarWidth) {
    if (overCircle(50,  40, 30))  { currentColor = c1; currentTool = 0; }
    if (overCircle(50,  90, 30))  { currentColor = c2; currentTool = 0; }
    if (overCircle(50, 140, 30))  { currentColor = c3; currentTool = 0; }
    if (overCircle(50, 190, 30))  { currentColor = c4; currentTool = 0; }
    if (overCircle(50, 240, 30))  { currentColor = c5; currentTool = 0; }
    if (overCircle(50, 290, 30))  { currentColor = c6; currentTool = 0; }

    if (mouseX >= sliderX - 8 && mouseX <= sliderX + 8 &&
        mouseY >= sliderY && mouseY <= sliderY + sliderH) {
      float t = constrain((sliderY + sliderH - mouseY) / sliderH, 0, 1);
      currentThickness = lerp(1, 20, t);
    }

    if (overCircle(50, 510, 30))  currentTool = (currentTool == 1) ? 0 : 1;
    if (overRect(35, 545, 30, 30)) currentTool = (currentTool == 2) ? 0 : 2;

    if (overRect(20, 600 - 90, 60, 20)) {
      fill(255); noStroke();
      rect(toolbarWidth, 0, width - toolbarWidth, height);
    }
    if (overRect(20, 600 - 60, 60, 20)) {
      savedImg = get(toolbarWidth, 0, width - toolbarWidth, height);
    }
    if (overRect(20, 600 - 30, 60, 20) && savedImg != null) {
      image(savedImg, toolbarWidth, 0);
    }
  }
}

void mouseDragged() {
  if (mouseX < toolbarWidth) {
    if (mouseX >= sliderX - 8 && mouseX <= sliderX + 8 &&
        mouseY >= sliderY && mouseY <= sliderY + sliderH) {
      float t = constrain((sliderY + sliderH - mouseY) / sliderH, 0, 1);
      currentThickness = lerp(1, 20, t);
    }
  } else {
    if (currentTool == 0) {
      stroke(currentColor);
      strokeWeight(currentThickness);
      line(pmouseX, pmouseY, mouseX, mouseY);
    } else {
      noStroke();
      fill(currentColor);
      float s = currentThickness * 5;
      if (currentTool == 1) ellipse(mouseX, mouseY, s, s);
      else if (currentTool == 2) rect(mouseX - s/2, mouseY - s/2, s, s);
    }
  }
}

void circleButton(color col, float x, float y, float d) {
  if (overCircle(x, y, d)) {
    stroke(0); strokeWeight(2);
  } else {
    noStroke();
  }
  fill(col);
  ellipse(x, y, d, d);
}

void rectButton(color col, float x, float y, float w, float h) {
  if (overRect(x, y, w, h)) {
    stroke(0); strokeWeight(2);
  } else {
    noStroke();
  }
  fill(col);
  rect(x, y, w, h);
}

boolean overCircle(float cx, float cy, float d) {
  return dist(mouseX, mouseY, cx, cy) < d/2;
}

boolean overRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w &&
         mouseY >= y && mouseY <= y + h;
}   
