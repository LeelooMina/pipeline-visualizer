<script lang="ts">
import { defineComponent } from "vue";
import loginButton from "./buttons/login-button.vue";
import logoutButton from "./buttons/logout-button.vue";
import signupButton from "./buttons/signup-button.vue";
import { useAuth0 } from "@auth0/auth0-vue";

export default defineComponent({
  name: 'Navbar',
  components: {
    loginButton,
    logoutButton,
    signupButton,
  },
  setup() {
    const { isAuthenticated } = useAuth0();
    // console.log('isAuthenticated =', isAuthenticated.value);
    
    return {
      isAuthenticated,
    };
  },
});

</script>

<template>
  <div class="fixed-bottom" style="z-index: 100; background-color: rgb(37, 207, 213);">
    <q-bar>
      <template v-if="!isAuthenticated">
        <!-- <signup-button /> -->
        <login-button />
      </template>
      <template v-if="isAuthenticated">
        <logout-button />
      </template>

      <q-space />

      <q-btn href="#" dense flat icon="refresh" />
    </q-bar>
  </div>
</template>
