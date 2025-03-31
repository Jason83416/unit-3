// ---------------------------------------------------------

// Sketch: Drawing Tool with Colors, Stamps, and a Slider

// ---------------------------------------------------------

//

// This sketch demonstrates:

//  1) Organized code and comments

//  2) A custom UI "toolbar" with tactile buttons

//  3) A drawing "Canvas" region for squiggly lines or stamps

//  4) 6 color buttons to switch colors for the line

//  5) Buttons that are encapsulated in their own functions

//  6) A thickness slider controlling stroke size

//  7) An "indicator" that shows the current color and thickness

//  8) Two stamp toggle buttons (circle stamp & rectangle stamp)

//  9) New (clears screen), Save, and Load

// 10) Both circle and rectangle buttons in the project

//

// Requirements explained in detail:

//    - The canvas is a PGraphics area we can freely draw on

//    - "Tactile" buttons highlight when hovered

//    - Clicking color buttons sets the current color (and disables stamp mode)

//    - Clicking a stamp button toggles a stamp on/off. If stamp is on, 

//      mouse clicks place that stamp. If stamp is off, we draw lines when dragging

//    - The thickness slider is also tactile

//    - The indicator shows the current stroke color and thickness

//    - The top bar has circle & rect buttons for color, plus stamp toggles

//    - New, Save, Load buttons do what you'd expect

//

// ---------------------------------------------------------

// GLOBAL VARIABLES

// ---------------------------------------------------------



// Main "canvas" for drawing lines/stamps, separate from the default window

PGraphics drawingCanvas;



// Current drawing color & stroke thickness

color currentColor;

float currentStrokeWeight = 3.0;



// Stamp toggles (can only have one stamp on at once, or none)

boolean stampCircleOn = false;

boolean stampRectOn = false;



// UI constants

int toolbarHeight = 100;           // Height of the top toolbar area

int canvasMargin = 10;             // Margin around the "canvas"

int sliderX = 350;                 // X position of thickness slider

int sliderY = 30;                  // Y position of thickness slider

int sliderWidth = 100;             // Width of thickness slider track

int sliderHeight = 10;             // Height of thickness slider track



// We'll store the handle's x-position so we can move it

float sliderHandleX;



// For highlighting which button is "pressed" or "selected"

boolean loadingImage = false;      // True when user tries to load an image



// Color palette for the 6 color buttons

color[] colors = {

  color(255,0,0),    // Red

  color(0,255,0),    // Green

  color(0,0,255),    // Blue

  color(255,255,0),  // Yellow

  color(255,0,255),  // Magenta

  color(0,255,255)   // Cyan

};



// ---------------------------------------------------------

// SETUP

// ---------------------------------------------------------

void setup() {

  size(800, 600);

  surface.setTitle("Drawing Tool with Stamps and Slider");



  // Create off-screen drawing surface

  drawingCanvas = createGraphics(width, height);



  // Clear that canvas initially

  clearCanvas();



  // Default color

  currentColor = color(0);



  // Place slider handle in an initial spot (mapping strokeWeight to handleX)

  sliderHandleX = map(currentStrokeWeight, 1, 20, sliderX, sliderX + sliderWidth);

}



// ---------------------------------------------------------

// DRAW

// ---------------------------------------------------------

void draw() {

  background(220);



  // Draw the "toolbar" region at the top

  drawToolbar();



  // Draw our main drawing canvas onto the screen

  // We'll position it so the toolbar is at the top

  image(drawingCanvas, 0, toolbarHeight);



  // If user is dragging the mouse in the canvas area and we have no stamp on,

  // we draw lines on the drawingCanvas in mouseDragged() event.



  // Show instructions or status (optional)

  fill(0);

  textSize(12);

  text("Drag on canvas to draw, or click stamps to place shapes.", 10, height - 10);

}



// ---------------------------------------------------------

// EVENT: MOUSE PRESSED

// ---------------------------------------------------------

void mousePressed() {

  // Check if we clicked in the toolbar area

  if (mouseY < toolbarHeight) {

    // We might have clicked a color button, or stamp button, or new/save/load

    checkColorButtons();

    checkStampButtons();

    checkSystemButtons();

    checkSliderHandle();

  } else {

    // If we are in the canvas area and a stamp is active, place the stamp

    if (stampCircleOn || stampRectOn) {

      placeStamp(mouseX, mouseY);

    }

  }

}



