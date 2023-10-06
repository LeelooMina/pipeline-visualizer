<script lang="ts">
import { defineComponent } from 'vue';
import { useAuth0 } from '@auth0/auth0-vue';

export default defineComponent({
  setup() {
    const { logout } = useAuth0();

    const handleLogout = () => {
      logout({
        logoutParams: {
          returnTo: window.location.origin,
        },
      });
    };

    return {
      handleLogout,
    };
  },
});
</script>

<template>
  <div>
    <button @click="handleLogout">Log Out</button>
  </div>
</template>
