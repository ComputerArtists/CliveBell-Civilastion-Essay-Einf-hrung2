int currentMode = 1; // 1–6 für die Kapitel
float offset = 0;

// Globale Zufallsfarben (werden bei 'c' neu gesetzt)
float chaosHue, chaosSat, chaosBri;
float valueHue, valueSat, valueBri;
float reasonHue, reasonSat, reasonBri;
float disseminatorHue, disseminatorSat, disseminatorBri;

// Partikel-Listen für verschiedene Modi
ArrayList<Partikel> barbarismParticles = new ArrayList<Partikel>();
ArrayList<Partikel> valueParticles = new ArrayList<Partikel>();
ArrayList<Funke> disseminators = new ArrayList<Funke>();

class Partikel {
  float x, y, speed, hue;
  Partikel(float x, float y, float hue) {
    this.x = x;
    this.y = y;
    this.speed = random(0.8, 2.0);
    this.hue = hue;
  }
  void update(float level) {
    y -= speed * level;
    if (y < 50) y = height - 50;
  }
  void show(float level) {
    fill(hue, 90 * level, 80 + sin(offset + x)*20 * level, 220);
    ellipse(x, y, 20 + sin(offset + x)*10 * level, 20 + sin(offset + x)*10 * level);
  }
}

class Funke {
  float x, y, size;
  Funke(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(30, 80);
  }
  void show(float spreadLevel) {
    float pulse = sin(offset + x)*20 + 80 * spreadLevel;
    fill(disseminatorHue, 90 * spreadLevel, pulse, 220);
    ellipse(x, y, size + pulse * 0.5, size + pulse * 0.5);
    noFill();
    stroke(disseminatorHue, 90 * spreadLevel, pulse, 150 * spreadLevel);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI / 8 + offset;
      line(x, y, x + cos(a)*pulse*2, y + sin(a)*pulse*2);
    }
    noStroke();
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeAllColors();
}

void randomizeAllColors() {
  chaosHue = random(0, 60);
  chaosSat = random(70, 100);
  chaosBri = random(50, 80);

  valueHue = random(40, 80);
  valueSat = random(80, 100);
  valueBri = random(80, 100);

  reasonHue = random(120, 240);
  reasonSat = random(70, 100);
  reasonBri = random(70, 100);

  disseminatorHue = random(40, 80);
  disseminatorSat = random(80, 100);
  disseminatorBri = random(80, 100);

  println("Alle Farben neu zufällig gesetzt!");
}

void draw() {
  background(5, 10, 20);
  offset += 0.005;

  float level = map(mouseY, height, 0, 0.0, 1.0);

  if (currentMode == 1) {
    // Modus 1: Trias Barbarica – Chaos
    fill(chaosHue, chaosSat * (1 - level), chaosBri, 220);
    rect(0, 0, width, height);
    for (int i = 0; i < 40 * (1 - level); i++) {
      stroke(random(0, 60), 90, 80, 180);
      strokeWeight(2);
      line(random(width), random(height), random(width), random(height));
    }
  }

  if (currentMode == 2) {
    // Modus 2: Paragons – Zeitstrahl
    stroke(255, 180 * level);
    strokeWeight(6);
    line(100, height/2, 900, height/2);
    float athensX = 250, renX = 500, franceX = 750;
    float pulse = sin(offset)*20 + 80 * level;
    fill(reasonHue, reasonSat, pulse, 220);
    ellipse(athensX, height/2, 140, 140);
    ellipse(renX, height/2, 140, 140);
    ellipse(franceX, height/2, 140, 140);
  }

  if (currentMode == 3) {
    // Modus 3: Wert-Pyramide
    fill(lerpColor(color(chaosHue, 10, 30), color(valueHue, 90, 90), level));
    triangle(width/2, height - 50, width*0.1, 50, width*0.9, 50);
  }

  if (currentMode == 4) {
    // Modus 4: Reason Enthroned – Thron
    fill(reasonHue, reasonSat, reasonBri + sin(offset*2)*20 * level, 220);
    ellipse(width/2, height/2, 200 + sin(offset)*40 * level, 200 + sin(offset)*40 * level);
    fill(reasonHue, reasonSat, reasonBri + 20, 220);
    triangle(width/2 - 40, height/2 - 100, width/2 + 40, height/2 - 100, width/2, height/2 - 140);
  }

  if (currentMode == 5) {
    // Modus 5: Disseminators – Funken im Dunkel
    for (int i = 0; i < 300 * (1 - level); i++) {
      fill(0, 0, random(20, 40));
      ellipse(random(width), random(height), 15 + random(-5, 5), 15 + random(-5, 5));
    }
    for (Funke f : disseminators) {
      f.show(level);
    }
  }

  fill(255);
  textSize(32);
  text("Civilization – Clive Bell", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'5' = Kapitel, 'c' = Farben, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Intensität | Klick = neue Elemente", width/2, height - 30);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (currentMode == 5) {
      disseminators.add(new Funke(mouseX, mouseY));
    }
  }
}

void keyPressed() {
  if (key >= '1' && key <= '5') {
    currentMode = key - '0';
  }
  if (key == 'c' || key == 'C') {
    randomizeAllColors();
  }
  if (key == 's' || key == 'S') {
    saveFrame("Civilization_Mod" + currentMode + "_####.png");
  }
}
