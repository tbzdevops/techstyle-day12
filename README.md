# Tag 12 Projekt — AI in DevOps

> **Projektauftrag TechStyle Online Shop.** Dieses Repository ist dein
> Startpunkt fuer Tag 12 und enthaelt den Stand nach Tag 11.

## Ausgangslage

Die TechStyle-Entwicklungsmannschaft waechst und der Review-Prozess wird zum
Engpass: Bei jedem Pull Request warten Aenderungen manchmal Stunden auf
menschliche Reviewer. Gleichzeitig schleichen sich immer wieder einfache
Fehler durch, die eigentlich automatisch erkannt werden koennten. Die
Teamleitung moechte AI nutzen, um die Pipeline intelligenter zu machen — ohne
die menschliche Kontrolle aufzugeben.

## Ziel

In **zwei Lektionen (90 Min)** baut ihr einen AI-Review-Bot fuer die
TechStyle-Pipeline — von der Spec ueber den lauffaehigen Workflow bis zur
Absicherung gegen Prompt Injection — und haltet die Entscheidung als ADR und
die Erfahrungen als Reflexion fest. Die ausfuehrliche Aufgabenstellung mit
Workflow-Geruest steht in der Tagesplanung Tag 12.

| Schritt | Zeit | Ergebnis |
| --- | --- | --- |
| 1 — Spec fuer den AI-Review-Bot | 10 Min | `specs/ai-review.md` |
| 2 — Workflow bauen, an einem echten PR testen | 35 Min | `.github/workflows/ai-review.yml` |
| 3 — Gegen Prompt Injection absichern | 15 Min | gehaerteter Workflow, Injection-Test-PR |
| 4 — Entscheidung als ADR | 10 Min | `docs/adr/0001-ai-review-in-der-pipeline.md` |
| 5 — Reflexion | 15 Min | `AI_INTEGRATION.md` |
| Puffer / Bonus | 5 Min | optional zweite AI-Integration |

## Aufgaben

### 1. Spec schreiben

`specs/ai-review.md` mit den Ueberschriften `Ziel`, `Anforderungen`,
`Akzeptanzkriterien` und `Out of Scope`: was der Bot tun soll, bevor ihr ihn
baut.

### 2. Workflow bauen und testen

Uebernehmt das Geruest aus der Tagesplanung nach
`.github/workflows/ai-review.yml` und loest die drei TODOs:

1. Nur den Diff der Python-Dateien an die AI schicken.
2. Fallback: schlaegt der API-Aufruf fehl, trotzdem einen Kommentar posten.
3. Im Kommentar darauf hinweisen, dass der Review AI-generiert und **kein
   Ersatz** fuer menschliches Code Review ist.

Testet mit einem echten Pull Request, der eine `.py`-Datei aendert.

> Der Workflow-Dateiname muss `ai` enthalten (z. B. `ai-review.yml`), sonst
> findet ihn die automatische Pruefung nicht.

### 3. Gegen Prompt Injection absichern

- Diff zwischen Begrenzern (`<diff> ... </diff>`) schicken und im
  System-Prompt als Daten kennzeichnen.
- Berechtigungen minimal halten: `pull-requests: write`, `models: read`,
  kein `write-all`.
- PR-Inhalte nie per `${{ steps... }}` direkt in `run:` einsetzen, sondern
  ueber `env:` oder Dateien (Script Injection).
- Einen zweiten PR mit praepariertem Injection-Kommentar oeffnen und das
  Ergebnis mit und ohne Haertung vergleichen.

### 4. Entscheidung als ADR

`docs/adr/0001-ai-review-in-der-pipeline.md` mit den Abschnitten Status,
Kontext, Entscheidung und Konsequenzen.

### 5. Reflexion

`AI_INTEGRATION.md` (mindestens 150 Woerter) mit den Abschnitten
Implementiertes Feature, Was die AI-Integration leistet, **Grenzen und
Schwaechen**, **Security-Betrachtung** (Ergebnis eures Prompt-Injection-Tests)
und Fazit.

