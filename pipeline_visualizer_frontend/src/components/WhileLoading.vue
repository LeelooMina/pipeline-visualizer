<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "WhileLoading",
  data() {
    return {
      loadingImg: "https://cdn.auth0.com/blog/hello-auth0/loader.svg" //change this to match Anthony's loading image
    };
  }
});
</script>

<template>
  <div class="loader">
    <img :src="loadingImg" alt="Loading..." />
  </div>
</template>
