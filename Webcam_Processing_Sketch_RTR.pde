import processing.video.*;
Capture video;

int yLocation, xLocation;

// Size of each cell in the grid
int videoScale = 4;
float counter = 0;
// Number of columns and rows in our system
int cols, rows;
float prevBrightness = 0;
float threshold = 95;
boolean mirror = true; 
int randomFactor = 50;

IntList lineXPoints, lineYPoints, linePoints;

void setup() {
noCursor(); 
  video = new Capture(this, width, height);
  video.start();



fullScreen();

  //size(1280, 720);
  background(0);
  cols = width / videoScale;
  rows = height / videoScale;
}




void draw() {



  if (video.available()) {
    background(0);
    video.read();
    
    video.loadPixels();
 

    background(0);




    // Begin loop for rows
    for (int i = 1; i < rows -1; i++) {


      linePoints = new IntList();
      boolean newLine = true;


      // Begin loop for cols
      for (int j = 1; j < cols - 1; j++) {

        // Where are we, pixel-wise?
        xLocation = width - 1 - j * videoScale;
        yLocation = i * videoScale; 


        float currentBrightness = getBrightness(xLocation, yLocation);


        strokeWeight(4);
        if (currentBrightness  > threshold && newLine == true) {

          //find x1 
          linePoints.append(xLocation);
          newLine = false;
        }
        if (currentBrightness  < threshold && newLine == false) {

          //find x2
          linePoints.append(xLocation);
          newLine = true;
        }

        if (xLocation >= width - 2*videoScale && newLine == false) {
          linePoints.append(xLocation);
        }
      }

      //draws lines from point 0 to point 1, point 2 to point 3, etc.
      for (int k = 0; k < linePoints.size()-1; k+=2)
      {

        int point1 = linePoints.get(k);
        int point2 = linePoints.get(k + 1); 
        int lineLength =  abs(point2 - point1); 

        stroke(0, 200+ random(-randomFactor, randomFactor), lineLength + random(-randomFactor, randomFactor) );
        strokeWeight(1);

        line(point1, yLocation, point2, yLocation);
      }

      //draws lines from point 1 to point 2, point 3 to point 4, etc.
      for (int k = 1; k < linePoints.size()-1; k+=2)
      {

        int point1 = linePoints.get(k);
        int point2 = linePoints.get(k + 1); 
        int lineLength =  abs(point2 - point1); 

        stroke(lineLength*2 - random(-randomFactor, randomFactor), 0, 255-lineLength - random(-randomFactor, randomFactor) );
        strokeWeight(1);
        line(point1, yLocation, point2, yLocation);
      }
     
    }
  
  }
}

void keyPressed() {
  print(threshold);
  println(", ", randomFactor);
  if (key==CODED) {
    if (keyCode == UP) 
    {
      threshold = abs(threshold - 5);
    } else if (keyCode ==  DOWN) 
    {
      threshold = threshold + 5;

      if (threshold>=255) 
      {
        threshold = 250;
      }
    } else if (keyCode == RIGHT)
    {
      randomFactor=randomFactor+1;
    } else if (keyCode == LEFT)
    {
      abs(randomFactor=randomFactor-1);
    }
    else if (keyCode == ENTER){
      
      
    }
      
  }
}


//samples taken from middle of square
color getColor(int x, int y) {
  color col = video.get(x + videoScale/2, y + videoScale/2);
  return col;
}
float getBrightness(int x, int y) {
  color col = video.get(x + videoScale/2, y + videoScale/2);
  return brightness(col);
}


//for (int q = 0; q<lineXPoints.size()-1; q+=2) {

//  stroke(0, lineXPoints.size()*50, 0);
//  strokeWeight(5);


//  //point(lineXPoints.get(counter), lineYPoints.get(counter));

//  // line(lineXPoints.get(q), lineYPoints.get(q), lineXPoints.get(q+1), lineYPoints.get(q+1));
//}
