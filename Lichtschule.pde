import processing.sound.*;

SoundFile enlightenSound;

float offset = 0;
float enlightenmentLevel = 0.0;

// Liste der Lehrer / Lichtkreise
ArrayList<Lehrer> lehrer = new ArrayList<Lehrer>();

// Zufällige Bell-Zitate für Popup
String[] bellZitate = {
  "Vernunft muss bewusst gefördert werden – durch Erziehung einer kleinen Elite.",
  "Ohne Vernunft gibt es nur Instinkt, Aberglaube und Grausamkeit.",
  "Zivilisation ist Reason enthroned – sie braucht Lehrer, nicht Massen.",
  "Die Schule der Vernunft ist die einzige Waffe gegen Barbarei.",
  "Die Elite muss die Fackel der Aufklärung weitergeben."
};

class Lehrer {
  float x, y, size, hue, driftOffset;
  Lehrer(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(40, 90);
    this.hue = random(120, 240); // Blau/Grün für Vernunft
    this.driftOffset = random(TWO_PI);
  }
  void update(float level) {
    // Leichte Bewegung (drift)
    x += sin(offset + driftOffset) * 0.5 * level;
    y += cos(offset + driftOffset * 1.3) * 0.4 * level;
    // Leichte Begrenzung
    if (x < width*0.15 || x > width*0.85) x = constrain(x, width*0.15, width*0.85);
    if (y < height*0.15 || y > height*0.85) y = constrain(y, height*0.15, height*0.85);
  }
  void show(float level) {
    float pulse = sin(offset + driftOffset) * 20 + 80 * level;
    fill(hue, 90 * level, pulse, 220);
    ellipse(x, y, size + pulse * 0.6, size + pulse * 0.6);
    
    // Lichtstrahlen
    noFill();
    stroke(hue, 90 * level, pulse, 150 * level);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI / 8 + offset * 0.4;
      line(x, y, x + cos(a) * pulse * 2.5 * level, y + sin(a) * pulse * 2.5 * level);
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
  
  // Sound laden (leises Klingeln bei Klick)
  enlightenSound = new SoundFile(this, "enlighten.wav"); // Datei im Sketch-Ordner
  
  // Start mit 4–6 Lehrern
  for (int i = 0; i < (int)random(4, 7); i++) {
    lehrer.add(new Lehrer(random(width*0.3, width*0.7), random(height*0.3, height*0.7)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  enlightenmentLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Dunkler Raum (Unwissenheit, Aberglaube)
  fill(0, 0, 20 + 10 * (1 - enlightenmentLevel));
  rect(0, 0, width, height);

  // Chaos-Partikel im Dunkel
  for (int i = 0; i < 300 * (1 - enlightenmentLevel); i++) {
    fill(random(0, 30), 20, random(20, 40));
    ellipse(random(width), random(height), 12 + random(-4, 4), 12 + random(-4, 4));
  }

  // Die Lichtschule – Lehrer strahlen aus
  for (Lehrer l : lehrer) {
    l.update(enlightenmentLevel);
    l.show(enlightenmentLevel);
  }

  // Netzwerk-Linien bei hohem Level (> 0.8)
  if (enlightenmentLevel > 0.8) {
    for (int i = 0; i < lehrer.size(); i++) {
      Lehrer l1 = lehrer.get(i);
      for (int j = i+1; j < lehrer.size(); j++) {
        Lehrer l2 = lehrer.get(j);
        float d = dist(l1.x, l1.y, l2.x, l2.y);
        if (d < 300) {
          stroke(180, 90, 90 + sin(offset)*30, 120 * (enlightenmentLevel - 0.8) * 5);
          strokeWeight(2 + sin(offset)*1);
          line(l1.x, l1.y, l2.x, l2.y);
        }
      }
    }
    noStroke();
  }

  fill(255);
  textSize(32);
  text("Vernunft fördern – Die Lichtschule", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke der Vernunft (oben = Lichtschule strahlt)", width/2, height - 80);
  text("Linksklick = neuer Lehrer | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    lehrer.add(new Lehrer(mouseX, mouseY));
    // enlightenSound.play(); // Leises Klingeln bei Klick
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Lehrer l : lehrer) {
      l.hue = random(120, 240);
    }
    println("Neue Farben für alle Lehrer!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("Lichtschule_####.png");
    println("Gespeichert!");
  }
}
