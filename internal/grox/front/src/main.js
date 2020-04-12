import Vue from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';
import vuetify from './plugins/vuetify';
import VueForceNextTick from 'vue-force-next-tick';
import axios from 'axios';
import { apiUrl } from '@/config';

Vue.use(VueForceNextTick);

Vue.config.productionTip = false;

axios.defaults.baseURL = apiUrl;
axios.defaults.withCredentials = true;

Vue.prototype.$http = axios;
store.$http = axios;

new Vue({
    router,
    store,
    vuetify,
    render: h => h(App)
}).$mount('#app');
