int currentMode = 1; // 1 = Thron der Vernunft, 2 = Dualität, 3 = Interaktiver Thron
float offset = 0;

// Zufällige Farben und Anzahlen (bei 'c' neu gesetzt)
float chaosHue, chaosSat, chaosBri; // Chaos/Instinkt
float harmonyHue, harmonySat, harmonyBri; // Harmonie/Reason
float throneHue, throneSat, throneBri; // Thron
int chaosCount, harmonyCount; // Zufällige Anzahl von Formen

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
    y -= speed * reasonLevel;
    if (y < 50) y = height - 50;
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
  chaosHue = random(0, 60); chaosSat = random(70, 100); chaosBri = random(50, 80); // Rot/Chaos
  harmonyHue = random(120, 240); harmonySat = random(70, 100); harmonyBri = random(70, 100); // Blau/Grün/Harmonie
  throneHue = random(40, 80); throneSat = random(80, 100); throneBri = random(80, 100); // Gold/Thron

  chaosCount = (int) random(20, 40); // Anzahl links
  harmonyCount = (int) random(10, 25); // Anzahl rechts

  println("Neue Farben und Formen generiert!");
}

void draw() {
  background(10);
  offset += 0.005;

  float reasonLevel = map(mouseY, height, 0, 0.0, 1.0); // Oben = Reason stark

  if (currentMode == 1) {
    // Modus 1: Thron der Vernunft (Basis)
    // Chaos links
    fill(lerpColor(color(chaosHue, chaosSat, chaosBri), color(0, 20, 30), reasonLevel));
    rect(0, 0, width/2, height);
    for (int i = 0; i < chaosCount * (1 - reasonLevel); i++) {
      stroke(chaosHue, 90, 80, 180);
      strokeWeight(2);
      line(random(0, width/2), random(height), random(0, width/2), random(height));
    }

    // Harmonie rechts
    fill(lerpColor(color(0, 20, 30), color(harmonyHue, harmonySat, harmonyBri), reasonLevel));
    rect(width/2, 0, width/2, height);
    noFill();
    stroke(harmonyHue, 90, 90 + sin(offset)*20 * reasonLevel, 220);
    strokeWeight(4);
    for (int i = 0; i < harmonyCount * reasonLevel; i++) {
      float r = 80 + i*30 + sin(offset + i)*20 * reasonLevel;
      ellipse(width*0.75, height/2, r*2, r*2);
    }

    // Zentraler Thron
    fill(throneHue, throneSat, throneBri + sin(offset*2)*20 * reasonLevel, 220);
    ellipse(width/2, height/2, 200 + sin(offset)*40 * reasonLevel, 200 + sin(offset)*40 * reasonLevel);
    // Krone
    fill(throneHue, throneSat, throneBri + 20, 220);
    triangle(width/2 - 40, height/2 - 100, width/2 + 40, height/2 - 100, width/2, height/2 - 140);
  } 

  if (currentMode == 2) {
    // Modus 2: Dualität mit Fade-Übergang
    for (int x = 0; x < width; x += 5) {
      float amt = map(x, 0, width, 0, 1);
      fill(lerpColor(color(chaosHue, chaosSat, chaosBri), color(harmonyHue, harmonySat, harmonyBri), reasonLevel * amt));
      rect(x, 0, 5, height);
    }

    // Chaos links – wilde Formen
    for (int i = 0; i < chaosCount * (1 - reasonLevel); i++) {
      fill(chaosHue, chaosSat, chaosBri + random(-10, 10), 180);
      triangle(random(0, width/2), random(height), random(0, width/2), random(height), random(0, width/2), random(height));
    }

    // Harmonie rechts – klare Formen
    for (int i = 0; i < harmonyCount * reasonLevel; i++) {
      float x = width/2 + 100 + cos(offset + i*2)*100 * reasonLevel;
      float y = 150 + i*30 + sin(offset + i)*30 * reasonLevel;
      fill(harmonyHue, harmonySat * reasonLevel, harmonyBri, 220);
      ellipse(x, y, 50, 50);
    }
  } 

  if (currentMode == 3) {
    // Modus 3: Interaktiver Thron – Klick erzeugt neue Vernunft-Symbole
    // Chaos links
    fill(lerpColor(color(chaosHue, chaosSat, chaosBri), color(0, 20, 30), reasonLevel));
    rect(0, 0, width/2, height);
    for (int i = 0; i < chaosCount * (1 - reasonLevel); i++) {
      stroke(chaosHue, 90, 80, 180);
      strokeWeight(2);
      line(random(0, width/2), random(height), random(0, width/2), random(height));
    }

    // Harmonie rechts
    fill(lerpColor(color(0, 20, 30), color(harmonyHue, harmonySat, harmonyBri), reasonLevel));
    rect(width/2, 0, width/2, height);
    noFill();
    stroke(harmonyHue, 90, 90 + sin(offset)*20 * reasonLevel, 220);
    strokeWeight(4);
    for (int i = 0; i < harmonyCount * reasonLevel; i++) {
      float r = 80 + i*30 + sin(offset + i)*20 * reasonLevel;
      ellipse(width*0.75, height/2, r*2, r*2);
    }

    // Zentraler Thron
    fill(throneHue, throneSat, throneBri + sin(offset*2)*20 * reasonLevel, 220);
    ellipse(width/2, height/2, 200 + sin(offset)*40 * reasonLevel, 200 + sin(offset)*40 * reasonLevel);
    // Krone
    fill(throneHue, throneSat, throneBri + 20, 220);
    triangle(width/2 - 40, height/2 - 100, width/2 + 40, height/2 - 100, width/2, height/2 - 140);

    // Neue Symbole bei Klick (in Modus 3)
    for (Partikel p : partikels) {
      p.update(reasonLevel);
      p.show(reasonLevel);
    }
  } 

  fill(255);
  textSize(32);
  text("Reason Enthroned – Der Thron der Vernunft", width/2, 80);
  textSize(24);
  text("Modus: " + currentMode + " ('1'-'3' = Modus, 'c' = Farben/Formen, 's' = Speichern)", width/2, height - 60);
  text("Maus Y = Reason-Stärke (oben = stark) | Klick = neue Symbole (Modus 3)", width/2, height - 30);
}

void mousePressed() {
  if (mouseButton == LEFT && currentMode == 3) {
    partikels.add(new Partikel(random(0, width), random(height), random(0, 360)));
  }
}

void keyPressed() {
  if (key >= '1' && key <= '3') {
    currentMode = key - '0';
    println("Modus: " + currentMode);
  }
  if (key == 'c' || key == 'C') {
    randomizeAll();
    println("Neue Farben und Formen!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("ReasonEnthroned_Mod" + currentMode + "_####.png");
    println("Gespeichert!");
  }
}
