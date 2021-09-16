<template>
  <div class="columns">
    <div class="column"></div>
    <div class="column is-two-fifths">
      <form @submit.prevent="onSubmit" class="box mt-6">
        <h3 class="title is-3">Sign up</h3>
        <b-notification
          type="is-danger"
          aria-close-label="Close notification"
          has-icon
          v-if="this.error !== null"
          role="alert"
        >
          <div v-for="(error, index) in error" :key="index">{{ error }}</div>
        </b-notification>

        <b-field
          label="Name"
          :type="{
            'is-danger': $v.form.user.name.$error,
            'is-success': $v.form.user.name.$dirty && !$v.form.user.name.$error,
          }"
        >
          <b-input v-model.trim="$v.form.user.name.$model" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.user.name.$error && !$v.form.user.name.required">Please enter your name</div>
          </template>
        </b-field>
        <b-field
          label="Email"
          :type="{
            'is-danger': $v.form.user.email.$error,
            'is-success': $v.form.user.email.$dirty && !$v.form.user.email.$error,
          }"
        >
          <b-input v-model="form.user.email" type="email" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.user.email.$error && !$v.form.user.email.required">Please enter your email</div>
          </template>
        </b-field>
        <b-field
          label="Password"
          :type="{
            'is-danger': $v.form.user.password.$error,
            'is-success': $v.form.user.password.$dirty && !$v.form.user.password.$error,
          }"
        >
          <b-input v-model="form.user.password" type="password" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.user.password.$error && !$v.form.user.password.required">Please enter your password</div>
          </template>
        </b-field>
        <b-field
          label="Password confirmation"
          :type="{
            'is-danger': $v.form.user.password_confirmation.$error,
            'is-success': $v.form.user.password_confirmation.$dirty && !$v.form.user.password_confirmation.$error,
          }"
        >
          <b-input v-model="form.user.password_confirmation" type="password" maxlength="30"></b-input>
          <template #message>
            <div v-if="$v.form.user.password_confirmation.$error && !$v.form.user.password_confirmation.required">
              Please enter your password confirmation
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
import { mapState, mapActions } from "vuex";
import { required } from "vuelidate/lib/validators";

export default {
  name: "SignUp",
  data() {
    return {
      form: {
        user: {
          name: "",
          email: "",
          password: "",
          password_confirmation: "",
        },
      },
    };
  },
  validations: {
    form: {
      user: {
        name: {
          required,
        },
        email: {
          required,
        },
        password: {
          required,
        },
        password_confirmation: {
          required,
        },
      },
    },
  },
  computed: {
    ...mapState("users", ["error"]),
  },
  methods: {
    ...mapActions("users", ["signUp"]),
    onSubmit() {
      this.$v.form.user.$touch();
      if (!this.$v.form.user.$invalid) {
        this.signUp(this.form);
      }
    },
  },
};
</script>
