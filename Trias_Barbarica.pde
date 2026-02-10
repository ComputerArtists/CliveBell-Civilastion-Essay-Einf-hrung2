float offset = 0;

void setup() {
  size(1200, 600);
  noStroke();
  colorMode(HSB, 360, 100, 100);  // Kandinsky-freundlicher HSB-Modus
  textAlign(CENTER);
  textSize(32);                   // Größere, klarere Schrift
}

void draw() {
  background(0);
  offset += 0.008;
  
  float chaos = map(mouseX, 0, width, 0.3, 1.8);          // Maus-X: Barbarismus-Intensität
  float colorBalance = map(mouseY, 0, height, 0.0, 1.0);  // Maus-Y: 0=Blau/Grün (oben), 1=Rot/Gelb/Violett (unten)
  
  // Panel 1 Hintergrund: Grausamkeit – Rot → Orange/Gelb
  float hue1 = lerp(0, 50, colorBalance);   // Rot → Orange/Gelb
  float sat1 = 80 + sin(offset * 2) * 15 + chaos * 20;
  fill(hue1, sat1, 70 + chaos * 30, 255);
  rect(0, 0, width/4, height);
  
  // Panel 2 Hintergrund: Aberglaube – Violett → Magenta/Blau
  float hue2 = lerp(270, 320, colorBalance);  // Violett → Magenta
  fill(hue2, 85 + chaos * 15, 65 + chaos * 35, 255);
  rect(width/4, 0, width/4, height);
  
  // Panel 3 Hintergrund: Mangelnde Vernunft – Gelb → Türkis/Orange
  float hue3 = lerp(180, 60, colorBalance);   // Türkis → Gelb/Orange
  fill(hue3, 90 + sin(offset * 1.5) * 20, 75 + chaos * 25, 255);
  rect(width/2, 0, width/4, height);
  
  // Panel 4 Hintergrund: Zivilisation – Tiefblau → Grün/Blau
  float hue4 = lerp(210, 140, colorBalance);  // Tiefblau → Grün
  fill(hue4, 70 + (1 - colorBalance) * 40, 80, 255);
  rect(width * 3/4, 0, width/4, height);
  
  // Feine Trennlinien
  stroke(0, 40);
  strokeWeight(2);
  for (int i = 1; i < 4; i++) line(width/4 * i, 0, width/4 * i, height);
  noStroke();
  
  // Panel 1 Inhalt: Grausamkeit – spitze Dreiecke
  pushMatrix();
  translate(width/8, height/2);
  rotate(offset * 0.6 * chaos);
  for (int i = 0; i < 10; i++) {
    float angle = i * TWO_PI / 10 + offset * chaos;
    float sz = 45 + sin(offset + i) * 30 * chaos;
    fill(lerp(10, 60, colorBalance), 95, 90, 220);
    triangle(cos(angle)*140, sin(angle)*140, 
              cos(angle + 0.4)*sz, sin(angle + 0.4)*sz, 
              cos(angle - 0.4)*sz, sin(angle - 0.4)*sz);
  }
  popMatrix();
  
  // Panel 2 Inhalt: Aberglaube – Kreise + ?
  pushMatrix();
  translate(width/8 * 3, height/2);
  rotate(offset * 0.4);
  for (int i = 0; i < 9; i++) {
    float a = i * TWO_PI / 9 + offset * 0.5;
    float r = 70 + sin(offset * 2.5 + i) * 40 * chaos;
    fill(lerp(240, 300, colorBalance), 90, 80, 210);
    ellipse(cos(a)*r*1.6, sin(a)*r*1.6, r*1.4, r*1.4);
    fill(360 - lerp(240, 300, colorBalance), 95, 95);
    textSize(r * 0.9);
    text("?", cos(a)*r*1.3, sin(a)*r*1.3 + 30);
  }
  popMatrix();
  
  // Panel 3 Inhalt: Mangelnde Vernunft – chaotische Linien
  float irrHue = lerp(180, 40, colorBalance);
  stroke(irrHue, 95, 95 + chaos*20, 170 * chaos);
  strokeWeight(2.5 + chaos * 4);
  for (int i = 0; i < 160 * chaos; i++) {
    float x1 = random(width/2, width*0.75);
    float y1 = random(height);
    float x2 = x1 + random(-100*chaos, 100*chaos);
    float y2 = y1 + random(-100*chaos, 100*chaos);
    line(x1, y1, x2, y2);
  }
  noStroke();
  
  // Panel 4 Inhalt: Zivilisation – ruhige Kreise + Linien
  noFill();
  stroke(360 - hue4, 90, 95);
  strokeWeight(4);
  for (int i = 0; i < 14; i++) {
    float r = 55 + i * 30 + sin(offset * 1.2 + i*3) * 20;
    ellipse(width * 0.875, height/2, r*2, r*2);
  }
  stroke(255, 240);
  strokeWeight(3.5);
  line(width*0.75 + 70, height/2 - 140, width*0.75 + 220, height/2 - 140);
  line(width*0.875, height/2 - 160, width*0.875, height/2 + 160);
  
  // Alle Labels in vollem Weiß – groß und klar
  fill(255);  // Volles Weiß, Opazität 255
  text("Grausamkeit",           width/8,     70);
  text("Aberglaube",            width/8 * 3, 70);
  text("Mangelnde Vernunft",    width/8 * 5, 70);
  text("Zivilisation",          width/8 * 7, 70);
}

void keyPressed() { 
  if (key == 's' || key == 'S') {
   saveFrame("Trias Barbarica-####.png");
    println("Gespeichert");
  }
}
