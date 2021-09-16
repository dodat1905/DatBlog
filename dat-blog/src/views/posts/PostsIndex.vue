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
    <pagination
      :perPage="posts.per_page"
      :totalPages="posts.total_pages"
      @current-page="nextPages"
      :current="currentPage"
    ></pagination>
  </div>
</template>
<script>
import { mapActions, mapState, mapMutations } from "vuex";
import Pagination from "./Pagination.vue";

export default {
  components: { Pagination },
  name: "PostsIndex",
  computed: {
    ...mapState("posts", ["posts"]),
    currentPage() {
      return parseInt(this.$route.query.page);
    },
  },
  methods: {
    ...mapActions("posts", {
      getPosts: "getPosts",
    }),
    ...mapMutations("users", ["SIGN_IN"]),
    nextPages(currentPage) {
      this.$router.push({ name: "Home", query: { page: currentPage } });
    },
  },
  created() {
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    if (urlParams.get("token") != null) {
      const data = {
        token: urlParams.get("token"),
        refresh_token: urlParams.get("refresh_token"),
        user: JSON.parse(urlParams.get("user")),
      };
      this.SIGN_IN(data);
    }
    this.getPosts(this.$route.query.page);
  },
  watch: {
    $route(to, from) {
      this.getPosts(to.query.page);
    },
  },
};
</script>

<style scoped>
.cursor-default {
  cursor: default;
}
</style>
