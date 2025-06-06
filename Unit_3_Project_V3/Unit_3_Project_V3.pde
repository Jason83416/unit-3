PGraphics drawingCanvas;

// Five color variables (pick any 5)
color c1 = color(255, 0, 0); // Red
color c2 = color(0, 255, 0); // Green
color c3 = color(0, 0, 255); // Blue
color c4 = color(255, 255, 0); // Yellow
color c5 = color(255, 0, 255); // Magenta

// Current color & thickness
color currentColor;
float currentThickness;

// Slider position
float sliderX = 300; // left edge of slider track
float sliderY = 30;
float sliderWidth = 100;
float sliderHeight = 10;
float sliderHandleX; // The circle handle's x position

void setup() {
size(800, 600);

// Create an offscreen canvas for drawing
drawingCanvas = createGraphics(width, height);
// Clear it to white
drawingCanvas.beginDraw();
drawingCanvas.background(255);
drawingCanvas.endDraw();

// Default color & thickness
currentColor = c1; // Start with red
currentThickness = 3;

// Position slider handle according to current thickness
// We'll allow thickness from 1..20
sliderHandleX = map(currentThickness, 1, 20, sliderX, sliderX + sliderWidth);
}

void draw() {
// Clear the background
background(220);

// Draw the top toolbar
drawToolbar();

// Show the offscreen canvas for lines
image(drawingCanvas, 0, toolbarHeight);

// Optional instructions
fill(0);
textSize(12);
text("Click a color, adjust thickness, then drag to draw below toolbar.", 10, height - 10);
}

// ---------------------------------------------------------
// MOUSE EVENTS
// ---------------------------------------------------------
void mousePressed() {
// If mouse is in the toolbar region, check color buttons or slider
if (mouseY < toolbarHeight) {
checkColorButtons();
checkSlider(); // see if the slider handle was clicked
}
}

void mouseDragged() {
// If dragging in the toolbar, might move the slider
if (mouseY < toolbarHeight) {
updateSliderHandle();
}
// Otherwise, draw lines in the canvas region
else {
drawingCanvas.beginDraw();
drawingCanvas.stroke(currentColor);
drawingCanvas.strokeWeight(currentThickness);
// We'll offset by toolbarHeight so lines align correctly
drawingCanvas.line(pmouseX, pmouseY - toolbarHeight,
mouseX, mouseY - toolbarHeight);
drawingCanvas.endDraw();
}
}

// ---------------------------------------------------------
// TOOLBAR
// ---------------------------------------------------------
void drawToolbar() {
// Background of the toolbar
fill(200);
noStroke();
rect(0, 0, width, toolbarHeight);

// 1) Draw 5 color buttons
// We'll position them at x=10,50,90,130,170 all at y=10, each w=30,h=30

// c1
if (mouseOverRect(10, 10, 30, 30)) {
stroke(0); strokeWeight(2);
} else {
noStroke();
}
fill(c1);
rect(10, 10, 30, 30);

// c2
if (mouseOverRect(50, 10, 30, 30)) {
stroke(0); strokeWeight(2);
} else {
noStroke();
}
fill(c2);
rect(50, 10, 30, 30);

// c3
if (mouseOverRect(90, 10, 30, 30)) {
stroke(0); strokeWeight(2);
} else {
noStroke();
}
fill(c3);
rect(90, 10, 30, 30);

// c4
if (mouseOverRect(130, 10, 30, 30)) {
stroke(0); strokeWeight(2);
} else {
noStroke();
}
fill(c4);
rect(130, 10, 30, 30);

// c5
if (mouseOverRect(170, 10, 30, 30)) {
stroke(0); strokeWeight(2);
} else {
noStroke();
}
fill(c5);
rect(170, 10, 30, 30);

// 2) Slider: a line + a handle circle
stroke(0);
strokeWeight(1);
line(sliderX, sliderY + sliderHeight/2, sliderX + sliderWidth, sliderY + sliderHeight/2);
// handle
float handleRadius = 8;
boolean hover = mouseOverCircle(sliderHandleX, sliderY + sliderHeight/2, handleRadius);
fill(hover ? 150 : 100);
noStroke();
ellipse(sliderHandleX, sliderY + sliderHeight/2, handleRadius*2, handleRadius*2);

// 3) Indicator (small circle) showing current color & thickness
stroke(0);
strokeWeight(currentThickness);
fill(currentColor);
ellipse(420, 25, 25, 25);

// Label for thickness
fill(0);
textSize(12);
text("Thickness: " + nf(currentThickness,1,1), sliderX + sliderWidth + 15, sliderY + 5);
}

// ---------------------------------------------------------
// CHECKS
// ---------------------------------------------------------
void checkColorButtons() {
// c1
if (mouseOverRect(10, 10, 30, 30)) {
currentColor = c1;
}
// c2
if (mouseOverRect(50, 10, 30, 30)) {
currentColor = c2;
}
// c3
if (mouseOverRect(90, 10, 30, 30)) {
currentColor = c3;
}
// c4
if (mouseOverRect(130, 10, 30, 30)) {
currentColor = c4;
}
// c5
if (mouseOverRect(170, 10, 30, 30)) {
currentColor = c5;
}
}

void checkSlider() {
// If mouse is over the slider handle, we'll move it in mouseDragged
float r = 8;
if (mouseOverCircle(sliderHandleX, sliderY + sliderHeight/2, r)) {
updateSliderHandle();
}
}

void updateSliderHandle() {
if (mouseY < toolbarHeight) {
// Constrain handle to the slider track
sliderHandleX = constrain(mouseX, sliderX, sliderX + sliderWidth);
// Map that position to thickness [1..20]
currentThickness = map(sliderHandleX, sliderX, sliderX + sliderWidth, 1, 20);
}
}

// ---------------------------------------------------------
// HELPER FUNCTIONS
// ---------------------------------------------------------
boolean mouseOverRect(float x, float y, float w, float h) {
return (mouseX >= x && mouseX <= x+w &&
mouseY >= y && mouseY <= y+h);
}

boolean mouseOverCircle(float cx, float cy, float r) {
float dx = mouseX - cx;
float dy = mouseY - cy;
return (dx*dx + dy*dy <= r*r);
}
