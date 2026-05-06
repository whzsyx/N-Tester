<template>
	<div class="api-automation-root">
		<ApiList v-if="currentService === null" @select-service="onSelectService" />
		<ApiServiceDetail
			v-else
			:serviceId="currentService.id"
			:serviceName="currentService.name"
			@back="onBack"
		/>
	</div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import ApiList from './api_list.vue';
import ApiServiceDetail from './api_service_detail.vue';

const currentService = ref<{ id: number; name: string } | null>(null);

function onSelectService(service: { id: number; name: string }) {
	currentService.value = service;
}

function onBack() {
	currentService.value = null;
}
</script>

<style scoped>
.api-automation-root {
	position: absolute;
	inset: 0;
	display: flex;
	flex-direction: column;
	overflow: hidden;
}
</style>
