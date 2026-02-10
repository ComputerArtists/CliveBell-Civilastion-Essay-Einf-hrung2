# Clive Bell – Civilization  
Visualisierungen in Processing

Dieses Repository enthält eine Sammlung von **Processing-Skripten**, die die zentralen Thesen und Kapitel aus Clive Bells Essay **Civilization** (Pelican Books, 1938) visuell interpretieren und umsetzen.

Das Projekt ist in enger Anlehnung an die Kapitelstruktur des Buches entstanden und wurde iterativ in einer langen Unterhaltung entwickelt.

## Inhaltsverzeichnis

- [Über das Projekt](#über-das-projekt)
- [Buchstruktur und zugehörige Skripte](#buchstruktur-und-zugehörige-skripte)
- [Gemeinsame Steuerung aller Skripte](#gemeinsame-steuerung-aller-skripte)
- [Installation & Ausführung](#installation--ausführung)
- [Lizenz](#lizenz)
- [Kontakt / Weiterentwicklung](#kontakt--weiterentwicklung)

## Über das Projekt

Clive Bells *Civilization* (1928/1938) ist ein elitärer, anti-egalitärer Essay über die Bedingungen echter Hochkultur.  
Das Buch unterscheidet scharf zwischen:

- **Barbarismus** (Grausamkeit, Aberglaube, fehlende Vernunft)
- **Zivilisation** (Muße, Luxus, Geschmack, Vernunft auf dem Thron, kleine kultivierte Minderheiten als Träger)

Die Skripte versuchen, diese Thesen **symbolisch, langsam und ästhetisch** (Kandinsky-inspiriert) darzustellen.

## Buchstruktur und zugehörige Skripte

| Kapitel / Abschnitt                         | Thema / These                                      | Haupt-Skript(e) / Ordner                               | Status      |
|---------------------------------------------|----------------------------------------------------|--------------------------------------------------------|-------------|
| Dedication & Introduction                   | Widmung an Virginia Woolf, Nachkriegs-Enttäuschung | (nicht visualisiert – nur Textgrundlage)               | –           |
| II. What Civilization Is Not                | Barbarismus-Trias (Grausamkeit, Aberglaube, Instinkt) | Trias Barbarica, Pulsierender Barbarismus, Evolutionärer Kontrast | abgeschlossen |
| III. The Paragons                           | Athen – Renaissance – Frankreich als Höhepunkte    | Paragons – Strahlendes Zentrum, Zeitstrahl der Höhepunkte | abgeschlossen |
| IV. Sense of Values                         | Ästhetik, Ethik, Intellekt um ihrer selbst willen  | Wert-Harmonie, Wert-Pyramide, Wert-Kontrast            | abgeschlossen |
| V. Reason Enthroned                         | Vernunft als oberster Wert auf dem Thron           | Reason Enthroned – Der Thron der Vernunft              | abgeschlossen |
| VI. Civilization and Its Disseminators      | Kleine kultivierte Minderheiten als Träger         | Disseminators – Funken im Dunkel, Leuchtende Kerne     | abgeschlossen |
| VII. How to Make a Civilization             | Rezept: Muße, Luxus, Erziehung, Schutz vor Krieg   | Rezept-Buch, Garten der Elite, Lichtschule, Waage, Schutzglocke, Lichtbaum, Aufstieg des Überflusses | abgeschlossen |

## Gemeinsame Steuerung aller Skripte

Fast alle Skripte verwenden dieselben Grundbedienungen:

- **Maus Y** (vertikal) → Intensität / Stärke des jeweiligen Themas  
  (oben = stark / blüht / Elite dominiert / Vernunft strahlt, unten = schwach / Chaos dominiert)
- **Linksklick** → neue Elemente hinzufügen (Funken, Pflanzen, Lehrer, Bausteine, Schutzsegmente usw.)
- **Taste 'c'** → neue zufällige Farben (meist Gold-/Neon-Variationen)
- **Taste 's'** → aktuelles Bild speichern als PNG

## Installation & Ausführung

1. **Processing installieren**  
   → https://processing.org/download

2. **Skript öffnen**  
   Jedes Skript ist eine eigenständige `.pde`-Datei. Einfach in Processing öffnen.

3. **Sound (optional)**  
   Einige Skripte nutzen `SoundFile` (Processing Sound Library).  
   Installiere die Bibliothek über den Processing-Manager → `Sketch → Import Library → Add Library → Sound`.  
   Lege ggf. die `.wav`-Dateien (`glow.wav`, `bloom.wav`, `enlighten.wav`, `balance.wav`) in den Sketch-Ordner.

4. **Ausführen**  
   Strg+R (Windows/Linux) oder Cmd+R (Mac)

## Lizenz

MIT License – frei für nicht-kommerzielle und künstlerische Nutzung.  
Falls du das Projekt weiterentwickeln oder ausstellen möchtest, sehr gerne – ich freue mich über Rückmeldung.

## Kontakt / Weiterentwicklung

Falls du Fragen hast, ein Skript weiter ausbauen möchtest, eine Modus-Kombination aller Kapitel willst oder das gesamte Projekt in eine interaktive Installation umwandeln möchtest:

→ Schreibe einfach eine Nachricht oder öffne ein Issue.

Viel Spaß beim Erkunden von Clive Bells Welt!

*„Civilization is Reason enthroned.“*  
— Clive Bell, 1928
