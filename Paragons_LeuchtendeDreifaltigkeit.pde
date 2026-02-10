float offset = 0;

void setup() {
  size(1200, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
}

void draw() {
  background(10, 20, 30); // Dunkler, edler Hintergrund
  offset += 0.005;
  
  float glow = sin(offset * 0.8) * 20 + 80; // Sanftes Pulsieren des Glanzes
  
  // Panel 1: Athen – Blau/Weiß/Gold, Kreise & Säulen-Symbole
  fill(210, 70, 60 + glow/2);
  rect(0, 0, width/3, height);
  noFill();
  stroke(50, 30, 100, 220); // Goldener Schimmer
  strokeWeight(3);
  for (int i = 0; i < 8; i++) {
    float r = 80 + sin(offset + i) * 30;
    ellipse(width/6, height/2, r*2, r*2);
  }
  // Säulen-Symbol (ionisch)
  fill(255, 240);
  rect(width/6 - 40, height/2 - 150, 80, 300);
  ellipse(width/6, height/2 - 150, 80, 80);
  
  // Panel 2: Renaissance-Italien – Rot/Gold/Grün, Dreiecke & Kreise
  fill(30, 80, 60 + glow/2);
  rect(width/3, 0, width/3, height);
  noFill();
  stroke(40, 90, 100, 220);
  for (int i = 0; i < 10; i++) {
    float a = i * TWO_PI / 10 + offset * 0.6;
    triangle(width/2 + cos(a)*120, height/2 + sin(a)*120,
              width/2 + cos(a + 0.3)*80, height/2 + sin(a + 0.3)*80,
              width/2 + cos(a - 0.3)*80, height/2 + sin(a - 0.3)*80);
  }
  
  // Panel 3: Frankreich (Aufklärung) – Blau/Weiß, Linien & Kreise
  fill(210, 60, 65 + glow/2);
  rect(width*2/3, 0, width/3, height);
  stroke(200, 20, 100, 220);
  strokeWeight(4);
  for (int i = 0; i < 12; i++) {
    float x = width*5/6 + sin(offset + i) * 80;
    line(x - 100, height/2 + i*20 - 120, x + 100, height/2 + i*20 - 120);
  }
  
  // Labels – volles Weiß
  fill(255);
  text("Athen – Perikles-Zeit", width/6, 80);
  text("Renaissance-Italien", width/2, 80);
  text("Frankreich – Aufklärung", width*5/6, 80);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("Paragons_LeuchtendeDreifaltigkeit-####.png");
    println("Gespeichert!");
  }
}
