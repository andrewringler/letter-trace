Maxim maxim;
AudioPlayer player;var Vec2D = toxi.geom.Vec2D,
    Line2D = toxi.geom.Line2D;

var LETTER_WIDTH = 20;
var LETTER_HEIGHT = 25;
var CIRCLE_RADIUS = 7;
float THRESHOLD = 3;

Letter[] letters, currentLetter;
int currentLetterIndex = 0;
float currentScale;
Vec2D mouseXY;
boolean requireMousePressedInCircleToContinue = false;

void setup() {
  size(400,400); // supress IDE warnings
  size(window.innerWidth, window.innerHeight);
  frameRate(30);
    
  maxim = new Maxim(this);
  player = maxim.loadFile("pencil.wav");
  player.volume(0.4);
  player.setLooping(true);

  createShapes();
  currentLetter = letters[currentLetterIndex];
}

void draw() {
  if(currentLetter.done && (currentLetterIndex+1) < letters.length){
    currentLetterIndex++;
    currentLetter = letters[currentLetterIndex];
    nextState = 0;
    done = false;
  }

  var newWidth = window.innerWidth;
  var newHeight = int(window.innerHeight);
  if(newWidth != width || newHeight != height){
    size(newWidth, newHeight);
  }  
  mouseXY = new Vec2D(mouseX, mouseY);
  currentScale = min(width/LETTER_WIDTH * 0.5, height/LETTER_HEIGHT * 0.5);

//  background(232,35,176);
  background(255);
  
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
  player.stop();
  player.cue(0);
}

void createShapes() {
  letters = new Letters[] {
    
  // A
  new Letter(new Vertex[]{
  new Vertex(LETTER_WIDTH/2, 0),
  new Vertex(0,LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH/2, 0, true),
  new Vertex(LETTER_WIDTH, LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH*0.7, LETTER_HEIGHT*0.4, true),
  new Vertex(LETTER_WIDTH*0.3, LETTER_HEIGHT*0.4)
  }),

  // B
  // C
  // D
  
  // E
  new Letter(new Vertex[]{
  new Vertex(0,0),
  new Vertex(0, LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH, 0, true),
  new Vertex(0, 0),
  new Vertex(LETTER_WIDTH*0.7, LETTER_HEIGHT*0.4, true),
  new Vertex(0, LETTER_HEIGHT*0.4),
  new Vertex(LETTER_WIDTH, LETTER_HEIGHT, true),
  new Vertex(0, LETTER_HEIGHT)
  }),
  
  // F
  // G
  // H
  // I
  // J
  // K
  // L
  // M
  // N
  // O
  // P
  // Q
  // R
  // S
  // T
  // U
  // V
  // W
  // X
  // Y
  
  // Z
  new Letter(new Vertex[]{
  new Vertex(0, 0),
  new Vertex(LETTER_WIDTH, 0),
  new Vertex(0, LETTER_HEIGHT),
  new Vertex(LETTER_WIDTH, LETTER_HEIGHT)
  })

  };
}

    //236  170  216  
   //   247  205  180  
   //241  184  244  
   //198  150  247  
   //220  251  179  
   //193  251  236  
   //

class Vertex {
  Vec2D pos;
  boolean newStroke;
  float x,y;

  Vertex(int x, int y){
    this(x, y, false);
  }
  
  Vertex(int x, int y, boolean newStroke){
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
  Vertex[] points;
  int state = 0;
  Line2D currentPath;
  Vec2D currentCircleXY = new Vec2D(0,0);
  boolean drawNext = true;
  Vec2D target;
  boolean done = false;
  
  Letter(Vertex[] points){
    this.points = points;
  }
  
  void drawIt() {
    noFill();
    shapeMode(CORNER);
    stroke(241,184,244,100);
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
      player.stop();
      return;
    }
    
    /* update circle location based on user press
    if they are following the current path
    towards the target
    */
    float speed = dist(mouseX, mouseY, pmouseX, pmouseY);
    float delta = mouseXY.distanceTo(currentCircleXY);
    boolean insideCircle = false;
    if(delta <= CIRCLE_RADIUS*currentScale && mousePressed){
      insideCircle = true;
      requireMousePressedInCircleToContinue = false;
      if(speed > 1){
        player.play();
      }else{
        player.stop();
      }
    }
    if(mousePressed && (insideCircle || !requireMousePressedInCircleToContinue)){
      if(speed > 1){
        player.play();
      }else{
        player.stop();
      }
      Vec2D closestPoint = currentLetter.currentPath.closestPointTo(mouseXY);
      float err = closestPoint.distanceTo(mouseXY);
      if(err <= THRESHOLD*currentScale){
        // moving towards target? (IE this move makes them closer to the target)
        if(mouseXY.distanceTo(target) < currentCircleXY.distanceTo(target)){
          currentCircleXY = closestPoint; // always show circle on path
        }
      }
    }
    
    /* have the reached the current target?
     or the final target for this letter? */
    if(currentCircleXY.distanceTo(target) <= THRESHOLD*currentScale) {
      int nextState = state+1;
      if(nextState == points.length){
        done = true;
      } else {
        if(nextState+1 <points.length && points[nextState+1].newStroke) {
          nextState++;
        }
        state = nextState;
        drawNext = true;
      }
    }
    
    if(done) {
      return;
    }

    /* draw current circle */
    //strokeWeight(currentScale);
    noStroke();  
    if(insideCircle){
      fill(236,170,216,200);
    }else{
      fill(193,251,232,200);
    }
    ellipseMode(CENTER);
    ellipse(currentCircleXY.x, currentCircleXY.y, CIRCLE_RADIUS*currentScale, CIRCLE_RADIUS*currentScale);    
  }
}

