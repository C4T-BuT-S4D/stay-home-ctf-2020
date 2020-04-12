<template>
    <v-dialog :value="value" persistent max-width="60%">
        <v-card>
            <v-card-title class="justify-center">Register form</v-card-title>
            <v-form>
                <v-container>
                    <v-text-field
                        v-model="username"
                        label="Username"
                        id="fr-username"
                        required
                        outlined
                    />
                    <v-text-field
                        v-model="password"
                        label="Password"
                        id="fr-password"
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
                    >Close</v-btn
                >
                <v-btn
                    color="green darken-1"
                    text
                    @click="submit"
                    id="fr-submit"
                    >Submit</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
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
        submit: async function() {
            try {
                await this.$http.post('/register', {
                    username: this.username,
                    password: this.password
                });
                this.error = null;
                this.$emit('input', false);
                await this.$store.dispatch('UPDATE_USER');
                this.username = null;
                this.password = null;
            } catch (e) {
                this.error = e.response.data.error;
            }
        }
    }
};
</script>
