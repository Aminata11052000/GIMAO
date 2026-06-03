"""
Migration de données initiales — GIMAO
======================================
Convertit create_initial_data.py en migration Django versionnée.

Ce fichier est exécuté automatiquement par `python manage.py migrate`
sur tout nouvel environnement, sans intervention manuelle.

Données créées :
- Rôles par défaut (Responsable GMAO, Technicien, Magasinier, Opérateur)
- Types de plans de maintenance
- Types de documents
- Modules, permissions et leurs relations (lues depuis perms_data.py)
- Utilisateur responsable par défaut
"""

from django.db import migrations


def create_initial_data(apps, schema_editor):
    """
    Peuple la base de données avec les données initiales nécessaires
    au fonctionnement de GIMAO.

    On utilise apps.get_model() (recommandé par Django) au lieu d'importer
    les modèles directement : cela garantit que la migration fonctionne même
    si les modèles évoluent dans le futur.

    On utilise get_or_create() partout pour rendre la migration idempotente
    (re-exécutable sans créer de doublons).
    """
    # Récupération des modèles via l'historique de migration (bonne pratique Django)
    Role                = apps.get_model('utilisateur', 'Role')
    Permission          = apps.get_model('utilisateur', 'Permission')
    Module              = apps.get_model('utilisateur', 'Module')
    RolePermission      = apps.get_model('utilisateur', 'RolePermission')
    Utilisateur         = apps.get_model('utilisateur', 'Utilisateur')
    TypePlanMaintenance = apps.get_model('maintenance', 'TypePlanMaintenance')
    TypeDocument        = apps.get_model('donnees', 'TypeDocument')

    # Import des données de référence (source de vérité unique pour les permissions)
    from tasks import perms_data

    # ── 1. Rôles ─────────────────────────────────────────────────────────────
    for role_name in perms_data.perms_map.keys():
        Role.objects.get_or_create(nomRole=role_name)

    # ── 2. Types de plans de maintenance ─────────────────────────────────────
    for libelle in ['Préventive systématique', 'Préventive conditionnelle', 'Corrective']:
        TypePlanMaintenance.objects.get_or_create(libelle=libelle)

    # ── 3. Types de documents ────────────────────────────────────────────────
    types_document = [
        "Manuel d'utilisation",
        "Manuel de maintenance",
        "Notice technique",
        "Schéma technique",
        "Contrat de maintenance",
        "Garantie",
        "Procédure de maintenance",
        "Consigne de sécurité",
        "Rapport d'intervention",
        "Rapport de contrôle",
        "Certificat de conformité",
        "Devis / Facture",
    ]
    for nom in types_document:
        TypeDocument.objects.get_or_create(nomTypeDocument=nom)

    # ── 4. Modules ────────────────────────────────────────────────────────────
    modules_data = {
        'di':     "Demandes d'intervention",
        'bt':     'Bons de travail',
        'eq':     'Équipements',
        'cp':     'Compteurs',
        'mp':     'Maintenances préventives',
        'stock':  'Stocks',
        'cons':   'Consommables',
        'mag':    'Magasins',
        'user':   'Utilisateurs',
        'role':   'Rôles',
        'loc':    'Lieux',
        'sup':    'Fournisseurs',
        'man':    'Fabricants',
        'eqmod':  "Modèles d'équipement",
        'export': 'Export',
        'menu':   'Menu',
        'dash':   'Dashboard',
    }
    modules = {}
    for code, nom in modules_data.items():
        module, _ = Module.objects.get_or_create(code=code, defaults={'nom': nom})
        modules[code] = module

    # ── 5. Permissions — premier passage (sans parents) ───────────────────────
    # On crée d'abord toutes les permissions sans leur parent,
    # car certains parents n'existent pas encore au moment du premier passage.
    for perm_name, (description, perm_type, _parent) in perms_data.perms.items():
        module_code = perm_name.split(':')[0]
        module = modules.get(module_code)

        perm, _created = Permission.objects.get_or_create(nomPermission=perm_name)

        changed = False
        if perm.description != description:
            perm.description = description
            changed = True
        if perm.type != perm_type:
            perm.type = perm_type
            changed = True
        if module and perm.module != module:
            perm.module = module
            changed = True
        if changed:
            perm.save()

    # ── 6. Permissions — deuxième passage (assignation des parents) ───────────
    # Toutes les permissions existent maintenant, on peut assigner les parents.
    for perm_name, (_desc, _type, parent_name) in perms_data.perms.items():
        perm = Permission.objects.get(nomPermission=perm_name)
        if parent_name:
            parent = Permission.objects.get(nomPermission=parent_name)
            if perm.parent != parent:
                perm.parent = parent
                perm.save()
        elif perm.parent is not None:
            perm.parent = None
            perm.save()

    # ── 7. Assignation des permissions aux rôles ──────────────────────────────
    for role_name, perm_list in perms_data.perms_map.items():
        role, _ = Role.objects.get_or_create(nomRole=role_name)
        for perm_name in perm_list:
            try:
                perm = Permission.objects.get(nomPermission=perm_name)
                RolePermission.objects.get_or_create(role=role, permission=perm)
            except Permission.DoesNotExist:
                pass

    # ── 8. Utilisateur responsable par défaut ─────────────────────────────────
    Utilisateur.objects.get_or_create(
        nomUtilisateur="responsable",
        defaults={"role": Role.objects.get(nomRole="Responsable GMAO")}
    )


def remove_initial_data(apps, schema_editor):
    """
    Migration inverse — supprime les données initiales.
    Appelée uniquement si on annule cette migration (python manage.py migrate tasks zero).
    """
    Role                = apps.get_model('utilisateur', 'Role')
    Module              = apps.get_model('utilisateur', 'Module')
    Utilisateur         = apps.get_model('utilisateur', 'Utilisateur')
    TypePlanMaintenance = apps.get_model('maintenance', 'TypePlanMaintenance')
    TypeDocument        = apps.get_model('donnees', 'TypeDocument')

    Utilisateur.objects.filter(nomUtilisateur="responsable").delete()
    Role.objects.filter(nomRole__in=[
        'Responsable GMAO', 'Technicien', 'Magasinier', 'Opérateur'
    ]).delete()
    TypePlanMaintenance.objects.filter(libelle__in=[
        'Préventive systématique', 'Préventive conditionnelle', 'Corrective'
    ]).delete()
    TypeDocument.objects.all().delete()
    Module.objects.all().delete()


class Migration(migrations.Migration):

    dependencies = [
        # On attend que tous les modèles utilisés soient bien créés en base
        ('utilisateur', '0009_role_est_defaut'),
        ('maintenance', '0004_bontravail_duree_previsionnelle_and_more'),
        ('donnees',     '0001_initial'),
    ]

    operations = [
        migrations.RunPython(
            create_initial_data,   # Fonction appelée lors de `migrate`
            remove_initial_data,   # Fonction appelée lors du retour en arrière
        ),
    ]
