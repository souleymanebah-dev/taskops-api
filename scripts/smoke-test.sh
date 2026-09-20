#!/usr/bin/env bash
set -uo pipefail

PORT="${1:?Usage: $0 <port> [version-attendue]}"
VERSION_ATTENDUE="${2:-}"
BASE="http://localhost:${PORT}"
DELAI_MAX=60
ATTENTE=2

echo "▶ Smoke test sur ${BASE}"

echo -n " 1/4 Attente du demarrage "
ecoule=0
while [ "$ecoule" -lt "$DELAI_MAX" ]; do
    if curl -sf "${BASE}/actuator/health" > /dev/null 2>&1; then
        echo "→ OK (${ecoule}s)"
        break
    fi
    echo -n "."
    sleep "$ATTENTE"
    ecoule=$((ecoule + ATTENTE))
done
if [ "$ecoule" -ge "$DELAI_MAX" ]; then
    echo " → ÉCHEC : pas de reponse apres ${DELAI_MAX}s"
    exit 1
fi

echo -n " 2/4 Etat de sante "
STATUT=$(curl -sf "${BASE}/actuator/health" | grep -o '"status":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ "$STATUT" != "UP" ]; then
    echo "→ ÉCHEC : statut = ${STATUT:-inconnu}"
    exit 1
fi
echo "→ UP"

if [ -n "$VERSION_ATTENDUE" ]; then
    echo -n " 3/4 Version "
    VERSION=$(curl -sf "${BASE}/actuator/info" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ "$VERSION" != "$VERSION_ATTENDUE" ]; then
        echo "→ ÉCHEC : ${VERSION} deployee, ${VERSION_ATTENDUE} attendue"
        exit 1
    fi
    echo "→ ${VERSION}"
else
    echo " 3/4 Version → (non verifiee)"
fi

echo -n " 4/4 Endpoint metier "
CODE=$(curl -s -o /dev/null -w '%{http_code}' "${BASE}/api/tasks")
if [ "$CODE" != "200" ]; then
    echo "→ ÉCHEC : GET /api/tasks a renvoye ${CODE}"
    exit 1
fi
echo "→ 200"

echo "✅ Smoke test reussi"
exit 0
