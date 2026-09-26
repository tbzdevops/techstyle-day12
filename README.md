# Tag 12 Projekt — AI in DevOps

> **Projektauftrag TechStyle Online Shop.** Dieses Repository ist dein
> Startpunkt für Tag 12 und enthält den Stand nach Tag 11.

## Ausgangslage

Die TechStyle-Entwicklungsmannschaft wächst und der Review-Prozess wird zum
Engpass: Bei jedem Pull Request warten Änderungen manchmal Stunden auf
menschliche Reviewer. Gleichzeitig schleichen sich immer wieder einfache
Fehler durch, die eigentlich automatisch erkannt werden könnten. Die
Teamleitung möchte AI nutzen, um die Pipeline intelligenter zu machen — ohne
die menschliche Kontrolle aufzugeben. Die Security-Verantwortliche stellt zwei
Bedingungen: Der Code von TechStyle darf keinen externen AI-Dienst erreichen,
und der Bot darf sich nicht über den Code, den er liest, umprogrammieren lassen.

## Ziel

In **zwei Lektionen (90 Min)** baut ihr einen self-hosted AI-Review-Bot für
die TechStyle-Pipeline: Das Modell läuft mit Ollama direkt im GitHub-Runner,
ohne Account und ohne API-Key. Von der Spec über den lauffähigen Workflow bis
zur Absicherung gegen Prompt Injection mit Prompt-Evals — und ihr haltet die
Entscheidung als ADR und die Erfahrungen als Reflexion fest. Die ausführliche Aufgabenstellung mit
Workflow-Gerüst steht in der Tagesplanung Tag 12.

| Schritt | Zeit | Ergebnis |
| --- | --- | --- |
| 1 — Spec für den AI-Review-Bot | 10 Min | `specs/ai-review.md` |
| 2 — Workflow bauen, an einem echten PR testen | 30 Min | `.github/workflows/ai-review.yml` |
| 3 — Prompt auslagern, härten, mit Evals testen | 20 Min | `prompts/`, `evals/cases/`, `ai-prompt-eval.yml`, Injection-Test-PR |
| 4 — Entscheidung als ADR | 10 Min | `docs/adr/0001-ai-review-in-der-pipeline.md` |
| 5 — Reflexion | 15 Min | `AI_INTEGRATION.md` |
| Puffer / Bonus | 5 Min | optional zweite AI-Integration |

## Aufgaben

### 1. Spec schreiben

`specs/ai-review.md` mit den Überschriften `Ziel`, `Anforderungen`,
`Akzeptanzkriterien` und `Out of Scope`: was der Bot tun soll, bevor ihr ihn
baut.

### 2. Workflow bauen und testen

Übernehmt das Gerüst aus der Tagesplanung nach
`.github/workflows/ai-review.yml`. Es startet Ollama als Service-Container und
lädt das Modell `gemma3:4b` — ihr braucht dafür nichts einzurichten. Löst die
drei TODOs:

1. Nur den Diff der Python-Dateien an die AI schicken.
2. Fallback: antwortet das Modell nicht rechtzeitig, trotzdem einen Kommentar posten.
3. Im Kommentar darauf hinweisen, dass der Review AI-generiert und **kein
   Ersatz** für menschliches Code Review ist.

Testet mit einem echten Pull Request, der eine `.py`-Datei ändert.

> Der Workflow-Dateiname muss `ai` enthalten (z. B. `ai-review.yml`), sonst
> findet ihn die automatische Prüfung nicht.

### 3. Prompt auslagern, härten und mit Evals testen

- System-Prompt nach `prompts/review-system.md` verschieben und im Workflow
  mit `jq --rawfile` einlesen.
- Diff zwischen Begrenzern (`<diff> ... </diff>`) schicken und im
  System-Prompt als Daten kennzeichnen.
- Prompt-Eval: In `evals/cases/` einen Testfall mit Injection-Kommentar
  anlegen (`.diff` + `.expect`) und einen Workflow
  `.github/workflows/ai-prompt-eval.yml`, der bei Änderungen an `prompts/`
  `bash evals/run.sh` ausführt. Das Skript `evals/run.sh` liegt schon bereit.
- Berechtigungen minimal halten: `contents: read`, `pull-requests: write`,
  kein `write-all`.
- PR-Inhalte nie per `${{ steps... }}` direkt in `run:` einsetzen, sondern
  über `env:` oder Dateien (Script Injection).
- Einen zweiten PR mit präpariertem Injection-Kommentar öffnen und das
  Ergebnis mit und ohne Härtung vergleichen.

### 4. Entscheidung als ADR

`docs/adr/0001-ai-review-in-der-pipeline.md` mit den Abschnitten Status,
Kontext, Entscheidung und Konsequenzen.

### 5. Reflexion

