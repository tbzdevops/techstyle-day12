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

Erweitert die TechStyle CI/CD-Pipeline um einen AI-Schritt. Entscheidend ist
nicht nur die technische Umsetzung, sondern auch die kritische Reflexion.

## Aufgaben

### 1. Waehlt eine AI-Integration (mind. eine, Bonus: mehrere)

**Option A — AI Release Notes** *(Einsteiger)*
Ein Workflow `.github/workflows/ai-release-notes.yml`, der bei Push auf
`main` Release Notes aus dem Git-Log generiert und als Actions Summary
ausgibt.

**Option B — AI PR Review** *(Fortgeschritten)*
Der vollstaendige AI Code Review aus der Praxis, erweitert um:
Beschraenkung auf `*.py`, einen Hinweis *"Dieser Review ist AI-generiert und
kein Ersatz fuer menschliches Code Review"*, sowie eine `AI_REVIEW.md` mit
den Schwaechen des Ansatzes.

**Option C — Commit Message Validator** *(Fortgeschritten)*
Ein Workflow, der Commit-Messages gegen Conventional Commits validiert und
bei Verstoessen einen AI-generierten Korrekturvorschlag liefert.

> Der Workflow-Dateiname muss `ai` enthalten, damit die automatische Pruefung
> ihn findet (z. B. `ai-release-notes.yml`, `ai-review.yml`).

### 2. Reflexionsdokument erstellen

Legt `AI_INTEGRATION.md` an, mit diesen Abschnitten:

- **Implementiertes Feature** — welche Option und warum?
- **Was die AI-Integration leistet** — konkrete beobachtete Vorteile
- **Grenzen und Schwaechen** — was kann sie nicht, wo war sie unzuverlaessig?
- **Security-Betrachtung** — welche Prompt-Injection-Risiken seht ihr, und
  was habt ihr dagegen unternommen?
- **Fazit** — wuerdet ihr das produktiv einsetzen, unter welchen Bedingungen?

Das Dokument muss mindestens 100 Woerter umfassen und einen Abschnitt zu
Grenzen bzw. Risiken enthalten.

### 3. Entscheidung als ADR dokumentieren

Legt unter `docs/adr/` einen Architecture Decision Record an (Status,
Kontext, Entscheidung, Konsequenzen) zu eurer AI-Integration.

> **Bonus (Spec-First):** Schreibt vorab eine kurze Spec
> (`specs/ai-workflow.md`) und lasst die `*.yml`-Datei daraus generieren.

**Erwartete Deliverables**

- Mindestens ein funktionierender AI-Workflow in der TechStyle-Pipeline
- `AI_INTEGRATION.md` mit ausgefuellter Reflexion
- Ein ADR unter `docs/adr/` zur AI-Integration
- Mindestens ein erfolgreicher Pipeline-Run

> **Tipp:** Die GitHub Models API kann gedrosselt sein — plant einen Fallback
> ein. Testet zuerst mit `workflow_dispatch`, bevor ihr auf `push` umstellt.

## Abnahmekriterien

Diese Kriterien prueft die Pipeline bei jedem Push automatisch. **Die Haken
setzt die Pipeline selbst:** ein erfuelltes Kriterium wird abgehakt, und
sobald eine Aenderung es wieder bricht, verschwindet der Haken. Du musst hier
nichts von Hand pflegen — beim naechsten Push wird die Liste ueberschrieben.

<!-- c50:progress -->
**Fortschritt: 0 / 5 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-08-24 21:16 UTC.
<!-- /c50:progress -->

- [ ] ⬜ AI-Workflow existiert (.github/workflows/*ai*.yml)
- [ ] ⬜ GitHub Models API oder KI-Integration im Workflow
- [ ] ⬜ AI_INTEGRATION.md Reflexionsdokument existiert
- [ ] ⬜ AI_INTEGRATION.md hat ausreichend Inhalt (mind. 100 Wörter)
- [ ] ⬜ Abschnitt zu Grenzen/Risiken von AI vorhanden

Zusaetzlich manuell abgenommen (nicht automatisch geprueft):

- Architecture Decision Record unter docs/adr/ angelegt

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
