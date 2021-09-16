import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import ActionCableVue from 'actioncable-vue';
import Buefy from "buefy";
import "buefy/dist/buefy.css";
import Vuelidate from "vuelidate";
Vue.config.productionTip = false;
Vue.use(Buefy);
Vue.use(Vuelidate);
Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: 'ws://localhost:3000/cable', // or function which returns a string with your JWT appended to your server URL as a query parameter
  connectImmediately: true,
});

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
