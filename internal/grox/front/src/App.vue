<template>
    <v-app>
        <login-form v-model="loginForm" />
        <register-form v-model="registerForm" />
        <me-form v-model="meForm" v-if="!isNull(user)" />

        <v-app-bar app clipped-left>
            <v-app-bar-nav-icon @click="show = !show" id="menu-btn" />
            <v-toolbar-title>Grox</v-toolbar-title>
            <v-spacer></v-spacer>
            <v-btn
                color="green"
                @click="loginForm = true"
                v-if="isNull(user)"
                id="login-button"
                >Login</v-btn
            >
            <v-btn color="green" v-else @click="meForm = true" id="me-button">{{
                user.username
            }}</v-btn>
            <v-btn
                color="red"
                class="ml-3"
                @click="registerForm = true"
                v-if="isNull(user)"
                id="register-button"
                >Register</v-btn
            >
            <v-btn
                class="ml-3"
                color="red"
                v-else
                @click="logout"
                id="logout-button"
                >Logout</v-btn
            >
        </v-app-bar>

        <v-navigation-drawer v-model="show" app clipped>
            <v-list dense>
                <v-list-item
                    link
                    @click="$router.push({ name: 'index' }).catch(() => {})"
                >
                    <v-list-item-action>
                        <v-icon>mdi-cube-outline</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title>Users</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
                <v-list-item
                    v-if="user !== null"
                    link
                    @click="
                        $router
                            .push({ name: 'empires', params: { id: user.id } })
                            .catch(() => {})
                    "
                >
                    <v-list-item-action>
                        <v-icon>mdi-account</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title>My empires</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
                <v-list-item
                    v-if="user !== null"
                    link
                    @click="
                        $router.push({ name: 'create_empire' }).catch(() => {})
                    "
                >
                    <v-list-item-action>
                        <v-icon>mdi-pencil</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title>Create empire</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
            </v-list>
        </v-navigation-drawer>

        <v-content>
            <v-container fluid>
                <v-row>
                    <router-view />
                </v-row>
            </v-container>
        </v-content>
    </v-app>
</template>

<script>
import LoginForm from '@/components/LoginForm';
import RegisterForm from '@/components/RegisterForm';
import MeForm from '@/components/MeForm';

import { mapState } from 'vuex';
import { isNull, isUndefined } from '@/utils/types';

export default {
    data: () => ({
        show: null,
        loginForm: false,
        registerForm: false,
        meForm: false
    }),

    components: {
        LoginForm,
        RegisterForm,
        MeForm
    },

    created: async function() {
        this.$vuetify.theme.dark = true;
        if (!isUndefined(this.$route.query.logop)) {
            this.loginForm = true;
        }
    },

    computed: mapState(['user']),

    methods: {
        isNull,

        dec2hex: function(dec) {
            return ('0' + dec.toString(16)).substr(-2);
        },

        str2hex: function(str) {
            let res = '';
            for (let i = 0; i < str.length; i += 1) {
                res += this.dec2hex(str.charCodeAt(i));
            }
            return res;
        },

        logout: async function() {
            await this.$http.post('/logout');
            await this.$store.dispatch('UPDATE_USER');

            if (this.$route.meta.auth) {
                this.$router
                    .push({
                        name: 'index',
                        query: {
                            redirect: this.str2hex(
                                JSON.stringify({
                                    name: this.$route.name,
                                    query: this.$route.query,
                                    params: this.$route.params
                                })
                            ),
                            logop: true
                        }
                    })
                    .catch(() => {});
            }
        }
    },

    watch: {
        $route: async function() {
            if (!isUndefined(this.$route.query.logop)) {
                this.loginForm = true;
            }
        }
    }
};
</script>
