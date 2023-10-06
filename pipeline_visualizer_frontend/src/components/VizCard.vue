<script lang="ts">
import { defineComponent } from "vue";


import Cards from "./Cards.vue";

export default defineComponent({
  components: {
    Cards,
  },

});
</script>

<template>
  <div class="q-pa-sm column items-center">
    <Cards class="my-card" />
  </div>
</template>

<style lang="scss" scoped>

</style>
