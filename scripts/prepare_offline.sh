#!/bin/bash
# ============================================================
# SCRIPT PROFESSEUR — À lancer UNE SEULE FOIS sur une machine
# connectée à Internet pour préparer les images Docker.
#
# Résultat : dossier images/ contenant 4 fichiers .tar
# À copier sur une clé USB ou un partage réseau.
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
IMAGES_DIR="$ROOT_DIR/images"

cd "$ROOT_DIR"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║     PRÉPARATION IMAGES GIMAO (offline)   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

mkdir -p "$IMAGES_DIR"

# ── Création du .env.prod minimal pour le build ──────────────
if [ ! -f .env.prod ]; then
    echo "Création du fichier .env.prod temporaire..."
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
fi

# ── Build des images backend et nginx ────────────────────────
echo "[1/4] Build de l'image backend..."
docker compose -f docker-compose.prod.yml build backend

echo "[2/4] Build de l'image nginx..."
docker compose -f docker-compose.prod.yml build nginx

# ── Pull des images externes ──────────────────────────────────
echo "[3/4] Téléchargement de mariadb:10.6..."
docker pull mariadb:10.6

echo "[4/4] Téléchargement de phpmyadmin..."
docker pull phpmyadmin/phpmyadmin

# ── Export des images en fichiers .tar ───────────────────────
echo ""
echo "Exportation des images..."

docker save gimao/backend:latest   -o "$IMAGES_DIR/backend.tar"
echo "  ✔ backend.tar"

docker save gimao/nginx:latest     -o "$IMAGES_DIR/nginx.tar"
echo "  ✔ nginx.tar"

docker save mariadb:10.6           -o "$IMAGES_DIR/mariadb.tar"
echo "  ✔ mariadb.tar"

docker save phpmyadmin/phpmyadmin  -o "$IMAGES_DIR/phpmyadmin.tar"
echo "  ✔ phpmyadmin.tar"

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║              TERMINÉ                     ║"
echo "║  Copier le dossier images/ sur les       ║"
echo "║  machines étudiants (clé USB, réseau...) ║"
echo "╚══════════════════════════════════════════╝"
echo ""
