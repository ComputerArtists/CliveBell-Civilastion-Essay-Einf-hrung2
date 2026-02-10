import processing.sound.*;

SoundFile balanceSound;

float offset = 0;
float balanceLevel = 0.0; // 0 = Masse dominiert, 1 = Elite dominiert
boolean neonMode;

ArrayList<PVector> masse = new ArrayList<PVector>();
ArrayList<PVector> elite = new ArrayList<PVector>();

// Globale Variablen (am Anfang des Skripts deklarieren)
float chaosHue, chaosSat, chaosBri;
float valueHue, valueSat, valueBri;
float reasonHue, reasonSat, reasonBri;
float disseminatorHue, disseminatorSat, disseminatorBri;
float neonAccentHue1, neonAccentHue2, neonAccentHue3;

class Pflanze {
  float x, y, size, hue, swayOffset;
  int formType; // 0 = Kreis, 1 = Dreieck, 2 = Blüte, 3 = Spirale

  Pflanze(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(40, 120);
    this.hue = random(40, 80); // Gold/Luxus-Bereich
    this.swayOffset = random(TWO_PI);
    this.formType = (int)random(0, 4);
  }

  void update(float level) {
    // Wind-Effekt + organische Sway-Bewegung
    x += sin(offset + swayOffset) * 0.6 * level + 0.4 * level * sin(offset * 0.2);
    y -= 0.5 * level; // leichter Aufstieg (Muße & Luxus „steigen“ nach oben)
    if (y < -100) y = height + 100; // wrap-around für kontinuierlichen Garten
  }

  void show(float level, int season) {
    float pulse = sin(offset + swayOffset) * 15 + 70 * level;

    // Saisonale Anpassung (Farbe, Helligkeit, Größe)
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
    rotate(offset * 0.01 + sin(offset + swayOffset) * 0.05 * level); // leichte Rotation + Wind-Schwankung
    if (formType == 0) {
      ellipse(0, 0, sz + pulse * 0.5, sz + pulse * 0.5);
    } else if (formType == 1) {
      triangle(0, -sz/2, -sz/2, sz/2, sz/2, sz/2);
    } else if (formType == 2) { // Blüte
      for (int i = 0; i < 8; i++) {
        float a = i * TWO_PI / 8 + offset * 0.1;
        ellipse(cos(a)*sz/2, sin(a)*sz/2, sz/4 + pulse*0.3, sz/4 + pulse*0.3);
      }
    } else { // Spirale
      for (float r = 10; r < sz; r += 15) {
        ellipse(r * cos(offset + r + swayOffset), r * sin(offset + r + swayOffset), 20 + pulse*0.4, 20 + pulse*0.4);
      }
    }
    popMatrix();
  }
}

void randomizeAllColors(boolean useNeon) {
  if (useNeon) {
    // Neon-Modus: sehr grell, leuchtend, cyberpunk-artig
    chaosHue = random(180, 300);           // Cyan-Magenta für dunkles Chaos
    chaosSat = random(80, 100);
    chaosBri = random(40, 70);

    valueHue = random(0, 360);             // Vollkommen wilder Neon-Bereich
    valueSat = 100;                        // Maximale Sättigung
    valueBri = random(85, 100);            // Fast immer sehr hell

    reasonHue = random(120, 300);          // Blau/Cyan/Magenta für Vernunft-Glow
    reasonSat = 100;
    reasonBri = random(90, 100);

    disseminatorHue = random(40, 160);     // Gold/Lime/Electric Blue
    disseminatorSat = 100;
    disseminatorBri = random(90, 100);

    // Drei Neon-Akzente für Linien, Strahlen, Explosionen
    neonAccentHue1 = random(0, 360);
    neonAccentHue2 = (neonAccentHue1 + 120) % 360;
    neonAccentHue3 = (neonAccentHue1 + 240) % 360;

    println("Neon-Farben aktiviert – maximale Leuchtkraft!");
  } else {
    // Normal-Modus: natürliche, elegante Farben (wie in den meisten Skripten)
    chaosHue = random(0, 60);
    chaosSat = random(10, 50);
    chaosBri = random(25, 65);

    valueHue = random(40, 80);
    valueSat = random(80, 100);
    valueBri = random(80, 100);

    reasonHue = random(120, 240);
    reasonSat = random(70, 100);
    reasonBri = random(70, 100);

    disseminatorHue = random(40, 80);
    disseminatorSat = random(80, 100);
    disseminatorBri = random(80, 100);

    // Leichte Neon-Akzente bleiben erhalten, aber gedämpft
    neonAccentHue1 = random(0, 360);
    neonAccentHue2 = (neonAccentHue1 + 120) % 360;
    neonAccentHue3 = (neonAccentHue1 + 240) % 360;

    println("Normale Farben neu gesetzt.");
  }
}

String popupText = "";
int popupTimer = 0;

String[] bellZitate = {
  "Civilization requires inequality – a cultivated elite above the mass.",
  "The mass can imitate, but only the few can create taste and reason.",
  "Luxury and leisure for a minority are the condition of beauty.",
  "Democracy levels down; civilization levels up through the elite.",
  "The elite must be protected – the many will always pull downwards."
};

