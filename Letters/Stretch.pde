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
