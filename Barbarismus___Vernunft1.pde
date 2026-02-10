void setup() {
  size(1000, 500);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(28);
  noStroke();
}

void draw() {
  background(0);
  
  float progress = map(mouseX, 0, width, 0, 1);  // Maus-X = Fortschritt zu Zivilisation (links=Barbarismus, rechts=Vernunft)
  float chaos = 1 - progress;                    // Umgekehrt für barbarische Intensität
  
  // Hintergrund-Gradient: von warm/barbarisch (rot/gelb) nach kühl/zivilisiert (blau/grün)
  for (int y = 0; y < height; y++) {
    float amt = map(y, 0, height, 0, 1);
    color from = lerpColor(color(20, 90, 90), color(210, 80, 60), progress);  // Gelb/Rot → Blau
    color toCol = lerpColor(color(40, 95, 95), color(140, 70, 70), progress); // Orange → Grün
    fill(lerpColor(from, toCol, amt));
    rect(0, y, width, 1);
  }
  
  // Barbarische Elemente (stark links, schwach rechts)
  fill(lerp(20, 210, progress), 95, 90, 220 * chaos);
  for (int i = 0; i < 30 * chaos; i++) {
    pushMatrix();
    translate(random(0, width * 0.45 * (1 + chaos)), random(height));
    rotate(random(TWO_PI));
    float sz = 30 + random(40) * chaos;
    triangle(0, -sz, -sz, sz, sz, sz);
    popMatrix();
  }
  
  // Aberglaube-Symbol (Mitte, verschwindet nach rechts)
  fill(lerp(270, 210, progress), 90, 85, 200 * (1 - abs(progress - 0.5) * 2));
  textSize(120 + sin(millis() * 0.005) * 20);
  text("?", width * 0.5 + sin(millis() * 0.003) * 60, height/2 + cos(millis() * 0.004) * 40);
  
  // Zivilisationselemente (stark rechts, schwach links)
  noFill();
  stroke(lerp(210, 140, progress), 85, 95, 255 * progress);
  strokeWeight(3);
  for (int i = 0; i < 12 * progress; i++) {
    float r = 50 + i * 35 + sin(millis() * 0.001 + i * 2) * 20;
    ellipse(width * 0.8, height/2, r * 2, r * 2);
  }
  
  // Zeitstrahl-Linie (horizontal durch die Mitte)
  stroke(255, 220);
  strokeWeight(6);
  line(0, height/2, width, height/2);
  
  // Labels – volles Weiß
  fill(255);
  text("Barbarismus", 150, height - 60);
  text("→ Übergang →", width/2, height - 60);
  text("Vernunft / Zivilisation", width - 150, height - 60);
  
  // Info unten
  fill(255, 220);
  textSize(18);
  text("Maus X = Evolution zu Zivilisation (links = Barbarismus, rechts = Vernunft)", width/2, height - 20);
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("Barbarismus_zu_Vernunft-####.png");
    println("Bild gespeichert!");
  }
}
