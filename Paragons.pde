int mode = 1; // 1 = Kombi, 99 = 'c' Zufallsfarben, 5 = Sternenhimmel, 6 = Minimal Gold
float offset = 0;
float rotSpeed = 0;
boolean[] paragonGlow = {false, false, false};

// Separate Popups pro Paragon
int[] popupTimers = {0, 0, 0};
String[] popupTexts = {"", "", ""};
float[] popupAlphas = {0, 0, 0};

// Zufallsfarben
float centerHue, centerSat, centerBri;
float spiralHue, spiralSat, spiralBri;
float[] athensCol = new float[3];
float[] renCol = new float[3];
float[] franceCol = new float[3];

void setup() {
  size(900, 600);
  colorMode(HSB, 360, 100, 100);
  textAlign(CENTER);
  textSize(28);
  smooth();
  randomizeAllColors();
}

void randomizeAllColors() {
  centerHue = random(40, 80); centerSat = random(70, 95); centerBri = random(70, 95);
  spiralHue = random(30, 90); spiralSat = random(80, 100); spiralBri = random(60, 90);
  athensCol[0] = random(180, 240); athensCol[1] = random(70, 95); athensCol[2] = random(70, 95);
  renCol[0]   = random(0, 60);     renCol[1]   = random(80, 100); renCol[2]   = random(70, 95);
  franceCol[0] = random(120, 180); franceCol[1] = random(70, 95); franceCol[2] = random(70, 95);
  println("Alle Farben neu gemischt!");
}

void draw() {
  background(5, 10, 20);
  offset += 0.004;
  rotSpeed = map(mouseX, 0, width, 0.1, 1.2);
  float cb = map(mouseY, 0, height, 0.0, 1.0);

  // Start der Matrix-Transformation für zentrierte Elemente
  pushMatrix(); // <--- pushMatrix 1
  translate(width/2, height/2);

  // Zentrales Leuchten
  noStroke();
  fill(centerHue, centerSat + sin(offset*1.5)*10, centerBri + sin(offset*1.5)*10, 220);
  ellipse(0, 0, 380 + sin(offset*2)*40, 380 + sin(offset*2)*40);

  if (mode == 1 || mode == 99) {
    rotate(offset * rotSpeed * 0.2);

    // Spirale
    for (float r = 0; r < 320; r += 6) {
      float a = r * 0.28 + offset * 0.9;
      float x = r * cos(a);
      float y = r * sin(a);
      fill(spiralHue, spiralSat, spiralBri + sin(r + offset)*15, 140);
      ellipse(x, y, 16 + r/28, 16 + r/28);
    }

    drawParagonAthen(cb, paragonGlow[0], (mode == 99));
    drawParagonRenaissance(cb, paragonGlow[1], (mode == 99));
    drawParagonFrankreich(cb, paragonGlow[2], (mode == 99));
  } 
  else if (mode == 5) {
    drawSternenhimmel(cb);
  } 
  else if (mode == 6) {
    drawMinimalGold(cb);
  }

  popMatrix(); // <--- popMatrix 1 (paart zu pushMatrix 1)

  // Popups – außerhalb aller Matrix, um Stabilität zu gewährleisten
  textSize(32);
  for (int i = 0; i < 3; i++) {
    if (popupTimers[i] > 0) {
      popupTimers[i]--;
      popupAlphas[i] = map(popupTimers[i], 0, 180, 0, 255);
      fill(255, popupAlphas[i]);
      text(popupTexts[i], width/2, 120 + i*40);
    }
  }

  // Globale Labels – außerhalb aller Matrix
  fill(255);
  text("Paragons – Strahlendes Zentrum", width/2, 60);
  text("Modus: " + (mode == 99 ? "'c' (zufällige Farben)" : mode), width/2, height - 60);
  text("'c' = neue Farben | Linksklick = Popup + Glow | 's' = Speichern", width/2, height - 30);
}

// Paragon-Zeichnungen – jede hat eigene push/pop
void drawParagonAthen(float cb, boolean extraGlow, boolean useRandom) {
  pushMatrix(); // <--- pushMatrix 2
  translate(-220, -140);
  scale(1 + sin(offset*3)*0.12 + (extraGlow ? 0.25 : 0));
  if (useRandom) fill(athensCol[0], athensCol[1], athensCol[2], 220);
  else fill(210, 70 + cb*30, 70 + sin(offset)*20, 220);
  ellipse(0, 0, 140, 140);
  popMatrix(); // <--- popMatrix 2
}

