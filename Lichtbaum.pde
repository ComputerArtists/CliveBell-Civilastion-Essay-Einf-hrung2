import processing.sound.*;

SoundFile bloomSound;

float offset = 0;
float educationLevel = 0.0;

// Liste der Früchte / Erkenntnis-Knoten
ArrayList<Frucht> fruechte = new ArrayList<Frucht>();

// Zufällige Bell-Zitate für Popup bei Klick
String[] bellZitate = {
  "Erziehung ist der einzige Weg, Vernunft und Geschmack zu schaffen.",
  "Ohne bewusste Förderung einer Elite bleibt die Menschheit in Barbarei.",
  "Vernunft muss gelehrt werden – sie entsteht nicht von selbst.",
  "Die Krone der Zivilisation wächst nur durch gezielte Erziehung.",
  "Die Elite ist der Baum, die Masse nur der Boden."
};

class Frucht {
  float angle, radius, hue, rotOffset;
  Frucht(float angle, float radius, float hue) {
    this.angle = angle;
    this.radius = radius;
    this.hue = hue;
    this.rotOffset = random(TWO_PI);
  }
  void update(float level) {
    angle += 0.01 * level * sin(offset + rotOffset);
    radius += 0.2 * level * cos(offset + rotOffset);
    radius = constrain(radius, 80, 350);
  }
  void show(float level) {
    float pulse = sin(offset + rotOffset) * 15 + 70 * level;
    float bx = width/2 + cos(angle) * radius * level;
    float by = height/2 - radius * level * 1.2;
    fill(hue, 90 * level, pulse, 220);
    ellipse(bx, by, 30 + pulse * 0.5, 30 + pulse * 0.5);
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Sound laden (leises Aufleuchten bei Klick)
  bloomSound = new SoundFile(this, "bloom.wav"); // Datei im Sketch-Ordner
  
  // Start mit 4–6 Früchten
  for (int i = 0; i < (int)random(4, 7); i++) {
    float angle = random(TWO_PI);
    float radius = random(80, 220);
    fruechte.add(new Frucht(angle, radius, random(40, 80)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  educationLevel = map(mouseY, height, 0, 0.0, 1.0);
  
  // Dunkler Boden / Wurzelbereich (Unwissenheit, Barbarei)
  fill(20, 40, 25 + 15 * (1 - educationLevel));
  rect(0, height*0.6, width, height*0.4);
  
  // Dunkle, verkrüppelte Wurzeln unten
  stroke(20, 60, 30 + 20 * (1 - educationLevel));
  strokeWeight(8);
  for (int i = 0; i < 12; i++) {
    float a = i * PI / 6 + offset * 0.1 * (1 - educationLevel);
    line(width/2, height*0.6, width/2 + cos(a)*200*(1-educationLevel), height*0.6 + sin(a)*100*(1-educationLevel));
  }
  noStroke();

  // Der Stamm des Baums – mit Wind-Effekt
  float trunkSway = sin(offset * 0.3) * 8 * educationLevel;
  fill(30, 60, 40 + 40 * educationLevel);
  rect(width/2 - 40 + trunkSway, height*0.6 - 400 * educationLevel, 80, 400 * educationLevel);

  // Goldene Krone / Baumkrone – wächst nach oben
  float crownHeight = 300 + 400 * educationLevel;
  float crownWidth = 400 + 600 * educationLevel;
  fill(50, 90, 80 + sin(offset)*20 * educationLevel, 220);
  ellipse(width/2 + trunkSway, height*0.6 - crownHeight, crownWidth, crownHeight);

  // Früchte / Erkenntnis-Knoten in der Krone
  for (Frucht f : fruechte) {
    f.update(educationLevel);
    f.show(educationLevel);
  }

  // Netzwerk-Linien zwischen Früchten bei hohem Level (> 0.8)
  if (educationLevel > 0.8) {
    for (int i = 0; i < fruechte.size(); i++) {
      Frucht f1 = fruechte.get(i);
      for (int j = i+1; j < fruechte.size(); j++) {
        Frucht f2 = fruechte.get(j);
        float bx1 = width/2 + cos(f1.angle) * f1.radius * educationLevel;
        float by1 = height/2 - f1.radius * educationLevel * 1.2;
        float bx2 = width/2 + cos(f2.angle) * f2.radius * educationLevel;
        float by2 = height/2 - f2.radius * educationLevel * 1.2;
        float d = dist(bx1, by1, bx2, by2);
        if (d < 250) {
          stroke(50, 90, 90 + sin(offset)*30, 120 * (educationLevel - 0.8) * 5);
          strokeWeight(2 + sin(offset)*1);
          line(bx1, by1, bx2, by2);
        }
      }
    }
    noStroke();
  }

  // Luxus-Partikel (Schmetterlinge / Juwelen) bei hohem Level (> 0.6)
  if (educationLevel > 0.6) {
    for (int i = 0; i < 8; i++) {
      float px = width/2 + random(-200, 200) * educationLevel;
      float py = height/2 - random(100, 400) * educationLevel;
      float phue = random(40, 80);
      fill(phue, 90, 90 + sin(offset + px)*20, 180 * (educationLevel - 0.6) * 5);
      ellipse(px + sin(offset + i)*40, py + cos(offset + i)*30, 12 + sin(offset + i)*4, 12 + sin(offset + i)*4);
    }
  }

  // Krone-Symbol / Vernunft-Symbol oben
  fill(50, 90, 90 + sin(offset*2)*20 * educationLevel, 220);
  triangle(width/2 - 60, height*0.6 - crownHeight - 80, width/2 + 60, height*0.6 - crownHeight - 80, width/2, height*0.6 - crownHeight - 140);

  fill(255);
  textSize(32);
  text("Erziehung zur Zivilisation – Der Lichtbaum", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke der Erziehung (oben = Krone groß & hell)", width/2, height - 80);
  text("Linksklick = neue Frucht / Erkenntnis | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    float angle = random(TWO_PI);
    float radius = random(100, 300);
    fruechte.add(new Frucht(angle, radius, random(40, 80)));
   //  bloomSound.play(); // Leises Aufleuchten bei Klick
    
    // Luxus-Explosion bei Klick (kleine goldene Blütenblätter / Erkenntnis-Funken)
    for (int i = 0; i < 16; i++) {
      float a = i * TWO_PI / 16 + random(TWO_PI);
      float dist = random(30, 80);
      float px = mouseX + cos(a) * dist;
      float py = mouseY + sin(a) * dist;
      fill(50, 90, 90 + sin(offset)*30, 200);
      ellipse(px, py, 10 + random(-3, 3), 10 + random(-3, 3));
    }
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Frucht f : fruechte) {
      f.hue = random(40, 80);
    }
    println("Neue Farben für alle Früchte!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("Lichtbaum_####.png");
    println("Gespeichert!");
  }
}
