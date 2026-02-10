import processing.sound.*;

SoundFile glowSound;

float offset = 0;
float bookOpen = 0.0;

ArrayList<Rezept> rezepte = new ArrayList<Rezept>();

String[] rezeptTexte = {
  "Muße schaffen (Leisure) – die Grundlage jeder Zivilisation",
  "Wirtschaftliche Sicherheit für wenige, nicht für alle",
  "Luxus & Überfluss fördern – Schönheit um ihrer selbst willen",
  "Geschmack & Schönheit schulen – durch Kunst und Erziehung",
  "Vernunft & Erziehung stärken – Aufklärung statt Aberglaube",
  "Grausamkeit & Aberglauben abschaffen – durch Vernunft",
  "Krieg & Revolution verhindern – Schutz der kultivierten Minderheit",
  "Kultivierte Minderheit schützen – Elite statt Massendemokratie"
};

class Rezept {
  float x, y, vx, vy, alpha, hue;
  String text;
  Rezept(float x, float y, String text) {
    this.x = x;
    this.y = y;
    this.vx = random(-0.5, 0.5);
    this.vy = random(-0.5, 0.5);
    this.alpha = 0;
    this.hue = random(40, 80);
    this.text = text;
  }
  void update(float level) {
    x += vx * level;
    y += vy * level;
    // Langsame Drift-Begrenzung
    if (x < width*0.2 || x > width*0.8) vx *= -1;
    if (y < height*0.2 || y > height*0.8) vy *= -1;
    alpha = lerp(alpha, 255 * level, 0.05);
  }
  void show(float level) {
    fill(hue, 90 * level, 90, alpha);
    textSize(24);
    text(text, x, y);
    // Leuchten
    noFill();
    stroke(hue, 90 * level, 90, alpha * 0.5);
    strokeWeight(2);
    ellipse(x, y, 200 + sin(offset + x)*20 * level, 80 + sin(offset + x)*10 * level);
    noStroke();
  }
}

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  smooth();
  
  // Sound initialisieren (leises Glühen)
  glowSound = new SoundFile(this, "glow.wav"); // Du brauchst eine glow.wav-Datei im Sketch-Ordner
  
  // Start mit 2 Rezepten
  rezepte.add(new Rezept(width/2 - 150, height/2 - 50, rezeptTexte[0]));
  rezepte.add(new Rezept(width/2 + 150, height/2 - 50, rezeptTexte[1]));
}

void draw() {
  background(10);
  offset += 0.005;

  float level = map(mouseY, height, 0, 0.0, 1.0);

  // Dunkler Hintergrund (Notwendigkeit, Masse)
  fill(0, 0, 20 + 10 * (1 - level));
  rect(0, 0, width, height);

  // Das Buch – Mitte
  fill(30, 50, 40 + 50 * level, 220);
  rect(width/2 - 250, height/2 - 200, 500, 400, 20);
  fill(20, 60, 30 + 60 * level, 220);
  rect(width/2 - 240, height/2 - 190, 480, 380, 15);

  // Leuchtende Rezepte + Verbindungen
  for (int i = 0; i < rezepte.size(); i++) {
    Rezept r = rezepte.get(i);
    r.update(level);
    r.show(level);

    // Netzwerk-Linien bei hohem Level
    if (level > 0.7) {
      for (int j = i+1; j < rezepte.size(); j++) {
        Rezept s = rezepte.get(j);
        float d = dist(r.x, r.y, s.x, s.y);
        if (d < 300) {
          stroke(50, 90, 90, 100 * level);
          strokeWeight(2);
          line(r.x, r.y, s.x, s.y);
        }
      }
      noStroke();
    }
  }

  fill(255);
  textSize(32);
  text("How to Make a Civilization", width/2, 80);
  textSize(24);
  text("Das Rezept-Buch", width/2, 120);
  textSize(20);
  text("Maus Y = Vollständigkeit des Rezepts (oben = stark)", width/2, height - 80);
  text("Linksklick = neues Rezept | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    int rnd = (int)random(rezeptTexte.length);
    rezepte.add(new Rezept(random(width*0.3, width*0.7), random(height*0.3, height*0.7), rezeptTexte[rnd]));
    //glowSound.play(); // Leises Glühen bei Klick
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (Rezept r : rezepte) {
      r.hue = random(40, 80);
    }
    println("Neue Farben für alle Rezepte!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("RezeptBuch_####.png");
    println("Gespeichert!");
  }
}
