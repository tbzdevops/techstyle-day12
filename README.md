# Tag 12 Projekt — DevSecOps

> **Projektauftrag TechStyle Online Shop.** Dieses Repository ist dein
> Startpunkt fuer Tag 12 und enthaelt den Stand nach Tag 11.

## Ausgangslage

Eine kuerzlich erfolgte Sicherheitsverletzung bei einem Konkurrenten hat die
Dringlichkeit von Sicherheitsmassnahmen bei TechStyle erhoeht. Das Team
integriert heute SAST- und DAST-Tools in die CI/CD-Pipeline, fuehrt ein
Security-Audit durch und behebt kritische Sicherheitsluecken im Online-Shop,
um Kundeninformationen besser zu schuetzen.

## Ziel

Erweitert euer TechStyle-Projekt um eine DevSecOps-Pipeline. Implementiert
automatisierte Sicherheitstests in eure bestehende CI/CD-Pipeline: statische
Code-Analyse (SAST) und Software Composition Analysis (SCA). Wenn ihr Zeit
habt, integriert als Zusatzaufgabe dynamische Sicherheitstests (DAST).

**Voraussetzungen:** GitHub Actions aktiviert, ein Snyk-Account mit
API-Token, YAML-Grundkenntnisse.

## Aufgaben

### 1. Security-Workflow erstellen

- Legt `.github/workflows/security-pipeline.yml` an.
- Der Workflow wird bei Push auf `main` und bei Pull Requests ausgeloest.
- Nutzt einen Ubuntu-Runner.

### 2. SAST/SCA-Integration mit Snyk

- Hinterlegt den Snyk-Token als GitHub Secret `SNYK_TOKEN`.
- Implementiert `snyk test` fuer Dependency-Scanning **und** `snyk code test`
  fuer die Code-Analyse.
- Definiert sinnvolle Severity-Thresholds, z. B. nur bei High/Critical
  fehlschlagen.

### 3. (Optional) Anwendung fuer DAST vorbereiten

- Startet die TechStyle-Anwendung im CI-Workflow und stellt sicher, dass sie
  erreichbar ist (z. B. via `localhost:<Port>`).
- Fuer die Datenbank: GitHub Services oder eine In-Memory-Variante.

### 4. (Optional) DAST-Integration mit OWASP ZAP

- Integriert den OWASP ZAP Baseline Scan.
- Konfiguriert ZAP fuer eure URLs und Authentifizierung.
- Stellt sicher, dass Login und Checkout gescannt werden.

### 5. Reporting und Monitoring

- Lasst Snyk eine SARIF-Datei erzeugen und ladet sie zu GitHub hoch. Die
  Findings erscheinen dann unter **Security → Code Scanning**.
- Dokumentiert die gefundenen Schwachstellen und wie sie behoben werden.

**Erwartete Deliverables**

- Funktionsfaehige Security-Pipeline mit SAST und SCA in GitHub Actions
- Dokumentation der implementierten Security-Massnahmen
- Analyse-Report der gefundenen Schwachstellen
- Behebungsplan fuer kritische Findings

> **Tipp:** Beginnt mit "warn-only", um Pipeline-Blockaden zu vermeiden, und
> zieht die Thresholds danach an.

## Abnahmekriterien

Diese Kriterien prueft die Pipeline bei jedem Push automatisch. **Die Haken
setzt die Pipeline selbst:** ein erfuelltes Kriterium wird abgehakt, und
sobald eine Aenderung es wieder bricht, verschwindet der Haken. Du musst hier
nichts von Hand pflegen — beim naechsten Push wird die Liste ueberschrieben.

<!-- c50:progress -->
**Fortschritt: 0 / 11 Kriterien erfüllt** ⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ — Stand: 2026-08-23 22:19 UTC.
<!-- /c50:progress -->

- [ ] ⬜ Aufgabe 1: Security-Workflow vorhanden (.github/workflows/security-pipeline.yml)
- [ ] ⬜ Aufgabe 1: Workflow definiert mindestens einen Job (jobs:)
- [ ] ⬜ Aufgabe 1: Wird bei Push und Pull Request ausgelöst
- [ ] ⬜ Aufgabe 2: SNYK_TOKEN als GitHub Secret referenziert
- [ ] ⬜ Aufgabe 2: Dependency-Scanning vorhanden (snyk test / SCA)
- [ ] ⬜ Aufgabe 2: Statische Code-Analyse vorhanden (snyk code test / SAST)
- [ ] ⬜ Aufgabe 2: Severity-Threshold definiert (z. B. high/critical)
- [ ] ⬜ Aufgabe 5: SARIF-Report wird zu GitHub Code Scanning hochgeladen
- [ ] ⬜ Aufgabe 5: Security-Dokumentation vorhanden (SECURITY.md)
- [ ] ⬜ Aufgabe 5: SECURITY.md dokumentiert Findings und Behebung
- [ ] ⬜ Aufgabe 5: SECURITY.md hat ausreichend Inhalt (mind. 100 Wörter)

Zusaetzlich manuell abgenommen (nicht automatisch geprueft):

- DevSecOps-Konzept und Shift-Left-Ansatz erklaert
- DAST mit OWASP ZAP durchgefuehrt (optionale Zusatzaufgabe)
- Kritische Sicherheitsluecken identifiziert und behoben

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
