<template>
    <v-dialog :value="value" persistent max-width="60%">
        <v-card>
            <v-card-title class="justify-center">Login form</v-card-title>
            <v-form>
                <v-container>
                    <v-text-field
                        v-model="username"
                        label="Username"
                        id="fl-username"
                        required
                        outlined
                    />
                    <v-text-field
                        v-model="password"
                        label="Password"
                        id="fl-password"
                        required
                        outlined
                        type="password"
                    />
                    <span
                        class="red"
                        v-if="error !== null"
                        style="white-space: pre;"
                        >{{ error }}
                    </span>
                </v-container>
            </v-form>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                    color="green darken-1"
                    text
                    @click="$emit('input', false)"
                    id="fl-close"
                    >Close</v-btn
                >
                <v-btn
                    color="green darken-1"
                    text
                    @click="submit"
                    id="fl-submit"
                    >Submit</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
import { isUndefined } from '@/utils/types';

export default {
    props: {
        value: Boolean
    },

    data: function() {
        return {
            username: null,
            password: null,
            error: null
        };
    },

    methods: {
        hex2str: function(hex) {
            let str = '';
            for (let i = 0; i < hex.length; i += 2) {
                str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
            }
            return str;
        },
        submit: async function() {
            try {
                await this.$http.post('/login/', {
                    username: this.username,
                    password: this.password
                });
                this.error = null;
                this.$emit('input', false);
                await this.$store.dispatch('UPDATE_USER');

                if (!isUndefined(this.$route.query.redirect)) {
                    const data = JSON.parse(
                        this.hex2str(this.$route.query.redirect)
                    );
                    this.$router
                        .push({
                            name: data.name,
                            query: data.query,
                            params: data.params
                        })
                        .catch(() => {});
                }

                this.username = null;
                this.password = null;
            } catch (e) {
                this.error = e.response.data.error;
            }
        }
    }
};
</script>
