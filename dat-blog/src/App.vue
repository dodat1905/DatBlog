<template>
  <div id="app">
    <Header></Header>
    <div class="container">
      <router-view />
    </div>
  </div>
</template>

<script>
import Header from "./views/Header.vue";

export default {
  components: {
    Header,
  },
};
</script>
<style>
@import "https://cdn.jsdelivr.net/npm/@mdi/font@5.8.55/css/materialdesignicons.min.css";
@import "https://use.fontawesome.com/releases/v5.2.0/css/all.css";

html {
  background-image: url('~@/assets/background.jpg');
  background-size: cover;
  background-attachment: fixed;
  background-position: 100% 60%;
}

.panel-block {
  background-color: white;
}

.pagination-link {
  background: white;
}
</style>
