<template>
  <NtestercUploadImages v-bind="$attrs" v-model:file-list="proxy">
    <template v-for="(_, name) in $slots" #[name]="slotProps">
      <slot :name="name" v-bind="slotProps" />
    </template>
  </NtestercUploadImages>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import NtestercUploadImages from '/@/components/ntesterc/NtestercUploadImages.vue';
const props = defineProps<{ fileList?: any }>();
const emit = defineEmits(['update:fileList']);
const proxy = computed({
  get: () => props.fileList,
  set: (v) => emit('update:fileList', v),
});
</script>
