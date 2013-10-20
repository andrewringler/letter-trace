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
