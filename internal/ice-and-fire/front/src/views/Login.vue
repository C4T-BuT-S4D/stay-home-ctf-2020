<template>
    <layout>
        <b-row class="my-auto justify-content-around">
            <b-form @submit="onSubmit">
                <b-form-group
                    id="input-group-username"
                    label="Username:"
                    label-for="input-username"
                >
                    <b-form-input
                        id="input-username"
                        v-model="username"
                        required
                        placeholder="Username"
                    ></b-form-input>
                </b-form-group>
                <b-form-group
                    id="input-group-password"
                    label="Password:"
                    label-for="input-password"
                >
                    <b-form-input
                        id="input-password"
                        v-model="password"
                        required
                        placeholder="Password"
                    ></b-form-input>
                </b-form-group>
                <b-button type="submit" variant="primary">Login</b-button>
            </b-form>
        </b-row>
    </layout>
</template>

<script>
import { Response, User, LoginRequest } from '@/proto/structs_pb';
import Layout from '@/layouts/Layout';
export default {
    components: {
        Layout
    },
    data: function() {
        return {
            username: '',
            password: ''
        };
    },
    methods: {
        async onSubmit(evt) {
            evt.preventDefault();

            let user = new User();
            user.setUsername(this.username);
            user.setPassword(this.password);

            let logReq = new LoginRequest();
            logReq.setUser(user);

            let rawResp = null;
            try {
                rawResp = await this.$http.post(
                    '/login/',
                    logReq.serializeBinary(),
                    {
                        responseType: 'arraybuffer',
                        headers: { 'Content-Type': 'application/octet-stream' }
                    }
                );
            } catch (e) {
                rawResp = e.response;
            }
            let resp = Response.deserializeBinary(rawResp.data);
            let ok = resp.getOk();
            if (!ok) {
                this.$toasted.show(`Error: ${resp.getText()}`);
            } else {
                this.$router.push({ name: 'Users' });
            }
        }
    }
};
</script>