// ---------------------------------------------------------

// EVENT: MOUSE DRAGGED

// ---------------------------------------------------------

void mouseDragged() {

  // If we drag the slider handle

  if (mouseY < toolbarHeight) {

    // Possibly adjust slider if we are dragging in that region

    updateSliderHandle();

  } else {

    // If we are dragging in the drawing area and no stamps are on, draw

    if (!stampCircleOn && !stampRectOn) {

      drawingCanvas.beginDraw();

      drawingCanvas.stroke(currentColor);

      drawingCanvas.strokeWeight(currentStrokeWeight);

      drawingCanvas.line(pmouseX, pmouseY - toolbarHeight, 

                         mouseX,  mouseY  - toolbarHeight);

      drawingCanvas.endDraw();

    }

  }

}



// ---------------------------------------------------------

// UTILITY: placeStamp()

// Places either a circle or rectangle stamp on the drawingCanvas

// ---------------------------------------------------------

void placeStamp(float x, float y) {

  drawingCanvas.beginDraw();

  drawingCanvas.noStroke();

  drawingCanvas.fill(currentColor);



  // Because the canvas is drawn offset by toolbarHeight,

  // we subtract that from y for correct placement.

  float adjustedY = y - toolbarHeight;



  if (stampCircleOn) {

    drawingCanvas.ellipse(x, adjustedY, currentStrokeWeight*5, currentStrokeWeight*5);

  } 

  else if (stampRectOn) {

    drawingCanvas.rectMode(CENTER);

    drawingCanvas.rect(x, adjustedY, currentStrokeWeight*5, currentStrokeWeight*5);

    drawingCanvas.rectMode(CORNER);

  }

  drawingCanvas.endDraw();

}



// ---------------------------------------------------------

// UTILITY: checkColorButtons()

// We have 6 color buttons in a row. If user clicks one, set that color

// and turn off stamp mode.

// ---------------------------------------------------------

void checkColorButtons() {

  // For example, place color buttons near x=10.., y=10, size ~30

  int btnSize = 30;

  int spacing = 10;

  int startX = 10;

  int startY = 10;



  for (int i=0; i<colors.length; i++) {

    int xPos = startX + i*(btnSize + spacing);

    int yPos = startY;

    if (mouseOverRect(xPos, yPos, btnSize, btnSize)) {

      // Assign the chosen color

      currentColor = colors[i];

      // Turn off stamp mode

      stampCircleOn = false;

      stampRectOn   = false;

      return;

    }

  }

}



// ---------------------------------------------------------

// UTILITY: checkStampButtons()

// We have 2 stamp toggle buttons (circle stamp & rect stamp).

// If clicked, we toggle them. Also, ensure only one is on at a time.

// ---------------------------------------------------------

void checkStampButtons() {

  // Let's say circle stamp button is at x=210, y=10

  // And rect stamp button is at x=260, y=10

  int btnSize = 30;



  // Circle stamp

  if (mouseOverRect(210, 10, btnSize, btnSize)) {

    // Toggle

    stampCircleOn = !stampCircleOn;

    if (stampCircleOn) {

      // Turn off the other

      stampRectOn = false;

    }

  }



  // Rectangle stamp

  if (mouseOverRect(250, 10, btnSize, btnSize)) {

    // Toggle

    stampRectOn = !stampRectOn;

    if (stampRectOn) {

      // Turn off the other

      stampCircleOn = false;

    }

  }

}



// ---------------------------------------------------------

// UTILITY: checkSystemButtons()

// We handle New, Save, and Load. We can position them somewhere else

// ---------------------------------------------------------

void checkSystemButtons() {

  // Let "New" be at x=500, "Save" at 550, "Load" at 600, each w=40,h=30

  if (mouseOverRect(500, 10, 40, 30)) {

    clearCanvas();

  }

  if (mouseOverRect(550, 10, 40, 30)) {

    saveCanvas();

  }

  if (mouseOverRect(600, 10, 40, 30)) {

    loadCanvas();

  }

}



