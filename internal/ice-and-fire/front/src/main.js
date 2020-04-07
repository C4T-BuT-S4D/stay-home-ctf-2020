import Vue from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';
import { BootstrapVue } from 'bootstrap-vue';
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap-vue/dist/bootstrap-vue.css';
import axios from 'axios';

let url = '';

if (process.env.NODE_ENV === 'development') {
    url = 'http://127.0.0.1:31337';
} else {
    url = window.location.origin;
}

const serverUrl = url;

const apiUrl = `${serverUrl}/api`;

axios.defaults.baseURL = apiUrl;
axios.defaults.withCredentials = true;

Vue.prototype.$http = axios;
store.$http = axios;

Vue.use(BootstrapVue);
Vue.config.productionTip = false;

new Vue({
    router,
    store,
    render: h => h(App)
}).$mount('#app');
