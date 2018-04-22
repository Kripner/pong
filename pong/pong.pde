Game game;
void setup() {
  size(750, 300);
  game = new Game(new HumanPlayer(), new AIPlayer(), true);
}

void draw() {
  if(game.nextFrame()) {
    game.reset();
  }
}
