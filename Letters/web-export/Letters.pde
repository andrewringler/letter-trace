Maxim maxim;
AudioPlayer player;var Vec2D = toxi.geom.Vec2D,
Line2D = toxi.geom.Line2D;    
Stretch stretch;

var LETTER_WIDTH = 20;
var LETTER_HEIGHT = 25;
var CIRCLE_RADIUS = 7;
float THRESHOLD = 3;

Letter[] letters, currentLetter;
int currentLetterIndex = 0;
Tracing tracing;

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
  tracing = new Tracing(currentLetter);
  
  stretch = new Stretch(LETTER_WIDTH, LETTER_HEIGHT, 0.5);
}

void draw() {
  stretch.update();
  
  if(tracing.done() && (currentLetterIndex+1) < letters.length){
    currentLetterIndex++;
    currentLetter = letters[currentLetterIndex];
    tracing = new Tracing(currentLetter);
  }

  background(255);
    
  currentLetter.update(tracing.state);
  tracing.update();  
}

void mouseReleased() {
  tracing.handleMouseReleased();
}

void mousePressed() {
  tracing.handleMousePressed();
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
}

class Letter {
  Vertex[] points;
  
  Letter(Vertex[] points){
    this.points = points;
  }
  
  void update(int state) {
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
    } 
    endShape();      
  }
}

class Tracing {
  Letter l;
  Vec2D userPos;     
  Line2D currentPath;
  int state = 0;
  boolean tracing = false;
  
  Tracing(Letter letter) {
    this.l = letter;
    userPos = l.points[state].pos;
    currentPath = new Line2D(userPos, l.points[state+1].pos);
  }
  
  void handleMousePressed() {
    if(!done() && !tracing){
      // maybe this is the start of a new trace
      float delta = stretch.mouse.distanceTo(userPos);
      if(delta <= CIRCLE_RADIUS){
        tracing = true;
      }
    }
  }
  
  void handleMouseReleased() {
    if(tracing) {
      // reset to start of current path
      userPos = l.points[state].pos;
      tracing = false;
    }
  }
  
  void target() {
    return currentPath.b;
  }
  
  void done() {
    return state >= (l.points.length-1);
  }
  
  void update() {
    /* update circle location based on user press
    only if they are actually following the correct
    current path in the direction of the target
    */
    if(tracing){
      float delta = stretch.mouse.distanceTo(userPos);
      Vec2D closestPoint = currentPath.closestPointTo(stretch.mouse);
      float err = closestPoint.distanceTo(stretch.mouse);
      if(err <= THRESHOLD){
        // moving towards target? (IE this move makes them closer to the target)
        if(stretch.mouse.distanceTo(target()) < userPos.distanceTo(target())){
          userPos = closestPoint;
        }
      }
    }
    
    if(tracing && userPos.distanceTo(target()) <= THRESHOLD) {
      // they have reached the current target, move on to the next path
      state++;
      if(state+1 < l.points.length && l.points[state+1].newStroke){
        state++;
      }
      tracing = false;
      if(!done()){
        userPos = l.points[state].pos;
        currentPath = new Line2D(userPos, l.points[state+1].pos);
      }
    }
    
    /* draw current circle */
    if(!done()){
      noStroke();  
      if(tracing){
        fill(236,170,216,200);
      }else{
        fill(193,251,232,200);
      }
      ellipseMode(CENTER);
      ellipse(userPos.x, userPos.y, CIRCLE_RADIUS, CIRCLE_RADIUS);    
    }
  }
}
class Stretch {
  int modelWidth;
  int modelHeight;
  float percentFilled;
  boolean sizeChanged = false;
  Vec2D mouse;
  
  Stretch(int modelWidth, int modelHeight, float percentFilled){
      this.modelWidth = modelWidth;
      this.modelHeight = modelHeight;
      this.percentFilled = percentFilled;
  }
  
  void update() {
    var newWidth = window.innerWidth;
    var newHeight = int(window.innerHeight);
    if(newWidth != width || newHeight != height){
      size(newWidth, newHeight);
      sizeChanged = true;
    } else {
      sizeChanged = false;
    }
    float currentScale = min(width/modelWidth * percentFilled, height/modelHeight * percentFilled);

    translate(width/2, height/2);
    scale(currentScale);
    translate(-modelWidth/2, -modelHeight/2);
    
    mouse = new Vec2D(mouseX, mouseY);
    mouse = mouse.sub(width/2, height/2);
    mouse = mouse.scale(1.0 / currentScale);
    mouse = mouse.sub(-modelWidth/2, -modelHeight/2);
  }
}

