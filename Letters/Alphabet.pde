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
