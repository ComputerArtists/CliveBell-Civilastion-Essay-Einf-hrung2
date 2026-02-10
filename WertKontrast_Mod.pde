int currentMode = 1; // 1 = Basis-Kontrast, 2 = Fade, 3 = Partikel, 4 = Symbole-Kontrast
float offset = 0;

// Zufallsfarben (werden bei 'c' neu gesetzt)
float leftHue, leftSat, leftBri; // Links: Chaos/Grau
float rightHue, rightSat, rightBri; // Rechts: Harmonie/Gold

// Separate zuschaltbare Symbole (für Modus 4)
boolean showCircles = true;
boolean showTriangles = true;
boolean showLines = true;

// Partikel-Liste für Modus 3
ArrayList<Partikel> partikels = new ArrayList<Partikel>();

class Partikel {
  float x, y, speed, hue;
  Partikel(float x, float y, float hue) {
    this.x = x;
    this.y = y;
    this.speed = random(-2.0, 2.0); // Kann nach links/rechts ziehen
    this.hue = hue;
  }
  void update(float valueLevel) {
    x += speed * (valueLevel - 0.5) * 2; // Zieht nach rechts bei hohem valueLevel
    y += random(-1, 1); // Leichtes Zittern
    if (x < 0) x = width;
    if (x > width) x = 0;
  }
  void show(float valueLevel) {
    fill(hue, 90 * valueLevel, 80 + sin(offset + x)*20 * valueLevel, 220);
    ellipse(x, y, 20 + sin(offset + x)*10 * valueLevel, 20 + sin(offset + x)*10 * valueLevel);
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeColors();
}

void randomizeColors() {
  leftHue = random(0, 40); leftSat = random(10, 40); leftBri = random(30, 60); // Grau/Chaos
  rightHue = random(40, 80); rightSat = random(80, 100); rightBri = random(80, 100); // Gold/Harmonie
  println("Neue Farben!");
}

void draw() {
  background(10);
  offset += 0.005;

  float valueLevel = map(mouseY, height, 0, 0.0, 1.0); // Oben = starke Werte rechts

  // Geteilter Bildschirm
  line(width/2, 0, width/2, height);

  // Links: Ohne Werte – Chaos
  for (int i = 0; i < 20 * (1 - valueLevel); i++) {
    fill(leftHue, leftSat, leftBri + random(-10, 10));
    rect(random(0, width/2), random(height), 40, 40);
  }

  // Rechts: Mit Werte – Harmonie
  for (int i = 0; i < 15 * valueLevel; i++) {
    float x = width/2 + 100 + cos(offset + i*2)*100 * valueLevel;
    float y = 150 + i*30 + sin(offset + i)*30 * valueLevel;
    fill(rightHue, rightSat * valueLevel, rightBri, 220);
    if (i % 2 == 0) ellipse(x, y, 50, 50);
    else triangle(x, y - 25, x - 25, y + 25, x + 25, y + 25);
  }

  // Modus-spezifische Variationen
  if (currentMode == 2) {
    // Modus 2: Fade-Gradient über die ganze Canvas
    for (int x = 0; x < width; x += 5) {
      float amt = map(x, 0, width, 0, 1);
      fill(lerpColor(color(leftHue, leftSat, leftBri), color(rightHue, rightSat, rightBri), valueLevel * amt));
      rect(x, 0, 5, height);
    }
  }

  if (currentMode == 3) {
    // Modus 3: Partikel-Kontrast
    for (Partikel p : partikels) {
      p.update(valueLevel);
      p.show(valueLevel);
    }
  }

  if (currentMode == 4) {
    // Modus 4: Symbole-Kontrast (nur intrinsische Symbole rechts, zuschaltbar)
    for (int i = 0; i < 12 * valueLevel; i++) {
      float x = width/2 + 100 + cos(offset + i*2)*100 * valueLevel;
      float y = 150 + i*30 + sin(offset + i)*30 * valueLevel;
      fill(rightHue, rightSat * valueLevel, rightBri, 220);
      if (i % 3 == 0 && showCircles) ellipse(x, y, 50, 50);
      else if (i % 3 == 1 && showTriangles) triangle(x, y - 25, x - 25, y + 25, x + 25, y + 25);
      else if (showLines) {
        stroke(rightHue, rightSat * valueLevel, rightBri, 220);
        strokeWeight(5);
        line(x - 50, y, x + 50, y);
        noStroke();
      }
    }
  }

  fill(255);
  textSize(32);
  text("Wert-Kontrast – Vorher/Nachher", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'4' = Modus, 'c' = Farben, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Wertschätzung | Klick = neue Partikel (Modus 3)", width/2, height - 30);
  text("'k' = Kreise an/aus | 'd' = Dreiecke an/aus | 'l' = Linien an/aus", width/2, height - 90);
}

void mousePressed() {
  if (mouseButton == LEFT && currentMode == 3) {
    partikels.add(new Partikel(random(width*0.2, width*0.8), height - 50, random(0, 360)));
  }
}

void keyPressed() {
  if (key >= '1' && key <= '4') {
    currentMode = key - '0';
    println("Modus gewechselt zu: " + currentMode);
  }
  if (key == 'c' || key == 'C') {
    randomizeColors();
    println("Neue Farben!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("WertKontrast_Mod" + currentMode + "_####.png");
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
