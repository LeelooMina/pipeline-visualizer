<script lang="ts">
import { defineComponent } from "vue";
import { useAuth0 } from "@auth0/auth0-vue";

export default defineComponent({
  setup() {
    const { loginWithRedirect } = useAuth0();

    const handleLogin = () => {
      loginWithRedirect(
        {
          appState: {
            target: '/',
          },
        }
      );
    };
 
    return {
      handleLogin,
    };
  },
});
</script>

<template>
  <div>
    <button @click="handleLogin">Log In</button>
  </div>
</template>
