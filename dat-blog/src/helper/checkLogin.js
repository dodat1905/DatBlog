import axios from "axios";
axios.defaults.baseURL = "http://localhost:3000";
import router from "../router/index";
import store from '../store/index';
import { NotificationProgrammatic as Notification } from "buefy";

const isLogin = function() {
  axios
    .post(
      "/api/v1/check_login",
      {},
      {
        headers: {
          Authorization: store.state.users.token,
        },
      }
    )
    .catch(() => {
      router.push("/");
      Notification.open({
        duration: 3000,
        message: 'Unauthorized',
        type: "is-danger",
        hasIcon: true,
      });
    });
};

export default isLogin;