// ---------------------------------------------------------

// UTILITY: checkSliderHandle()

// If we press in the slider region, we might move the handle

// ---------------------------------------------------------

void checkSliderHandle() {

  // The slider track is at (sliderX, sliderY, sliderWidth, sliderHeight)

  // The handle is basically a small circle/rect around sliderHandleX

  float handleRadius = 10;

  float dy = mouseY - sliderY - sliderHeight/2.0;

  float dx = mouseX - sliderHandleX;

  // If within handle radius, consider it "grabbed"

  if (sqrt(dx*dx + dy*dy) < handleRadius) {

    updateSliderHandle();

  }

}



// ---------------------------------------------------------

// UTILITY: updateSliderHandle()

// Move handle as we drag, clamp to slider track, map to stroke weight

// ---------------------------------------------------------

void updateSliderHandle() {

  // Only update if we are in the vertical range roughly

  if (mouseY >= sliderY - 20 && mouseY <= sliderY + 40) {

    sliderHandleX = constrain(mouseX, sliderX, sliderX + sliderWidth);

    // Map that handle position to stroke weight range

    currentStrokeWeight = map(sliderHandleX, sliderX, sliderX + sliderWidth, 1, 20);

  }

}



// ---------------------------------------------------------

// UTILITY: drawToolbar()

// Draws all UI elements in the top region

// ---------------------------------------------------------

void drawToolbar() {

  // Toolbar background

  fill(200);

  noStroke();

  rect(0, 0, width, toolbarHeight);



  // 1) Draw 6 color buttons

  drawColorButtons();



  // 2) Draw stamp toggle buttons

  drawStampButtons();



  // 3) Draw thickness slider

  drawSlider();



  // 4) Draw "Indicator" shape that shows current color and thickness

  drawIndicator();



  // 5) Draw New, Save, and Load Buttons

  drawSystemButtons();

}



// ---------------------------------------------------------

// UTILITY: drawColorButtons()

// ---------------------------------------------------------

void drawColorButtons() {

  int btnSize = 30;

  int spacing = 10;

  int startX = 10;

  int startY = 10;



  for (int i=0; i<colors.length; i++) {

    int xPos = startX + i*(btnSize + spacing);

    int yPos = startY;



    boolean hover = mouseOverRect(xPos, yPos, btnSize, btnSize);

    if (hover) {

      stroke(0);

      strokeWeight(2);

    } else {

      noStroke();

    }



    fill(colors[i]);

    // Example: circle or rectangle button:

    // You can pick whichever shape you prefer for the color swatches

    rect(xPos, yPos, btnSize, btnSize);

  }

}



// ---------------------------------------------------------

// UTILITY: drawStampButtons()

//  - We'll show 2 small squares that are toggled

//  - Inside each, we draw an icon: circle or rect

// ---------------------------------------------------------

void drawStampButtons() {

  int btnSize = 30;



  // Circle stamp

  int xCircleBtn = 210;

  int yCircleBtn = 10;

  boolean hoverC = mouseOverRect(xCircleBtn, yCircleBtn, btnSize, btnSize);



  stroke(0);

  if (hoverC) {

    strokeWeight(2);

  } else {

    strokeWeight(1);

  }



  // If toggled on, fill with a highlight

  if (stampCircleOn) {

    fill(180, 200, 255);

  } else {

    fill(220);

  }

  rect(xCircleBtn, yCircleBtn, btnSize, btnSize);

  // Icon

  fill(0);

  ellipse(xCircleBtn + btnSize/2, yCircleBtn + btnSize/2, 15, 15);



  // Rectangle stamp

  int xRectBtn = 250;

  int yRectBtn = 10;

  boolean hoverR = mouseOverRect(xRectBtn, yRectBtn, btnSize, btnSize);

  if (hoverR) {

    strokeWeight(2);

  } else {

    strokeWeight(1);

  }



  if (stampRectOn) {

    fill(180, 200, 255);

  } else {

    fill(220);

  }

  rect(xRectBtn, yRectBtn, btnSize, btnSize);

  // Icon

  fill(0);

  rect(xRectBtn + btnSize/2 - 7, yRectBtn + btnSize/2 - 5, 14, 10);

}



