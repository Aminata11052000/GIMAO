<template>
  <FailureListComponent
    @create="handleCreate"
    @row-click="handleRowClick"
    :showCreateButton="canCreateDI" />
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';
import FailureListComponent from '@/components/FailureListComponent.vue';

const router = useRouter();
const store = useStore();

const canCreateDI = computed(() => store.getters.hasPermission('di:create'));

const handleCreate = () => {
  router.push({ name: 'CreateFailure' });
};

const handleRowClick = (item) => {
  router.push({ name: 'FailureDetail', params: { id: item.id } });
};
</script>