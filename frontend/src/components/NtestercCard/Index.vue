<template>
  <InnerCard v-bind="$attrs">
    <slot />
    <template v-for="(_, name) in $slots" #[name]="slotProps">
      <slot :name="name" v-bind="slotProps" />
    </template>
  </InnerCard>
</template>

<script setup lang="ts">
import InnerCard from '/@/components/ntesterc/NtestercCard.vue';
</script>