void setup() {
  size(900, 600);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Sound laden (leises Kippen / Waage-Geräusch)
  balanceSound = new SoundFile(this, "balance.wav"); // Datei im Sketch-Ordner
  
  // Start mit vielen kleinen Punkten links (Masse) und wenigen großen rechts (Elite)
  for (int i = 0; i < 180; i++) {
    masse.add(new PVector(random(100, width/2 - 80), random(100, height - 100)));
  }
  for (int i = 0; i < 15; i++) {
    elite.add(new PVector(random(width/2 + 80, width - 100), random(100, height - 100)));
  }
}
void draw() {
  background(5, 5, 15); // Dunkler, neon-freundlicher Hintergrund
  offset += 0.005;

  balanceLevel = map(mouseY, height, 0, 0.0, 1.0);
  float tilt = (balanceLevel - 0.5) * 80; // Starke Neigung der Waage

  // Waage-Balken mit Glow (Neon oder normal)
  stroke(neonMode ? color(200, 255, 255, 180 + sin(offset*3)*75) : color(255, 180));
  strokeWeight(10);
  line(100, height/2 + tilt, width - 100, height/2 - tilt);

  // Waage-Mitte – Neon-Ring oder klassischer Kreis
  noFill();
  stroke(neonMode ? color(180, 255, 255, 220 + sin(offset*4)*35) : color(255, 220));
  strokeWeight(neonMode ? 6 + sin(offset*2)*2 : 6);
  ellipse(width/2, height/2, 60 + sin(offset*2)*10, 60 + sin(offset*2)*10);
  noStroke();

  // Linke Seite: Masse (viele kleine Punkte – chaos-Farben nutzen)
  for (PVector p : masse) {
    float alpha = map(balanceLevel, 0, 1, 255, 60);
    float driftX = sin(offset + p.y * 0.02) * 3;
    float driftY = cos(offset + p.x * 0.02) * 2.5;

    // Neon- oder Normal-Farbe aus chaos-Variablen
    fill(chaosHue + sin(offset + p.x)*30, 
         neonMode ? 100 : chaosSat, 
         neonMode ? 70 + sin(offset*5)*30 : chaosBri, 
         alpha);

    ellipse(p.x + driftX, p.y + driftY, 10 + sin(offset + p.x)*4, 10 + sin(offset + p.x)*4);
  }

  // Rechte Seite: Elite (wenige große Kreise – value-Farben nutzen)
  for (PVector p : elite) {
    float pulse = sin(offset + p.x * 0.03) * 30 + 90 * balanceLevel;
    float driftX = cos(offset + p.y * 0.02) * 5;
    float driftY = sin(offset + p.x * 0.02) * 4;

    // Neon- oder Normal-Farbe aus value-Variablen
    fill(valueHue + sin(offset + p.y)*40, 
         neonMode ? 100 : valueSat, 
         neonMode ? 90 + sin(offset*6)*10 : valueBri, 
         220);

    ellipse(p.x + driftX, p.y + driftY, 70 + pulse * 0.7, 70 + pulse * 0.7);

    // Innere Neon-Symbole (V & G für Vernunft & Geschmack)
    fill(255, 255, 255, 220 * balanceLevel);
    textSize(28);
    text("V", p.x + driftX, p.y + driftY - 12);
    text("G", p.x + driftX, p.y + driftY + 18);
  }

  // Neon-Linien von Elite zu Masse bei hohem Level (> 0.8) – Einfluss
  if (balanceLevel > 0.8) {
    for (PVector e : elite) {
      for (PVector m : masse) {
        float d = dist(e.x, e.y, m.x, m.y);
        if (d < 400) {
          stroke(180, 255, 255, 80 * (balanceLevel - 0.8) * 5);
          strokeWeight(1.5 + sin(offset)*1);
          line(e.x, e.y, m.x, m.y);
        }
      }
    }
    noStroke();
  }

  // Popup-Text (Bell-Zitat bei Klick)
  if (popupTimer > 0) {
    popupTimer--;
    float alpha = map(popupTimer, 0, 240, 0, 255);
    fill(255, alpha);
    textSize(24);
    text(popupText, width/2, height - 150);
  }

  // UI-Texte
  fill(255);
  textSize(32);
  text("Elite vs. Masse – Die Waage der Zivilisation", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke der Elite (oben = Elite dominiert)", width/2, height - 80);
  text("Linksklick = neuer Punkt (links = Masse, rechts = Elite) | 'c' = Neon-Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
   // balanceSound.play(); // Leises Kippen bei Klick
    
    if (mouseX < width/2) {
      // Links = Masse (kleiner Punkt)
      masse.add(new PVector(mouseX, mouseY));
    } else {
      // Rechts = Elite (großer Kreis)
      elite.add(new PVector(mouseX, mouseY));
    }
    
    // Popup mit zufälligem Zitat
    popupText = bellZitate[(int)random(bellZitate.length)];
    popupTimer = 240; // 4 Sekunden
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    randomizeAllColors(false);  // normale Farben
    neonMode = false;
  }
  if (key == 'n' || key == 'N') {
    randomizeAllColors(true);   // Neon-Modus (wie du es für die Waage wolltest)
    neonMode = true;
  }
  if (key == 's' || key == 'S') {
    saveFrame("Civilization_####.png");
    println("Gespeichert!");
  }
}
