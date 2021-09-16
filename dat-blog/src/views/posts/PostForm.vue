<template>
  <form @submit.prevent="onSubmit" class="box mt-6">
    <b-notification type="is-danger" aria-close-label="Close notification" has-icon v-if="errors !== null" role="alert">
      <div v-for="(error, index) in this.$store.state.posts.errors" :key="index">
        {{ error }}
      </div>
    </b-notification>
    <b-field
      label="Title"
      :type="{
        'is-danger': v.form.post.title.$error,
        'is-success': v.form.post.title.$dirty && !v.form.post.title.$error,
      }"
    >
      <b-input v-model="v.form.post.title.$model" maxlength="150"></b-input>
      <template #message>
        <div v-if="v.form.post.title.$error && !v.form.post.title.required">
          Please enter title
        </div>
      </template>
    </b-field>
    <b-field
      label="Content"
      :type="{
        'is-danger': v.form.post.content.$error,
        'is-success': v.form.post.content.$dirty && !v.form.post.content.$error,
      }"
    >
      <editor
        v-model="v.form.post.content.$model"
        api-key="no-api-key"
        :init="{
          height: 500,
          menubar: true,
          plugins: [
            'advlist anchor autolink codesample fullscreen help image imagetools',
            ' lists link media noneditable preview',
            ' searchreplace table template  visualblocks wordcount',
          ],
          toolbar:
            'insertfile a11ycheck undo redo | bold italic | fontsizeselect fontselect | forecolor backcolor | template codesample | \
             alignleft aligncenter alignright alignjustify | bullist numlist | link image media tinydrive',
          images_upload_handler: upload_handler,
        }"
      />
      <template #message>
        <div v-if="v.form.post.content.$error && !v.form.post.content.required">
          Please enter your content
        </div>
      </template>
    </b-field>
    <b-field
      label="Tag"
      :type="{
        'is-danger': v.form.post.tags.$error,
        'is-success': v.form.post.tags.$dirty && !v.form.post.tags.$error,
      }"
    >
      <b-taginput
        v-model="v.form.post.tags.$model"
        :data="filteredTags"
        autocomplete
        :allow-new="true"
        field="user.first_name"
        icon="label"
        placeholder="Add a tag"
        @typing="getFilteredTags"
      >
      </b-taginput>
      <template #message>
        <div v-if="v.form.post.tags.$error && !v.form.post.tags.required">
          Please enter the tags
        </div>
      </template>
    </b-field>
    <b-button type="is-primary" native-type="submit">Submit</b-button>
  </form>
</template>
<script>
import axios from "axios";
import Editor from "@tinymce/tinymce-vue";

axios.defaults.baseURL = "http://localhost:3000";
axios.defaults.headers.common["Accept"] = "application/json";

export default {
  name: "PostForm",
  components: {
    editor: Editor,
  },
  props: {
    onSubmit: Function,
    form: Object,
    errors: Array,
    filteredTags: Array,
    getFilteredTags: Function,
    token: String,
    v: Object,
  },
  methods: {
    upload_handler(blobInfo, success, failure, progress) {
      var xhr, formData;

      xhr = new XMLHttpRequest();
      xhr.withCredentials = false;
      xhr.open("POST", "http://localhost:3000/api/v1/posts/upload_images");
      xhr.setRequestHeader("Authorization", this.$store.state.users.token);

      xhr.upload.onprogress = function(e) {
        progress((e.loaded / e.total) * 100);
      };

      xhr.onload = function() {
        var json;

        if (xhr.status === 403) {
          failure("HTTP Error: " + xhr.status, { remove: true });
          return;
        }

        if (xhr.status < 200 || xhr.status >= 300) {
          failure("HTTP Error: " + xhr.status);
          return;
        }

        json = JSON.parse(xhr.responseText);

        if (!json || typeof json.location != "string") {
          failure("Invalid JSON: " + xhr.responseText);
          return;
        }

        success(json.location);
      };

      xhr.onerror = function() {
        failure("Image upload failed due to a XHR Transport error. Code: " + xhr.status);
      };

      formData = new FormData();
      formData.append("file", blobInfo.blob(), blobInfo.filename());

      xhr.send(formData);
    },
  },
};
</script>
