void setup() {
  size(1000, 500);
}

void draw() {
  background(20);
  
  float progress = map(mouseX, 0, width, 0, 1);  // Maus-X = Fortschritt zu Zivilisation
  
  // Hintergrund-Gradient: von rot/gelb zu blau
  for (int y = 0; y < height; y++) {
    float amt = map(y, 0, height, 0, 1);
    color c1 = lerpColor(color(200,0,0), color(0,0,200), progress);
    color c2 = lerpColor(color(255,200,0), color(0,200,255), progress);
    stroke(lerpColor(c1, c2, amt));
    line(0, y, width, y);
  }
  
  // Barbarische Elemente (links dominant bei progress niedrig)
  if (progress < 0.6) {
    fill(255, 80, 0, 200 * (1-progress));
    for (int i = 0; i < 20; i++) {
      pushMatrix();
      translate(random(0, width*0.4), random(height));
      rotate(random(TWO_PI));
      triangle(0, -30, -30, 30, 30, 30);
      popMatrix();
    }
  }
  
  // Aberglaube-Symbole (Mitte)
  fill(180, 0, 220, 180 * (1-abs(progress-0.5)*2));
  textSize(80);
  text("?", width*0.5 + sin(millis()*0.005)*40, height/2);
  
  // Zivilisation (rechts dominant bei progress hoch)
  if (progress > 0.4) {
    noFill();
    stroke(255, 255 * progress);
    strokeWeight(3);
    for (int i = 0; i < 10; i++) {
      float r = 50 + i*30;
      ellipse(width*0.8, height/2, r*2, r*2);
    }
  }
  
  // Zeitstrahl-Linie
  stroke(255);
  strokeWeight(6);
  line(0, height/2, width, height/2);
  
  fill(255);
  textSize(32);
  textAlign(CENTER);
  text("Barbarismus → Übergang → Zivilisation", width/2, height - 40);
}
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("Barbarismus_zu_Vernunft2-####.png");
    println("Bild gespeichert!");
  }
}
