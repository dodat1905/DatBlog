<template>
  <div class="columns">
    <div class="column"></div>
    <div class="column is-two-fifths">
      <form @submit.prevent="onSubmit" class="box mt-6">
        <h3 class="title is-3">Reset password</h3>
        <b-notification
          type="is-danger"
          has-icon
          aria-close-label="Close notification"
          v-if="errors !== null"
          role="alert"
        >
          <div v-for="(error, index) in this.errors" :key="index">
            {{ error }}
          </div>
        </b-notification>
        <b-field
          label="Password"
          :type="{
            'is-danger': $v.form.password.$error,
            'is-success': $v.form.password.$dirty && !$v.form.password.$error,
          }"
        >
          <b-input v-model.trim="$v.form.password.$model" maxlength="30" type="password"></b-input>
          <template #message>
            <div v-if="$v.form.password.$error && !$v.form.password.required">Please enter password</div>
            <div v-if="$v.form.password.$error && !$v.form.password.minlength">
              Password cannot be less than 8 characters
            </div>
          </template>
        </b-field>
        <b-field
          label="Password confirmation"
          :type="{
            'is-danger': $v.form.password_confirmation.$error,
            'is-success': $v.form.password_confirmation.$dirty && !$v.form.password_confirmation.$error,
          }"
        >
          <b-input v-model.trim="$v.form.password_confirmation.$model" maxlength="30" type="password"></b-input>
          <template #message>
            <div v-if="$v.form.password_confirmation.$error && !$v.form.password_confirmation.required">
              Please enter password confirmation
            </div>
            <div v-if="$v.form.password_confirmation.$error && !$v.form.password_confirmation.sameAsPassword">
              Password and Password confirmation is not the same
            </div>
            <div v-if="$v.form.password_confirmation.$error && !$v.form.password_confirmation.minlength">
              Password confirmation cannot be less than 8 characters
            </div>
          </template>
        </b-field>
        <b-button type="is-primary" native-type="submit">Submit</b-button>
      </form>
    </div>
    <div class="column"></div>
  </div>
</template>
<script>
import { required, sameAs, minLength } from "vuelidate/lib/validators";
import { NotificationProgrammatic as Notification } from "buefy";
import axios from "axios";
export default {
  name: "ResetPassword",
  data() {
    return {
      errors: null,
      form: {
        password: "",
        password_confirmation: "",
      },
    };
  },
  validations: {
    form: {
      password: {
        required,
        minLength: minLength(8),
      },
      password_confirmation: {
        required,
        sameAsPassword: sameAs("password"),
        minLength: minLength(8),
      },
    },
  },
  methods: {
    onSubmit() {
      this.$v.form.$touch();
      if (!this.$v.form.$invalid) {
        axios
          .patch("/api/v1/reset_password", {
            email: this.$route.query.email,
            password: this.form.password,
            password_confirmation: this.form.password_confirmation,
          })
          .then((response) => {
            this.$router.push({ name: "Home" });
            Notification.open({
              duration: 3000,
              message: response.data.message,
              type: "is-success",
              hasIcon: true,
            });
          })
          .catch((error) => {
            this.errors = error.response.data.errors;
          });
      }
    },
  },
  created() {
    axios
      .post("/api/v1/reset_password", {
        token: this.$route.query["amp;token"],
        email: this.$route.query.email,
      })
      .catch((error) => {
        this.$router.push({ name: "Home" });
        Notification.open({ duration: 3000, message: error.response.data.message, type: "is-danger", hasIcon: true });
      });
  },
};
</script>
