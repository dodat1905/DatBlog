<template>
  <div class="columns">
    <div class="column"></div>
    <div class="column is-two-fifths">
      <form @submit.prevent="onSubmit" class="box mt-6">
        <h3 class="title is-3">Forgot password</h3>
        <b-notification
          type="is-danger"
          has-icon
          aria-close-label="Close notification"
          v-if="error !== null"
          role="alert"
        >
          {{ error }}
        </b-notification>
        <b-field
          label="Email"
          :type="{
            'is-danger': $v.form.email.$error,
            'is-success': $v.form.email.$dirty && !$v.form.email.$error,
          }"
        >
          <b-input v-model.trim="$v.form.email.$model" maxlength="30" type="email"></b-input>
          <template #message>
            <div v-if="$v.form.email.$error && !$v.form.email.required">Please enter email</div>
            <div v-if="$v.form.email.$error && !$v.form.email.email">Email invalidate</div>
          </template>
        </b-field>
        <b-button type="is-primary" native-type="submit">Submit</b-button>
      </form>
    </div>
    <div class="column"></div>
  </div>
</template>
<script>
import { mapActions } from "vuex";
import { required, email } from "vuelidate/lib/validators";

export default {
  name: "ForgotPassword",
  data() {
    return {
      error: null,
      form: {
        email: "",
      },
    };
  },
  validations: {
    form: {
      email: {
        required,
        email
      },
    },
  },
  methods: {
    ...mapActions("users", ['forgotPassword']),
    onSubmit() {
      this.$v.form.$touch();
      if (!this.$v.form.$invalid) {
        this.forgotPassword(this.form).catch((error) => {
          this.error = error.response.data;
      });
      }
    },
  },
};
</script>
