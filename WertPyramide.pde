float offset = 0;
boolean showCircles = true;
boolean showTriangles = true;
boolean showLines = true;

// Zufällige Farben und Anzahlen (werden bei 'c' neu gesetzt)
float circleHue, circleSat, circleBri;
float triangleHue, triangleSat, triangleBri;
float lineHue, lineSat, lineBri;
int circleCount, triangleCount, lineCount;

// Partikel-Liste
ArrayList<Partikel> partikels = new ArrayList<Partikel>();

class Partikel {
  float x, y, speed, hue;
  Partikel(float x, float y, float hue) {
    this.x = x;
    this.y = y;
    this.speed = random(0.8, 1.8);
    this.hue = hue;
  }
  void update(float valueLevel) {
    y -= speed * valueLevel;
    if (y < 50) y = height - 50;
  }
  void show(float valueLevel) {
    fill(hue, 90 * valueLevel, 80 + sin(offset + x)*20 * valueLevel, 220);
    ellipse(x, y, 20 + sin(offset + x)*10 * valueLevel, 20 + sin(offset + x)*10 * valueLevel);
  }
}

// Basis-Farben (werden bei 'c' überschrieben)
float pyramidHue = 50;
float baseHue = 0;

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeColors();
}

void randomizeColors() {
  pyramidHue = random(40, 80);
  baseHue = random(0, 30);

  // Separate Farben für Kreise, Dreiecke, Linien
  circleHue = random(0, 360);
  circleSat = random(70, 100);
  circleBri = random(70, 95);

  triangleHue = random(0, 360);
  triangleSat = random(70, 100);
  triangleBri = random(70, 95);

  lineHue = random(0, 360);
  lineSat = random(70, 100);
  lineBri = random(70, 95);

  // Zufällige Anzahl pro Symbol-Art
  circleCount   = (int) random(6, 22);
  triangleCount = (int) random(4, 16);
  lineCount     = (int) random(5, 20);

  println("Neue Farben & Anzahlen generiert!");
}

void draw() {
  background(10);
  offset += 0.005;

  float valueLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Variation 2: Fade-Gradient über die ganze Canvas
  for (int y = 0; y < height; y += 5) {
    float amt = map(y, 0, height, 1.0, 0.0);
    fill(lerpColor(color(baseHue, 10, 30), color(pyramidHue, 90, 90), valueLevel * amt));
    rect(0, y, width, 5);
  }

  // Utilitaristische Basis – Werkzeuge
  for (int i = 0; i < 15 * (1 - valueLevel); i++) {
    fill(baseHue, 10, 40 + random(-10, 10));
    rect(random(width*0.2, width*0.8), random(height*0.6, height - 50), 30, 60);
    line(random(width*0.2, width*0.8), random(height*0.6, height - 50), random(width*0.2, width*0.8), random(height*0.6, height - 50));
  }

  // Intrinsische Werte oben – Symbole (zuschaltbar + zufällige Anzahl)
  for (int i = 0; i < circleCount * valueLevel; i++) {
    if (showCircles) {
      float y = 150 + i*25 + sin(offset + i)*25 * valueLevel;
      float x = width/2 + cos(offset + i*2)*120 * valueLevel;
      fill(circleHue, circleSat * valueLevel, circleBri, 220);
      ellipse(x, y, 50, 50);
    }
  }

  for (int i = 0; i < triangleCount * valueLevel; i++) {
    if (showTriangles) {
      float y = 150 + i*25 + sin(offset + i + 10)*25 * valueLevel;
      float x = width/2 + cos(offset + i*2 + 5)*120 * valueLevel;
      fill(triangleHue, triangleSat * valueLevel, triangleBri, 220);
      triangle(x, y - 25, x - 25, y + 25, x + 25, y + 25);
    }
  }

  for (int i = 0; i < lineCount * valueLevel; i++) {
    if (showLines) {
      float y = 150 + i*25 + sin(offset + i + 20)*25 * valueLevel;
      float x = width/2 + cos(offset + i*2 + 10)*120 * valueLevel;
      stroke(lineHue, lineSat * valueLevel, lineBri, 220);
      strokeWeight(5);
      line(x - 50, y, x + 50, y);
      noStroke();
    }
  }

  // Partikel
  for (Partikel p : partikels) {
    p.update(valueLevel);
    p.show(valueLevel);
  }

  fill(255);
  textSize(32);
  text("Wert-Pyramide – Aufstieg der Werte", width/2, 80);
  textSize(24);
  text("Maus Y = Wertschätzung | Klick = neue Partikel", width/2, height - 60);
  text("'c' = neue Farben & Anzahlen | 's' = Speichern", width/2, height - 30);
  text("'k' = Kreise an/aus | 'd' = Dreiecke an/aus | 'l' = Linien an/aus", width/2, height - 90);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    partikels.add(new Partikel(random(width*0.2, width*0.8), height - 50, random(0, 360)));
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    randomizeColors();
  }
  if (key == 's' || key == 'S') {
    saveFrame("WertPyramide_####.png");
    println("Gespeichert!");
  }
  if (key == 'k' || key == 'K') {
    showCircles = !showCircles;
    println("Kreise: " + (showCircles ? "an" : "aus"));
  }
  if (key == 'd' || key == 'D') {
    showTriangles = !showTriangles;
    println("Dreiecke: " + (showTriangles ? "an" : "aus"));
  }
  if (key == 'l' || key == 'L') {
    showLines = !showLines;
    println("Linien: " + (showLines ? "an" : "aus"));
  }
}
