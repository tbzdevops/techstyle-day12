#!/bin/bash
source .github/classroom/grade.sh

echo "🔍 Prüfe Abnahmekriterien für Tag 16 — Sammelcheck (Monitoring, Security, Container)"
echo ""

check \
  "ci-workflow" \
  "Monitoring-Konfiguration vorhanden (Tag 9-10)" \
  "[ -f 'prometheus.yml' ] || [ -f 'monitoring/prometheus.yml' ] || grep -rq 'prometheus' . 2>/dev/null"

check_workflow_exists \
  "security-scan" \
  "Security-Workflow vorhanden (Tag 11)" \
  "security*.yml"

check_file_exists \
  "dockerfile" \
  "Dockerfile vorhanden (Tag 14)" \
  "Dockerfile"

check_workflow_exists \
  "ci-workflow" \
  "Container-Pipeline vorhanden (Tag 15)" \
  "container*.yml|build*.yml|docker*.yml"

summary 16
