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
float currentScale;
Vec2D mouseXY, mouseModelVec2D;
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
  
  stretch = new Stretch(LETTER_WIDTH, LETTER_HEIGHT, 0.5);
}

void draw() {
  stretch.update();
  
  if(currentLetter.done && (currentLetterIndex+1) < letters.length){
    currentLetterIndex++;
    currentLetter = letters[currentLetterIndex];
    nextState = 0;
    done = false;
  }

//  background(232,35,176);
  background(255);
    
  currentLetter.drawIt();
  currentLetter.trace();  
}

void mouseReleased() {
  requireMousePressedInCircleToContinue = true;
  player.stop();
  player.cue(0);
}

