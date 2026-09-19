#!/bin/bash
# PROJEKT Tag 12 — AI in DevOps (zwei Lektionen): AI-Review-Bot für TechStyle.
# Nicht zu verwechseln mit dem gleichnamigen Praxis-Check im Repository
# praxis-day12.
source .github/classroom/grade.sh

WF=.github/workflows
DOKU=AI_INTEGRATION.md
MODEL_CALL='models\.github\.ai|models\.inference|openai|anthropic|ollama|gpt-|claude'

# PyYAML wird für den Script-Injection-Check gebraucht. Auf ubuntu-latest ist
# es vorhanden; lokal ggf. nicht.
python3 -c "import yaml" 2>/dev/null \
  || python3 -m pip install --quiet --disable-pip-version-check pyyaml >/dev/null 2>&1

# Die AI-Workflows (*ai*.yml / *ai*.yaml), die auf Pull Requests reagieren.
ai_pr_wf() {
  ls $WF/*ai*.yml $WF/*ai*.yaml 2>/dev/null | xargs -r grep -lE 'pull_request' 2>/dev/null
}
# Zeilen der AI-PR-Workflows ohne reine Kommentarzeilen — TODO-Kommentare aus
# dem Gerüst sollen kein Kriterium erfüllen.
ai_pr_code() {
  local files
  files="$(ai_pr_wf)"
  [ -n "$files" ] || return 1
  # shellcheck disable=SC2086
  grep -hvE '^[[:space:]]*#' $files
}

# Kein Wert aus Step-Outputs oder PR-Texten direkt in run:/script: — sonst kann
# ein präparierter PR Shell- bzw. JS-Code im Runner ausführen.
no_script_injection() {
  local files
  files="$(ai_pr_wf)"
  [ -n "$files" ] || return 1
  # shellcheck disable=SC2086
  python3 - $files <<'PY'
import re, sys
import yaml

BAD = re.compile(r"\$\{\{[^}]*(steps\.[^}]*outputs|github\.event\.(pull_request|issue|comment|head_commit|commits)[^}]*(title|body|message|ref|label)|github\.head_ref)[^}]*\}\}")
for path in sys.argv[1:]:
    try:
        d = yaml.safe_load(open(path, encoding="utf-8"))
    except Exception:
        sys.exit(1)
    jobs = (d or {}).get("jobs") or {}
    for job in jobs.values():
        for step in (job or {}).get("steps") or []:
            scripts = [step.get("run") or "", ((step.get("with") or {}).get("script")) or ""]
            if any(BAD.search(str(s)) for s in scripts):
                sys.exit(1)
PY
}

solution_for_id() {
  case "$1" in
    spec)
      echo "Lege specs/ai-review.md an (Vorlage in der Tagesplanung, Schritt 1)." ;;
    spec-content)
      echo "Die Spec braucht die Überschriften Ziel, Anforderungen, Akzeptanzkriterien und Out of Scope." ;;
    ai-workflow)
      echo "Lege $WF/ai-review.yml an. Der Dateiname muss 'ai' enthalten, und der Workflow muss auf pull_request reagieren." ;;
    ai-api)
      echo "Rufe im Workflow ein AI-Modell auf, z. B. https://models.github.ai/inference/chat/completions mit model openai/gpt-4o-mini." ;;
    ai-py)
      echo "TODO 1: Schicke nur den Diff der Python-Dateien an die AI, z. B. git diff ... -- '*.py'." ;;
    ai-fallback)
      echo "TODO 2: Schlägt der API-Aufruf fehl, soll der Workflow trotzdem kommentieren — z. B. 'if curl ...; then ... else echo \"AI-Review nicht verfügbar\" > review.md; fi' oder '|| echo ...'." ;;
    ai-disclaimer)
      echo "TODO 3: Ergänze im PR-Kommentar den Hinweis, dass der Review AI-generiert und kein Ersatz für menschliches Code Review ist (die Worte 'kein Ersatz' müssen vorkommen)." ;;
    ai-permissions)
      echo "Setze im Workflow einen permissions-Block mit 'pull-requests: write' und 'models: read' — und kein 'write-all'." ;;
    ai-injection)
      echo "Setze keine Step-Outputs (\${{ steps.X.outputs.Y }}) oder PR-Texte (Titel, Body, Branch-Name) direkt in run:/script: ein. Übergib sie über env: oder eine Datei." ;;
    adr)
      echo "Lege docs/adr/0001-ai-review-in-der-pipeline.md an (Vorlage in der Tagesplanung, Schritt 4)." ;;
    adr-content)
      echo "Der ADR braucht die Abschnitte Status, Kontext, Entscheidung und Konsequenzen." ;;
    reflexion)
      echo "Lege $DOKU mit mindestens 150 Wörtern an (Abschnitte siehe Tagesplanung, Schritt 5)." ;;
    reflexion-grenzen)
      echo "Ergänze in $DOKU eine Überschrift 'Grenzen und Schwächen' und beschreibe, was der Bot übersehen hat." ;;
    reflexion-security)
      echo "Ergänze in $DOKU eine Überschrift 'Security-Betrachtung' mit dem Ergebnis eures Prompt-Injection-Tests." ;;
    *) echo "Überprüfe die Aufgabenstellung im README" ;;
  esac
}

echo "🔍 Prüfe Abnahmekriterien für Tag 12 — AI in DevOps"
echo ""
echo "── Schritt 1: Spec ──"

check "spec" \
  "Spec für den AI-Review-Bot vorhanden (specs/*.md)" \
  "ls specs/*.md 2>/dev/null | grep -q ."

check "spec-content" \
  "Spec nennt Ziel, Anforderungen, Akzeptanzkriterien und Out of Scope" \
  "grep -qiE '^#+[[:space:]]*ziel' specs/*.md && grep -qiE '^#+[[:space:]]*anforderung' specs/*.md && grep -qiE '^#+[[:space:]]*akzeptanzkriterien' specs/*.md && grep -qiE '^#+[[:space:]]*out.of.scope' specs/*.md"

echo ""
echo "── Schritt 2: AI-Review-Workflow ──"

check "ai-workflow" \
  "AI-Workflow reagiert auf Pull Requests (.github/workflows/*ai*.yml)" \
  "ai_pr_wf | grep -q ."

check "ai-api" \
  "AI-Modell wird im Workflow aufgerufen (z. B. GitHub Models)" \
  "ai_pr_code | grep -qiE '$MODEL_CALL'"

check "ai-py" \
  "Nur der Diff der Python-Dateien geht an die AI (TODO 1)" \
  "ai_pr_code | grep -E 'diff' | grep -qE '\\.py'"

check "ai-fallback" \
  "Fallback, wenn die AI-API nicht antwortet (TODO 2)" \
  "ai_pr_code | grep -qE '\\|\\||continue-on-error|(^|[[:space:];])if[[:space:]]'"

check "ai-disclaimer" \
  "PR-Kommentar weist auf AI-Generierung hin — kein Ersatz für menschliches Review (TODO 3)" \
  "ai_pr_code | grep -qi 'kein Ersatz'"

echo ""
echo "── Schritt 3: Absicherung ──"

check "ai-permissions" \
  "Workflow-Berechtigungen minimal (pull-requests: write, models: read, kein write-all)" \
  "ai_pr_code | grep -qE 'pull-requests:[[:space:]]*write' && ai_pr_code | grep -qE 'models:[[:space:]]*read' && ! ai_pr_code | grep -qE 'write-all'"

check "ai-injection" \
  "Keine Step-Outputs oder PR-Texte direkt in run:/script: (Script Injection)" \
  "no_script_injection"

echo ""
echo "── Schritt 4: ADR ──"

check "adr" \
  "Architecture Decision Record vorhanden (docs/adr/*.md)" \
  "ls docs/adr/*.md 2>/dev/null | grep -q ."

check "adr-content" \
  "ADR nennt Status, Kontext, Entscheidung und Konsequenzen" \
  "grep -qiE '^#+[[:space:]]*status' docs/adr/*.md && grep -qiE '^#+[[:space:]]*kontext' docs/adr/*.md && grep -qiE '^#+[[:space:]]*entscheidung' docs/adr/*.md && grep -qiE '^#+[[:space:]]*konsequenz' docs/adr/*.md"

echo ""
echo "── Schritt 5: Reflexion ──"

check "reflexion" \
  "AI_INTEGRATION.md mit Reflexion vorhanden (mind. 150 Wörter)" \
  "[ \$(wc -w < $DOKU 2>/dev/null || echo 0) -ge 150 ]"

check "reflexion-grenzen" \
  "AI_INTEGRATION.md: Abschnitt Grenzen und Schwächen" \
  "grep -qiE '^#+.*(grenze|schwäche|schwaeche|limit)' $DOKU"

check "reflexion-security" \
  "AI_INTEGRATION.md: Security-Betrachtung mit Prompt-Injection-Test" \
  "grep -qiE '^#+.*(security|sicherheit)' $DOKU && grep -qiE 'prompt.?injection' $DOKU"

summary 12
