int currentMode = 1; // 1 = Basis, 2 = Symbole-Explosion, 3 = Partikel-Aufstieg, 4 = Fade-Übergang
float offset = 0;
float aestheticHue = 210;
float intellectualHue = 30;
float ethicalHue = 140;

// Partikel-Liste für Modus 3
ArrayList<Partikel> partikels = new ArrayList<Partikel>();

class Partikel {
  float x, y, speed, hue;
  Partikel(float x, float y, float hue) {
    this.x = x;
    this.y = y;
    this.speed = random(0.8, 1.8); // Langsam
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

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  randomizeColors();
}

void randomizeColors() {
  aestheticHue = random(180, 240);
  intellectualHue = random(0, 60);
  ethicalHue = random(120, 180);
  println("Neue zufällige Farben!");
}

void draw() {
  background(10);
  offset += 0.005; // Sehr langsam

  float valueLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Zentrale Balance – Kreis (Ästhetik)
  fill(aestheticHue, 80 * valueLevel, 80 + sin(offset)*20 * valueLevel, 220);
  ellipse(width/2, height/2 - 100, 150 + sin(offset)*30 * valueLevel, 150 + sin(offset)*30 * valueLevel);

  // Dreieck (Intellekt)
  fill(intellectualHue, 90 * valueLevel, 80 + sin(offset + 1)*20 * valueLevel, 220);
  triangle(width/2, height/2 + 100, width/2 - 100, height/2 + 200, width/2 + 100, height/2 + 200);

  // Linie (Ethik)
  stroke(ethicalHue, 90 * valueLevel, 80 + sin(offset + 2)*20 * valueLevel, 220);
  strokeWeight(10 + sin(offset + 2)*5 * valueLevel);
  line(width/2 - 200, height/2, width/2 + 200, height/2);
  noStroke();

  // Modus-spezifische Inhalte
  if (currentMode == 2) {
    // Modus 2: Symbole-Explosion (bei Klick neue Formen)
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI / 8 + offset;
      float r = 80 + sin(offset + i)*40 * valueLevel;
      fill(aestheticHue + i*30, 90 * valueLevel, 80, 220);
      ellipse(width/2 + cos(a)*r, height/2 + sin(a)*r, 30, 30);
    }
  }

  if (currentMode == 3) {
    // Modus 3: Partikel-Aufstieg
    for (Partikel p : partikels) {
      p.update(valueLevel);
      p.show(valueLevel);
    }
  }

  if (currentMode == 4) {
    // Modus 4: Fade-Übergang
    for (int y = 0; y < height; y += 5) {
      float amt = map(y, 0, height, 0, 1);
      fill(lerpColor(color(0, 0, 30), color(50, 90, 90), valueLevel * amt));
      rect(0, y, width, 5);
    }
  }

  fill(255);
  textSize(32);
  text("Wert-Harmonie – Leuchtende Balance", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'4' = Modus, 'c' = Farben, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Wertschätzung | Klick = neue Partikel (Modus 3)", width/2, height - 30);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (currentMode == 2) {
      // Modus 2: neue Symbol-Explosion
      for (int i = 0; i < 6; i++) {
        float a = i * TWO_PI / 6 + random(TWO_PI);
        float r = random(50, 150);
        fill(random(0, 360), 90, 90, 220);
        ellipse(width/2 + cos(a)*r, height/2 + sin(a)*r, 30, 30);
      }
    }
    if (currentMode == 3) {
      // Modus 3: neue Partikel
      partikels.add(new Partikel(random(width*0.3, width*0.7), height - 50, random(0, 360)));
    }
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
    saveFrame("WertHarmonie_Mod" + currentMode + "_####.png");
    println("Gespeichert!");
  }
}
