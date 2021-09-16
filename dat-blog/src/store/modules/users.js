import axios from "axios";
import router from "../../router/index";
import { NotificationProgrammatic as Notification } from "buefy";

axios.defaults.baseURL = "http://localhost:3000";

const state = () => ({
  users: null,
  currentUser: JSON.parse(localStorage.getItem("currentUser")),
  token: localStorage.getItem("token"),
  refreshToken: localStorage.getItem("refreshToken"),
  error: null,
});

const actions = {
  signIn({ commit }, data) {
    axios
      .post("/api/v1/sessions", { name: data.name, password: data.password, remember: data.remember })
      .then((response) => {
        commit("SIGN_IN", response.data);
      })
      .catch((errors) => {
        commit("SIGN_IN_ERROR", errors.response.data);
      });
  },
  signUp({ commit }, data) {
    axios
      .post("/api/v1/users", { user: data.user })
      .then((response) => {
        commit("SIGN_UP", response.data);
      })
      .catch((errors) => {
        commit("SIGN_UP_ERROR", errors.response.data);
      });
  },
  forgotPassword({ commit }, data) {
    return axios
      .post("/api/v1/password_resets", {
        email: data.email,
      })
      .then((response) => {
        commit("RESET_PASSWORD", response.data);
      });
  },
};

const mutations = {
  SIGN_IN(state, data) {
    localStorage.setItem("currentUser", JSON.stringify(data.user));
    state.currentUser = JSON.parse(localStorage.getItem("currentUser"));
    localStorage.setItem("token", data.token);
    state.token = localStorage.getItem("token", data.token);
    localStorage.setItem("refreshToken", data.refresh_token);
    state.refreshToken = localStorage.getItem("refreshToken", data.refresh_token);
    state.error = null;
    window.location.href = "/";
  },
  SIGN_OUT(state) {
    state.currentUser = null;
    state.token = null;
    localStorage.removeItem("currentUser");
    localStorage.removeItem("token");
    localStorage.removeItem("refreshToken");
    state.error = null;
    router.push("/");
  },
  SIGN_IN_ERROR(state, data) {
    state.error = data.message;
  },
  SIGN_UP(state, data) {
    localStorage.setItem("currentUser", JSON.stringify(data.user));
    state.currentUser = JSON.parse(localStorage.getItem("currentUser"));
    localStorage.setItem("token", data.token);
    state.token = localStorage.getItem("token", data.token);
    localStorage.setItem("refreshToken", data.refresh_token);
    state.refreshToken = localStorage.getItem("refreshToken", data.refresh_token);
    state.error = null;
    router.push("/");
    Notification.open({ duration: 3000, message: data.message, type: "is-success", hasIcon: true });
  },
  RESET_PASSWORD(state, data) {
    router.push("/");
    Notification.open({ duration: 3000, message: data.message, type: "is-success", hasIcon: true });
  },
  SIGN_UP_ERROR(state, data) {
    state.error = data.errors;
  },
};

export default {
  namespaced: true,
  state,
  actions,
  mutations,
};
