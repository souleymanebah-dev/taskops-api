# Stratégie de déploiement — TaskOps API

## Artefact
- Un seul artefact par version : `taskops-api-<version>.jar`
- Produit uniquement par le workflow `release.yml`, déclenché par un tag `v*`
- **Jamais reconstruit** entre les environnements (*build once, deploy everywhere*)
- Version lisible à chaud sur `GET /actuator/info`

## Environnements

| Environnement | Déclencheur | Stratégie | Validation |
|---|---|---|---|
| Développement | manuel | recreate | aucune |
| Recette | tag `v*` | rolling | smoke test |
| Production | validation manuelle | blue/green | smoke test + surveillance 15 min |

## Configuration

Toute la configuration passe par des variables d'environnement.
Aucun secret dans le dépôt. Voir `application.properties` pour la liste
des variables et leurs valeurs par défaut de développement.

## Retour arrière

- **Blue/Green** : rebasculer le routeur vers l'environnement précédent (< 5 s)
- L'environnement précédent reste démarré **24 h** après un déploiement
- Toute migration de base doit être rétrocompatible d'au moins une version
  (patron *expand / contract*)

## Critères d'échec d'un déploiement

Le déploiement est annulé automatiquement si :
- le smoke test échoue (`/actuator/health` ≠ UP, ou `/api/tasks` ≠ 200)
- l'application ne répond pas dans les 60 secondes
