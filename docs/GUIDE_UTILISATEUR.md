# Guide utilisateur — GIMAO

Ce guide décrit les fonctionnalités disponibles pour chaque rôle de l'application GIMAO.

---

## Sommaire

- [Connexion](#connexion)
- [Opérateur prod](#operateur-prod)
- [Technicien prod](#technicien-prod)
- [Technicien maintenance](#technicien-maintenance)
- [Magasinier](#magasinier)
- [Responsable GMAO](#responsable-gmao)

---

## Connexion

### Première connexion

Lors de votre première connexion, votre compte ne possède pas encore de mot de passe.

1. Saisir votre nom d'utilisateur et cliquer sur **Connexion**.
2. L'application vous invite à définir un mot de passe.
3. Saisir et confirmer votre nouveau mot de passe, puis valider.
4. Vous êtes connecté et redirigé vers votre tableau de bord.

### Connexions suivantes

1. Saisir votre nom d'utilisateur et votre mot de passe.
2. Cliquer sur **Connexion**.

### Changer son mot de passe

Depuis le menu en haut à droite, accéder à votre profil puis cliquer sur **Changer le mot de passe**.

---

## Opérateur prod

Le rôle Opérateur prod permet de signaler des anomalies sur les équipements et de suivre l'avancement des demandes créées.

### Tableau de bord

A l'ouverture, le tableau de bord affiche :
- vos demandes d'intervention en cours,
- la liste des équipements disponibles,
- des statistiques sur vos demandes.

### Créer une demande d'intervention

1. Dans le menu, cliquer sur **Demandes d'intervention**.
2. Cliquer sur **Nouvelle demande**.
3. Renseigner les champs :
   - **Nom** : titre court décrivant l'anomalie.
   - **Équipement** : sélectionner l'équipement concerné.
   - **Statut supposé** : indiquer l'état perçu de l'équipement (dégradé, à l'arrêt, hors service).
   - **Commentaire** : décrire l'anomalie en détail.
   - **Documents** (optionnel) : joindre une photo ou un fichier.
4. Cliquer sur **Enregistrer**.

La demande est créée avec le statut **En attente**.

### Suivre ses demandes d'intervention

1. Aller dans **Demandes d'intervention**.
2. La liste affiche toutes vos demandes avec leur statut actuel.

Les statuts possibles sont :

| Statut | Signification |
|--------|--------------|
| En attente | La demande est soumise, en attente de traitement par le responsable |
| Acceptée | Le responsable a pris en charge la demande |
| Refusée | Le responsable a refusé la demande (motif visible dans le détail) |
| Transformée | Un bon de travail a été créé à partir de cette demande |

### Modifier une demande

Une demande peut être modifiée uniquement si elle est encore **En attente** et si vous en êtes l'auteur.

1. Ouvrir la demande concernée.
2. Cliquer sur **Modifier**.
3. Apporter les modifications et enregistrer.

### Consulter les équipements

1. Aller dans **Équipements**.
2. Cliquer sur un équipement pour voir ses informations : localisation, modèle, statut actuel, documents associés.

---

## Technicien prod

Le rôle Technicien prod permet de consulter et traiter les bons de travail assignés, et de déclarer des interventions.

### Tableau de bord

Le tableau de bord affiche :
- les bons de travail qui vous sont assignés,
- la liste des équipements,
- des statistiques sur vos interventions.

### Consulter ses bons de travail

1. Aller dans **Bons de travail**.
2. La liste affiche tous les BT, avec un filtre possible par statut ou par équipement.
3. Cliquer sur un BT pour voir son détail : équipement concerné, diagnostic, consommables requis, documents.

### Démarrer un bon de travail

Lorsqu'une intervention commence physiquement :

1. Ouvrir le bon de travail concerné.
2. Cliquer sur **Démarrer**.
3. Le statut passe à **En cours** et la date de début est enregistrée automatiquement.

### Renseigner un bon de travail en cours

Pendant l'intervention :

1. Ouvrir le BT en cours.
2. Cliquer sur **Modifier**.
3. Renseigner ou mettre à jour :
   - **Diagnostic** : description technique du problème constaté.
   - **Consommables utilisés** : sélectionner les pièces ou fournitures consommées et indiquer les quantités.
   - **Documents** : joindre des photos ou comptes rendus.
4. Enregistrer.

### Clôturer un bon de travail

Lorsque l'intervention est terminée :

1. Ouvrir le bon de travail.
2. Vérifier que le diagnostic et les consommables sont renseignés.
3. Cliquer sur **Clôturer**.
4. Le statut passe à **Terminé** et la date de fin est enregistrée. Le responsable est notifié pour validation.

> Si le responsable refuse la clôture, un commentaire de refus est visible dans le détail du BT. Corriger les informations demandées et soumettre à nouveau.

### Consulter les équipements

1. Aller dans **Équipements**.
2. Consulter les informations d'un équipement : statut, compteurs de maintenance, plans de maintenance, historique des états, KPI.
3. Il est possible de modifier les informations d'un équipement et d'y attacher des documents.

### Consulter les compteurs de maintenance

1. Depuis le détail d'un équipement, accéder à l'onglet **Compteurs**.
2. Les compteurs affichent la valeur courante et la prochaine échéance de maintenance.
3. Il est possible de mettre à jour la valeur d'un compteur après une intervention.

### Déclarer une demande d'intervention

Un technicien peut également créer une DI s'il constate une anomalie pendant sa tournée, selon la même procédure que l'opérateur.

---

## Technicien maintenance

Le rôle Technicien maintenance dispose des mêmes actions que le [Technicien prod](#technicien-prod) (consultation et traitement des bons de travail assignés, déclaration d'interventions, consultation des équipements et des compteurs), avec deux capacités supplémentaires :

### Accéder au calendrier des maintenances

1. Aller dans **Calendrier**.
2. Le calendrier affiche les interventions planifiées (BT avec date prévue) et les prochaines échéances de maintenance préventive.

### Créer et modifier des plans de maintenance préventive

1. Aller dans **Équipements** et ouvrir un équipement.
2. Accéder à l'onglet **Plans de maintenance**.
3. Créer un plan en renseignant le nom, le type, les habilitations requises, les consommables nécessaires et les documents associés.
4. Ajouter des compteurs de déclenchement (compteur numérique ou calendaire) avec leur seuil et leur périodicité.

---

## Magasinier

Le rôle Magasinier permet de gérer les stocks de consommables, les magasins, et de valider les demandes de consommables sur les bons de travail.

### Tableau de bord

Le tableau de bord affiche un résumé des niveaux de stock par magasin.

### Gérer les consommables

#### Créer un consommable

1. Aller dans **Stocks > Consommables**.
2. Cliquer sur **Nouveau consommable**.
3. Renseigner la désignation, le seuil de stock faible, et éventuellement une image.
4. Enregistrer.

#### Modifier ou supprimer un consommable

1. Ouvrir le consommable concerné.
2. Cliquer sur **Modifier** ou **Supprimer**.

### Gérer les magasins

#### Créer un magasin

1. Aller dans **Stocks > Magasins**.
2. Cliquer sur **Nouveau magasin**.
3. Renseigner le nom, indiquer s'il est mobile, et éventuellement l'adresse.
4. Enregistrer.

### Enregistrer un achat

Lorsqu'une livraison de consommables est reçue :

1. Aller dans **Stocks > Consommables** et ouvrir le consommable concerné.
2. Cliquer sur **Enregistrer un achat**.
3. Renseigner :
   - la date,
   - la quantité achetée,
   - le prix unitaire,
   - le fournisseur et le fabricant.
4. À l'étape suivante, distribuer la quantité achetée entre les différents magasins.
5. Confirmer l'achat. Les stocks des magasins sont mis à jour automatiquement.

### Transférer du stock entre magasins

1. Depuis le détail d'un consommable, cliquer sur **Transférer du stock**.
2. Sélectionner le magasin source, le magasin destination et la quantité.
3. Confirmer.

### Valider une demande de consommable sur un BT

Lorsqu'un technicien a déclaré des consommables sur un bon de travail, le magasinier doit confirmer la remise physique des pièces :

1. Aller dans **Bons de travail**.
2. Ouvrir le BT concerné et accéder à l'onglet **Consommables**.
3. Pour chaque consommable à remettre, cliquer sur **Valider la remise**.
4. Le stock du magasin concerné est décrémenté automatiquement.

### Surveiller les alertes de stock

Les consommables dont le stock est inférieur au seuil défini apparaissent en alerte dans la liste des consommables. Enregistrer un achat pour réapprovisionner.

---

## Responsable GMAO

Le rôle Responsable GMAO dispose de l'ensemble des droits sur l'application : traitement des demandes, gestion des interventions, des équipements, des utilisateurs et des données de référence.

### Tableau de bord

Le tableau de bord affiche une vue globale :
- toutes les demandes d'intervention en cours,
- tous les bons de travail et leur statut,
- les équipements et les alertes de stock,
- des statistiques complètes de maintenance.

### Traiter une demande d'intervention

1. Aller dans **Demandes d'intervention**.
2. Ouvrir une demande **En attente**.
3. Examiner la description et les documents joints.
4. Choisir l'action :
   - **Accepter** : la demande est prise en charge.
   - **Refuser** : saisir un motif de refus.
   - **Transformer en bon de travail** : crée directement un BT à partir de la demande (renseigner le diagnostic initial et mettre à jour le statut de l'équipement si nécessaire).

### Créer et gérer les bons de travail

#### Créer un bon de travail manuellement

1. Aller dans **Bons de travail**.
2. Cliquer sur **Nouveau bon de travail**.
3. Renseigner le nom, le type (correctif ou préventif), la date prévue, la durée prévisionnelle, le diagnostic initial et la demande d'intervention associée.
4. Enregistrer.

#### Assigner des techniciens

1. Ouvrir le bon de travail.
2. Dans la section **Techniciens assignés**, sélectionner un ou plusieurs techniciens.
3. Enregistrer. Les techniciens concernés voient le BT apparaître dans leur liste.

#### Valider ou refuser la clôture d'un BT

Lorsqu'un technicien soumet un BT pour clôture (statut **Terminé**) :

1. Ouvrir le BT.
2. Vérifier le diagnostic, les consommables et les documents.
3. Choisir :
   - **Accepter la clôture** : le BT passe au statut **Clôturé**.
   - **Refuser la clôture** : saisir un commentaire indiquant ce qui doit être complété. Le BT repasse **En cours**.

### Gérer les équipements

#### Créer un équipement

1. Aller dans **Équipements**.
2. Cliquer sur **Nouvel équipement**.
3. Renseigner : désignation, numéro de série, référence, lieu, modèle, fabricant, fournisseur, date de mise en service, prix d'achat.
4. Enregistrer.

#### Archiver un équipement

L'archivage d'un équipement clôture automatiquement toutes ses DI et BT en cours.

1. Ouvrir l'équipement.
2. Cliquer sur **Archiver**.

#### Consulter les indicateurs de performance (KPI)

Depuis le détail d'un équipement, l'onglet **KPI** affiche :
- le nombre de pannes,
- le MTBF (temps moyen entre pannes),
- le MTTR (temps moyen de réparation).

#### Consulter l'historique des états

Depuis le détail d'un équipement, l'onglet **Historique des états** affiche un diagramme de Gantt représentant les périodes de fonctionnement, de dégradation, d'arrêt et hors service.

### Gérer les plans de maintenance préventive

1. Aller dans **Équipements** et ouvrir un équipement.
2. Accéder à l'onglet **Plans de maintenance**.
3. Créer un plan en renseignant le nom, le type, les habilitations requises, les consommables nécessaires et les documents associés.
4. Ajouter des compteurs de déclenchement (compteur numérique ou calendaire) avec leur seuil et leur périodicité.

### Consulter le calendrier des maintenances

1. Aller dans **Calendrier**.
2. Le calendrier affiche toutes les interventions planifiées (BT avec date prévue) et les prochaines échéances de maintenance préventive.
3. Il est possible de filtrer par période ou par technicien.

### Gérer les utilisateurs

#### Créer un utilisateur

1. Aller dans **Utilisateurs**.
2. Cliquer sur **Nouvel utilisateur**.
3. Renseigner le nom, le prénom, l'email, le nom d'utilisateur et le rôle.
4. Enregistrer. L'utilisateur définira son mot de passe à sa première connexion.

#### Modifier les permissions d'un utilisateur

Les permissions peuvent être personnalisées utilisateur par utilisateur, indépendamment du rôle :

1. Ouvrir le profil de l'utilisateur.
2. Aller dans l'onglet **Permissions**.
3. Cocher ou décocher les permissions souhaitées.
4. Enregistrer. Ces permissions personnalisées prennent le dessus sur celles du rôle.

Pour revenir aux permissions du rôle, cliquer sur **Réinitialiser les permissions**.

#### Désactiver un utilisateur

1. Ouvrir le profil de l'utilisateur.
2. Cliquer sur **Désactiver le compte**. L'utilisateur ne peut plus se connecter mais ses données sont conservées.

### Gérer les données de référence

Dans le menu **Gestion des données**, il est possible de gérer :
- les **lieux** (hiérarchie site / bâtiment / salle),
- les **fabricants** et **fournisseurs**,
- les **modèles d'équipement**,
- les **types de documents**,
- les **rôles** et leurs permissions.

#### Créer un rôle

1. Aller dans **Gestion des données > Rôles**.
2. Cliquer sur **Nouveau rôle**.
3. Nommer le rôle et sélectionner les permissions associées.
4. Il est possible de **dupliquer** un rôle existant pour partir d'un modèle.

### Exporter les données

Depuis le menu **Exports**, il est possible d'exporter au format Excel :
- les équipements, statuts, compteurs, seuils,
- les demandes d'intervention et bons de travail,
- les consommables, stocks, magasins, historiques d'achats,
- les utilisateurs, fournisseurs, fabricants, lieux.
