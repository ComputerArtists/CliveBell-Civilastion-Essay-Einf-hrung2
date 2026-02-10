float pulse = 0;
float noiseOffset = 0;
float offset = 0;  // Korrigiert: Globale Variable deklariert

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(32);
  frameRate(60);
}

void draw() {
  background(0);
  pulse = sin(millis() * 0.0025) * 0.5 + 0.5;           // Basis-Puls
  pulse += noise(noiseOffset) * 0.4;                    // Organischer, unregelmäßiger Herzschlag
  noiseOffset += 0.01;
  offset += 0.015;  // Korrigiert: Offset wird hier inkrementiert
  
  float chaos = map(mouseX, 0, width, 1.8, 0.3);        // Links = max Barbarismus
  float colorBalance = map(mouseY, 0, height, 0.0, 1.0); // Oben = Blau/Grün, unten = Rot/Gelb/Violett
  
  // Globaler Hintergrund – leichter Gradient
  for (int y = 0; y < height; y++) {
    float amt = map(y, 0, height, 0, 1);
    color from = lerpColor(color(210, 70, 50), color(40, 95, 95), colorBalance);
    color toCol = lerpColor(color(300, 80, 60), color(20, 100, 100), colorBalance);  // Korrigiert: to → toCol
    fill(lerpColor(from, toCol, amt));
    rect(0, y, width, 1);
  }
  
  // Zentrale pulsierende Barbarismus-Entität (Mitte-links)
  pushMatrix();
  translate(width * 0.38, height/2);
  scale(1 + pulse * chaos * 0.7);
  rotate(pulse * 0.4 * chaos);
  
  // 1. Grausamkeit – rote/orange Dreiecke, aggressiv
  for (int i = 0; i < 8; i++) {
    float a = i * TWO_PI / 8 + offset;
    float sz = 60 + sin(pulse * 5 + i) * 40 * chaos;
    fill(lerp(10, 60, colorBalance), 95, 85 + pulse * 20, 220);
    triangle(cos(a)*180, sin(a)*180,
              cos(a + 0.5)*sz, sin(a + 0.5)*sz,
              cos(a - 0.5)*sz, sin(a - 0.5)*sz);
  }
  
  // 2. Aberglaube – violette Kreise + ?
  for (int i = 0; i < 6; i++) {
    float a = i * TWO_PI / 6 + offset * 0.8;
    float r = 70 + cos(pulse * 6 + i) * 50 * chaos;
    fill(lerp(250, 320, colorBalance), 90, 75 + pulse * 25, 200);
    ellipse(cos(a)*r*1.4, sin(a)*r*1.4, r*1.3, r*1.3);
    fill(360 - lerp(250, 320, colorBalance), 100, 100);
    textSize(r * 0.7);
    text("?", cos(a)*r*1.1, sin(a)*r*1.1 + 20);
  }
  
  // 3. Mangelnde Vernunft – gelbe/orange chaotische Linien aus dem Zentrum
  stroke(lerp(170, 50, colorBalance), 95, 95 + pulse * 20, 180 * chaos);
  strokeWeight(2.5 + pulse * 4 * chaos);
  for (int i = 0; i < 50 * chaos; i++) {
    float len = random(80, 220) * chaos;
    float ang = random(TWO_PI);
    line(0, 0, cos(ang)*len, sin(ang)*len);
  }
  noStroke();
  
  popMatrix();
  
  // Rechte Seite: ruhige Zivilisation – geometrische Ordnung
  fill(lerp(210, 140, colorBalance), 65, 80, 255);  // Vollständiger Hintergrund
  rect(width/2, 0, width/2, height);
  
  noFill();
  stroke(360 - lerp(210, 140, colorBalance), 85, 95);
  strokeWeight(4);
  for (int i = 0; i < 10; i++) {
    float r = 60 + i * 35 + sin(offset * 1.5 + i*2) * 25;
    ellipse(width * 0.75, height/2, r*2, r*2);
  }
  stroke(255, 240);
  line(width*0.6, height/2 - 130, width*0.9, height/2 - 130);
  line(width*0.75, height/2 - 150, width*0.75, height/2 + 150);
  
  // Labels – volles Weiß
  fill(0);
  text("Pulsierender Barbarismus", width/4, 70);
  text("Vernunft ruht", width * 0.75, 70);
  
  // Kleine Info unten
  fill(255, 220);
  textSize(18);
  text("Maus X = Chaos-Intensität | Maus Y = Farb-Balance (Blau oben → Rot/Gelb unten)", width/2, height - 40);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("PulsierenderBarbarismus-####.png");
    println("Bild gespeichert!");
  }
}
