import Vue from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';

import {SpaceSosPromiseClient} from '@/spacesos_grpc_web_pb.js';
import Toasted from 'vue-toasted';

Vue.config.productionTip = false;

let url = '';
if (process.env.NODE_ENV === 'development') {
    url = 'http://127.0.0.1:3334';
} else {
    url = 'http://' +window.location.hostname + ':3334'
}


Vue.prototype.$client = new SpaceSosPromiseClient(url, null, null);


Vue.use(Toasted, {
    position: 'top-right',
    duration: 2000,
    keepOnHover: true
});

new Vue({
    router,
    store,
    render: h => h(App)
}).$mount('#app');
