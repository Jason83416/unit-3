//Jason Zhao
//block 2-3

//pallette 
color darkPurple = #230F28;
color pink       = #F21D41;
color lightGreen = #EBEBBC;
color medGreen   = #BCE3C5; 
color darkGreen  = #82B3AE;

float sliderX; 
float thickness;
float sliderY;

void setup(){
  size(800,600);
  strokeWeight(5);
  stroke(pink);
  sliderX = 400;
  sliderY = 300;
  thickness = 0;

}

void draw(){
  background(0);
  
  thickness = map(sliderY, 100, 500, 0,15);
  
  //strokeWeight(thickness);
  //line(100,300,700,300);
  //circle(sliderX,300,50);
  
   strokeWeight(thickness);
  line(400,100,400,500);
  circle(400,sliderY,50);


}

void mouseDragged(){
  controlSlider();
}

void mouseReleased(){
  controlSlider();
}


void controlSlider(){
   //if(mouseX > 100 && mouseX <700 && mouseY >275 && mouseY <325){
    //sliderX = mouseX;
   //}
    if(mouseX > 375 && mouseX <425 && mouseY >100 && mouseY <500){
    sliderY = mouseY;
  }
}
