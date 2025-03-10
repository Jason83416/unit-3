//Jason Zhao
//mar, 3, 2025

color orange = #FA680D;
color lightOrange  = #F0A14D;
color creamOrange  = #F2BF89;
color darkOrange   = #FF6905;
color mediumOrange = #FF8705;
color white        = #FFFFFF;

//variables for color selection 
color selectedColor;

void setup(){
  size(800, 600);
  strokeWeight(5);
  stroke(orange);
  selectedColor = darkOrange;
}//end of setup ==========

void draw(){
  background(creamOrange);
  
   //buttons

  tactile (50,250,150);
  fill(lightOrange);
    rect(50, 50, 200, 100);
   
  tactile (250,50,150);
  fill(mediumOrange);
    rect(250, 50, 200, 100);
  
  
  tactile (450,250,150);
  fill(darkOrange);
    rect(450, 50, 200, 100);
  
  //indicator
  stroke(darkOrange);
  fill(selectedColor);
  square(160,175,400);
}
  
  void tactile (int x, int y, int r){
        if (dist(x,y,mouseX,mouseY) < r){
  stroke(white);
  } else {
    stroke(darkOrange);
  }
  }//end tactile
  
  
  
void mouseReleased(){  
  //lightorange button
  if (mouseX > 50 && mouseX < 250 && mouseY > 50 && mouseY < 200) {
    selectedColor = lightOrange;
  }
  
  //mediumOrange button
 if (mouseX > 250 && mouseX < 450 && mouseY > 50 && mouseY < 200) {
  
    selectedColor = mediumOrange;
  }
  //darkOrange button
  if (mouseX > 450 && mouseX < 650 && mouseY > 50 && mouseY < 200) {
  
    selectedColor = darkOrange;
   }
}  
