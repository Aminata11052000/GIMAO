<template>
  <v-row dense>
    <v-col cols="12" md="4">
      <FormField
        v-model="localSeuil.derniereIntervention"
        field-name="derniereIntervention"
        type="number"
        label="Dernière intervention"
        placeholder="0"
        min="0"
        @update:model-value="updateProchaineMaintenance"
      />
    </v-col>

    <v-col cols="12" md="4">
      <FormField
        v-model="localSeuil.ecartInterventions"
        field-name="ecartInterventions"
        type="number"
        label="Écart entre interventions"
        placeholder="0"
        min="0"
        @update:model-value="updateProchaineMaintenance"
      />
    </v-col>

    <v-col cols="12" md="4">
      <FormField
        :model-value="localSeuil.prochaineMaintenance"
        field-name="prochaineMaintenance"
        type="number"
        label="Prochaine maintenance"
        :readonly="true"
      />
    </v-col>
  </v-row>
</template>

<script setup>
import { reactive, watch } from "vue";
import { FormField } from "@/components/common";

const props = defineProps({
  modelValue: {
    type: Object,
    required: true,
    // { derniereIntervention: number, ecartInterventions: number, prochaineMaintenance: number }
  },
  estGlissant: {
    type: Boolean,
    default: false,
  },
  valeurCourante: {
    type: Number,
    default: null,
  },
});

const emit = defineEmits(["update:modelValue"]);

const toNumberOrNull = (value) => {
  if (value === null || value === undefined || value === "") {
    return null;
  }

  const parsed = Number(value);
  return Number.isNaN(parsed) ? null : parsed;
};

// Copie locale pour éviter la mutation directe de la prop
const localSeuil = reactive({
  derniereIntervention: props.modelValue.derniereIntervention ?? 0,
  ecartInterventions:   props.modelValue.ecartInterventions   ?? 0,
  prochaineMaintenance: props.modelValue.prochaineMaintenance ?? 0,
});

// Sync depuis le parent (ex : mode édition)
watch(
  () => props.modelValue,
  (val) => {
    localSeuil.derniereIntervention = val.derniereIntervention ?? 0;
    localSeuil.ecartInterventions   = val.ecartInterventions   ?? 0;
    localSeuil.prochaineMaintenance = val.prochaineMaintenance ?? 0;
  },
  { deep: true }
);

const updateProchaineMaintenance = () => {
  const ecart = toNumberOrNull(localSeuil.ecartInterventions);

  // Glissant : on part de la valeur actuelle du compteur
  // Non glissant : on part de la dernière intervention
  const base = props.estGlissant
    ? toNumberOrNull(props.valeurCourante)
    : toNumberOrNull(localSeuil.derniereIntervention);

  if (base === null || ecart === null) {
    localSeuil.prochaineMaintenance = "";
  } else {
    localSeuil.prochaineMaintenance = base + ecart;
  }

  emit("update:modelValue", {
    ...localSeuil,
    derniereIntervention: toNumberOrNull(localSeuil.derniereIntervention),
    ecartInterventions:   toNumberOrNull(localSeuil.ecartInterventions),
    prochaineMaintenance: toNumberOrNull(localSeuil.prochaineMaintenance),
  });
};

// Recalcule quand estGlissant change sans que l'utilisateur retouche les champs
watch(() => props.estGlissant, updateProchaineMaintenance);
</script>