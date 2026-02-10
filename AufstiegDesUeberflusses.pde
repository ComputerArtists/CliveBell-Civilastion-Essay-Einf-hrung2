import processing.sound.*;

SoundFile bloomSound;

float offset = 0;
float abundanceLevel = 0.0;

// Liste der Luxus-Formen
ArrayList<LuxusForm> luxus = new ArrayList<LuxusForm>();

// Zufällige Bell-Zitate für Popup bei Klick
String[] bellZitate = {
  "Luxury is not waste – it is the condition of beauty and taste.",
  "Without leisure and superfluity there is no art, no thought, no civilization.",
  "Beauty must be pursued for its own sake, not for utility.",
  "The elite must be allowed to cultivate taste and elegance.",
  "Civilization is born from excess, not from necessity."
};

class LuxusForm {
  float x, y, size, hue, swayOffset;
  int formType; // 0=Kreis, 1=Dreieck, 2=Blüte, 3=Spirale
  LuxusForm(float x, float y) {
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
  
  // Start mit 5–8 Luxus-Formen
  for (int i = 0; i < (int)random(5, 9); i++) {
    luxus.add(new LuxusForm(random(width*0.2, width*0.8), height - random(100, 300)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  abundanceLevel = map(mouseY, height, 0, 0.0, 1.0);
  int season = (int)map(abundanceLevel, 0, 1, 0, 3); // 0=Frühling, 1=Sommer, 2=Herbst, 3=Winter

  // Unten: Graue, utilitaristische Rechtecke (Notwendigkeit, Mangel)
  fill(0, 0, 30 + 20 * (1 - abundanceLevel));
  rect(0, height*0.7, width, height*0.3);
  for (int i = 0; i < 60 * (1 - abundanceLevel); i++) {
    fill(0, 0, 40 + random(-10, 10));
    rect(random(width), height - random(0, 200), 30, 60);
  }

  // Oben: Aufstieg des Überflusses – Luxus-Formen
  for (LuxusForm f : luxus) {
    f.update(abundanceLevel);
    f.show(abundanceLevel, season);
  }

  // Goldene Ranken / Verbindungen bei hohem Level (> 0.7)
  if (abundanceLevel > 0.7) {
    for (int i = 0; i < luxus.size(); i++) {
      LuxusForm p1 = luxus.get(i);
      for (int j = i+1; j < luxus.size(); j++) {
        LuxusForm p2 = luxus.get(j);
        float d = dist(p1.x, p1.y, p2.x, p2.y);
        if (d < 300) {
          stroke(50, 90, 90 + sin(offset)*30, 120 * (abundanceLevel - 0.7) * 3.33);
          strokeWeight(2 + sin(offset)*1);
          line(p1.x, p1.y, p2.x, p2.y);
        }
      }
    }
    noStroke();
  }

  // Luxus-Partikel (Schmetterlinge / Juwelen) bei hohem Level (> 0.6)
  if (abundanceLevel > 0.6) {
    for (int i = 0; i < 8; i++) {
      float px = random(width*0.2, width*0.8);
      float py = random(height*0.3, height*0.7);
      float phue = random(40, 80);
      fill(phue, 90, 90 + sin(offset + px)*20, 180 * (abundanceLevel - 0.6) * 5);
      ellipse(px + sin(offset + i)*40, py + cos(offset + i)*30, 12 + sin(offset + i)*4, 12 + sin(offset + i)*4);
    }
  }

  fill(255);
  textSize(32);
  text("Geschmack & Schönheit – Der Aufstieg des Überflusses", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke des Überflusses (oben = Luxus dominiert)", width/2, height - 100);
  text("Saison: " + (season == 0 ? "Frühling" : season == 1 ? "Sommer" : season == 2 ? "Herbst" : "Winter"), width/2, height - 70);
  text("Linksklick = neues Luxus-Element | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    luxus.add(new LuxusForm(random(width*0.2, width*0.8), height - random(100, 300)));
    // bloomSound.play(); // Leises Aufblühen bei Klick
    
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
    for (LuxusForm f : luxus) {
      f.hue = random(40, 80);
    }
    println("Neue Farben für alle Luxus-Formen!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("AufstiegDesUeberflusses_####.png");
    println("Gespeichert!");
  }
}
