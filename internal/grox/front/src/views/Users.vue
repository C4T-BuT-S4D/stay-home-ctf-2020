<template>
    <v-col cols="12" md="12">
        <v-simple-table v-if="error === null">
            <template v-slot:default>
                <thead>
                    <tr>
                        <th class="text-left">Username</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="user of users" :key="user.id">
                        <td @click="openUser(user.id)" class="pc">
                            {{ user.username }}
                        </td>
                    </tr>
                </tbody>
            </template>
        </v-simple-table>
        <div class="red" v-if="error !== null" style="white-space: pre;">
            {{ error }}
        </div>
    </v-col>
</template>

<script>
import { isNull } from '@/utils/types';
import { mapState } from 'vuex';

export default {
    data: function() {
        return {
            users: [],
            error: null
        };
    },

    computed: mapState(['user']),

    created: async function() {
        const r = await this.$http.get('/user/list');
        try {
            this.users = r.data.ok;
        } catch (_) {
            this.error = r.data.error;
        }
    },

    methods: {
        isNull,
        openUser: function(id) {
            this.$router
                .push({ name: 'empires', params: { id } })
                .catch(() => {});
        }
    }
};
</script>

<style lang="scss" scoped>
.pc {
    cursor: pointer;
}
</style>
