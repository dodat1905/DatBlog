<template>
  <div class="mt-5">
    <div v-for="post in posts.data" :key="post.id">
      <a class="panel is-link" :href="'#/posts/' + post.id">
        <p class="panel-heading mt-5">
          {{ post.title }}
        </p>
        <div class="panel-block columns m-0 p-0">
          <div class="column is-6">by {{ post.author }}, last updated {{ post.created_at }}</div>
        </div>
        <div class="panel-block">
          <div class="column is-12" v-html="post.content"></div>
        </div>
        <div class="panel-block">
          <b-taglist v-for="(tag, index) in post.tags" :key="index">
            <b-tag type="is-info">{{ tag }}</b-tag>
          </b-taglist>
        </div>
      </a>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState, mapMutations } from "vuex";
import Pagination from "./posts/Pagination.vue";
import axios from "axios";
export default {
  // components: { Pagination },
  name: "Search",
  computed: {
    currentPage() {
      return parseInt(this.$route.query.page);
    },
  },
  data() {
    return {
      posts: {
        data: []
      }
    }
  },
  created() {
    axios.get('/api/v1/search', {
      params: {
        search: this.$route.query.search
      }
    }).then(response => {
      this.posts.data = response.data
    })
  },
  watch: {
    $route(to, from) {
      axios.get('/api/v1/search', {
        params: {
          search: this.$route.query.search
        }
      }).then(response => {
        this.posts.data = response.data
      })
      // react to route changes...
    }
  }
}
</script>
