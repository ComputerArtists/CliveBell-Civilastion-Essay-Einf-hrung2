float offset = 0;
float recipeLevel = 0.0;

// Liste der Rezept-Bausteine (unten grau, oben gold)
ArrayList<Baustein> bausteine = new ArrayList<Baustein>();

class Baustein {
  float x, y, w, h, hue;
  Baustein(float x, float y, float w, float h, float hue) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.hue = hue;
  }
  void show(float level) {
    float alpha = map(y, height, 0, 180 * (1 - level), 255 * level);
    fill(hue, 90 * level, 80 + sin(offset + x)*20 * level, alpha);
    rect(x, y, w, h, 8);
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Start mit grauer Basis (unten) und ein paar goldenen Bausteinen (oben)
  for (int i = 0; i < 30; i++) {
    float x = random(width*0.1, width*0.9);
    float y = height - random(50, 250);
    float w = random(30, 80);
    float h = random(40, 100);
    bausteine.add(new Baustein(x, y, w, h, random(0, 40))); // Grau/Utilitaristisch
  }
  for (int i = 0; i < 8; i++) {
    float x = random(width*0.3, width*0.7);
    float y = random(80, 300);
    float w = random(60, 140);
    float h = random(50, 120);
    bausteine.add(new Baustein(x, y, w, h, random(40, 80))); // Gold/Überfluss
  }
}

void draw() {
  background(10);
  offset += 0.005;

  recipeLevel = map(mouseY, height, 0, 0.0, 1.0); // Oben = Rezept vollständig

  // Dunkler Hintergrund (Notwendigkeit, Mangel)
  fill(0, 0, 20 + 15 * (1 - recipeLevel));
  rect(0, 0, width, height);

  // Umgedrehte Pyramide – Basis unten breit, Spitze oben
  fill(lerpColor(color(0, 0, 30), color(50, 90, 90), recipeLevel));
  triangle(width/2, height - 50, width*0.1, 50 + (height - 100) * (1 - recipeLevel), width*0.9, 50 + (height - 100) * (1 - recipeLevel));

  // Rezept-Bausteine (unten grau, oben gold)
  for (Baustein b : bausteine) {
    b.show(recipeLevel);
  }

  fill(255);
  textSize(32);
  text("How to Make a Civilization", width/2, 80);
  textSize(24);
  text("Die Rezept-Pyramide", width/2, 120);
  textSize(20);
  text("Maus Y = Vollständigkeit des Rezepts (oben = Pyramide komplett)", width/2, height - 80);
  text("Linksklick = neuer Baustein | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    float x = random(width*0.2, width*0.8);
    float y = random(80, height - 100);
    float w = random(60, 140);
    float h = random(50, 120);
    float hue = random(40, 80); // Gold/Überfluss
    bausteine.add(new Baustein(x, y, w, h, hue));
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Baustein b : bausteine) {
      b.hue = random(0, 80); // Mischung aus Grau und Gold
    }
    println("Neue Farben für alle Bausteine!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("RezeptPyramide_####.png");
    println("Gespeichert!");
  }
}
