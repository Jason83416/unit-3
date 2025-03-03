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
}//enf of setup ==========

void draw(){
  background(creamOrange);
  
  
  //buttons
  if (dist(100,100,mouseX,mouseY) < 50){
  stroke(white);
  } else {
    stroke(darkOrange);
  }
  
  fill(lightOrange);
  circle(100,100,100);
  
    if (dist(100,300,mouseX,mouseY) < 50){
  stroke(white);
  } else {
    stroke(darkOrange);
  }
  fill(mediumOrange);
  circle(100,300,100);
  
    if (dist(100,500,mouseX,mouseY) < 50){
  stroke(white);
  } else {
    stroke(darkOrange);
  }
  fill(darkOrange);
  circle(100,500,100);
  
  //indicator
  stroke(darkOrange);
  fill(selectedColor);
  square(300,100,400);
}
  
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
