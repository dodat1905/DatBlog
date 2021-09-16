import Vue from "vue";
import VueRouter from "vue-router";
import axios from "axios";
import store from "../store/index";
import { NotificationProgrammatic as Notification } from "buefy";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ "../views/Home.vue"),
  },
  {
    path: "/users/sign_in",
    name: "SignIn",

    component: () => import("../views/users/SignIn.vue"),
  },
  {
    path: "/users/sign_up",
    name: "SignUp",
    component: () => import("../views/users/SignUp.vue"),
  },
  {
    path: "/posts/new",
    name: "NewPost",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/posts/PostsNew.vue"),
  },
  {
    path: "/posts/:id",
    name: "ShowPost",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/posts/PostsShow.vue"),
  },
  {
    path: "/posts/:id/edit",
    name: "EditPost",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/posts/PostsEdit.vue"),
  },
  {
    path: "/users/forgot_password",
    name: "ForgotPassword",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/users/ForgotPassword.vue"),
  },
  {
    path: "/users/reset_password",
    name: "ResetPassword",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/users/ResetPassword.vue"),
  },
  {
    path: "/search",
    name: "Search",
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import("../views/Search.vue"),
  },
];

const router = new VueRouter({
  routes,
});

router.beforeEach((to, from, next) => {
  const publicPages = ["SignIn", "SignUp", "ForgotPassword", "ResetPassword"];
  const loginPages = ["NewPost", "EditPost"];
  if (localStorage.getItem("token") !== null) {
    axios
      .post(
        "/api/v1/check_login",
        {},
        {
          headers: {
            Authorization: store.state.users.token,
            RefreshAuthorization: store.state.users.refreshToken,
          },
        }
      )
      .then((response) => {
        if (response.data.message == 'Login user successfully!') {
          store.commit("users/SIGN_IN", response.data);
        }
      })
      .catch((error) => {
        if (error.response.data.login_errors === "Signature has expired") {
          store.commit("users/SIGN_OUT");
        } else {
          router.push("/");
          Notification.open({ duration: 3000, message: "Unauthorized", type: "is-danger", hasIcon: true });
        }
      });
  }
  if (publicPages.includes(to.name) && store.state.users.currentUser) {
    next({ name: "Home" });
  } else if (loginPages.includes(to.name) && store.state.users.currentUser == undefined) {
    next({ name: "Home" });
  } else {
    next();
  }
});

export default router;
