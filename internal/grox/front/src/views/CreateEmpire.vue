<template>
    <v-col cols="12" md="12">
        <v-card>
            <v-card-title>Create task</v-card-title>
            <v-form>
                <v-container>
                    <v-text-field
                        v-model="name"
                        label="Name"
                        required
                        outlined
                    />
                </v-container>
            </v-form>
            <v-btn class="ml-3 mb-3" color="blue" @click="submit">Create</v-btn>
            <div class="red" v-if="error !== null" style="white-space: pre;">
                {{ error }}
            </div>
        </v-card>
    </v-col>
</template>

<script>
export default {
    data: function() {
        return {
            error: null,
            name: null
        };
    },

    methods: {
        submit: async function() {
            let r;
            try {
                r = await this.$http.post('/empire/create', {
                    name: this.name
                });
                const id = r.data.ok;
                this.$router
                    .push({ name: 'empire', params: { id } })
                    .catch(() => {});
            } catch (_) {
                this.error = r.data.error;
            }
        }
    }
};
</script>
