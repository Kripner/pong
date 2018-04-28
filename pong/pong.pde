Game currentGame;
Population population;
void setup() {
  size(750, 300);
  population = new Population(50);
}

void draw() {
  if (currentGame == null || currentGame.nextFrame()) {
    //println("Training...");
    //population.train(250);
    //println("Training completed");
    
    
    currentGame = new Game(new AIPlayer(), new GAPlayer(), true);
  }
}
