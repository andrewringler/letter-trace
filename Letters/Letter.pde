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
//        player.play();
      }else{
        player.stop();
      }
    }
    if(mousePressed && (insideCircle || !requireMousePressedInCircleToContinue)){
      if(speed > 1){
//        player.play();
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
