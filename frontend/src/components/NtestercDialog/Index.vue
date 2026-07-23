<template>
  <InnerDialog v-bind="$attrs" ref="inner">
    <template v-for="(_, name) in $slots" #[name]="slotProps">
      <slot :name="name" v-bind="slotProps" />
    </template>
  </InnerDialog>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import InnerDialog from '/@/components/ntesterc/NtestercDialog.vue';
const inner = ref();
defineExpose({
  ntestercOpen: (...args: any[]) => inner.value?.ntestercOpen?.(...args),
  ntestercClose: (...args: any[]) => inner.value?.ntestercClose?.(...args),
  ntestercQuickClose: (...args: any[]) => inner.value?.ntestercQuickClose?.(...args),
});
</script>
