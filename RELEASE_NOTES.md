# NiceOne – Release Notes

## v1.1.1-alpha
_13. April 2026_

### Neu: Überarbeitetes Interface

Das UI wurde grundlegend neu strukturiert. Das Fenster ist jetzt in zwei Tabs aufgeteilt:

- **Begrüßungen** – Nachrichten verwalten, nach Sprache (Deutsch / Englisch) gefiltert
- **Optionen** – alle Einstellungen an einem Ort

Die Tab-Beschriftungen passen sich automatisch an die aktive Sprache an.

---

### Neu: Sprachauswahl in den Optionen

Die aktive Begrüßungssprache wird jetzt direkt im Optionen-Tab gesetzt – klar und eindeutig. Der bisherige Doppelklick-Mechanismus auf den Sprach-Tabs wurde entfernt.

---

### Neu: Einmalige Begrüßung in der Party

Im Optionen-Tab gibt es einen neuen Toggle: **„Einmalig in Party"** (EN: „Once in Party").

- **Aus (Standard):** Jeder neue Spieler der der Party beitritt wird einzeln begrüßt.
- **An:** Die Begrüßung wird nur einmal gesendet – beim ersten Beitritt zur Gruppe.

---

### Sonstiges

- Alle Einstellungen (Sprache, Party/Raid-Toggles, neuer Party-Once-Toggle) werden beim Ausloggen gespeichert und beim nächsten Login wiederhergestellt.
- Kleine Anpassungen an der Infobox.
- Code-Struktur intern bereinigt und besser aufgeteilt.

---

## v1.0.0-alpha
_Erster öffentlicher Alpha-Release_

- Automatische Begrüßung beim Beitreten einer Party oder eines Raids
- Zufällige Auswahl aus eigenen Nachrichten (keine Wiederholung hintereinander)
- Begrüßungen auf Deutsch und Englisch verwaltbar
- Einstellbar ob Party, Raid oder beides begrüßt wird
- Eigene Nachrichten hinzufügen, bearbeiten und löschen
- Einstellungen werden über Neustarts hinweg gespeichert
- Slash-Befehle: `/niceone` und `/greet`
