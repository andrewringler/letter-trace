var Vec2D = toxi.geom.Vec2D,
    Line2D = toxi.geom.Line2D;

var LETTER_WIDTH = 20;
var LETTER_HEIGHT = 25;
var CIRCLE_RADIUS = 7;
float THRESHOLD = 3;

Letter a, currentLetter;
float currentScale;
Vec2D mouseXY;
boolean requireMousePressedInCircleToContinue = false;

void setup() {
  size(400,400); // supress IDE warnings
  size(window.innerWidth, window.innerHeight);
  frameRate(30);
    
  createShapes();
  currentLetter = a;
}

void draw() {
  var newWidth = window.innerWidth;
  var newHeight = int(window.innerHeight);
  if(newWidth != width || newHeight != height){
    size(newWidth, newHeight);
  }  
  mouseXY = new Vec2D(mouseX, mouseY);
  currentScale = min(width/LETTER_WIDTH * 0.5, height/LETTER_HEIGHT * 0.5);

  background(232,35,176);
  
  pushMatrix();
  translate(width/2, height/2);
  scale(currentScale);
  translate(-LETTER_WIDTH/2, -LETTER_HEIGHT/2);
  
  currentLetter.drawIt();
  
  popMatrix();

  currentLetter.trace();  
}

void mouseReleased() {
  requireMousePressedInCircleToContinue = true;
}

void createShapes() {
  a = new Letter(new Vertex[]{
  new Vertex(LETTER_WIDTH/2, 0),
  new Vertex(0,LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH/2, 0, true),
  new Vertex(LETTER_WIDTH, LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH*0.7, LETTER_HEIGHT*0.4, true),
  new Vertex(LETTER_WIDTH*0.3, LETTER_HEIGHT*0.4)
  });
}

