# Guide de contribution

Merci de l'intérêt que vous portez au projet GIMAO. Ce document décrit les conventions et le processus à suivre pour contribuer.

---

## Sommaire

- [Prérequis](#prérequis)
- [Mettre en place l'environnement de développement](#mettre-en-place-lenvironnement-de-développement)
- [Workflow Git](#workflow-git)
- [Conventions de nommage des branches](#conventions-de-nommage-des-branches)
- [Conventions de commit](#conventions-de-commit)
- [Lancer les tests](#lancer-les-tests)
- [Soumettre une Pull Request](#soumettre-une-pull-request)
- [Signaler un bug](#signaler-un-bug)

---

## Prérequis

- Python 3.9+
- Node.js 18+
- Docker et Docker Compose
- Git

---

## Mettre en place l'environnement de développement

```bash
git clone <url-du-depot>
cd GIMAO
docker compose -f docker-compose.dev.yml up -d
```

L'environnement complet démarre en une commande. Voir le [README](README.md) pour le détail des services disponibles.

Pour travailler sans Docker sur le backend :

```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py init_data
python manage.py runserver
```

Pour le frontend :

```bash
cd frontend
npm install
npm run serve
```

---

## Workflow Git

1. Créer une branche depuis `main` (voir conventions ci-dessous).
2. Développer et commiter sur cette branche.
3. S'assurer que les tests passent.
4. Ouvrir une Pull Request vers `main`.
5. La branche est supprimée après merge.

Ne jamais commiter directement sur `main`.

---

## Conventions de nommage des branches

| Type | Format | Exemple |
|------|--------|---------|
| Fonctionnalité liée à un ticket | `SCRUM-<id>-<description-courte>` | `SCRUM-42-export-pdf-bt` |
| Correction de bug | `BUG-<description-courte>` | `BUG-fix-calcul-seuil` |
| Refactoring / technique | `TECH-<description-courte>` | `TECH-refactor-useApi` |

La description est en minuscules, mots séparés par des tirets, sans accents.

---

## Conventions de commit

Les messages de commit suivent le format [Conventional Commits](https://www.conventionalcommits.org/) :

```
<type>(<scope>): <description courte en français>
```

Types courants :

| Type | Usage |
|------|-------|
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `refactor` | Refactoring sans changement de comportement |
| `test` | Ajout ou modification de tests |
| `docs` | Documentation uniquement |
| `chore` | Tâche technique (dépendances, config, etc.) |

Exemples :

```
feat(maintenance): ajouter le filtrage des BT par technicien
fix(stock): corriger le calcul du stock disponible après distribution
docs(readme): mettre à jour la section déploiement
```

La description est en français, commence par un verbe à l'infinitif, sans majuscule ni point final.

---

## Lancer les tests

### Tests backend

```bash
cd backend
pytest
```

Pour voir la couverture :

```bash
pytest --cov=. --cov-report=html
```

Le rapport HTML est généré dans `backend/htmlcov/index.html`.

### Tests frontend

```bash
cd frontend
npm run test
```

Tous les tests doivent passer avant de soumettre une Pull Request.

---

## Soumettre une Pull Request

1. S'assurer que la branche est à jour avec `main` :
   ```bash
   git fetch origin
   git rebase origin/main
   ```

2. Vérifier que les tests passent.

3. Ouvrir la Pull Request avec :
   - Un titre clair décrivant le changement.
   - Une description expliquant le contexte, ce qui a changé et pourquoi.
   - Le numéro de ticket associé si applicable (ex. `SCRUM-42`).

4. Toute PR doit être relue avant d'être mergée dans `main`.

---

## Signaler un bug

Ouvrir une issue en précisant :

- La version ou le commit concerné.
- Les étapes pour reproduire le problème.
- Le comportement attendu et le comportement observé.
- Les logs ou captures d'écran si disponibles.
