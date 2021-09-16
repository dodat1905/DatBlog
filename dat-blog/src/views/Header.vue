<template>
  <div>
    <b-navbar class="is-black" fixed-top>
      <template #brand>
        <b-navbar-item tag="router-link" :to="{ path: '/' }">
          <img
            src="https://raw.githubusercontent.com/buefy/buefy/dev/static/img/buefy-logo.png"
            alt="Lightweight UI components for Vue.js based on Bulma"
          />
        </b-navbar-item>
      </template>
      <template #start>
        <b-navbar-item tag="router-link" :to="{ path: '/' }">
          Home
        </b-navbar-item>
        <b-navbar-item href="#">
          Documentation
        </b-navbar-item>
        <b-field>
          <b-input placeholder="Search..."
              type="search"
              icon="magnify"
              icon-clickable
              class="mt-2"
              v-model="searchData"
              @keyup.enter.native="search"
              @icon-click="search">
          </b-input>
        </b-field>
      </template>

      <template #end>
        <b-navbar-item tag="div">
          <div class="buttons">
            <a class="button is-primary" href="/#/users/sign_up" v-if="currentUser === null">
              <strong>Sign up</strong>
            </a>
            <a class="button is-primary" href="/#/users/sign_in" v-if="currentUser === null">
              <strong>Sign in</strong>
            </a>
            <div v-if="currentUser !== null">
              <b-dropdown aria-role="list" position="is-bottom-left" scrollable max-height="500">
                <template #trigger="{ active }">
                  <b-icon
                    pack="fas"
                    icon="info-circle "
                    size="is-large"
                    class="mb-1 is-clickable has-text-link"
                    :icon-right="active ? 'menu-up' : 'menu-down'"
                  ></b-icon>
                </template>
                <div class="dropdown-content notification">
                  <div v-for="notification in notifications" :key="notification.id">
                    <a class="dropdown-item" @click="readNotification(notification.id)">
                      <p>
                        {{ notification.body }}
                        <b-icon
                          pack="fas"
                          icon="circle"
                          class="has-text-link is-pulled-right"
                          v-if="notification.unread"
                        ></b-icon>
                      </p>
                      <p>{{ notification.sender }} - {{ notification.created_at }}</p>
                    </a>
                    <hr class="dropdown-divider" />
                  </div>
                </div>
              </b-dropdown>
              <span class="mb-1 mr-2">({{ notificationsCount }})</span>
              <a class="button is-primary" href="/#/posts/new">
                <strong>New post</strong>
              </a>
              <a class="button is-primary" @click="$store.commit('users/SIGN_OUT')">
                <strong>Sign out</strong>
              </a>
            </div>
          </div>
        </b-navbar-item>
      </template>
    </b-navbar>
  </div>
</template>
<script>
import { mapState } from "vuex";
import axios from "axios";
export default {
  name: "Header",
  data() {
    return {
      notifications: [],
      searchData: this.$route.query.search,
    };
  },
  computed: {
    ...mapState("users", ["currentUser"]),
    notificationsCount() {
      return this.notifications.filter((notification) => notification.unread).length;
    },
  },
  channels: {
    NotificationChannel: {
      connected() {
        axios.get("/api/v1/notifications").then((response) => {
          this.notifications = response.data.notifications;
        });
      },
      rejected() {},
      received(data) {
        this.notifications.unshift(data);
      },
      disconnected() {},
    },
  },
  methods: {
    readNotification(id) {
      const notification = this.notifications.find((notification) => notification.id == id);
      if (notification.unread === true) {
        axios.patch("/api/v1/notifications/" + id).then(() => {
          notification.unread = false;
        });
      }
    },
    search() {
      this.$router.push({ name: "Search", query: { search: this.searchData } });
    }
  },
  created() {
    if (this.currentUser !== null) {
      this.$cable.subscribe({
        channel: "NotificationChannel",
        room: "notifications",
      });
    }
  }
};
</script>

<style scoped>
.notification {
  min-width: 25rem;
  padding: 1.25rem;
}
</style>
