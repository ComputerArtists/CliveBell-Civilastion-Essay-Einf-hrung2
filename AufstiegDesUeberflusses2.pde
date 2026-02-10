float offset = 0;
float abundanceLevel = 0.0; // 0 = nur Notwendigkeit, 1 = voller Überfluss

ArrayList<LuxusElement> luxusElements = new ArrayList<LuxusElement>();

String[] bellZitate = {
  "Luxury is not waste – it is the condition of beauty and taste.",
  "Civilization is born from excess, not from necessity.",
  "Beauty must be pursued for its own sake, not for utility.",
  "The elite must be allowed to cultivate taste and elegance.",
  "Without superfluity there is no art, no thought, no civilization."
};

class LuxusElement {
  float x, y, size, hue, rotSpeed;
  int type; // 0=Kreis, 1=Dreieck, 2=Spirale, 3=Blüte
  LuxusElement(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = random(40, 140);
    this.hue = random(40, 80);
    this.rotSpeed = random(-0.02, 0.02);
    this.type = (int)random(0, 4);
  }
  void update(float level) {
    y -= 0.4 * level; // Aufstieg
    if (y < -100) y = height + 100;
  }
  void show(float level) {
    float pulse = sin(offset + x*0.02) * 20 + 80 * level;
    fill(hue, 90 * level, pulse, 220);
    pushMatrix();
    translate(x, y);
    rotate(offset * rotSpeed);
    if (type == 0) ellipse(0, 0, size + pulse*0.6, size + pulse*0.6);
    else if (type == 1) triangle(0, -size/2, -size/2, size/2, size/2, size/2);
    else if (type == 2) {
      for (float r = 20; r < size; r += 20) {
        ellipse(r * cos(offset + r), r * sin(offset + r), 30 + pulse*0.4, 30 + pulse*0.4);
      }
    } else {
      for (int i = 0; i < 10; i++) {
        float a = i * TWO_PI / 10 + offset*0.2;
        ellipse(cos(a)*size/1.5, sin(a)*size/1.5, size/5 + pulse*0.3, size/5 + pulse*0.3);
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
  
  // Start mit grauer Basis und wenigen goldenen Elementen
  for (int i = 0; i < 40; i++) {
    float x = random(width);
    float y = height - random(80, 300);
    luxusElements.add(new LuxusElement(x, y));
  }
}

void draw() {
  background(10);
  offset += 0.005;

  abundanceLevel = map(mouseY, height, 0, 0.0, 1.0);

  // Unten: Graue, utilitaristische Rechtecke (Notwendigkeit, Mangel)
  fill(0, 0, 30 + 20 * (1 - abundanceLevel));
  rect(0, height*0.65, width, height*0.35);
  for (int i = 0; i < 80 * (1 - abundanceLevel); i++) {
    fill(0, 0, 40 + random(-10, 10));
    rect(random(width), height - random(0, 200), 30, 60);
  }

  // Oben: Aufstieg des Überflusses – Luxus-Elemente
  for (LuxusElement f : luxusElements) {
    f.update(abundanceLevel);
    f.show(abundanceLevel);
  }

  fill(255);
  textSize(32);
  text("Luxus & Schönheit – Der Aufstieg des Überflusses", width/2, 80);
  textSize(24);
  text("Kapitel VII – How to Make a Civilization", width/2, 120);
  textSize(20);
  text("Maus Y = Stärke des Überflusses (oben = Luxus dominiert)", width/2, height - 80);
  text("Linksklick = neues Luxus-Element | 'c' = neue Farben | 's' = Speichern", width/2, height - 40);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    luxusElements.add(new LuxusElement(random(width*0.2, width*0.8), height - random(100, 300)));
  }
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    for (LuxusElement f : luxusElements) {
      f.hue = random(40, 80);
    }
    println("Neue Farben für alle Luxus-Elemente!");
  }
  if (key == 's' || key == 'S') {
    saveFrame("AufstiegDesUeberflusses_####.png");
    println("Gespeichert!");
  }
}
