int currentMode = 1; // 1 = Var 1+3, 2 = Var 2+1+3
float offset = 0;
ArrayList<Partikel> partikels = new ArrayList<Partikel>();

// Zufallsfarben für Pyramide, Basis und Werte (bei 'c' neu gesetzt)
float pyramidHue, pyramidSat, pyramidBri;
float baseHue, baseSat, baseBri;
float valueHue, valueSat, valueBri;

class Partikel {
  float x, y, speed;
  Partikel(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = random(0.5, 1.5); // Langsamere Partikelgeschwindigkeit
  }
  void update(float valueLevel) {
    y -= speed * valueLevel;
    if (y < 50) y = height - 50;
  }
  void show(float valueLevel) {
    float hue = lerp(baseHue, valueHue, valueLevel);
    fill(hue, valueSat * valueLevel, valueBri, 220);
    ellipse(x, y, 20, 20);
  }
}

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeColors();
}

void randomizeColors() {
  pyramidHue = random(40, 80); pyramidSat = random(70, 95); pyramidBri = random(70, 95);
  baseHue = random(0, 30); baseSat = random(10, 30); baseBri = random(30, 50);
  valueHue = 50; valueSat = random(80, 100); valueBri = random(80, 100); // Gold
  println("Neue zufällige Farben!");
}

void draw() {
  background(10);
  offset += 0.005; // Langsamere Geschwindigkeit

  float valueLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Pyramide-Hintergrund
  fill(lerpColor(color(baseHue, baseSat, baseBri), color(pyramidHue, pyramidSat, pyramidBri), valueLevel));
  triangle(width/2, height - 50, width*0.1, 50, width*0.9, 50);

  if (currentMode == 1) {
    drawMode1(valueLevel);
  } else if (currentMode == 2) {
    drawMode2(valueLevel);
  }

  // Partikel (gemeinsam für beide Modi)
  for (Partikel p : partikels) {
    p.update(valueLevel);
    p.show(valueLevel);
  }

  fill(255);
  textSize(32);
  text("Wert-Hierarchie – Goldene Pyramide", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'/'2' = Modus, 'c' = Farben, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Wertschätzung | Klick = neue Partikel", width/2, height - 30);
}

void drawMode1(float valueLevel) {
  // Variation 1 + 3: Symbole + Partikel
  // Utilitaristische Basis – Werkzeuge
  for (int i = 0; i < 15 * (1 - valueLevel); i++) {
    fill(baseHue, baseSat, baseBri + random(-10, 10));
    rect(random(width*0.2, width*0.8), random(height*0.6, height - 50), 30, 60);
    line(random(width*0.2, width*0.8), random(height*0.6, height - 50), random(width*0.2, width*0.8), random(height*0.6, height - 50)); // "Griff"
  }

  // Intrinsische Werte oben – Kunst-Symbole
  for (int i = 0; i < 12 * valueLevel; i++) {
    float y = 150 + i*25 + sin(offset + i)*25 * valueLevel;
    fill(valueHue, valueSat, valueBri + sin(offset + i)*20 * valueLevel, 220);
    if (i % 2 == 0) ellipse(width/2 + cos(offset + i*2)*120 * valueLevel, y, 50, 50);
    else triangle(width/2 + cos(offset + i*2)*120 * valueLevel, y - 25, width/2 + cos(offset + i*2)*120 * valueLevel - 25, y + 25, width/2 + cos(offset + i*2)*120 * valueLevel + 25, y + 25);
  }
}

void drawMode2(float valueLevel) {
  // Variation 2 + 1 + 3: Fade-Übergang + Symbole + Partikel
  // Fade-Gradient
  for (int y = height - 50; y > 50; y -= 5) {
    float amt = map(y, 50, height - 50, 1.0, 0.0);
    fill(lerpColor(color(baseHue, baseSat, baseBri), color(pyramidHue, pyramidSat, pyramidBri), valueLevel * amt));
    rect(0, y, width, 5);
  }

  // Utilitaristische Basis – Werkzeuge
  for (int i = 0; i < 15 * (1 - valueLevel); i++) {
    fill(baseHue, baseSat, baseBri + random(-10, 10));
    rect(random(width*0.2, width*0.8), random(height*0.6, height - 50), 30, 60);
    line(random(width*0.2, width*0.8), random(height*0.6, height - 50), random(width*0.2, width*0.8), random(height*0.6, height - 50));
  }

  // Intrinsische Werte oben – Kunst-Symbole
  for (int i = 0; i < 12 * valueLevel; i++) {
    float y = 150 + i*25 + sin(offset + i)*25 * valueLevel;
    fill(valueHue, valueSat, valueBri + sin(offset + i)*20 * valueLevel, 220);
    if (i % 2 == 0) ellipse(width/2 + cos(offset + i*2)*120 * valueLevel, y, 50, 50);
    else triangle(width/2 + cos(offset + i*2)*120 * valueLevel, y - 25, width/2 + cos(offset + i*2)*120 * valueLevel - 25, y + 25, width/2 + cos(offset + i*2)*120 * valueLevel + 25, y + 25);
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    partikels.add(new Partikel(random(width*0.2, width*0.8), height - 50));
  }
}

void keyPressed() {
  if (key == '1') currentMode = 1;
  if (key == '2') currentMode = 2;
  if (key == 'c' || key == 'C') randomizeColors();
  if (key == 's' || key == 'S') {
    saveFrame("WertPyramide_Mod" + currentMode + "_####.png");
    println("Gespeichert!");
  }
}
