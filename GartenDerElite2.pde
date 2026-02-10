import processing.sound.*;

SoundFile bloomSound;

float offset = 0;
float gardenLevel = 0.0;

// Liste der Pflanzen
ArrayList<Pflanze> pflanzen = new ArrayList<Pflanze>();

// Zufällige Bell-Zitate für Popup bei Klick auf Pflanze
String[] bellZitate = {
  "Luxury is not waste – it is the condition of beauty and taste.",
  "Without leisure and superfluity there is no art, no thought, no civilization.",
  "Beauty must be pursued for its own sake, not for utility.",
  "The elite must be allowed to cultivate taste and elegance.",
  "Civilization is born from excess, not from necessity."
};

class Pflanze {
  float x, y, size, hue, swayOffset;
  int formType; // 0=Kreis, 1=Dreieck, 2=Blüte, 3=Spirale
  Pflanze(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(40, 120);
    this.hue = random(40, 80);
    this.swayOffset = random(TWO_PI);
    this.formType = (int)random(0, 4);
  }
  void update(float level) {
    // Wind-Effekt + organische Sway-Bewegung
    x += sin(offset + swayOffset) * 0.6 * level + 0.4 * level * sin(offset * 0.2);
    y -= 0.5 * level; // leichter Aufstieg
    if (y < -100) y = height + 100;
  }
  void show(float level, int season) {
    float pulse = sin(offset + swayOffset) * 15 + 70 * level;
    
    // Saisonale Anpassung
    float sat = 90;
    float bri = pulse;
    float sz = size;
    if (season == 0) { // Frühling – frisch & bunt
      sat = 90 + 10 * level;
      sz *= 1.1;
    } else if (season == 1) { // Sommer – voll & strahlend
      bri += 20;
      sz *= 1.3;
    } else if (season == 2) { // Herbst – warm & welk
      sat = 70;
      bri -= 10;
      sz *= 0.9;
    } else { // Winter – klar & reduziert
      sat = 40;
      bri = 60 + sin(offset)*10;
      sz *= 0.7;
    }
    
    fill(hue, sat * level, bri, 220);
    pushMatrix();
    translate(x, y);
    rotate(offset * 0.01); // leichte Rotation
    if (formType == 0) ellipse(0, 0, sz + pulse * 0.5, sz + pulse * 0.5);
    else if (formType == 1) triangle(0, -sz/2, -sz/2, sz/2, sz/2, sz/2);
    else if (formType == 2) {
      for (int i = 0; i < 8; i++) {
        float a = i * TWO_PI / 8;
        ellipse(cos(a)*sz/2, sin(a)*sz/2, sz/4 + pulse*0.3, sz/4 + pulse*0.3);
      }
    } else {
      for (float r = 10; r < sz; r += 15) {
        ellipse(r * cos(offset + r), r * sin(offset + r), 20 + pulse*0.4, 20 + pulse*0.4);
      }
    }
    popMatrix();
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Sound laden (leises Aufblühen)
  bloomSound = new SoundFile(this, "bloom.wav"); // Datei im Sketch-Ordner
  
  // Start mit 6 Pflanzen
  for (int i = 0; i < 6; i++) {
    pflanzen.add(new Pflanze(random(width*0.2, width*0.8), random(height*0.6, height*0.9)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  gardenLevel = map(mouseY, height, 0, 0.0, 1.0);
  int season = (int)map(gardenLevel, 0, 1, 0, 3); // 0=Frühling, 1=Sommer, 2=Herbst, 3=Winter

  // Dunkler Hintergrund (Arbeit, Utilitarismus)
  fill(0, 0, 20 + 10 * (1 - gardenLevel));
  rect(0, 0, width, height);

  // Der Garten wächst von unten nach oben – mit Schichten/Tiefe
  for (int layer = 0; layer < 3; layer++) {
    float layerLevel = gardenLevel * (0.6 + layer*0.2); // Hintergrund schwächer
    pushMatrix();
    translate(0, layer * 20); // leichte Tiefen-Staffelung
    for (Pflanze p : pflanzen) {
      p.update(layerLevel);
      p.show(layerLevel, season);
    }
    popMatrix();
  }

  // Goldene Ranken / Verbindungen bei hohem Level (> 0.7)
  if (gardenLevel > 0.7) {
    for (int i = 0; i < pflanzen.size(); i++) {
      Pflanze p1 = pflanzen.get(i);
      for (int j = i+1; j < pflanzen.size(); j++) {
        Pflanze p2 = pflanzen.get(j);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        if (d < 300) {
          stroke(50, 90, 90 + sin(offset)*30, 120 * (gardenLevel - 0.7) * 3.33);
          strokeWeight(2 + sin(offset)*1);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
    noStroke();
  }

  // Luxus-Partikel (Schmetterlinge / Juwelen) bei hohem Level (> 0.6)
  if (gardenLevel > 0.6) {
    for (int i = 0; i < 8; i++) {
      float px = random(width*0.2, width*0.8);
      float py = random(height*0.3, height*0.7);
      float phue = random(40, 80);
      fill(phue, 90, 90 + sin(offset + px)*20, 180 * (gardenLevel - 0.6) * 5);
      ellipse(px + sin(offset + i)*40, py + cos(offset + i)*30, 12 + sin(offset + i)*4, 12 + sin(offset + i)*4);
    }
  }

  fill(255);
  textSize(32);
  text("Muße & Luxus – Der Garten der Elite", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke von Muße & Luxus (oben = Garten blüht)", width/2, height - 100);
  text("Saison: " + (season == 0 ? "Frühling" : season == 1 ? "Sommer" : season == 2 ? "Herbst" : "Winter"), width/2, height - 70);
  text("Linksklick = neue Pflanze | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    pflanzen.add(new Pflanze(random(width*0.2, width*0.8), random(height*0.5, height*0.9)));
    //bloomSound.play(); // Leises Aufblühen bei Klick
    
    // Luxus-Explosion bei Klick (kleine goldene Blütenblätter)
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
    for (Pflanze p : pflanzen) {
      p.hue = random(40, 80);
    }
    println("Neue Farben für alle Pflanzen!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("GartenDerElite_####.png");
    println("Gespeichert!");
  }
}
