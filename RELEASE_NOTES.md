# NiceOne – Release Notes

## v1.2.0-alpha
_14. April 2026_

### Neu: Benutzerdefinierte Sprachen (Language Slots 3 & 4)

Im Optionen-Tab gibt es jetzt zwei zusätzliche Sprach-Slots die du selbst benennen kannst.

- Namen können direkt im Optionen-Tab vergeben werden (max. 12 Zeichen)
- Jeder Slot hat eine eigene Nachrichtenliste im Begrüßungen-Tab
- Keine vorgefertigten Beispielnachrichten – du startest mit einer leeren Liste
- Sobald ein Slot als aktive Sprache gewählt ist, sendet das Addon Begrüßungen aus dieser Liste
- Das UI bleibt auf Englisch wenn Slot 3 oder 4 aktiv ist

### Neu: Zufällige Verzögerung vor der Begrüßung

Bisher hat NiceOne immer nach genau 2,5 Sekunden gegrüßt. Das wirkte bei mehreren Spielern mit dem Addon zu maschinell. Die Verzögerung ist jetzt zufällig zwischen 2 und 7 Sekunden. Jede Begrüßung wird unabhängig ausgewürfelt.

---

## v1.1.0-alpha
_13. April 2026_

### Neu: Überarbeitetes Interface

Das Fenster ist jetzt in zwei Tabs aufgeteilt:

- **Begrüßungen** – Nachrichten verwalten, nach Sprache gefiltert
- **Optionen** – alle Einstellungen an einem Ort

### Neu: Sprachauswahl in den Optionen

Die aktive Begrüßungssprache wird jetzt direkt im Optionen-Tab gesetzt.

### Neu: Einmalige Begrüßung in der Party

Neuer Toggle im Optionen-Tab: **„Einmalig in Party"**

- **Aus (Standard):** Jeder neue Spieler der der Party beitritt wird einzeln begrüßt
- **An:** Die Begrüßung wird nur beim ersten Beitritt zur Gruppe gesendet

Alle Einstellungen werden gespeichert und beim Login wiederhergestellt.

---

## v1.0.0-alpha
_Erster Alpha-Release_

- Automatische Begrüßung beim Beitreten einer Party oder eines Raids
- Zufällige Auswahl aus eigenen Nachrichten (keine direkte Wiederholung)
- Deutsch und Englisch als Sprachen wählbar
- Party- und Raid-Begrüßung separat aktivierbar
- Eigene Nachrichten hinzufügen, bearbeiten und löschen
- Einstellungen bleiben über Neustarts gespeichert
- Slash-Befehle: `/niceone` und `/greet`
