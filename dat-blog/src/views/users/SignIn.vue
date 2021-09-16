<template>
  <div class="columns">
    <div class="column"></div>
    <div class="column is-two-fifths">
      <form @submit.prevent="onSubmit" class="box mt-6">
        <h3 class="title is-3">Sign in</h3>
        <b-notification
          type="is-danger"
          has-icon
          aria-close-label="Close notification"
          v-if="this.$store.state.users.error !== null"
          role="alert"
        >
          {{ this.$store.state.users.error }}
        </b-notification>
        <b-field
          label="Name"
          :type="{
            'is-danger': $v.form.name.$error,
            'is-success': $v.form.name.$dirty && !$v.form.name.$error,
          }"
        >
          <b-input v-model.trim="$v.form.name.$model" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.name.$error && !$v.form.name.required">Please enter your name</div>
          </template>
        </b-field>
        <b-field
          label="Password"
          :type="{
            'is-danger': $v.form.password.$error,
            'is-success': $v.form.password.$dirty && !$v.form.password.$error,
          }"
        >
          <b-input v-model="form.password" type="password" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.password.$error && !$v.form.password.required">Please enter your password</div>
          </template>
        </b-field>
        <b-button type="is-primary" native-type="submit">Submit</b-button>
        <b-checkbox v-model="form.remember" class="ml-3 mt-2">
          Remember me </b-checkbox
        ><br /><br />
        <a href="/#/users/forgot_password">Forgot password?</a><br /><br />
        <b-button type="is-danger" @click="signInGoogle">Sign in with Google</b-button>
      </form>
    </div>
    <div class="column"></div>
  </div>
</template>
<script>
import { mapActions } from "vuex";
import { required } from "vuelidate/lib/validators";
import axios from "axios";

export default {
  name: "SignIn",
  data() {
    return {
      form: {
        name: "",
        password: "",
        remember: false,
      },
    };
  },
  validations: {
    form: {
      name: {
        required,
      },
      password: {
        required,
      },
    },
  },
  methods: {
    ...mapActions("users", {
      signIn: "signIn",
    }),
    onSubmit() {
      this.$v.form.$touch();
      if (!this.$v.form.$invalid) {
        this.signIn(this.form);
      }
    },
    signInGoogle() {
      window.location.href = "http://localhost:3000/auth/google_oauth2";
    },
  },
};
</script>

<style scoped>
.remember-me {
  vertical-align: -webkit-baseline-middle;
}
</style>
