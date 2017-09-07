// - - - - - PROJECT 4 SUMMARY - - - - - 
// Tricia Leach
// MUC 272
// PCC - Summer 2017
// This project utilizes the Leap Motion for interactions.
// Each of the actions is also available by using the keyboard
// for those who do not have a Leap Motion.
//
// LEAP MOTION INTERACTIONS
// - - - - - - - - - - - - -
// BACKGROUND COLOR CHANGE: hold up left or right hand
// ZOOM IN: hold hand out flat, counter-clockwise circle motion
// ZOOM OUT: hold hand out flat, clockwise circle motion
// SPIN GRAPHICS: pinch fingers slightly
// SPIN GRAPHICS (STOP): hold fingers still
// RESET ART TO ORIGINAL: hold hand tightly in fist
//
// KEYBOARD INTERACTIONS
// - - - - - - - - - - -
// BACKGROUND COLOR CHANGE: left or right arrow key
// ZOOM IN: up arrow key
// ZOOM OUT: down arrow key
// SPIN GRAPHICS: press r key repeatedly
// SPIN GRAPHICS (STOP): press t key
// RESET ART TO ORIGINAL: delete or backspace key
// - - - additional keyboard interactions
// CHANGE CIRCLE COLORS: press 1, 2, or 3 key
// CHANGE CIRCLE COLORS (RESET): press 0 key

import de.voidplus.leapmotion.*;
LeapMotion leap;

// - - - - - - - - - - - - - - - - VARIABLES
color lineColor0 = color(50,50,50);
color lineColor1 = color(123,123,255);
color lineColor2 = color(123,255,123);
color lineColor3 = color(255,123,123);
color lineColorCurrent = lineColor0;
color lineColorOdd = lineColorCurrent;
// - - -
color bgColor0 = color(50,50,50);
color bgColor1 = color(123,123,255);
color bgColor2 = color(123,255,123);
color bgColor3 = color(0,0,0);
color backgroundCurrent = bgColor0;
// - - -
float lineThickness = 2;
float zoom = 1;
float circRotation = 0;


// - - - - - - - - - - - - - - - - VARIABLES (LEAP)
boolean handIsLeft;
boolean handIsRight;
float handGrab;
float handPinch;


// - - - - - - - - - - - - - - - - SETUP
void setup() {
  //size(800, 600, P3D);
  fullScreen(P3D);
  pixelDensity(displayDensity());  // this smooths out on retina
  leap = new LeapMotion(this);
  leap = new LeapMotion(this).allowGestures();  // All gestures
  frameRate(10);
}


// - - - - - - - - - - - - - - - - KEY PRESSED SETTINGS

// settings to match Leap Motion interactions
// for those without a Leap Motion
void keyPressed() {
  if (key == CODED) {
    // change background color with right/left arrow keys
    if (keyCode == RIGHT) {
      backgroundCurrent = bgColor1;
    } else if (keyCode == LEFT) {
      backgroundCurrent = bgColor2;
    } 
    
    // zoom in/out with up/down arrow keys
    if (keyCode == UP) {
      zoom = zoom + 0.5;
    } else if (keyCode == DOWN) {
      if (zoom > 1) {
        zoom = zoom - 0.5;
      }
    }
  } // END key == CODED
  
  // rotates circles if letter r is pressed
  if (key == 'r' || key == 'R') {
    for (int i = 0; i < 1000; i++) {
        circRotation = circRotation + .001;
    }
  }
  
  // returns to normal circle rotation if t is pressed
  if (key == 't' || key == 'T') {
    circRotation = 0;
  }
  
  // changes line color
  if (key == '1') {
    lineColorCurrent = lineColor1;
    lineColorOdd = lineColor1;
  }
  
  // changes line color
  if (key == '2') {
    lineColorCurrent = lineColor2;
    lineColorOdd = lineColor2;
  }
  
  // changes line color
  if (key == '3') {
    lineColorOdd = lineColor3;
  }
  
  // changes line color
  if (key == '0') {
    lineColorCurrent = lineColor0;
    lineColorOdd = lineColor0;
  }
  
  // pressing backspace or delete returns to starting state
  if (keyCode == BACKSPACE || keyCode == DELETE) {
      backgroundCurrent = bgColor0;
      zoom = 1;
      circRotation = 0;
      lineColorCurrent = lineColor0;
      lineColorOdd = lineColor0;
  }
    
}

