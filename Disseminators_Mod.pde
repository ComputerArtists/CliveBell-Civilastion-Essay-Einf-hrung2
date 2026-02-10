int currentMode = 1; // 1 = Leuchtende Kerne, 2 = Strahlende Minderheit, 3 = Verbreitungs-Netzwerk
float offset = 0;

// Zufällige Farben und Anzahl (bei 'c' neu gesetzt)
float coreHue, coreSat, coreBri;
int coreCount;

// Liste der Disseminator-Kerne
ArrayList<PVector> cores = new ArrayList<PVector>();

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeAll();
  // Start mit einigen Kernen
  for (int i = 0; i < 10; i++) {
    cores.add(new PVector(random(width), random(height)));
  }
}

void randomizeAll() {
  coreHue = random(40, 80); // Gold-Bereich
  coreSat = random(80, 100);
  coreBri = random(80, 100);

  coreCount = (int) random(8, 25); // Zufällige Anzahl Kerne

  // Neue Kerne erzeugen
  cores.clear();
  for (int i = 0; i < coreCount; i++) {
    cores.add(new PVector(random(width), random(height)));
  }

  println("Neue Farben und Anzahl der Disseminatoren generiert!");
}

void draw() {
  background(5, 10, 20);
  offset += 0.005;

  float spreadLevel = map(mouseY, height, 0, 0.0, 1.0); // Oben = starke Verbreitung

  // Dunkles Chaos-Feld (die Masse)
  for (int i = 0; i < 300 * (1 - spreadLevel); i++) {
    fill(0, 0, random(20, 40));
    ellipse(random(width), random(height), 15 + random(-5, 5), 15 + random(-5, 5));
  }

  // Modus-spezifische Inhalte
  if (currentMode == 1) {
    // Modus 1: Leuchtende Kerne
    for (PVector p : cores) {
      float pulse = sin(offset + p.x)*20 + 80 * spreadLevel;
      fill(coreHue, coreSat, pulse, 220);
      ellipse(p.x, p.y, 30 + pulse * 0.5, 30 + pulse * 0.5);
    }
  }

  if (currentMode == 2) {
    // Modus 2: Strahlende Minderheit
    for (PVector p : cores) {
      float pulse = sin(offset + p.x)*20 + 80 * spreadLevel;
      fill(coreHue, coreSat, pulse, 220);
      ellipse(p.x, p.y, 40 + pulse * 0.5, 40 + pulse * 0.5);

      // Strahlen
      noFill();
      stroke(coreHue, coreSat, pulse, 150 * spreadLevel);
      strokeWeight(2);
      for (int j = 0; j < 8; j++) {
        float a = j * TWO_PI / 8 + offset;
        line(p.x, p.y, p.x + cos(a)*pulse*2, p.y + sin(a)*pulse*2);
      }
      noStroke();
    }
  }

  if (currentMode == 3) {
    // Modus 3: Verbreitungs-Netzwerk
    for (int i = 0; i < cores.size(); i++) {
      PVector p = cores.get(i);
      float pulse = sin(offset + i)*20 + 80 * spreadLevel;
      fill(coreHue, coreSat, pulse, 220);
      ellipse(p.x, p.y, 30 + pulse * 0.5, 30 + pulse * 0.5);

      // Verbindungen zu anderen Kernen
      for (int j = i+1; j < cores.size(); j++) {
        PVector q = cores.get(j);
        float dist = dist(p.x, p.y, q.x, q.y);
        if (dist < 200 * spreadLevel) {
          stroke(coreHue, coreSat, pulse, 100 * spreadLevel);
          strokeWeight(2);
          line(p.x, p.y, q.x, q.y);
        }
      }
      noStroke();
    }
  }

  fill(255);
  textSize(32);
  text("Civilization and Its Disseminators", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'3' = Modus, 'c' = Farben/Anzahl, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Verbreitungsstärke (oben = stark) | Klick = neuer Disseminator", width/2, height - 30);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    cores.add(new PVector(mouseX, mouseY));
  }
}

void keyPressed() {
  if (key >= '1' && key <= '3') {
    currentMode = key - '0';
    println("Modus gewechselt zu: " + currentMode);
  }
  if (key == 'c' || key == 'C') {
    randomizeAll();
    println("Neue Farben und Kerne!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("Disseminators_Mod" + currentMode + "_####.png");
    println("Gespeichert!");
  }
}
