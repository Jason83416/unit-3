color darkPurple = #230F2B;
color pink       = #F21D41;
color lightGreen = #EBEBBC;
color medGreen   = #BCE3C5;
color darkGreen  = #82B3AE;
color red        = #F53500;
color blue       = #0032F5;

int toggle;

void setup () {
  size(800, 600);
  strokeWeight(5);
  textSize(30);

  toggle = 1;
}

void draw() {
  background(255);


  fill(darkGreen);
  stroke(lightGreen);
  rect(50, 100, 200, 100);
  
  
  fill(red);
  stroke(lightGreen);
  rect(250, 100, 200, 100);
  
  
  fill(darkGreen);
  stroke(lightGreen);
  rect(450, 100, 200, 100);

  if (toggle > 0) {

    guidelines();
  }
}

void mouseReleased() {
  if (mouseX > 100 && mouseX < 300 && mouseY > 100 && mouseY < 200) {
    toggle = toggle * -1;
  }
}

void guidelines() {
  fill(pink);
  stroke(pink);
  line(0, mouseY, width, mouseY);
  line(mouseX, 0, mouseX, height);
}