> **Tipp:** Die GitHub Models API ist gedrosselt — genau dafuer ist TODO 2 da.
> Bleibt der Kommentar aus, im Tab **Actions** den Lauf oeffnen: `401`/`403`
> deutet auf fehlende `permissions`.

## Abnahmekriterien

Diese Kriterien prueft die Pipeline bei jedem Push automatisch. **Die Haken
setzt die Pipeline selbst:** ein erfuelltes Kriterium wird abgehakt, und
sobald eine Aenderung es wieder bricht, verschwindet der Haken. Du musst hier
nichts von Hand pflegen — beim naechsten Push wird die Liste ueberschrieben.

<!-- c50:progress -->
**Fortschritt: 0 / 14 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-09-19 18:27 UTC.
<!-- /c50:progress -->

- [ ] ⬜ Spec für den AI-Review-Bot vorhanden (specs/*.md)
- [ ] ⬜ Spec nennt Ziel, Anforderungen, Akzeptanzkriterien und Out of Scope
- [ ] ⬜ AI-Workflow reagiert auf Pull Requests (.github/workflows/*ai*.yml)
- [ ] ⬜ AI-Modell wird im Workflow aufgerufen (z. B. GitHub Models)
- [ ] ⬜ Nur der Diff der Python-Dateien geht an die AI (TODO 1)
- [ ] ⬜ Fallback, wenn die AI-API nicht antwortet (TODO 2)
- [ ] ⬜ PR-Kommentar weist auf AI-Generierung hin — kein Ersatz für menschliches Review (TODO 3)
- [ ] ⬜ Workflow-Berechtigungen minimal (pull-requests: write, models: read, kein write-all)
- [ ] ⬜ Keine Step-Outputs oder PR-Texte direkt in run:/script: (Script Injection)
- [ ] ⬜ Architecture Decision Record vorhanden (docs/adr/*.md)
- [ ] ⬜ ADR nennt Status, Kontext, Entscheidung und Konsequenzen
- [ ] ⬜ AI_INTEGRATION.md mit Reflexion vorhanden (mind. 150 Wörter)
- [ ] ⬜ AI_INTEGRATION.md: Abschnitt Grenzen und Schwächen
- [ ] ⬜ AI_INTEGRATION.md: Security-Betrachtung mit Prompt-Injection-Test

Zusaetzlich manuell abgenommen (nicht automatisch geprueft):

- Pull Request mit AI-Kommentar und Injection-Test-PR im Repository sichtbar

## Abnahmekriterien selber pruefen

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
konkreten Loesungshinweis. Sobald ein Kriterium fehlt, endet das Skript mit
Exit-Code 1.

**In GitHub** — bei jedem Push:

Der Workflow **🎓 Classroom Autograding** laeuft automatisch und hakt die
erfuellten Kriterien oben im README ab. Ergebnis im Tab
**Actions** → letzter Run → Job *Abnahmekriterien pruefen*.

Die Punktzahl ist **anteilig**: jedes erfuellte Abnahmekriterium zaehlt einen
Punkt (z. B. `Points 8/13`). Gruen wird der Lauf erst, wenn alle Kriterien
erfuellt sind — Teilpunkte gibt es aber ab dem ersten.

## Anwendung lokal starten

```bash
./run_dev.sh
```

Legt ein venv an, installiert die Abhaengigkeiten, seedet die Datenbank und
startet den Dev-Server auf http://localhost:5000. Admin-Panel unter `/admin`.

Hinweise zur Anwendung:

- Die Datenbank liegt unter `/tmp/techstyle.db`.
- `python seed_data.py` (im aktivierten venv) setzt die Produkte zurueck.
- Das Admin-Panel hat noch kein Login — das ist zum jetzigen Zeitpunkt so gewollt.
