#!/bin/bash
source .github/classroom/grade.sh

echo "🔍 Prüfe Abnahmekriterien für Tag 13 — AI in DevOps"
echo ""

check_workflow_exists \
  "ai-integration" \
  "AI-Workflow existiert (.github/workflows/*ai*.yml)" \
  "*ai*.yml"

check_file_contains \
  "ai-integration" \
  "GitHub Models API oder KI-Integration im Workflow" \
  ".github/workflows/*ai*.yml" \
  "models.inference|openai|copilot|claude|ollama|ai|llm"

check_file_exists \
  "ai-integration" \
  "AI_INTEGRATION.md Reflexionsdokument existiert" \
  "AI_INTEGRATION.md"

check \
  "ai-integration" \
  "AI_INTEGRATION.md hat ausreichend Inhalt (mind. 100 Wörter)" \
  "[ \$(wc -w < AI_INTEGRATION.md 2>/dev/null) -ge 100 ]"

check_file_contains \
  "ai-integration" \
  "Abschnitt zu Grenzen/Risiken von AI vorhanden" \
  "AI_INTEGRATION.md" \
  "grenz|risiko|limit|schwäche|sicherheit|security|prompt|inject"

summary 13
