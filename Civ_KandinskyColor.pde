import java.text.SimpleDateFormat;
import java.util.Date;

float offset = 0;
char mode = 'g';
float chaosIntensity = 0;     // Maus-X: links = Chaos hoch
float kandinskyColorLevel = 0; // Maus-Y: oben = Blau (Zivilisation), unten = Gelb/Rot (Barbarismus)

ArrayList<PVector> extraClusters = new ArrayList<PVector>();

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH-mm");

void setup() {
  size(900, 650);
  background(255);
  textAlign(CENTER);
  textSize(22);
  frameRate(30);
}

void draw() {
  background(255);
  
  // Maus-Steuerung Kandinsky-Style
  chaosIntensity     = map(mouseX, 0, width, 1.5, 0.1);           // Links = max Barbarismus
  kandinskyColorLevel = map(mouseY, 0, height, 1.0, 0.0);         // Oben = Blau (1.0), unten = Gelb/Rot (0.0)
  
  // Barbarische Seite (links)
  color barbarBG = lerpColor(color(180, 0, 0), color(0, 0, 180), kandinskyColorLevel); // Rot unten → Blau oben
  fill(barbarBG);
  rect(0, 0, 450, height);
  
  if      (mode == 'g') drawGrausamkeitBarbarisch(chaosIntensity, kandinskyColorLevel);
  else if (mode == 'a') drawAberglaubeBarbarisch(chaosIntensity, kandinskyColorLevel);
  else if (mode == 'v') drawVernunftMangelBarbarisch(chaosIntensity, kandinskyColorLevel);
  else if (mode == 'm') drawMischmodusBarbarisch(chaosIntensity, kandinskyColorLevel);
  else if (mode == 'c') drawZivilUebergangBarbarisch(chaosIntensity, kandinskyColorLevel);
  
  // Zivilisierte Seite (rechts) – umgekehrte Farb-Logik
  color civilBG = lerpColor(color(0, 0, 180), color(180, 0, 0), kandinskyColorLevel); // Blau oben → Rot unten
  fill(civilBG);
  rect(450, 0, 450, height);
  
  if      (mode == 'g') drawGrausamkeitZivilisiert(kandinskyColorLevel);
  else if (mode == 'a') drawAberglaubeZivilisiert(kandinskyColorLevel);
  else if (mode == 'v') drawVernunftZivilisiert(kandinskyColorLevel);
  else if (mode == 'm') drawMischmodusZivilisiert(kandinskyColorLevel);
  else if (mode == 'c') drawZivilUebergangZivilisiert(chaosIntensity, kandinskyColorLevel);
  
  // Kandinsky-Cluster (von Klicks)
  for (PVector p : extraClusters) {
    drawKandinskyCluster(p.x, p.y, chaosIntensity * 0.5, kandinskyColorLevel);
  }
  
  // Grenze
  stroke(lerpColor(color(255, 100, 0), color(0, 100, 255), kandinskyColorLevel));
  strokeWeight(5);
  line(450, 0, 450, height);
  strokeWeight(1);
  
  // UI
  fill(255);
  text("Kandinsky-Farben: Maus Y oben = Blau (Zivilisation), unten = Gelb/Rot (Barbarismus)", width/2, 40);
  text("Maus X = Chaos-Intensität | Linksklick = neuer Cluster | r = Reset | s = Speichern", width/2, 80);
  text("Modus: " + getModusName(), width/2, height - 30);
  
  offset += 0.04;
}

String getModusName() {
  if (mode == 'g') return "Grausamkeit";
  if (mode == 'a') return "Aberglaube";
  if (mode == 'v') return "Mangelnde Vernunft";
  if (mode == 'm') return "Mischmodus";
  if (mode == 'c') return "Zivilisations-Übergang";
  return "?";
}

// Kandinsky-Cluster mit Farbsteuerung
void drawKandinskyCluster(float x, float y, float intns, float colorLvl) {
  noFill();
  color col = lerpColor(color(255, 220, 0), color(0, 80, 255), colorLvl); // Gelb unten → Blau oben
  stroke(col, 200);
  strokeWeight(3 + intns * 2);
  float sz = random(50, 140) * intns;
  ellipse(x, y, sz, sz);
  line(x - sz, y, x + sz, y);
  triangle(x, y - sz, x - sz, y + sz, x + sz, y + sz);
}

