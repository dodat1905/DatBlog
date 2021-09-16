<template>
  <div class="mt-5">
    <div class="panel is-link">
      <p class="panel-heading">
        {{ post.title }}
      </p>
      <div class="panel-block columns m-0 p-0">
        <div class="column is-10">by {{ post.author }}, last updated {{ post.created_at }}</div>
        <div class="column is-2" v-if="showButton(post.author)">
          <b-icon
            pack="fas"
            icon="trash"
            size="is-medium"
            class="is-pulled-right has-text-danger is-clickable"
            @click.native="destroyPost"
          ></b-icon>
          <router-link :to="{ name: 'EditPost', params: { id: $route.params.id } }" class="is-pulled-right">
            <b-icon pack="fas" icon="edit" size="is-medium"></b-icon>
          </router-link>
        </div>
      </div>
      <div class="panel-block">
        <div class="column is-12" v-html="post.content"></div>
      </div>
      <div class="panel-block">
        <b-taglist v-for="(tag, index) in post.tags" :key="index">
          <b-tag type="is-info">{{ tag }}</b-tag>
        </b-taglist>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from "vuex";

export default {
  name: "PostsShow",
  computed: {
    ...mapState("posts", ["post"]),
    ...mapState("users", ["currentUser", "token"]),
  },
  methods: {
    ...mapActions("posts", ["showPost", "deletePost"]),
    destroyPost() {
      this.$buefy.dialog.confirm({
        message: "Confirm to delete this post?",
        onConfirm: () => this.deletePost(this.$route.params.id)
      });
    },
    showButton(author) {
      return this.token !== null && (this.currentUser.type === 'Admin' || this.currentUser.name == author)
    }
  },
  created() {
    this.showPost({ post: { id: this.$route.params.id } });
  },
};
</script>
