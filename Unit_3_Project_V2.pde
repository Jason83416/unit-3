// ---------------------------------------------------------
// Simplified Drawing Tool with Color Buttons, Stamps (Circle, Rect, Pine Tree),
// Thickness Slider, and New/Save/Load
// ---------------------------------------------------------

PGraphics canvas; // Offscreen drawing surface
color currentColor = color(0);
float currentStrokeWeight = 3;

// We'll track the "stamp mode" with an integer instead of separate booleans:
// 0 = no stamp (just drawing lines)
// 1 = circle stamp
// 2 = rectangle stamp
// 3 = pine tree stamp
int stampMode = 0;

// Positions/sizes for toolbar elements
int toolbarHeight = 100;
int sliderX = 350, sliderY = 30, sliderW = 100;
float sliderHandleX; // We'll track the handle's x position

// Some constants for button geometry
int btnSize = 30;
int margin = 10;
int colorCount = 6;
color[] colors = {
color(255,0,0), color(0,255,0), color(0,0,255),
color(255,255,0), color(255,0,255), color(0,255,255)
};

void setup() {
size(800, 600);
canvas = createGraphics(width, height);
clearCanvas();
// Initialize slider handle to match currentStrokeWeight in [1..20]
sliderHandleX = map(currentStrokeWeight, 1, 20, sliderX, sliderX + sliderW);
}

void draw() {
background(220);
drawToolbar();
image(canvas, 0, toolbarHeight); // Show the offscreen canvas below the toolbar
}

// -------------------------------------------------------------------------
// MOUSE EVENTS
// -------------------------------------------------------------------------
void mousePressed() {
// If we clicked in the top toolbar area
if (mouseY < toolbarHeight) {
handleToolbarClick();
} else {
// If we clicked in the drawing area and we have a stamp selected
if (stampMode > 0) {
placeStamp(mouseX, mouseY);
}
}
}

void mouseDragged() {
// If dragging in the toolbar region, maybe move the slider
if (mouseY < toolbarHeight) {
updateSliderHandle();
}
// Otherwise, if no stamp is active, draw lines
else if (stampMode == 0) {
canvas.beginDraw();
canvas.stroke(currentColor);
canvas.strokeWeight(currentStrokeWeight);
canvas.line(pmouseX, pmouseY - toolbarHeight, mouseX, mouseY - toolbarHeight);
canvas.endDraw();
}
}

// -------------------------------------------------------------------------
// TOOLBAR UI
// -------------------------------------------------------------------------
void drawToolbar() {
// Toolbar background
fill(200);
noStroke();
rect(0, 0, width, toolbarHeight);

// 1) Draw color buttons
for (int i=0; i<colorCount; i++) {
float xPos = margin + i*(btnSize+margin);
float yPos = margin;
boolean hover = mouseOverRect(xPos, yPos, btnSize, btnSize);
if (hover) { stroke(0); strokeWeight(2); } else { noStroke(); }
fill(colors[i]);
rect(xPos, yPos, btnSize, btnSize);
}

// 2) Draw circle, rect, pine tree buttons
drawStampButton(210, "Circle", 1, stampMode==1);
drawStampButton(250, "Rect", 2, stampMode==2);
drawStampButton(width - 40, "Pine", 3, stampMode==3);

// 3) Thickness slider
stroke(0); strokeWeight(1);
line(sliderX, sliderY + 5, sliderX + sliderW, sliderY + 5);
float handleR = 8;
fill(mouseOverCircle(sliderHandleX, sliderY+5, handleR) ? 150 : 100);
noStroke();
ellipse(sliderHandleX, sliderY+5, 2*handleR, 2*handleR);
fill(0);
text("Thickness: " + nf(currentStrokeWeight, 1, 1), sliderX + sliderW + 15, sliderY + 8);

// 4) Indicator shape (shows current color and thickness)
stroke(0);
strokeWeight(currentStrokeWeight);
fill(currentColor);
ellipse(420, 25, 25, 25);

// 5) New, Save, Load
drawTextButton(500, "New");
drawTextButton(550, "Save");
drawTextButton(600, "Load");
}

// Helper for drawing a text-based button
void drawTextButton(float x, String label) {
boolean hov = mouseOverRect(x, 10, 40, 30);
if (hov) { stroke(0); strokeWeight(2); } else { noStroke(); }
fill(200);
rect(x, 10, 40, 30);
fill(0);
text(label, x+8, 30);
}

