#!/usr/bin/env bash
set -euo pipefail

DEPUIS="${1:?Usage: $0 <tag-depart> <tag-arrivee>}"
JUSQUA="${2:-HEAD}"

COMMITS=$(git log --no-merges --pretty=format:'%s' "${DEPUIS}..${JUSQUA}")

section() {
    local type="$1" titre="$2"
    local lignes
    lignes=$(echo "$COMMITS" | grep -E "^${type}(\(.+\))?!?: " || true)
    if [ -n "$lignes" ]; then
        echo "### ${titre}"
        echo ""
        echo "$lignes" | sed -E "s/^${type}(\(.+\))?!?: /- /"
        echo ""
    fi
}

echo "## ${JUSQUA} — $(date +%Y-%m-%d)"
echo ""
section "feat" "✨ Nouvelles fonctionnalités"
section "fix" "🐛 Corrections"
section "perf" "⚡ Performances"
section "refactor" "♻️ Refactorisations"
section "docs" "📚 Documentation"
section "ci" "⚙️ Intégration continue"
section "build" "📦 Build et dépendances"
