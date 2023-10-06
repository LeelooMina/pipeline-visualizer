<script lang="ts">
// import VizCard from "./components/VizCard.vue";
import Navbar from "./components/Navbar.vue";
import { useAuth0 } from "@auth0/auth0-vue";

import { defineComponent } from "vue";
import WhileLoading from "./components/WhileLoading.vue";

export default defineComponent({
  components: {
    // VizCard,
    Navbar,
    WhileLoading,
  },
  setup() {
    const { isLoading } = useAuth0();
    return {
      isLoading,
    };
  },
});
</script>

<template>
  <Navbar />
  <div v-if="isLoading">
    <WhileLoading />
  </div>
  <div v-else>
    <router-view></router-view>
  </div>
  <!-- <VizCard/> -->

</template>

<style lang="scss" scoped>
.my-card {
    width: 100%;
    max-width: 250px;
}

</style>
