float offset = 0;

void setup() {
  size(1200, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  blendMode(ADD); // Für goldenen Schimmer-Effekt
}

void draw() {
  background(5, 10, 15); // Sehr dunkler, edler Hintergrund
  offset += 0.005;
  
  float glow = sin(offset * 1.2) * 15 + 70; // Pulsierender Glanz
  float mx = map(mouseX, 0, width, 0, 1);   // Für leichte Interaktion
  
  // Panel 1: Athen – Blau/Gold, Säulen & Kreise
  pushMatrix();
  translate(width/6, height/2);
  fill(210, 60 + mx*20, 50 + glow/2, 180);
  rect(-width/6, -height/2, width/3, height);
  noFill();
  stroke(50, 90, 90 + glow, 220); // Gold-Schimmer
  strokeWeight(4);
  // Säulen-Symbol
  for (int i = -1; i <= 1; i++) {
    rect(i*80, -150, 60, 300);
    ellipse(i*80, -150, 60, 60); // Kapitell
  }
  // Lorbeer-Kreise
  for (int i = 0; i < 6; i++) {
    float r = 70 + sin(offset + i) * 20;
    ellipse(0, -80 + i*40, r*2, r*2);
  }
  popMatrix();
  
  // Panel 2: Renaissance-Italien – Rot/Gold, Dreiecke & zentrale Figur
  pushMatrix();
  translate(width/2, height/2);
  fill(30, 80 + mx*20, 55 + glow/2, 180);
  rect(-width/6, -height/2, width/3, height);
  noFill();
  stroke(40, 95, 85 + glow, 220);
  // Vitruv-Mann-ähnliche Figur (einfach)
  ellipse(0, 0, 120 + sin(offset)*20, 120 + sin(offset)*20);
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8 + offset * 0.5;
    triangle(cos(a)*160, sin(a)*160, cos(a + 0.4)*90, sin(a + 0.4)*90, cos(a - 0.4)*90, sin(a - 0.4)*90);
  }
  popMatrix();
  
  // Panel 3: Frankreich – Blau/Weiß/Gold, geschwungene Linien
  pushMatrix();
  translate(width*5/6, height/2);
  fill(210, 70 + mx*20, 60 + glow/2, 180);
  rect(-width/6, -height/2, width/3, height);
  noFill();
  stroke(200, 20, 95 + glow, 220);
  strokeWeight(5);
  for (int i = 0; i < 10; i++) {
    float x = sin(offset + i) * 120;
    float y = cos(offset + i * 1.5) * 80;
    bezier(x - 100, y - 50, x + random(-50,50), y + random(-50,50), x + 100, y + 50, x, y + 100);
  }
  popMatrix();
  
  // Reset blendMode für Labels
  blendMode(BLEND);
  
  // Labels – volles Weiß, oben zentriert
  fill(255);
  text("Athen – Perikles-Zeit", width/6, 80);
  text("Renaissance-Italien", width/2, 80);
  text("Frankreich – Aufklärung", width*5/6, 80);
  
  // Kleine Info
  fill(255, 220);
  textSize(18);
  text("Maus horizontal = leichter Glanz-Wechsel | 's' = Speichern", width/2, height - 30);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("Paragons_LeuchtendeDreifaltigkeit-####.png");
    println("Gespeichert!");
  }
}
