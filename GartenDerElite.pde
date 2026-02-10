import processing.sound.*;

SoundFile glowSound;

float offset = 0;
float gardenLevel = 0.0;

// Liste der Pflanzen
ArrayList<Pflanze> pflanzen = new ArrayList<Pflanze>();

// Zufällige Bell-Zitate für Popup
String[] bellZitate = {
  "Civilization is a rarity; it requires leisure and luxury for a few.",
  "The mass can enjoy civilization, but only a minority can create it.",
  "Luxury is not waste – it is the condition of beauty and taste.",
  "Reason and taste must be cultivated in a small elite.",
  "Without leisure there is no art, no thought, no civilization.",
  "The elite must be protected from the barbarism of the many.",
  "War and revolution are the greatest enemies of civilization."
};

class Pflanze {
  float x, y, size, hue, swayOffset;
  Pflanze(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(40, 90);
    this.hue = random(40, 80);
    this.swayOffset = random(TWO_PI);
  }
  void update(float level) {
    // Leichte Bewegung (Wind-Effekt + Sway)
    x += sin(offset + swayOffset) * 0.6 * level;
    y += cos(offset + swayOffset * 1.2) * 0.4 * level;
    // Wind von links nach rechts
    x += 0.4 * level * sin(offset * 0.2);
  }
  void show(float level, int season) {
    float pulse = sin(offset + swayOffset) * 15 + 70 * level;
    
    // Saisonale Farb- & Größen-Anpassung
    float sat = 90;
    float bri = pulse;
    float sz = size;
    if (season == 0) { // Frühling
      sat = 90 + 10 * level;
      sz *= 1.1;
    } else if (season == 1) { // Sommer
      bri += 20;
      sz *= 1.3;
    } else if (season == 2) { // Herbst
      sat = 70;
      bri -= 10;
      sz *= 0.9;
    } else { // Winter
      sat = 40;
      bri = 60 + sin(offset)*10;
      sz *= 0.7;
    }
    
    fill(hue, sat * level, bri, 220);
    ellipse(x, y, sz + pulse * 0.6, sz + pulse * 0.6);
    
    // Blütenblätter
    noFill();
    stroke(hue, sat * level, bri, 180 * level);
    strokeWeight(2);
    for (int i = 0; i < 8; i++) {
      float a = i * TWO_PI / 8 + offset * 0.3;
      line(x, y, x + cos(a) * pulse * 1.2, y + sin(a) * pulse * 1.2);
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
  
  // Sound laden
  glowSound = new SoundFile(this, "glow.wav"); // Datei im Sketch-Ordner
  
  // Start mit 6 Pflanzen
  for (int i = 0; i < 6; i++) {
    pflanzen.add(new Pflanze(random(width*0.2, width*0.8), random(height*0.6, height*0.9)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  gardenLevel = map(mouseY, height, 0, 0.0, 1.0);
  
  // Saison bestimmen (0=Frühling, 1=Sommer, 2=Herbst, 3=Winter)
  int season = (int)map(gardenLevel, 0, 1, 0, 3);

  // Dunkler Hintergrund (Arbeit, Utilitarismus)
  fill(0, 0, 20 + 10 * (1 - gardenLevel));
  rect(0, 0, width, height);

  // Der Garten wächst von unten nach oben
  for (Pflanze p : pflanzen) {
    p.update(gardenLevel);
    p.show(gardenLevel, season);
  }

  // Netzwerk-Linien bei hohem Level (> 0.8)
  if (gardenLevel > 0.8) {
    for (int i = 0; i < pflanzen.size(); i++) {
      Pflanze p1 = pflanzen.get(i);
      for (int j = i+1; j < pflanzen.size(); j++) {
        Pflanze p2 = pflanzen.get(j);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        if (d < 250) {
          stroke(50, 90, 90 + sin(offset)*30, 120 * (gardenLevel - 0.8) * 5);
          strokeWeight(2 + sin(offset)*1);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
    noStroke();
  }

  // Luxus-Partikel (Schmetterlinge / Juwelen) bei hohem Level
  if (gardenLevel > 0.7) {
    for (int i = 0; i < 5; i++) {
      float px = random(width*0.2, width*0.8);
      float py = random(height*0.4, height*0.8);
      float phue = random(40, 80);
      fill(phue, 90, 90 + sin(offset + px)*20, 180);
      ellipse(px + sin(offset + i)*30, py + cos(offset + i)*20, 12, 12);
    }
  }

  fill(255);
  textSize(32);
  text("Muße & Luxus – Der Garten der Elite", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke von Muße & Luxus (oben = Garten blüht)", width/2, height - 100);
  text("Linksklick = neue Pflanze | 'c' = neue Farben | 's' = Speichern", width/2, height - 60);
  text("Saison: " + (season == 0 ? "Frühling" : season == 1 ? "Sommer" : season == 2 ? "Herbst" : "Winter"), width/2, height - 30);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    pflanzen.add(new Pflanze(random(width*0.2, width*0.8), random(height*0.5, height*0.9)));
    // glowSound.play(); // Leises Glühen bei Klick
    
    // Luxus-Explosion bei Klick (kleine goldene Blütenblätter)
    for (int i = 0; i < 12; i++) {
      float a = i * TWO_PI / 12 + random(TWO_PI);
      float dist = random(20, 60);
      float px = mouseX + cos(a) * dist;
      float py = mouseY + sin(a) * dist;
      fill(50, 90, 90 + sin(offset)*30, 200);
      ellipse(px, py, 10, 10);
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
