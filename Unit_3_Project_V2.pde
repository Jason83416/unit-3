// Simple Drawing App with Toolbar, Buttons, Slider, Stamps, and Save/Load
// Jason Zhao – Programming 11

int toolbarHeight = 100;        // Height of the top toolbar

// Six preset colors
color c1, c2, c3, c4, c5, c6;
color currentColor;             // Currently selected drawing color
float currentThickness = 5;     // Currently selected stroke weight (1..20)

// Slider geometry
float sliderX = 320, sliderY = 40, sliderW = 150;

// Stamp tool toggles
boolean stampCircle = false;
boolean stampRect   = false;

// Saved drawing snapshot
PImage savedImg;

void setup() {
  size(800, 600);
  background(255);  // White drawing area

  // Define the six color buttons
  c1 = color(255, 0, 0);    // Red
  c2 = color(0, 255, 0);    // Green
  c3 = color(0, 0, 255);    // Blue
  c4 = color(255, 255, 0);  // Yellow
  c5 = color(255, 0, 255);  // Magenta
  c6 = color(0, 255, 255);  // Cyan

  // Initialize brush settings
  currentColor     = c1;
  currentThickness = 5;
}

void draw() {
  // Draw the toolbar background
  noStroke();
  fill(220);
  rect(0, 0, width, toolbarHeight);

  // Draw all buttons, the slider, the indicator, and labels
  drawButtons();
}

// ——————————————————————————————————————————————————————————
// Draw all UI controls in the toolbar
// ——————————————————————————————————————————————————————————
void drawButtons() {
  // 1) Color buttons
  circleButton(c1,  30, 30, 30);
  circleButton(c2,  80, 30, 30);
  circleButton(c3, 130, 30, 30);
  circleButton(c4, 180, 30, 30);
  circleButton(c5, 230, 30, 30);
  circleButton(c6, 280, 30, 30);

  // 2) Thickness slider track
  stroke(0);
  line(sliderX, sliderY, sliderX + sliderW, sliderY);

  // 3) Slider handle (tactile circle)
  float handleX = map(currentThickness, 1, 20, sliderX, sliderX + sliderW);
  circleButton(color(150), handleX, sliderY, 16);

  // 4) Indicator showing current color & thickness
  stroke(0);
  strokeWeight(currentThickness);
  fill(currentColor);
  ellipse(550, 30, 30, 30);
  strokeWeight(1);

  // 5) Stamp tool buttons (circle vs. rectangle)
  circleButton(stampCircle ? color(150, 200, 255) : color(200),
               650, 30, 30);
  rectButton  (stampRect   ? color(150, 200, 255) : color(200),
               685, 15, 30, 30);

  // 6) New / Save / Load buttons
  rectButton(color(200), 600, 60, 50, 20);
  rectButton(color(200), 660, 60, 50, 20);
  rectButton(color(200), 720, 60, 50, 20);

  // Labels for New, Save, Load
  fill(0);
  textSize(12);
  text("New",  600 + 25, 60 + 12);
  text("Save", 660 + 25, 60 + 12);
  text("Load", 720 + 25, 60 + 12);
}

// ——————————————————————————————————————————————————————————
// Handle mouse clicks on toolbar controls
// ——————————————————————————————————————————————————————————
void mousePressed() {
  if (mouseY < toolbarHeight) {
    // Color buttons
    if (overCircle(30, 30, 30))  { currentColor = c1; stampCircle = stampRect = false; }
    if (overCircle(80, 30, 30))  { currentColor = c2; stampCircle = stampRect = false; }
    if (overCircle(130,30, 30))  { currentColor = c3; stampCircle = stampRect = false; }
    if (overCircle(180,30, 30))  { currentColor = c4; stampCircle = stampRect = false; }
    if (overCircle(230,30, 30))  { currentColor = c5; stampCircle = stampRect = false; }
    if (overCircle(280,30, 30))  { currentColor = c6; stampCircle = stampRect = false; }

    // Recompute handle X locally
    float hx = map(currentThickness, 1, 20, sliderX, sliderX + sliderW);
    // Slider handle click
    if (overCircle(hx, sliderY, 16)) {
      float t = constrain((mouseX - sliderX) / sliderW, 0, 1);
      currentThickness = lerp(1, 20, t);
    }

    // Stamp tool toggles
    if (overCircle(650, 30, 30))      { stampCircle = !stampCircle; if (stampCircle) stampRect = false; }
    if (overRect(685, 15, 30, 30))    { stampRect   = !stampRect;   if (stampRect)   stampCircle = false; }

    // New / Save / Load
    if (overRect(600, 60, 50, 20)) {
      fill(255); noStroke();
      rect(0, toolbarHeight, width, height - toolbarHeight);
    }
    if (overRect(660, 60, 50, 20)) {
      savedImg = get(0, toolbarHeight, width, height - toolbarHeight);
    }
    if (overRect(720, 60, 50, 20) && savedImg != null) {
      image(savedImg, 0, toolbarHeight);
    }
  }
}


// ——————————————————————————————————————————————————————————
// Handle drawing or stamping when dragging below toolbar
// ——————————————————————————————————————————————————————————
void mouseDragged() {
  if (mouseY > toolbarHeight) {
    // Freehand “squiggly” drawing
    if (!stampCircle && !stampRect) {
      stroke(currentColor);
      strokeWeight(currentThickness);
      line(pmouseX, pmouseY, mouseX, mouseY);
    }
    // Circle stamp
    else if (stampCircle) {
      noStroke();
      fill(currentColor);
      float s = currentThickness * 5;
      ellipse(mouseX, mouseY, s, s);
    }
    // Rectangle stamp
    else if (stampRect) {
      noStroke();
      fill(currentColor);
      float s = currentThickness * 5;
      rect(mouseX - s/2, mouseY - s/2, s, s);
    }
  }
}

// ——————————————————————————————————————————————————————————
// Draws a tactile circular button
// ——————————————————————————————————————————————————————————
void circleButton(color col, float x, float y, float d) {
  if (overCircle(x, y, d)) {
    stroke(0);
    strokeWeight(2);
  } else {
    noStroke();
  }
  fill(col);
  ellipse(x, y, d, d);
}

// ——————————————————————————————————————————————————————————
// Draws a tactile rectangular button
// ——————————————————————————————————————————————————————————
void rectButton(color col, float x, float y, float w, float h) {
  if (overRect(x, y, w, h)) {
    stroke(0);
    strokeWeight(2);
  } else {
    noStroke();
  }
  fill(col);
  rect(x, y, w, h);
}

// ——————————————————————————————————————————————————————————
// Utility: is mouse over a circle?
// ——————————————————————————————————————————————————————————
boolean overCircle(float cx, float cy, float d) {
  return dist(mouseX, mouseY, cx, cy) < d/2;
}

// ——————————————————————————————————————————————————————————
// Utility: is mouse over a rectangle?
// ——————————————————————————————————————————————————————————
boolean overRect(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w &&
         mouseY >= y && mouseY <= y + h;
}
