<template>
  <v-card elevation="2" class="mb-4">
    <v-card-title class="text-h6">
      <v-icon class="mr-2">mdi-chart-timeline</v-icon>
      Historique des états
    </v-card-title>
    <v-divider></v-divider>

    <v-card-text>
      <!-- Chargement -->
      <v-row v-if="loading" justify="center" class="py-4">
        <v-progress-circular indeterminate color="primary" />
      </v-row>

      <!-- Erreur -->
      <v-alert v-else-if="erreur" type="error" variant="tonal">
        Impossible de charger l'historique des états.
      </v-alert>

      <!-- Aucun historique -->
      <p v-else-if="!plages.length" class="text-caption text-grey text-center py-4">
        Aucun historique d'état disponible pour cet équipement.
      </p>

      <template v-else>
        <!-- Filtre par période (Option B) -->
        <v-row dense class="mb-3" align="center">
          <v-col cols="12" sm="5">
            <v-text-field
              v-model="filtreDebut"
              type="date"
              label="Du"
              density="compact"
              variant="outlined"
              hide-details
              clearable
              :max="filtreFin || undefined"
            />
          </v-col>
          <v-col cols="12" sm="5">
            <v-text-field
              v-model="filtreFin"
              type="date"
              label="Au"
              density="compact"
              variant="outlined"
              hide-details
              clearable
              :min="filtreDebut || undefined"
            />
          </v-col>
          <v-col cols="12" sm="2">
            <v-btn
              variant="text"
              color="primary"
              size="small"
              block
              @click="reinitialiserFiltres"
            >
              Tout voir
            </v-btn>
          </v-col>
        </v-row>

        <!-- Message si aucun résultat après filtre -->
        <p
          v-if="!series.length"
          class="text-caption text-grey text-center py-4"
        >
          Aucun état sur cette période.
        </p>

        <!-- Timeline avec zoom (Option A + B) -->
        <apexchart
          v-else
          type="rangeBar"
          height="180"
          :options="chartOptions"
          :series="series"
        />
      </template>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useApi }       from '@/composables/useApi';
import { API_BASE_URL } from '@/utils/constants';

// ── Props ────────────────────────────────────────────────────────────────────
const props = defineProps({
  equipementId: {
    type: [Number, String],
    required: true,
  },
});

// ── Constantes ───────────────────────────────────────────────────────────────
const STATUTS_CONFIG = {
  EN_FONCTIONNEMENT: { label: 'En fonctionnement', couleur: '#4CAF50' },
  DEGRADE:           { label: 'Dégradé',            couleur: '#FF9800' },
  A_LARRET:          { label: 'À l\'arrêt',         couleur: '#F44336' },
  HORS_SERVICE:      { label: 'Hors service',       couleur: '#616161' },
};

// ── État ─────────────────────────────────────────────────────────────────────
const historiqueApi = useApi(API_BASE_URL);
const loading       = ref(true);
const erreur        = ref(false);
const historique    = ref([]);

// Filtres de période (Option B)
const filtreDebut = ref(null);
const filtreFin   = ref(null);

// ── Chargement ───────────────────────────────────────────────────────────────
const fetchHistorique = async () => {
  loading.value = true;
  erreur.value  = false;
  try {
    historique.value = await historiqueApi.get(
      `equipements/${props.equipementId}/historique_statuts/`
    );
  } catch {
    erreur.value = true;
  } finally {
    loading.value = false;
  }
};

// ── Calcul des plages de temps ────────────────────────────────────────────────
const plages = computed(() => {
  if (!historique.value.length) return [];

  return historique.value.map((entry, i) => {
    const debut = new Date(entry.dateChangement).getTime();
    const fin   = i < historique.value.length - 1
      ? new Date(historique.value[i + 1].dateChangement).getTime()
      : Date.now();

    return { statut: entry.statut, debut, fin };
  });
});

// ── Plages filtrées par la période choisie (Option B) ────────────────────────
const plagesFiltrees = computed(() => {
  if (!filtreDebut.value && !filtreFin.value) return plages.value;

  const debut = filtreDebut.value ? new Date(filtreDebut.value).getTime() : null;
  // Pour le filtre de fin, on prend la fin de la journée choisie
  const fin   = filtreFin.value
    ? new Date(filtreFin.value + 'T23:59:59').getTime()
    : null;

  return plages.value.filter(p => {
    const apresDebut = !debut || p.fin   >= debut;
    const avantFin   = !fin   || p.debut <= fin;
    return apresDebut && avantFin;
  });
});

// ── Transformation en séries ApexCharts ──────────────────────────────────────
const series = computed(() => {
  const parStatut = {};

  plagesFiltrees.value.forEach(({ statut, debut, fin }) => {
    // Découper la plage aux bornes du filtre si nécessaire
    const debutFiltre = filtreDebut.value
      ? new Date(filtreDebut.value).getTime()
      : null;
    const finFiltre = filtreFin.value
      ? new Date(filtreFin.value + 'T23:59:59').getTime()
      : null;

    const debutAffiche = debutFiltre ? Math.max(debut, debutFiltre) : debut;
    const finAffiche   = finFiltre   ? Math.min(fin,   finFiltre)   : fin;

    if (!parStatut[statut]) parStatut[statut] = [];
    parStatut[statut].push({ x: 'État', y: [debutAffiche, finAffiche] });
  });

  return Object.entries(parStatut).map(([statut, data]) => ({
    name:  STATUTS_CONFIG[statut]?.label  ?? statut,
    color: STATUTS_CONFIG[statut]?.couleur ?? '#999999',
    data,
  }));
});

// ── Réinitialiser les filtres ─────────────────────────────────────────────────
const reinitialiserFiltres = () => {
  filtreDebut.value = null;
  filtreFin.value   = null;
};

// ── Options du graphique ──────────────────────────────────────────────────────
const chartOptions = computed(() => ({
  chart: {
    type:    'rangeBar',
    // Option A : zoom activé
    toolbar: {
      show: true,
      tools: {
        download:  false,
        selection: true,
        zoom:      true,
        zoomin:    true,
        zoomout:   true,
        pan:       true,
        reset:     true,
      },
    },
    zoom: {
      enabled: true,
      type:    'x',        // zoom horizontal uniquement (axe du temps)
    },
    // Défilement horizontal quand zoomé
    scrollbar: {
      enabled: true,
    },
  },
  plotOptions: {
    bar: {
      horizontal:        true,
      barHeight:         '50%',
      rangeBarGroupRows: false,
    },
  },
  xaxis: {
    type: 'datetime',
    // Bornes dynamiques selon le filtre (Option B)
    min: filtreDebut.value ? new Date(filtreDebut.value).getTime() : undefined,
    max: filtreFin.value
      ? new Date(filtreFin.value + 'T23:59:59').getTime()
      : undefined,
    labels: {
      datetimeFormatter: {
        year:  'yyyy',
        month: 'MMM yyyy',
        day:   'dd MMM',
      },
    },
  },
  yaxis: { show: false },
  legend: {
    show:     true,
    position: 'bottom',
  },
  tooltip: {
    x: { format: 'dd MMM yyyy HH:mm' },
    y: { title: { formatter: () => '' } },
  },
  grid: { padding: { left: 10, right: 10 } },
}));

onMounted(fetchHistorique);
</script>
