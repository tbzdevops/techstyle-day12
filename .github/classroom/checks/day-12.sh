#!/bin/bash
source .github/classroom/grade.sh

echo "🔍 Prüfe Abnahmekriterien für Tag 12 — Skalierung & Performance"
echo ""

check_file_contains \
  "ci-workflow" \
  "Skalierungs-Dokumentation vorhanden" \
  "README.md|docs/*.md|SCALING.md" \
  "scale|load|performance|benchmark|concurrent"

check_file_contains \
  "ci-workflow" \
  "Lasttest oder Performance-Test dokumentiert" \
  "README.md|docs/*.md|tests/*.py|PERFORMANCE.md" \
  "load.test|loadtest|performance|benchmark|k6|jmeter"

check \
  "ci-workflow" \
  "Dokumentation hat ausreichend Inhalt" \
  "grep -rh . README.md docs/*.md SCALING.md PERFORMANCE.md 2>/dev/null | wc -w | grep -qE '[0-9]{3,}'"

summary 12
