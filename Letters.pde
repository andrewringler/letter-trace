var Vec2D = toxi.geom.Vec2D,
    Line2D = toxi.geom.Line2D;

var LETTER_WIDTH = 20;
var LETTER_HEIGHT = 25;
var CIRCLE_RADIUS = 7;
float THRESHOLD = 1;

Letter a, currentLetter;
float currentScale;
Vec2D mouseXY;

void setup() {
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

class Point {
  Vec2D pos;
  boolean newStroke;
  float x,y;

  Point(int x, int y){
    this(x, y, false);
  }
  
  Point(int x, int y, boolean newStroke){
    this.pos = new Vec2D(x,y);
    this.x = x;
    this.y = y;
    this.newStroke = newStroke;
  }
  
  Vec2D screen() {
    return new Vec2D(screenX(x, y), screenY(x, y));
  }
}

class Letter {
  Point[] points;
  int state = 0;
  Line2D currentPath;
  Vec2D currentCircleXY = new Vec2D(0,0);
  boolean drawNext = true;
  Vec2D target;
  boolean done = false;
  
  Letter(Point[] points){
    this.points = points;
  }
  
  void drawIt() {
    noFill();
    shapeMode(CORNER);
    stroke(100, 100);
    strokeWeight(1);
    
    beginShape();
    for(int i=0; i<points.length && i<=(state+1); i++){
      if(points[i].newStroke){
        endShape();      
        beginShape();
      }
      vertex(points[i].x, points[i].y);
      if(i == state && drawNext){
        currentCircleXY = points[i].screen();
        drawNext = false;
        
        if(i<points.length-1){
          currentPath = new Line2D(points[i].screen(), points[i+1].screen());
          target = points[i+1].screen();
        }
      }
    } 
    endShape();      
  }
  
  void trace() {
    if(done){
      return;
    }
    
    /* update circle location based on user press
    if they are following the current path
    towards the target
    */
    float delta = mouseXY.distanceTo(currentCircleXY);
    boolean insideCircle = false;
    if(delta <= CIRCLE_RADIUS*currentScale && mousePressed){
      insideCircle = true;
    }
    if(mousePressed && insideCircle){
      float err = currentLetter.currentPath.closestPointTo(mouseXY).distanceTo(mouseXY);
      if(err <= THRESHOLD*currentScale){
        // moving towards target? (IE this move makes them closer to the target)
        if(mouseXY.distanceTo(target) < currentCircleXY.distanceTo(target)){
          currentCircleXY = mouseXY;
        }
      }
    }
    
    /* have the reached the current target?
     or the final target for this letter? */
    if(currentCircleXY.distanceTo(target) <= THRESHOLD*currentScale){
      int nextState = state+1;
      if(nextState == points.length){
        done = true;
      }else{
        if(nextState+1 <points.length && points[nextState+1].newStroke){
          nextState++;
        }
        state = nextState;
        drawNext = true;
      }
    }
    
    if(done){
      return;
    }

    /* draw current circle */
    strokeWeight(currentScale);  
    if(insideCircle){
      stroke(0);
    }else{
      noStroke();
    }
    fill(100);
    ellipseMode(CENTER);
    ellipse(currentCircleXY.x, currentCircleXY.y, CIRCLE_RADIUS*currentScale, CIRCLE_RADIUS*currentScale);
  }
}

void createShapes() {
  a = new Letter(new Point[]{
  new Point(0,LETTER_HEIGHT),
  new Point(LETTER_WIDTH/2, 0),
  new Point(LETTER_WIDTH, LETTER_HEIGHT),
  new Point(LETTER_WIDTH*0.7, LETTER_HEIGHT*0.4, true),
  new Point(LETTER_WIDTH*0.3, LETTER_HEIGHT*0.4)
  });
}


