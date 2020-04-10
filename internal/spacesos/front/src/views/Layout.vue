<template>
    <div id="wrapper" style="overflow: auto">
        <div class="top-bar">
            <div class="top-bar-left">
                <ul class="dropdown menu" data-dropdown-menu>
                    <li class="menu-text">Spacesos</li>
                    <template v-if="!loggedIn">
                        <li><a href="/register">Register</a></li>
                        <li><a href="/login">Login</a></li>
                    </template>
                    <template v-if="loggedIn">
                        <li><a href="/">{{ user }}</a></li>
                        <li><a href="#" v-on:click="logout">Logout</a></li>
                    </template>
                </ul>
            </div>
            <div class="top-bar-right">
                <ul class="menu">
                    <li><a href="/public">Public crashes</a></li>
                    <template v-if="loggedIn">
                        <ul class="menu">
                            <li><a href="/friends">Friends</a></li>
                            <li><a href="/crashes">Crashes</a></li>
                        </ul>
                    </template>
                </ul>
            </div>
        </div>
        <slot></slot>
    </div>
</template>
<script>
    export default {
        computed: {
            loggedIn() {
                return this.$store.state.sessionId != null;
            },
            user() {
                return this.$store.state.user;
            }
        },
        methods: {
            logout() {
                this.$store.commit('logout');
            }
        }
    };
</script>
