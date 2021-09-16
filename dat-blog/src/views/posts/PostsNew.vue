<template>
  <div class="columns">
    <div class="column"></div>
    <div class="column is-full">
      <h3 class="title is-3">New post</h3>
      <post-form
        :form="form"
        :onSubmit="onSubmit"
        :filteredTags="filteredTags"
        :getFilteredTags="getFilteredTags"
        :errors="errors"
        :token="$store.state.users.token"
        :v="this.$v"
      ></post-form>
    </div>
    <div class="column"></div>
  </div>
</template>
<script>
import { mapState, mapActions } from "vuex";
import axios from "axios";
axios.defaults.baseURL = "http://localhost:3000";
import PostForm from "./PostForm.vue";
import { required } from "vuelidate/lib/validators";

export default {
  components: { PostForm },
  name: "CreatePost",
  data() {
    return {
      filteredTags: [],
      tags: [],
      errors: null,
      form: {
        post: {
          title: "",
          content: "",
          tags: [],
          user_id: this.$store.state.users.currentUser.id,
        },
      },
    };
  },
  validations: {
    form: {
      post: {
        title: {
          required,
        },
        content: {
          required,
        },
        tags: {
          required,
        },
      },
    },
  },
  computed: {
    ...mapState("posts", ["post"]),
  },
  methods: {
    ...mapActions("posts", ["createPost"]),
    getFilteredTags(text) {
      this.filteredTags = this.tags.filter((option) => {
        return option.toString().indexOf(text) >= 0;
      });
    },
    onSubmit() {
      this.$v.form.post.$touch();
      if (!this.$v.form.post.$invalid) {
        this.createPost(this.form).then(() => {
          this.errors = this.post.errors;
        });
      }
    },
  },
  created() {
    axios.get("/api/v1/tags", {}).then((response) => {
      this.tags = response.data.tags.map((tag) => tag.name);
    });
  },
};
</script>
