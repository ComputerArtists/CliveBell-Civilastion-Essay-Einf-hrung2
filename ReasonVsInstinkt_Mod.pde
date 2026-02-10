int currentMode = 1; // 1 = Basis-Dualität, 2 = Fade-Übergang, 3 = Partikel-Dualität, 4 = Symbole-Dualität
float offset = 0;

// Zufällige Farben und Anzahlen (bei 'c' neu gesetzt)
float instinktHue, instinktSat, instinktBri; // Links: Instinkt/Chaos
float reasonHue, reasonSat, reasonBri; // Rechts: Reason/Harmonie
int instinktCount, reasonCount; // Zufällige Anzahl von Formen
boolean showTriangles = true, showCircles = true, showLines = true;

// Partikel-Liste für Modus 3
ArrayList<Partikel> partikels = new ArrayList<Partikel>();

class Partikel {
  float x, y, speed, hue;
  Partikel(float x, float y, float hue) {
    this.x = x;
    this.y = y;
    this.speed = random(0.5, 1.5); // Langsam
    this.hue = hue;
  }
  void update(float reasonLevel) {
    x += speed * reasonLevel;
    if (x > width) x = 0;
  }
  void show(float reasonLevel) {
    fill(hue, 90 * reasonLevel, 80 + sin(offset + x)*20 * reasonLevel, 220);
    ellipse(x, y, 20, 20);
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeAll();
}

void randomizeAll() {
  instinktHue = random(0, 60); instinktSat = random(70, 100); instinktBri = random(50, 80); // Rot/Chaos
  reasonHue = random(120, 240); reasonSat = random(70, 100); reasonBri = random(70, 100); // Blau/Grün/Harmonie

  instinktCount = (int) random(10, 30); // Zufällige Anzahl links
  reasonCount = (int) random(5, 20); // Zufällige Anzahl rechts

  println("Neue Farben und Formen generiert!");
}

void draw() {
  background(10);
  offset += 0.005;

  float reasonLevel = map(mouseY, height, 0, 0.0, 1.0); // Oben = Reason stark

  // Geteilter Bildschirm
  line(width/2, 0, width/2, height);

  // Links: Instinkt – Chaos
  for (int i = 0; i < instinktCount * (1 - reasonLevel); i++) {
    fill(instinktHue, instinktSat, instinktBri + random(-10, 10));
    rect(random(0, width/2), random(height), 40, 40);
  }

  // Rechts: Reason – Harmonie
  if(currentMode == 1) {
  for (int i = 0; i < reasonCount * reasonLevel; i++) {
    float x = width/2 + 100 + cos(offset + i*2)*100 * reasonLevel;
    float y = 150 + i*30 + sin(offset + i)*30 * reasonLevel;
    fill(reasonHue, reasonSat * reasonLevel, reasonBri, 220);
    if (i % 2 == 0) ellipse(x, y, 50, 50);
    else triangle(x, y - 25, x - 25, y + 25, x + 25, y + 25);
  }
  }

  // Modus-spezifische Variationen
  if (currentMode == 2) {
    // Modus 2: Fade-Übergang
    for (int x = 0; x < width; x += 5) {
      float amt = map(x, 0, width, 0, 1);
      fill(lerpColor(color(instinktHue, instinktSat, instinktBri), color(reasonHue, reasonSat, reasonBri), reasonLevel * amt));
      rect(x, 0, 5, height);
    }
  }

  if (currentMode == 3) {
    // Modus 3: Partikel-Dualität
    for (Partikel p : partikels) {
      p.update(reasonLevel);
      p.show(reasonLevel);
    }
  }

  if (currentMode == 4) {
    // Modus 4: Symbole-Dualität (zuschaltbar)
    for (int i = 0; i < reasonCount * reasonLevel; i++) {
      float x = width/2 + 100 + cos(offset + i*2)*100 * reasonLevel;
      float y = 150 + i*30 + sin(offset + i)*30 * reasonLevel;
      fill(reasonHue, reasonSat * reasonLevel, reasonBri, 220);
      if (i % 3 == 0 && showCircles) ellipse(x, y, 50, 50);
      else if (i % 3 == 1 && showTriangles) triangle(x, y - 25, x - 25, y + 25, x + 25, y + 25);
      else if (showLines) {
        stroke(reasonHue, reasonSat * reasonLevel, reasonBri, 220);
        strokeWeight(5);
        line(x - 50, y, x + 50, y);
        noStroke();
      }
    }
  }

  fill(255);
  textSize(32);
  text("Reason vs Instinkt Dualität", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'4' = Modus, 'c' = Farben/Formen, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Reason-Stärke (oben = stark) | Klick = neue Partikel (Modus 3)", width/2, height - 30);
  text("'k' = Kreise an/aus | 'd' = Dreiecke an/aus | 'l' = Linien an/aus (Modus 4)", width/2, height - 90);
}

void mousePressed() {
  if (mouseButton == LEFT && currentMode == 3) {
    partikels.add(new Partikel(random(0, width), random(height), random(0, 360)));
  }
}

void keyPressed() {
  if (key >= '1' && key <= '4') {
    currentMode = key - '0';
    println("Modus gewechselt zu: " + currentMode);
  }
  if (key == 'c' || key == 'C') {
    randomizeAll();
    println("Neue Farben und Formen!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("ReasonVsInstinkt_Mod" + currentMode + "_####.png");
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
