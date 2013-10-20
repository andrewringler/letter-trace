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
