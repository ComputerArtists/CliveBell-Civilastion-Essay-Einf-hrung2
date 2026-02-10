import processing.sound.*;

SoundFile shieldSound;

float offset = 0;
float protectionLevel = 0.0;

// Liste der Schutz-Segmente (goldene Bögen/Schilde)
ArrayList<Schutz> schutz = new ArrayList<Schutz>();

// Zufällige Bell-Zitate für Popup
String[] bellZitate = {
  "War and revolution are the greatest enemies of civilization.",
  "The elite must be protected from the barbarism of the many.",
  "Vernunft muss den Frieden aktiv schützen – nicht nur existieren.",
  "Ohne Schutz vor Krieg stirbt jede Zivilisation.",
  "Die Glocke der Vernunft ist der Schild der kultivierten Minderheit."
};

class Schutz {
  float angle, radius, hue, driftOffset;
  Schutz(float angle, float radius, float hue) {
    this.angle = angle;
    this.radius = radius;
    this.hue = hue;
    this.driftOffset = random(TWO_PI);
  }
  void update(float level) {
    // Leichte Bewegung (drift + pulse)
    angle += sin(offset + driftOffset) * 0.004 * level;
    radius += cos(offset + driftOffset * 1.3) * 0.3 * level;
    radius = constrain(radius, 100, 500);
  }
  void show(float level) {
    float pulse = sin(offset + driftOffset) * 30 + 100 * level;
    fill(hue, 90 * level, pulse, 180 * level);
    noStroke();
    arc(width/2, height/2, radius * 2 * level, radius * 2 * level, angle - HALF_PI/2, angle + HALF_PI/2, PIE);
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Sound laden (leises Schwingen bei Klick)
  shieldSound = new SoundFile(this, "shield.wav"); // Datei im Sketch-Ordner
  
  // Start mit 4 Schutz-Segmenten (eine kleine Glocke)
  for (int i = 0; i < 4; i++) {
    float angle = i * HALF_PI;
    schutz.add(new Schutz(angle, 180 + i*40, random(40, 80)));
  }
}

void draw() {
  background(5, 10, 20);
  offset += 0.005;

  protectionLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Dunkles Chaos-Feld mit Kriegssymbolen
  fill(0, 0, 15 + 10 * (1 - protectionLevel));
  rect(0, 0, width, height);

  // Rote/orange Kriegssymbole (Explosionen, Dreiecke, zackige Linien)
  for (int i = 0; i < 80 * (1 - protectionLevel); i++) {
    float x = random(width);
    float y = random(height);
    fill(random(0, 40), 90 * (1 - protectionLevel), 80, 180);
    triangle(x, y, x + random(-30, 30), y + random(-30, 30), x + random(-30, 30), y + random(-30, 30));
  }

  // Die Schutzglocke der Vernunft – Segmente
  float maxRadius = 300 + 400 * protectionLevel;
  for (Schutz s : schutz) {
    s.update(protectionLevel);
    s.show(protectionLevel);
  }

  // Zentrale Glocke (Hauptschutz)
  float pulse = sin(offset * 1.5) * 30 + 100 * protectionLevel;
  fill(50, 90, pulse, 180 * protectionLevel);
  ellipse(width/2, height/2, maxRadius + pulse, maxRadius + pulse);

  // Krone / Symbol der Vernunft
  fill(50, 90, pulse + 20, 220 * protectionLevel);
  triangle(width/2 - 60, height/2 - 140, width/2 + 60, height/2 - 140, width/2, height/2 - 200);

  // Netzwerk-Linien zwischen Segmenten bei hohem Level (> 0.8)
  if (protectionLevel > 0.7) {
    for (int i = 0; i < schutz.size(); i++) {
      Schutz s1 = schutz.get(i);
      for (int j = i+1; j < schutz.size(); j++) {
        Schutz s2 = schutz.get(j);
        float d = abs(s1.angle - s2.angle);
        if (d < PI/2) {
          stroke(50, 90, 90 + sin(offset)*30, 120 * (protectionLevel - 0.8) * 5);
          strokeWeight(2 + sin(offset)*1);
          float x1 = width/2 + cos(s1.angle) * s1.radius * protectionLevel;
          float y1 = height/2 + sin(s1.angle) * s1.radius * protectionLevel;
          float x2 = width/2 + cos(s2.angle) * s2.radius * protectionLevel;
          float y2 = height/2 + sin(s2.angle) * s2.radius * protectionLevel;
          line(x1, y1, x2, y2);
        }
      }
    }
    noStroke();
  }

  fill(255);
  textSize(32);
  text("Krieg verhindern – Die Schutzglocke der Vernunft", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke des Schutzes (oben = Glocke groß)", width/2, height - 80);
  text("Linksklick = neues Schutz-Segment | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    float angle = random(TWO_PI);
    float radius = random(200, 400);
    schutz.add(new Schutz(angle, radius, random(40, 80)));
   // shieldSound.play(); // Leises Schwingen bei Klick
  }
   if (mouseButton == RIGHT) {
   saveFrame("Schutzglocke_####.png");
   println("Gespeichert!");
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Schutz s : schutz) {
      s.hue = random(40, 80);
    }
    println("Neue Farben für alle Schutz-Segmente!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("Schutzglocke_####.png");
    println("Gespeichert!");
  }
}
