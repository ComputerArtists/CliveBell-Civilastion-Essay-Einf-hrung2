import processing.sound.*;

SoundFile enlightenSound;

float offset = 0;
float enlightenmentLevel = 0.0;
String popupText = "";
int popupTimer = 0;

// Liste der Lichtkegel
ArrayList<Lichtkegel> kegel = new ArrayList<Lichtkegel>();

// Zufällige Bell-Zitate für Popup
String[] bellZitate = {
  "Vernunft muss bewusst gefördert werden – durch Erziehung einer kleinen Elite.",
  "Ohne Vernunft gibt es nur Instinkt, Aberglaube und Grausamkeit.",
  "Zivilisation ist Reason enthroned – sie braucht Lehrer, nicht Massen.",
  "Die Schule der Vernunft ist die einzige Waffe gegen Barbarei.",
  "Die Elite muss die Fackel der Aufklärung weitergeben."
};

class Lichtkegel {
  float apexX, apexY, widthAtBase, hue, driftOffset;
  Lichtkegel(float apexX, float apexY) {
    this.apexX = apexX;
    this.apexY = apexY;
    this.widthAtBase = random(120, 300);
    this.hue = random(120, 240);
    this.driftOffset = random(TWO_PI);
  }
  void update(float level) {
    // Leichte Bewegung der Spitze (drift)
    apexX += sin(offset + driftOffset) * 0.6 * level;
    apexY += cos(offset + driftOffset * 1.3) * 0.4 * level;
    apexX = constrain(apexX, width*0.1, width*0.9);
    apexY = constrain(apexY, height*0.05, height*0.35);
  }
  void show(float level) {
    float pulse = sin(offset + driftOffset) * 20 + 80 * level;
    float currentWidth = widthAtBase * level + pulse * 2;
    
    // Halbtransparenter Kegel (von oben nach unten)
    noStroke();
    for (int i = 0; i < 100; i++) {
      float progress = i / 100.0;
      float y = apexY + progress * (height - apexY);
      float w = currentWidth * progress;
      fill(hue, 90 * level, pulse, 80 * (1 - progress) * level);
      ellipse(apexX, y, w, w * 0.6);
    }
    
    // Leuchtende Spitze
    fill(hue, 90 * level, pulse + 20, 220 * level);
    ellipse(apexX, apexY, 60 + pulse * 0.8, 60 + pulse * 0.8);
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
  
  // Start mit 3–5 Lichtkegeln
  for (int i = 0; i < (int)random(3, 6); i++) {
    kegel.add(new Lichtkegel(random(width*0.3, width*0.7), random(height*0.1, height*0.3)));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  enlightenmentLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Dunkler Raum (Unwissenheit, Aberglaube, Instinkt)
  fill(0, 0, 20 + 10 * (1 - enlightenmentLevel));
  rect(0, 0, width, height);

  // Chaos-Partikel im Dunkel
  for (int i = 0; i < 350 * (1 - enlightenmentLevel); i++) {
    fill(random(0, 30), 20, random(20, 40));
    ellipse(random(width), random(height), 12 + random(-4, 4), 12 + random(-4, 4));
  }

  // Die Lichtkegel – strahlen von oben nach unten
  for (Lichtkegel k : kegel) {
    k.update(enlightenmentLevel);
    k.show(enlightenmentLevel);
  }

  // Netzwerk-Linien zwischen Kegeln bei hohem Level (> 0.8)
  if (enlightenmentLevel > 0.8) {
    for (int i = 0; i < kegel.size(); i++) {
      Lichtkegel k1 = kegel.get(i);
      for (int j = i+1; j < kegel.size(); j++) {
        Lichtkegel k2 = kegel.get(j);
        float d = dist(k1.apexX, k1.apexY, k2.apexX, k2.apexY);
        if (d < 350) {
          stroke(180, 90, 90 + sin(offset)*30, 120 * (enlightenmentLevel - 0.8) * 5);
          strokeWeight(2 + sin(offset)*1);
          line(k1.apexX, k1.apexY, k2.apexX, k2.apexY);
        }
      }
    }
    noStroke();
  }

  // Popup-Text (wenn Timer läuft)
  if (popupTimer > 0) {
    popupTimer--;
    float alpha = map(popupTimer, 0, 240, 0, 255);
    fill(255, alpha);
    textSize(24);
    text(popupText, width/2, height - 150);
  }

  fill(255);
  textSize(32);
  text("Vernunft fördern – Die Lichtkegel", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke der Vernunft (oben = Kegel hell & breit)", width/2, height - 80);
  text("Linksklick = neuer Lichtkegel | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    kegel.add(new Lichtkegel(mouseX, random(height*0.1, height*0.3)));
    //enlightenSound.play(); // Leises Klingeln bei Klick
    
    // Popup mit zufälligem Zitat
    popupText = bellZitate[(int)random(bellZitate.length)];
    popupTimer = 240; // 4 Sekunden (bei 60 fps)
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Lichtkegel k : kegel) {
      k.hue = random(120, 240);
    }
    println("Neue Farben für alle Lichtkegel!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("Lichtkegel_####.png");
    println("Gespeichert!");
  }
}