// ---------------------------------------------------------

// UTILITY: drawSlider()

//  - A horizontal line with a draggable handle

// ---------------------------------------------------------

void drawSlider() {

  // Draw track

  stroke(0);

  strokeWeight(1);

  line(sliderX, sliderY + sliderHeight/2,

       sliderX + sliderWidth, sliderY + sliderHeight/2);



  // Draw handle

  float handleRadius = 10;

  boolean hoverHandle = false;

  float dx = mouseX - sliderHandleX;

  float dy = mouseY - (sliderY + sliderHeight/2);

  if (sqrt(dx*dx + dy*dy) < handleRadius) {

    hoverHandle = true;

  }



  if (hoverHandle) {

    fill(150);

  } else {

    fill(100);

  }

  noStroke();

  ellipse(sliderHandleX, sliderY + sliderHeight/2, handleRadius*2, handleRadius*2);



  // (Optional) label

  fill(0);

  textSize(12);

  text("Thickness: " + nf(currentStrokeWeight, 1, 1), sliderX + sliderWidth + 15, sliderY + 5);

}



// ---------------------------------------------------------

// UTILITY: drawIndicator()

//  - A shape that changes color and thickness as we adjust

// ---------------------------------------------------------

void drawIndicator() {

  // Let’s place it at x=420, y=15, size=25

  int xPos = 420;

  int yPos = 15;

  int size = 25;



  // Outline is black

  stroke(0);

  strokeWeight(currentStrokeWeight);

  fill(currentColor);

  // We can just draw a circle or rectangle as the indicator

  ellipse(xPos, yPos + size/2, size, size);

}



// ---------------------------------------------------------

// UTILITY: drawSystemButtons() -> "New", "Save", "Load"

// ---------------------------------------------------------

void drawSystemButtons() {

  // Let's make them at x=500, 550, 600 with width=40, height=30

  int w = 40;

  int h = 30;



  // New

  if (mouseOverRect(500, 10, w, h)) {

    stroke(0); strokeWeight(2);

  } else {

    noStroke();

  }

  fill(200);

  rect(500, 10, w, h);

  fill(0);

  text("New", 508, 30);



  // Save

  if (mouseOverRect(550, 10, w, h)) {

    stroke(0); strokeWeight(2);

  } else {

    noStroke();

  }

  fill(200);

  rect(550, 10, w, h);

  fill(0);

  text("Save", 555, 30);



  // Load

  if (mouseOverRect(600, 10, w, h)) {

    stroke(0); strokeWeight(2);

  } else {

    noStroke();

  }

  fill(200);

  rect(600, 10, w, h);

  fill(0);

  text("Load", 605, 30);

}



// ---------------------------------------------------------

// UTILITY: clearCanvas()

// Clears the PGraphics canvas to a blank background

// ---------------------------------------------------------

void clearCanvas() {

  drawingCanvas.beginDraw();

  drawingCanvas.background(255);

  drawingCanvas.endDraw();

}



// ---------------------------------------------------------

// UTILITY: saveCanvas()

// Saves the PGraphics canvas as a PNG

// ---------------------------------------------------------

void saveCanvas() {

  drawingCanvas.save("myDrawing.png");

  println("Canvas saved to myDrawing.png");

}



// ---------------------------------------------------------

// UTILITY: loadCanvas()

// Loads previously saved PNG into the PGraphics canvas

// ---------------------------------------------------------

void loadCanvas() {

  // Try loading the same "myDrawing.png"

  PImage loaded = loadImage("myDrawing.png");

  if (loaded == null) {

    println("No image found to load!");

    return;

  }

  drawingCanvas.beginDraw();

  drawingCanvas.image(loaded, 0, 0);

  drawingCanvas.endDraw();

  println("Canvas loaded from myDrawing.png");

}



// ---------------------------------------------------------

// HELPER: mouseOverRect(x, y, w, h)

// Checks if the mouse is within a rectangle

// ---------------------------------------------------------

boolean mouseOverRect(float x, float y, float w, float h) {

  if (mouseX >= x && mouseX <= x+w &&

      mouseY >= y && mouseY <= y+h) {

    return true;

  }

  return false;

}
