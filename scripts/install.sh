#!/bin/bash
# ============================================================
# SCRIPT ÉTUDIANT — Installation GIMAO sans compte Docker
#
# Pré-requis :
#   - Docker Desktop lancé
#   - Git installé
#   - Le dossier images/ présent à la racine du projet
#     (fourni par le professeur sur clé USB ou réseau)
#
# Usage (Git Bash) :
#   bash scripts/install.sh
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_DIR="$ROOT_DIR/images"

cd "$ROOT_DIR"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        INSTALLATION GIMAO — TP           ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# ── Vérification Docker ───────────────────────────────────────
if ! docker info > /dev/null 2>&1; then
    echo "ERREUR : Docker Desktop n'est pas lancé."
    echo "Lance Docker Desktop, attends que l'icône baleine soit stable,"
    echo "puis relance ce script."
    exit 1
fi

# ── Vérification du dossier images/ ──────────────────────────
REQUIRED_IMAGES=("backend.tar" "nginx.tar" "mariadb.tar" "phpmyadmin.tar")
for img in "${REQUIRED_IMAGES[@]}"; do
    if [ ! -f "$IMAGES_DIR/$img" ]; then
        echo "ERREUR : fichier images/$img introuvable."
        echo "Assure-toi d'avoir copié le dossier images/ fourni par le professeur."
        exit 1
    fi
done

# ── Chargement des images ─────────────────────────────────────
echo "[1/5] Chargement des images Docker..."
for img in "${REQUIRED_IMAGES[@]}"; do
    echo "  Chargement de $img..."
    docker load -i "$IMAGES_DIR/$img"
done
echo "  ✔ Images chargées"

# ── Création du fichier .env.prod ────────────────────────────
echo ""
echo "[2/5] Création du fichier de configuration..."
cat > .env.prod << 'EOF'
MYSQL_ROOT_PASSWORD=rootpass123
MYSQL_DATABASE=gimao
MYSQL_USER=gimao_user
MYSQL_PASSWORD=gimao_pass123
SECRET_KEY=django-insecure-tp-gimao-2026-xK8mP3qL9nR7vW2jH5tY1uA4sD6fG0cE
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=Admin1234!
DJANGO_SUPERUSER_EMAIL=admin@gimao.fr
EOF
cp .env.prod .env
echo "  ✔ .env.prod créé"

# ── Démarrage des conteneurs ──────────────────────────────────
echo ""
echo "[3/5] Démarrage de l'application..."
docker compose -f docker-compose.prod.yml up -d
echo "  ✔ Conteneurs démarrés"

# ── Migrations ────────────────────────────────────────────────
echo ""
echo "[4/5] Initialisation de la base de données..."
docker compose -f docker-compose.prod.yml exec backend python manage.py migrate tasks --fake
docker compose -f docker-compose.prod.yml exec backend python manage.py migrate
docker compose -f docker-compose.prod.yml exec backend python manage.py init_data
echo "  ✔ Base de données initialisée"

# ── Seed ──────────────────────────────────────────────────────
echo ""
echo "[5/5] Chargement des données de démonstration..."
docker compose -f docker-compose.prod.yml exec backend python manage.py seed_tp_data
echo "  ✔ Données chargées"

# ── Résumé ────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║        INSTALLATION TERMINÉE !           ║"
echo "║                                          ║"
echo "║  Ouvre ton navigateur sur :              ║"
echo "║  http://localhost                        ║"
echo "╚══════════════════════════════════════════╝"
echo ""
