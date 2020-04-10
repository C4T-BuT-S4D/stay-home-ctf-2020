<template>
    <layout>
        <div style="padding-left: 10px; margin-top: 20px;">
            <h3 style="color: white;">Register</h3>
            <p style="color: white;">
                Welcome to the service!
            </p>
            <form @submit="register">
                <label style="color: white;">
                    <input required v-model="name" type="text" style="width: 30%;" name="login" placeholder="login">
                </label>
                <label style="color: white;">Password:
                    <input type="password" required v-model="password" style="width: 30%" name="password"
                           placeholder="password">
                </label>
                <br>
                <button class="button success" type="submit">Register</button>
            </form>
        </div>
    </layout>
</template>
<script>
    import Layout from './Layout';
    import {AuthRequest} from '@/spacesos_pb.js';

    export default {
        data: function () {
            return {
                name: "",
                password: "",
                error: null,
            };
        },
        components: {
            Layout
        },
        methods: {
            async register(event) {
                event.preventDefault();
                let request = new AuthRequest();
                request.setLogin(this.name);
                request.setPassword(this.password);
                try {
                    let resp = await this.$client.register(request, {});
                    this.$store.commit('login', {
                        sessionId: resp.getSessionid(),
                        user: this.name,
                    });
                    this.$router.push({ name: 'Index' });
                } catch (e) {
                    this.$toasted.error(e.message);
                }
            },
        }
    }
    ;
</script>
