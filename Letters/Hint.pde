int TWEEN_TIME_CONSTANT = 0.2;
float MIN_TWEEN_TIME = 7;
float STROKE_DELAY = 5;
float HOLD_TIME = 18;

class Hint {
  Letter l;
  int state = 0;
  float pathLength = 0;
  boolean hinting = true;
  Tween t;
  
  Hint(Letter l) {
    this.l = l;  
    float dist = l.points[state].pos.distanceTo(l.points[state+1].pos);
    t = new Tween(this, "pathLength", 1f, max(MIN_TWEEN_TIME, TWEEN_TIME_CONSTANT*dist)).play();
  }
  
  void stop() {
    hinting = false;
    t.stop();
  }
  
  void hintLetter() {
    if(!hinting){
      return;
    }
    
    drawHint();
   
    if(pathLength >= 1){
      state++;
      if(state+1 < l.points.length && l.points[state+1].newStroke){
        state++;
      }
      if(state == l.points.length-1){
        t = t.noDelay().setDuration(HOLD_TIME).play(); // hold shape
      }else if(state >= l.points.length){
        hinting = false;
        t.stop();      
      }else{
        float dist = l.points[state].pos.distanceTo(l.points[state+1].pos);
        t = t.setDuration(max(MIN_TWEEN_TIME, TWEEN_TIME_CONSTANT*dist));
        t = t.delay(STROKE_DELAY).play();
      }
    }
  }
  
  void drawHint() {
    noFill();
    shapeMode(CORNER);
    stroke(241,184,244,100);
    strokeWeight(1);
    
    Vec2D intermediateTarget;
    beginShape();
    for(int i=0; i<l.points.length && i<=(state+1); i++){
      if(l.points[i].newStroke){
        endShape();      
        beginShape();
      }
      if(i == state+1){
        intermediateTarget = l.points[i-1].pos.interpolateTo(l.points[i].pos, pathLength); 
        vertex(intermediateTarget.x, intermediateTarget.y);
      }else{
        vertex(l.points[i].x, l.points[i].y);
      }
    } 
    endShape();
    
    if(intermediateTarget != null){
      noStroke();  
      fill(193,251,232,200);
      ellipseMode(CENTER);
      ellipse(intermediateTarget.x, intermediateTarget.y, CIRCLE_RADIUS, CIRCLE_RADIUS);   
    }
  }
}