void drawSternenhimmel(float cb) {
  for (int g = 0; g < 3; g++) {
    float hue = lerp(210, 50, cb + g*0.3);
    for (int i = 0; i < 18; i++) {
      float a = i * TWO_PI / 18 + offset + g*2.5;
      float r = 140 + g*70 + sin(offset + i + g*4) * 40;
      float x = cos(a) * r;
      float y = sin(a) * r;
      fill(hue, 90 + sin(offset*6 + i)*30, 90 + sin(offset*5 + i)*30, 180);
      ellipse(x, y, 14 + sin(offset*5 + i)*10, 14 + sin(offset*5 + i)*10);
    }
  }
  fill(255);
  textSize(28);
  text("Sternenhimmel der Vernunft", 0, -220);
}

void drawMinimalGold(float cb) {
  float hue = lerp(50, 40, cb);
  float pulse = sin(offset*3) * 20 + 80;
  fill(hue, 90, pulse, 220);
  ellipse(-200, -100, 90 + sin(offset*4)*25, 90 + sin(offset*4)*25);
  ellipse(0, -100, 90 + sin(offset*4 + 1)*25, 90 + sin(offset*4 + 1)*25);
  ellipse(200, -100, 90 + sin(offset*4 + 2)*25, 90 + sin(offset*4 + 2)*25);

  fill(255);
  textSize(26);
  text("Athen          Renaissance          Frankreich", 0, 0);
  textSize(22);
  text("Minimalistische Goldene Punkte", 0, 200);
}

void drawParagonRenaissance(float cb, boolean extraGlow, boolean useRandom) {
  pushMatrix(); // <--- pushMatrix 3
  translate(220, -140);
  scale(1 + sin(offset*3 + 1)*0.12 + (extraGlow ? 0.25 : 0));
  if (useRandom) fill(renCol[0], renCol[1], renCol[2], 220);
  else fill(30, 90 + cb*30, 75 + sin(offset)*20, 220);
  ellipse(0, 0, 140, 140);
  popMatrix(); // <--- popMatrix 3
}

void drawParagonFrankreich(float cb, boolean extraGlow, boolean useRandom) {
  pushMatrix(); // <--- pushMatrix 4
  translate(0, 220);
  scale(1 + sin(offset*3 + 2)*0.12 + (extraGlow ? 0.25 : 0));
  if (useRandom) fill(franceCol[0], franceCol[1], franceCol[2], 220);
  else fill(140, 70 + cb*30, 70 + sin(offset)*20, 220);
  ellipse(0, 0, 140, 140);
  popMatrix(); // <--- popMatrix 4
}

// drawSternenhimmel und drawMinimalGold haben keine push/pop – sie brauchen keine lokalen Transformationen

void mousePressed() {
  if (mode == 1 || mode == 99) {
    if (mouseButton == LEFT) {
      float dA = dist(mouseX, mouseY, width/2 - 220, height/2 - 140);
      float dR = dist(mouseX, mouseY, width/2 + 220, height/2 - 140);
      float dF = dist(mouseX, mouseY, width/2, height/2 + 220);

      if (dA < 100) {
        paragonGlow[0] = true;
        popupTimers[0] = 180;
        popupTexts[0] = "Athen – Perikles-Zeit";
        popupAlphas[0] = 255;
      }
      if (dR < 100) {
        paragonGlow[1] = true;
        popupTimers[1] = 180;
        popupTexts[1] = "Renaissance-Italien";
        popupAlphas[1] = 255;
      }
      if (dF < 100) {
        paragonGlow[2] = true;
        popupTimers[2] = 180;
        popupTexts[2] = "Frankreich – Aufklärung";
        popupAlphas[2] = 255;
      }
    }
    if (mouseButton == RIGHT) {
      for (int i = 0; i < 3; i++) {
        paragonGlow[i] = false;
        popupTimers[i] = 0;
        popupAlphas[i] = 0;
      }
    }
  }
}

void keyPressed() {
  if (key >= '1' && key <= '6') mode = key - '0';
  if (key == 'c' || key == 'C') {
    mode = 99;
    randomizeAllColors();
  }
  if (key == 's' || key == 'S') saveFrame("Paragons_####.png");
}
