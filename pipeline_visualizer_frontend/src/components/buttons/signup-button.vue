<script lang="ts">
import { defineComponent } from 'vue';
import { useAuth0 } from '@auth0/auth0-vue';

export default defineComponent({
  setup() {
    const { loginWithRedirect } = useAuth0();

    const handleSignup = () => {
      loginWithRedirect({
        appState: {
          target: '/',
        },
        authorizationParams: {
          screen_hint: 'signup',
        }
      });
    };

    return {
      handleSignup,
    };
  },
});
</script>

<template>
  <div>
    <button @click="handleSignup">Sign Up</button>
  </div>
</template>