// ==============================================
// BARBARISCHE FUNKTIONEN (angepasst an Farb-Level)
// ==============================================

void drawGrausamkeitBarbarisch(float intns, float colorLvl) {
  color fillCol = lerpColor(color(255, 80, 0), color(0, 150, 255), colorLvl);
  fill(fillCol);
  for (int i = 0; i < 5; i++) {
    float x = 70 + i * 80;
    pushMatrix();
    translate(x + sin(offset + i) * 12 * intns, 180 + cos(offset + i * 2) * 10 * intns);
    triangle(0, -60, -45, 60, 45, 60);
    popMatrix();
  }
}

void drawAberglaubeBarbarisch(float intns, float colorLvl) {
  pushMatrix();
  translate(225, 220);
  rotate(offset * 1.8 * intns);
  color c = lerpColor(color(220, 180, 0), color(100, 0, 220), colorLvl); // Gelb → Violett
  fill(c);
  ellipse(0, 0, 180 + 80 * intns, 240 + 100 * intns);
  fill(255);
  textSize(90 + 50 * intns);
  text("?", 0, 35);
  popMatrix();
}

void drawVernunftMangelBarbarisch(float intns, float colorLvl) {
  color lineCol = lerpColor(color(255, 200, 0), color(0, 200, 255), colorLvl);
  stroke(lineCol);
  for (int i = 0; i < 140 * intns; i++) {
    line(random(0, 450), random(0, height), random(0, 450), random(0, height));
  }
}

void drawMischmodusBarbarisch(float intns, float colorLvl) {
  drawGrausamkeitBarbarisch(intns * 0.8, colorLvl);
  drawAberglaubeBarbarisch(intns * 0.7, colorLvl);
  drawVernunftMangelBarbarisch(intns * 0.9, colorLvl);
}

void drawZivilUebergangBarbarisch(float intns, float colorLvl) {
  fill(lerpColor(color(200, 50, 50), color(50, 50, 200), colorLvl), 140);
  rect(30, 80, 390, 480);
  fill(255);
  textSize(32);
  text("→ Zivilisation", 225, 320);
}

// ==============================================
// ZIVILISIERTE FUNKTIONEN
// ==============================================

void drawGrausamkeitZivilisiert(float colorLvl) {
  fill(lerpColor(color(0, 100, 255), color(255, 100, 0), colorLvl));
  ellipse(600, 220, 70, 70);
  ellipse(750, 220, 70, 70);
  arc(675, 340, 100, 100, 0, PI);
}

void drawAberglaubeZivilisiert(float colorLvl) {
  fill(lerpColor(color(0, 180, 100), color(180, 0, 100), colorLvl));
  rect(550, 180, 140, 140);
  textSize(28);
  fill(255);
  text("Ordnung", 620, 260);
}

void drawVernunftZivilisiert(float colorLvl) {
  stroke(lerpColor(color(0, 120, 220), color(220, 120, 0), colorLvl));
  line(500, 120, 800, 120);
  ellipse(650, 280, 90, 90);
  textSize(26);
  text("Vernunft", 650, 380);
}

void drawMischmodusZivilisiert(float colorLvl) {
  drawGrausamkeitZivilisiert(colorLvl);
  drawAberglaubeZivilisiert(colorLvl);
  drawVernunftZivilisiert(colorLvl);
}

void drawZivilUebergangZivilisiert(float intns, float colorLvl) {
  fill(lerpColor(color(0, 180, 220), color(220, 0, 80), colorLvl), 180);
  rect(480, 80, 390, 480);
  fill(255);
  textSize(32);
  text("Zivilisation", 675, 300);
}

// ==============================================
// INTERAKTION
// ==============================================

void mousePressed() {
  if (mouseButton == LEFT) {
    extraClusters.add(new PVector(mouseX, mouseY));
  }
}

void keyPressed() {
  if (key == 'g' || key == 'G') mode = 'g';
  if (key == 'a' || key == 'A') mode = 'a';
  if (key == 'v' || key == 'V') mode = 'v';
  if (key == 'm' || key == 'M') mode = 'm';
  if (key == 'c' || key == 'C') mode = 'c';
  
  if (key == 'r' || key == 'R') extraClusters.clear();
  
  if (key == 's' || key == 'S') {
   saveFrame("Civ_KandinskyColor-####.png");
    println("Gespeichert");
  }
}
