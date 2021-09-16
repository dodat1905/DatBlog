<template>
  <div>
    <posts-index></posts-index>
  </div>
</template>

<script>
import PostsIndex from "./posts/PostsIndex.vue";
// @ is an alias to /src
export default {
  components: { PostsIndex },
  name: "Home",
};
</script>
