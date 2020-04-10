import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        sessionId: null,
        user: null,
    },
    mutations: {
        login(state, payload) {
            console.log(payload);
            state.sessionId = payload.sessionId;
            state.user = payload.user;
        },
        logout(state) {
            state.user = null;
            state.sessionId = null;
        }
    },
    actions: {},
    modules: {},
    plugins: [createPersistedState()]
});
