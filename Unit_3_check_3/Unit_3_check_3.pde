//Jason Zhao
//block 2-3

//pallette 
color darkPurple = #230F28;
color pink       = #F21D41;
color lightGreen = #EBEBBC;
color medGreen   = #BCE3C5; 
color darkGreen  = #82B3AE;

float sliderX; 

void setup(){
  size(800,600);
  strokeWeight(5);
  stroke(pink);
  sliderX = 400;

}

void draw(){
  background(0);
  
  line(100,300,700,300);
  circle(sliderX,300,50);
}

void mouseDragged(){
  
}

void mouseReleased(){
  controlSlider();
}


void controlSlider(){
   if(mouseX > 100 && mouseX <700 && mouseY >275 && mouseY <325){
    sliderX = mouseX;
  }
}