// - - - - - - - - - - - - - - - - LEAP MOTION INTERACTIONS
// - - - - - - - - - - - - - - - - CIRCLE GESTURES

void leapOnCircleGesture(CircleGesture g, int state){
  int direction = g.getDirection();
  
  // zoom in/out by twirling hand in clockwise or
  // or counter-clockwise direction
  if (direction == 0) {
      zoom = zoom + 0.01;
    } else if (direction == 1) {
      if (zoom > 1) {
        zoom = zoom - 0.01;
      }
    }
}


// - - - - - - - - - - - - - - - - DRAW LOOP
void draw() {
  background(backgroundCurrent);
  
// - - - - - - - - - - - - - - - - LEAP MOTION INTERACTIONS
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    handIsLeft = hand.isLeft();
    handIsRight = hand.isRight();
    handGrab = hand.getGrabStrength();
    handPinch = hand.getPinchStrength();
    
    // change background color based on hand
    if (handIsRight) {
      backgroundCurrent = bgColor1;
    } else if (handIsLeft) {
      backgroundCurrent = bgColor2;
    }
    
    // rotate with hand pinch
    if (handPinch > 0.2 && handPinch < 0.9) {
      for (int i = 0; i < 1000; i++) {
        circRotation = circRotation + .001;
      }
    } else if (handPinch < 0.2) {
      circRotation = 0;
    }
    
    // hand in fist resets bg color and zoom level
    if (handGrab == 1.0) {
      backgroundCurrent = bgColor0;
      zoom = 1;
      circRotation = 0;
      lineColorCurrent = lineColor0;
      lineColorOdd = lineColor0;
    }
    
  } // end of HAND
 
 
// - - - - - - - - - - -  - - - - - ARTWORK
  // ZOOM IN OR OUT
  // needs to be translated to center
  // before zoom, so that it will zoom
  // to center, instead of left corner
  translate(width/2,height/2);
  scale(zoom);
  // and then translated back after zoom
  translate(-width/2,-height/2);
  
  // ROTATION
  // needs to be translated to center
  // before rotation, so that it will rotate
  // around center, instead of left corner
  translate(width/2,height/2);
  rotateX(circRotation);
  translate(-width/2,-height/2);
  
  // creates multiples of rows of concentric circles
  rowCircles();
  translate(-width + width/8, height/4, 0);
  rowCircles();
  translate(-width - width/8, height/4, 0);
  rowCircles();
  translate(-width + width/8, height/4, 0);
  rowCircles();
  translate(-width - width/8, height/4, 0);
  rowCircles();
}


// - - - - - - - - - - - - - - - - FUNCTIONS

// creates individual concentric circles
void makeCircle() {
  strokeWeight(lineThickness);
  stroke(lineColorCurrent);
  int z = 0;
  for (int i = 0; i < 15; i++) {
    // changes color every other circle
    if (i % 2 == 0) {
      stroke(lineColorOdd);
      ellipse(0, 0, 22+z, 22+z);
    }
    // changes color every other circle
    if (i % 2 != 0) {
      stroke(lineColorCurrent);
      ellipse(0, 0, 22+z, 22+z);
    }
    z = z + 15;
  }
}

// creates rows of circles from concentric circles
void rowCircles() {
  int xTranslate = width/4;
  // creates first four circles in row
  for (int i = 0; i < 4; i++) {
    makeCircle();
    translate(xTranslate, 0, 0);
  }
  // creates fifth circle in row
  makeCircle();
}