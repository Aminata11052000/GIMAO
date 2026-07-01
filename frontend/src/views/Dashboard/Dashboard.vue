<template>
  <v-container fluid style="max-width: 90%">
    <div class="dashboard">
      <!-- Action : forcer le calcul du préventif -->
      <div
        v-if="store.getters.hasPermission('mp:create')"
        class="d-flex justify-end mb-3"
      >
        <v-btn
          color="primary"
          variant="flat"
          prepend-icon="mdi-calculator-variant"
          size="small"
          :loading="forcing"
          @click="forcerCalcul"
        >
          <span class="d-none d-sm-inline">Forcer le calcul des BT préventifs</span>
          <span class="d-inline d-sm-none">Forcer le calcul</span>
        </v-btn>
      </div>

      <!-- STATS COMPONENT -->
      <StatsComponent v-if="hasStats" :perms="getPermsForStats" />

      <!-- Dashboard horizontal -->
      <v-row dense v-if="hasDIandBtHorizontal">
        <v-col cols="12" md="6">
          <v-card rounded="">
            <FailureListComponent
              @row-click="handleRowClickDI"
              title="Liste des DI"
              :showSearch="true"
              :showCreateButton="false"
            />

            <v-btn
              color="primary"
              class="mt-4 float-right mr-4 mb-4"
              rounded=""
              @click="handleCreateDI"
              :showCreateButton="false"
            >
              Créer une DI
            </v-btn>
          </v-card>
        </v-col>

        <v-col cols="12" md="6">
          <v-card rounded="">
            <InterventionListComponent
              @row-click="handleRowClickBT"
              title="Liste des BT"
              :showSearch="true"
              :showCreateButton="false"
            />

            <v-btn
              color="primary"
              class="mt-4 float-right mr-4 mb-4"
              @click="handleCreateBT"
              v-if="store.getters.hasPermission('bt:create')"
            >
              Créer un BT
            </v-btn>
          </v-card>
        </v-col>
      </v-row>

      <!-- Dashboard vertical -->
      <div
        v-else-if="store.getters.hasPermission('dash:display.vertical')"
        class="column"
      >
        <v-card rounded="" v-if="store.getters.hasPermission('dash:display.di')">
          <FailureListComponent
            @row-click="handleRowClickDI"
            title="Liste des DI"
            :showSearch="true"
            :showCreateButton="false"
          />

          <v-btn
            color="primary"
            class="mt-4 float-right mr-4 mb-4"
            rounded=""
            @click="handleCreateDI"
            :showCreateButton="false"
          >
            Créer une DI
          </v-btn>
        </v-card>

        <v-card rounded="" v-else-if="store.getters.hasPermission('dash:display.diCreated')">
          <FailureListComponent
            @row-click="handleRowClickDI"
            title="Vos DI"
            :showSearch="true"
            :showCreateButton="false"
            :api-endpoint="`demandes-intervention/par_utilisateur/?utilisateur_id=${store.getters.currentUser.id}`"
          />

          <v-btn
            color="primary"
            class="mt-4 float-right mr-4 mb-4"
            rounded=""
            @click="handleCreateDI"
            :showCreateButton="false"
          >
            Créer une DI
          </v-btn>
        </v-card>

        <v-card rounded="" v-if="store.getters.hasPermission('dash:display.bt')">
          <InterventionListComponent
            @row-click="handleRowClickBT"
            title="Liste des BT"
            :showSearch="true"
            :showCreateButton="false"
          />

          <v-btn
            color="primary"
            class="mt-4 float-right mr-4 mb-4"
            @click="handleCreateBT"
          >
            Créer un BT
          </v-btn>
        </v-card>

        <v-card rounded="" v-else-if="store.getters.hasPermission('dash:display.btAssigned')">
          <InterventionListComponent
            @row-click="handleRowClickBT"
            title="Vos BT Assignés"
            :showSearch="true"
            :showCreateButton="false"
            show-statut-filter
            :apiEndpoint="`bons-travail/assigne_a/?utilisateur_id=${store.getters.currentUser.id}`"
          />

          <v-btn
            color="primary"
            class="mt-4 float-right mr-4 mb-4"
            @click="handleCreateBT"
          >
            Créer un BT
          </v-btn>
        </v-card>

        <v-card rounded="" v-if="store.getters.hasPermission('dash:display.eq')">
          <EquipmentListComponent
            title="Liste des Équipements"
            :showSearch="true"
            @row-click="handleRowClickEquipment"
            :getItemsBySelf="true"
          />
        </v-card>
      </div>

      <!-- Equipement standalone -->
      <div
        v-if="
          store.getters.hasPermission('dash:display.eq') &&
          !store.getters.hasPermission('dash:display.vertical') &&
          !store.getters.hasPermission('dash:display.di')
        "
      >
        <v-card rounded="" v-if="store.getters.hasPermission('dash:display.eq')">
          <EquipmentListComponent
            title="Liste des Équipements"
            :showSearch="true"
            @row-click="handleRowClickEquipment"
            :getItemsBySelf="true"
          />
        </v-card>
      </div>

      <!-- Dashboard magasinier -->
      <div v-if="store.getters.hasPermission('dash:display.mag')">
        <Stocks />
      </div>
    </div>
    <v-btn
      class="floating-logout-button"
      color="primary"
      dark
      @click="showLogoutConfirm = true"
      v-if="!store.getters.hasPermission('menu:view')"
    >
      <v-icon left>mdi-logout</v-icon>
      Se déconnecter
    </v-btn>

    <ConfirmationModal
      v-model="showLogoutConfirm"
      type="warning"
      title="Déconnexion"
      message="Êtes-vous sûr de vouloir vous déconnecter ?"
      confirm-text="Se déconnecter"
      cancel-text="Annuler"
      confirm-icon="mdi-logout"
      @confirm="logout"
    />

    <v-snackbar v-model="snackbar" :color="snackbarColor" timeout="4000">
      {{ snackbarMessage }}
    </v-snackbar>
  </v-container>
