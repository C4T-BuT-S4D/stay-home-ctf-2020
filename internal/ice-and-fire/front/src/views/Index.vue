<template>
    <layout>
        <b-row class="my-auto justify-content-around">
            <b-button
                class="mx-auto col col-5"
                variant="primary"
                @click="go('Login')"
                >Login</b-button
            >
            <b-button
                class="mx-auto col col-5"
                variant="secondary"
                @click="go('Register')"
                >Register</b-button
            >
        </b-row>
    </layout>
</template>

<script>
import Layout from '@/layouts/Layout';
export default {
    components: {
        Layout
    },
    methods: {
        go: function(to) {
            this.$router.push({ name: to });
        }
    }
};
</script>
