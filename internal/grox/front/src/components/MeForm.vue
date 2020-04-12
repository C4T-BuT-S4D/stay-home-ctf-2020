<template>
    <v-dialog :value="value" max-width="30%" persistent>
        <v-card>
            <v-card-title class="justify-center">Profile</v-card-title>
            <v-container>
                <v-row>
                    <v-col cols="12" md="6">
                        <div>Username: {{ user.username }}</div>
                        <div>Id: {{ user.id }}</div>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-img
                            src="https://ctforces.com/media/avatars/default_avatar.main.png"
                            width="100%"
                            height="100%"
                        />
                    </v-col>
                </v-row>
            </v-container>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn
                    color="green darken-1"
                    text
                    @click="$emit('input', false)"
                    id="me-close"
                    >Close</v-btn
                >
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
import { mapState } from 'vuex';

export default {
    props: {
        value: Boolean
    },

    computed: mapState(['user'])
};
</script>
