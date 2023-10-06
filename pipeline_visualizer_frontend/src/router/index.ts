import { authGuard } from "@auth0/auth0-vue";
import { createRouter, createWebHistory } from "vue-router";

const NotFoundPage = () => import("../components/NotFound.vue");
const VizCardVue = () => import("../components/VizCard.vue");
const CallbackPage = () => import("../components/Callback.vue");

const routes = [
  {
    path: "/",
    name: "VizCardVue",
    component: VizCardVue,
    beforeEnter: authGuard,
  },
  { 
    path: "/callback", 
    name: "Callback", 
    component: CallbackPage 
  },
  { 
    path: "/:catchAll(.*)", 
    name: "Not Found", 
    component: NotFoundPage 
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
