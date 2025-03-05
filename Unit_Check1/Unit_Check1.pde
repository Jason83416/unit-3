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

  tactile (50,50,50);
  fill(lightOrange);
  circle(50,50,100);
   
  tactile (150,50,50);
  fill(mediumOrange);
  circle(150,50,100);
  
  
  tactile (250,50,50);
  fill(darkOrange);
  circle(250,50,100);
  
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
  if (dist(50,50,mouseX,mouseY) < 50){
    selectedColor = lightOrange;
  }
  
  //mediumOrange button
  if (dist(150,50,mouseX,mouseY) < 50){
    selectedColor = mediumOrange;
  }
  //darkOrange button
   if (dist(250,50,mouseX,mouseY) < 50){
    selectedColor = darkOrange;
   }
}  

