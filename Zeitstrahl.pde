int popupTimer = 0;
String popupText = "";

void setup() {
  size(1000, 500);
  textAlign(CENTER);
  textSize(28);
  smooth();
}

void draw() {
  background(10, 15, 30);
  float progress = map(mouseX, 0, width, 0, 1); // Maus-X = Zeitfortschritt
  float glowLevel = map(mouseY, 0, height, 0.0, 1.0); // Maus-Y = Glanz

  // Zeitstrahl (horizontal durch Mitte)
  stroke(255, 180);
  strokeWeight(6);
  line(100, height/2, 900, height/2);

  // Drei Höhepunkte als pulsierende Kreise
  float athensX = 250;
  float renX = 500;
  float franceX = 750;

  // Athen (Perikles-Zeit)
  float athensPulse = sin(millis() * 0.003) * 20 + 80 * glowLevel;
  fill(210, 80, athensPulse, 220);
  ellipse(athensX, height/2, 140 + athensPulse * 0.3, 140 + athensPulse * 0.3);
  if (dist(mouseX, mouseY, athensX, height/2) < 70) {
    fill(255);
    textSize(24);
    text("Athen", athensX, height/2 + 180);
    text("Perikles-Zeit", athensX, height/2 + 210);
    text("„The highest point of Greek civilisation“", athensX, height/2 + 240);
  }

  // Renaissance-Italien
  float renPulse = sin(millis() * 0.003 + 2) * 20 + 80 * glowLevel;
  fill(30, 90, renPulse, 220);
  ellipse(renX, height/2, 140 + renPulse * 0.3, 140 + renPulse * 0.3);
  if (dist(mouseX, mouseY, renX, height/2) < 70) {
    fill(255);
    textSize(24);
    text("Renaissance-Italien", renX, height/2 + 180);
    text("Humanismus & Kunst", renX, height/2 + 210);
    text("„The most civilised society that ever existed“", renX, height/2 + 240);
  }

  // Frankreich (Aufklärung)
  float francePulse = sin(millis() * 0.003 + 4) * 20 + 80 * glowLevel;
  fill(140, 80, francePulse, 220);
  ellipse(franceX, height/2, 140 + francePulse * 0.3, 140 + francePulse * 0.3);
  if (dist(mouseX, mouseY, franceX, height/2) < 70) {
    fill(255);
    textSize(24);
    text("Frankreich", franceX, height/2 + 180);
    text("1653–1789", franceX, height/2 + 210);
    text("„The most civilised society in modern times“", franceX, height/2 + 240);
  }

  // Labels unten
  fill(255);
  textSize(36);
  text("Zeitstrahl der Höhepunkte", width/2, 80);
  textSize(20);
  text("Maus X = Zeitfortschritt | Maus Y = Glanz | Hover/Klick = Details", width/2, height - 40);
    if (popupTimer > 0) {
    popupTimer--;
    float alpha = map(popupTimer, 0, 180, 0, 255);
    fill(255, alpha);
    textSize(32);
    text(popupText, width/2, 120);
  }
}

void mousePressed() {
  float athensX = 250;
  float renX = 500;
  float franceX = 750;

  if (dist(mouseX, mouseY, athensX, height/2) < 70) {
    popupTimer = 180;
    popupText = "Athen – Perikles-Zeit\n„The highest point of Greek civilisation“";
  }
  if (dist(mouseX, mouseY, renX, height/2) < 70) {
    popupTimer = 180;
    popupText = "Renaissance-Italien\n„The most civilised society that ever existed“";
  }
  if (dist(mouseX, mouseY, franceX, height/2) < 70) {
    popupTimer = 180;
    popupText = "Frankreich 1653–1789\n„The most civilised society in modern times“";
  }
}

void keyPressed(){ 
saveFrame("Zeitstrahl-####.png");
}
    println("Gespeichert!");