// Helper for drawing stamp toggle buttons
void drawStampButton(float x, String label, int modeValue, boolean on) {
boolean hov = mouseOverRect(x, 10, btnSize, btnSize);
stroke(0); strokeWeight(hov ? 2 : 1);
fill(on ? color(180, 200, 255) : 220);
rect(x, 10, btnSize, btnSize);

// Just a simple label in black for clarity
fill(0);
textSize(10);
textAlign(CENTER, CENTER);
text(label, x + btnSize/2, 10 + btnSize/2);
textAlign(LEFT, BASELINE);
}

// -------------------------------------------------------------------------
// TOOLBAR CLICK HANDLER
// -------------------------------------------------------------------------
void handleToolbarClick() {
// 1) Check color buttons
for (int i=0; i<colorCount; i++) {
float xPos = margin + i*(btnSize+margin);
float yPos = margin;
if (mouseOverRect(xPos, yPos, btnSize, btnSize)) {
currentColor = colors[i];
stampMode = 0; // turning off any stamp
return;
}
}

// 2) Check stamp buttons
if (mouseOverRect(210, 10, btnSize, btnSize)) {
stampMode = (stampMode == 1) ? 0 : 1; // toggle circle
return;
}
if (mouseOverRect(250, 10, btnSize, btnSize)) {
stampMode = (stampMode == 2) ? 0 : 2; // toggle rect
return;
}
if (mouseOverRect(width - 40, 10, btnSize, btnSize)) {
stampMode = (stampMode == 3) ? 0 : 3; // toggle pine
return;
}

// 3) Check New, Save, Load
if (mouseOverRect(500, 10, 40, 30)) { clearCanvas(); return; }
if (mouseOverRect(550, 10, 40, 30)) { saveCanvas(); return; }
if (mouseOverRect(600, 10, 40, 30)) { loadCanvas(); return; }

// 4) Possibly the slider handle
if (mouseOverCircle(sliderHandleX, sliderY+5, 8)) {
updateSliderHandle();
}
}

// -------------------------------------------------------------------------
// STAMPS
// -------------------------------------------------------------------------
void placeStamp(float mx, float my) {
canvas.beginDraw();
canvas.noStroke();
canvas.fill(currentColor);
float yAdjusted = my - toolbarHeight;

// Circle
if (stampMode == 1) {
canvas.ellipse(mx, yAdjusted, currentStrokeWeight*5, currentStrokeWeight*5);
}
// Rectangle
else if (stampMode == 2) {
canvas.rectMode(CENTER);
canvas.rect(mx, yAdjusted, currentStrokeWeight*5, currentStrokeWeight*5);
canvas.rectMode(CORNER);
}
// Pine Tree
else if (stampMode == 3) {
// trunk
canvas.fill(102, 51, 0);
float trunkW = currentStrokeWeight*1.5;
float trunkH = currentStrokeWeight*3;
canvas.rectMode(CENTER);
canvas.rect(mx, yAdjusted + trunkH/2, trunkW, trunkH);

// pine needles (using currentColor)
canvas.fill(currentColor);
// top triangle
canvas.triangle(mx, yAdjusted - (currentStrokeWeight*4),
mx - (currentStrokeWeight*2.5), yAdjusted,
mx + (currentStrokeWeight*2.5), yAdjusted);
// larger triangle below
canvas.triangle(mx, yAdjusted - (currentStrokeWeight*8),
mx - (currentStrokeWeight*4), yAdjusted - (currentStrokeWeight*4),
mx + (currentStrokeWeight*4), yAdjusted - (currentStrokeWeight*4));
canvas.rectMode(CORNER);
}
canvas.endDraw();
}

// -------------------------------------------------------------------------
// SLIDER
// -------------------------------------------------------------------------
void updateSliderHandle() {
// Constrain the mouse to the slider range if near slider
if (mouseY < toolbarHeight) {
sliderHandleX = constrain(mouseX, sliderX, sliderX+sliderW);
currentStrokeWeight = map(sliderHandleX, sliderX, sliderX+sliderW, 1, 20);
}
}

// -------------------------------------------------------------------------
// HELPERS
// -------------------------------------------------------------------------
boolean mouseOverRect(float x, float y, float w, float h) {
return (mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h);
}

boolean mouseOverCircle(float cx, float cy, float r) {
float dx = mouseX - cx;
float dy = mouseY - cy;
return (dx*dx + dy*dy <= r*r);
}

void clearCanvas() {
canvas.beginDraw();
canvas.background(255);
canvas.endDraw();
}

void saveCanvas() {
canvas.save("myDrawing.png");
println("Canvas saved: myDrawing.png");
}

void loadCanvas() {
PImage loaded = loadImage("myDrawing.png");
if (loaded != null) {
canvas.beginDraw();
canvas.image(loaded, 0, 0);
canvas.endDraw();
println("Canvas loaded: myDrawing.png");
} else {
println("No image found to load!");
}
}
