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
      <p v-else-if="!series.length" class="text-caption text-grey text-center py-4">
        Aucun historique d'état disponible pour cet équipement.
      </p>

      <!-- Timeline -->
      <apexchart
        v-else
        type="rangeBar"
        height="180"
        :options="chartOptions"
        :series="series"
      />
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
// Chaque entrée de l'historique représente le début d'un état.
// La fin d'un état = le début du suivant (ou maintenant pour le dernier).
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

// ── Transformation en séries ApexCharts ──────────────────────────────────────
// Un état = une série avec toutes ses plages de temps.
const series = computed(() => {
  const parStatut = {};

  plages.value.forEach(({ statut, debut, fin }) => {
    if (!parStatut[statut]) parStatut[statut] = [];
    parStatut[statut].push({ x: 'État', y: [debut, fin] });
  });

  return Object.entries(parStatut).map(([statut, data]) => ({
    name:  STATUTS_CONFIG[statut]?.label  ?? statut,
    color: STATUTS_CONFIG[statut]?.couleur ?? '#999999',
    data,
  }));
});

// ── Options du graphique ──────────────────────────────────────────────────────
const chartOptions = computed(() => ({
  chart: {
    type:    'rangeBar',
    toolbar: { show: false },
    zoom:    { enabled: false },
  },
  plotOptions: {
    bar: {
      horizontal:  true,
      barHeight:   '50%',
      rangeBarGroupRows: false,
    },
  },
  xaxis: {
    type: 'datetime',
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