</template>

<script setup>
import { computed, ref } from "vue";
import { useStore } from "vuex";
import ConfirmationModal from "@/components/common/ConfirmationModal.vue";
import { useRouter } from "vue-router";

import FailureListComponent from "@/components/FailureListComponent.vue";
import InterventionListComponent from "@/components/InterventionListComponent.vue";
import EquipmentListComponent from "@/components/EquipmentListComponent.vue";
import StatsComponent from "@/components/StatsComponent.vue";
import Stocks from "@/views/Stocks/Stocks.vue";
import { useApi } from "@/composables/useApi";
import { API_BASE_URL } from "@/utils/constants";

const store = useStore();
const router = useRouter();
const api = useApi(API_BASE_URL);

const forcing = ref(false);
const snackbar = ref(false);
const snackbarMessage = ref("");
const snackbarColor = ref("success");

const forcerCalcul = async () => {
  if (forcing.value) return;
  forcing.value = true;
  try {
    const res = await api.post("plans-maintenance/forcer_calcul/");
    snackbarMessage.value = res?.message || "Calcul des maintenances préventives effectué.";
    snackbarColor.value = "success";
    snackbar.value = true;
  } catch (e) {
    console.error(e);
    snackbarMessage.value = "Erreur lors du calcul des maintenances préventives.";
    snackbarColor.value = "error";
    snackbar.value = true;
  } finally {
    setTimeout(() => { forcing.value = false; }, 4000);
  }
};

const role = computed(() => store.getters.userRole);

/**
 * Perms
 */
const getPermsForStats = () => {
  const perm =
    store.getters.hasPermission("dash:stats.full") ||
    store.getters.hasPermission("dash:stats.bt") ||
    store.getters.hasPermission("dash:stats.di");
  return perm;
};

const hasStats = computed(() => {
  return (
    store.getters.hasPermission("dash:stats.full") ||
    store.getters.hasPermission("dash:stats.bt") ||
    store.getters.hasPermission("dash:stats.di")
  );
});
const hasDIandBtHorizontal = computed(() => {
  return (
    store.getters.hasPermission("dash:display.di") &&
    store.getters.hasPermission("dash:display.bt") &&
    !store.getters.hasPermission("dash:display.vertical")
  );
});

const showLogoutConfirm = ref(false);

const logout = () => {
  store.dispatch("logout");
  window.location.href = "/login";
};

// Gestion click DI
const handleRowClickDI = (failure) => {
  router.push({
    name: "FailureDetail",
    params: { id: failure.id },
    query: { from: "dashboard" },
  });
};

const handleCreateDI = () => {
  router.push({ name: "CreateFailure", query: { from: "dashboard" } });
};

// Gestion click BT
const handleRowClickBT = (intervention) => {
  router.push({
    name: "InterventionDetail",
    params: { id: intervention.id },
    query: { from: "dashboard" },
  });
};

const handleCreateBT = () => {
  router.push({
    name: "CreateIntervention",
    query: { from: "dashboard" },
  });
};

// Gestion click Equipment
const handleRowClickEquipment = (equipment) => {
  router.push({
    name: "EquipmentDetail",
    params: { id: equipment.id },
    query: { from: "dashboard" },
  });
};

const statsFull = computed(() => isResponsable.value);
</script>

<style scoped>
.dashboard {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* Responsable : 2 colonnes */
.row.two-columns {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
}

/* Technicien / Opérateur : vertical */
.column {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

/* Responsive */
@media (max-width: 900px) {
  .row.two-columns {
    grid-template-columns: 1fr;
  }
}

.floating-logout-button {
  position: fixed !important;
  bottom: 24px;
  left: 24px;
  z-index: 100;
  border-radius: 5px !important;
  width: auto !important;
  padding: 0 12px !important;
}

.floating-logout-button-magasinier {
  position: fixed !important;
  bottom: 24px;
  left: 24px;
  z-index: 100;
}
</style>
