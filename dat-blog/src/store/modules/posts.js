import axios from "axios";
import router from "../../router/index";
import { NotificationProgrammatic as Notification } from "buefy";

axios.defaults.baseURL = "http://localhost:3000";
axios.defaults.headers.common['Accept'] = 'application/json'

const state = () => ({
  posts: {},
  post: {},
  errors: null,
});

const getters = () => ({
  getUser(state) {
    return state
  }
})

const actions = {
  getPosts(context, page) {
    axios.get("/api/v1/posts/?page=" + page).then((response) => {
      context.commit("SET_POSTS", response.data.posts);
    });
  },
  showPost({ commit, state, rootState }, data) {
    return axios.get("/api/v1/posts/" + data.post.id).then((response) => {
      commit("SHOW_POST", response.data.post);
    });
  },
  createPost({ commit, state, rootState }, data) {
    return axios
      .post(
        "/api/v1/posts",
        { post: data.post },
        {
          headers: { Authorization: rootState.users.token },
        }
      )
      .then((response) => {
        commit("HANDLE_POST", response.data);
      })
      .catch((errors) => {
        commit("POST_ERROR", errors.response.data);
      });
  },
  updatePost({ commit, state, rootState }, data) {
    return axios
      .patch(
        "/api/v1/posts/" + data.post.id,
        {
          post: data.post,
        },
        {
          headers: {
            Authorization: rootState.users.token,
          },
        }
      )
      .then((response) => {
        commit("HANDLE_POST", response.data);
      })
      .catch((errors) => {
        commit("POST_ERROR", errors.response.data);
      });
  },
  deletePost({ commit, state, rootState }, id) {
    axios
      .delete("/api/v1/posts/" + id, {
        headers: {
          Authorization: rootState.users.token,
        },
      })
      .then((response) => {
        commit("DELETE_POST", response.data);
      });
  },
};

const mutations = {
  SET_POSTS(state, posts) {
    state.posts = posts;
  },
  HANDLE_POST(state, data) {
    state.errors = null;
    router.push("/");
    Notification.open({ duration: 3000, message: data.message, type: "is-success", hasIcon: true });
  },
  POST_ERROR(state, response) {
    state.errors = response.errors;
  },
  SHOW_POST(state, post) {
    state.post = post;
  },
  DELETE_POST(state, data) {
    state.post = {};
    router.push("/");
    Notification.open({ duration: 3000, message: data.message, type: "is-success", hasIcon: true });
  },
};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
