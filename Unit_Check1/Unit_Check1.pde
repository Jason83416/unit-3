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

  tactile (100,100,50);
  fill(lightOrange);
  circle(100,100,100);
   
  tactile (100,300,50);
  fill(mediumOrange);
  circle(100,300,100);
  
  
  tactile (100,500,50);
  fill(darkOrange);
  circle(100,500,100);
  
  //indicator
  stroke(darkOrange);
  fill(selectedColor);
  square(300,100,400);
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
  if (dist(100,100,mouseX,mouseY) < 50){
    selectedColor = lightOrange;
  }
  
  //mediumOrange button
  if (dist(100,300,mouseX,mouseY) < 50){
    selectedColor = mediumOrange;
  }
  //darkOrange button
   if (dist(100,500,mouseX,mouseY) < 50){
    selectedColor = darkOrange;
   }
}  