`AI_INTEGRATION.md` (mindestens 150 Wörter) mit den Abschnitten
Implementiertes Feature, Was die AI-Integration leistet, **Grenzen und
Schwächen**, **Security-Betrachtung** (Ergebnis eures Prompt-Injection-Tests)
und Fazit.

> **Tipp:** Ein Lauf dauert 2–3 Minuten, das Modell rechnet auf der CPU des
> Runners. Genau deshalb braucht es TODO 2. Bleibt der Kommentar aus, im Tab
> **Actions** den Lauf öffnen: `403` beim Kommentieren deutet auf fehlende
> `permissions`, ein leerer Kommentar auf ein falsches `jq`-Feld.

## Abnahmekriterien

Diese Kriterien prüft die Pipeline bei jedem Push automatisch. **Die Haken
setzt die Pipeline selbst:** ein erfülltes Kriterium wird abgehakt, und
sobald eine Änderung es wieder bricht, verschwindet der Haken. Du musst hier
nichts von Hand pflegen — beim nächsten Push wird die Liste überschrieben.

<!-- c50:progress -->
**Fortschritt: 0 / 17 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-09-20 08:38 UTC.
<!-- /c50:progress -->

- [ ] ⬜ Spec für den AI-Review-Bot vorhanden (specs/*.md)
- [ ] ⬜ Spec nennt Ziel, Anforderungen, Akzeptanzkriterien und Out of Scope
- [ ] ⬜ AI-Workflow reagiert auf Pull Requests (.github/workflows/*ai*.yml)
- [ ] ⬜ AI-Modell wird im Workflow aufgerufen (z. B. Ollama im Runner)
- [ ] ⬜ Nur der Diff der Python-Dateien geht an die AI (TODO 1)
- [ ] ⬜ Fallback, wenn die AI-API nicht antwortet (TODO 2)
- [ ] ⬜ PR-Kommentar weist auf AI-Generierung hin — kein Ersatz für menschliches Review (TODO 3)
- [ ] ⬜ Workflow-Berechtigungen minimal (contents: read, pull-requests: write, kein write-all)
- [ ] ⬜ Keine Step-Outputs oder PR-Texte direkt in run:/script: (Script Injection)
- [ ] ⬜ System-Prompt versioniert unter prompts/ und im Workflow eingelesen
- [ ] ⬜ Prompt-Eval: Testfall mit Injection-Versuch in evals/cases/
- [ ] ⬜ Prompt-Eval läuft als Workflow bei Änderungen an prompts/
- [ ] ⬜ Architecture Decision Record vorhanden (docs/adr/*.md)
- [ ] ⬜ ADR nennt Status, Kontext, Entscheidung und Konsequenzen
- [ ] ⬜ AI_INTEGRATION.md mit Reflexion vorhanden (mind. 150 Wörter)
- [ ] ⬜ AI_INTEGRATION.md: Abschnitt Grenzen und Schwächen
- [ ] ⬜ AI_INTEGRATION.md: Security-Betrachtung mit Prompt-Injection-Test

Zusätzlich manuell abgenommen (nicht automatisch geprüft):

- Pull Request mit AI-Kommentar und Injection-Test-PR im Repository sichtbar
- Lauf von «AI Prompt Eval» im Tab Actions (grün, oder rot mit Begründung in `AI_INTEGRATION.md`)

## Abnahmekriterien selber prüfen

**Lokal** — jederzeit, ohne Push:

```bash
bash .github/classroom/grade.sh
```

Das Skript liest die Tagesnummer aus `.classroom50.yaml`. Du kannst sie auch
erzwingen:

```bash
CLASSROOM_DAY=12 bash .github/classroom/grade.sh
```

Die Ausgabe listet jedes Kriterium mit ✅ oder ❌ und nennt bei jedem ❌ den
konkreten Lösungshinweis. Sobald ein Kriterium fehlt, endet das Skript mit
Exit-Code 1.

**In GitHub** — bei jedem Push:

Der Workflow **🎓 Classroom Autograding** läuft automatisch und hakt die
erfüllten Kriterien oben im README ab. Ergebnis im Tab
**Actions** → letzter Run → Job *Abnahmekriterien prüfen*.

Die Punktzahl ist **anteilig**: jedes erfüllte Abnahmekriterium zählt einen
Punkt (z. B. `Points 8/13`). Grün wird der Lauf erst, wenn alle Kriterien
erfüllt sind — Teilpunkte gibt es aber ab dem ersten.

## Anwendung lokal starten

```bash
./run_dev.sh
```

Legt ein venv an, installiert die Abhängigkeiten, seedet die Datenbank und
startet den Dev-Server auf http://localhost:5000. Admin-Panel unter `/admin`.

Hinweise zur Anwendung:

- Die Datenbank liegt unter `/tmp/techstyle.db`.
- `python seed_data.py` (im aktivierten venv) setzt die Produkte zurück.
- Das Admin-Panel hat noch kein Login — das ist zum jetzigen Zeitpunkt so gewollt.
